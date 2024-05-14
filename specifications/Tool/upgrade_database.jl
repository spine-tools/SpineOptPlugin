using SpineInterface

# (original class, original parameter name), new parameter name
parameters_to_be_renamed = [
    (("unit", "number_of_units"), "existing_units"),
    (("unit", "unit_availability_factor"), "availability_factor"),
    (("unit", "unit_investment_lifetime"), "lifetime"),
    (("unit", "unit_investment_variable_type"), "investment_method")
]

# (original class, original parameter name), (new parameter name, [map indexes of new parameter])
parameters_to_maps = [
	# Unit investments
	(("unit", "candidate_units"), ("investment_limits", ["max_new"])),
    (("unit", "fix_units_invested"), ("investment_limits", ["fix_new"])),
	(("unit", "fix_units_invested_available"), ("investment_limits", ["fix_cumulative"])),
	(("unit", "initial_units_invested"), ("investment_limits", ["min_new"])),
	(("unit", "initial_units_invested_available"), ("investment_limits", ["min_cumulative"])),

	# Unit online
    (("unit", "fix_units_on"), ("units_online", ["min", "max"])),
    (("unit", "initial_units_on"), ("units_online", ["initial"])),

	# Unit mga
	(("unit", "units_invested_big_m_mga"), ("mga", ["investment_big_m"])),
	(("unit", "units_invested_mga"), ("mga", ["investment"])),
	(("unit", "units_invested_mga_weight"), ("mga", ["investment_weight"]))
]

# (original class, original parameter name), [(new class, new parameter name, linking dimension)]
parameters_to_other_classes = [
	# Unit --> unit__to_node / unit__from_node
	(("unit", "curtailment_cost"), 
		[("unit__to_node", "curtailment_cost", 1), ("unit__from_node", "curtailment_cost", 1)]),
	(("unit", "fom_cost"), 
		[("unit__to_node", "fixed_annual_cost", 1), ("unit__from_node", "fixed_annual_cost", 1)]),
	(("unit", "shut_down_cost"), 
		[("unit__to_node", "shutdown_cost", 1), ("unit__from_node", "shutdown_cost", 1)]),
	(("unit", "start_up_cost"), 
		[("unit__to_node", "startup_cost", 1), ("unit__from_node", "startup_cost", 1)]),
	(("unit", "unit_investment_cost"), 
		[("unit__to_node", "investment_cost", 1), ("unit__from_node", "investment_cost", 1)]),
	(("unit", "units_on_cost"), 
		[("unit__to_node", "online_cost", 1), ("unit__from_node", "online_cost", 1)])
]


# Copy the db from url_in to url_out
function copy_database(url_in, url_out)
	data = export_data(url_in)
	import_data(url_out, data, "Imported data from an old SpineOpt database.")
end


# Go through the parameters, rename them and commit session
function rename_parameters(db_url, parameters_to_be_renamed)
	for (old_par_def, new_par_name) in parameters_to_be_renamed
		rename_parameter(db_url, old_par_def[1], old_par_def[2], new_par_name)
	end
	run_request(db_url, "call_method", ("commit_session", "Rename parameters."))
end

# Find the parameter id and rename the parameter
function rename_parameter(db_url, class_name, old_par_name, new_par_name)
	pdef = run_request(db_url, "call_method", ("get_item", "parameter_definition"), Dict(
		"entity_class_name" => class_name, "name" => old_par_name)
	)
	check_run_request_return_value(run_request(db_url, "call_method", ("update_item", "parameter_definition"), Dict(
		"id" => pdef["id"], "name" => new_par_name))
	)
end


# Go through the parameters, convert to a Map parameter and commit session
function transform_parameters_to_maps(db_url, parameters_to_maps)
	for (old_par_def, new_par_def) in parameters_to_maps
		transform_parameter_to_map(db_url, old_par_def[1], old_par_def[2], new_par_def[1], new_par_def[2])
	end
	run_request(db_url, "call_method", ("commit_session", "Transform parameters to Maps."))
end

# Find parameter values and transform them into Map parameter values
function transform_parameter_to_map(db_url, class_name, old_par_name, new_par_name, map_indexes)
	# Add new parameter definition
	try
		check_run_request_return_value(run_request(db_url, "call_method", ("add_parameter_definition_item",), Dict(
			"entity_class_name" => class_name, "name" => new_par_name))
		)
	catch
		println("skipping add_parameter_definition_item")
	end
	# Compute new_pvals
	entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict(
		"entity_class_name" => class_name)
	)
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for entity in entity_items
		for alternative in alternative_items
			indexes = Array{String}(undef, 0)
			values = Array{Any}(undef, 0)
			for map_index in map_indexes
				# Get value of the old parameter
				pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
					"entity_class_name" => class_name, "parameter_definition_name" => old_par_name, 
					"entity_byname" => (entity["name"],), "alternative_name" => alternative["name"])
				)
				if length(pval) > 0
					# Add index to the array
					push!(indexes, map_index)
					# Select the value part, convert it from the DB into a Julia object and add to the array
					push!(values, parse_db_value(pval["value"], pval["type"]))
				end
			end
			if length(indexes) > 0
				# Create a map type object based on the indexes and values
				new_value = Map(indexes, values)
				# Check if the parameter value already exists and merge if needed
				pval_existing = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
					"entity_class_name" => class_name, "parameter_definition_name" => new_par_name, 
					"entity_byname" => (entity["name"],), "alternative_name" => alternative["name"])
				)
				if length(pval_existing) > 0
					existing_value = parse_db_value(pval_existing["value"], pval_existing["type"])
					new_value = merge!(existing_value, new_value)
				end
				# Convert the object into a DB representation
				db_value, db_type = unparse_db_value(new_value)
				# Add the new map type parameter value into the database
				check_run_request_return_value(run_request(
					db_url, "call_method", ("add_update_parameter_value_item",), Dict(
						"entity_class_name" => class_name, "parameter_definition_name" => new_par_name, 
						"entity_byname" => (entity["name"],), "alternative_name" => alternative["name"], 
						"value" => db_value, "type" => db_type)
					)
				)
			end
		end
	end
	# Remove old parameter definition
	pdef = run_request(db_url, "call_method", ("get_parameter_definition_item",), Dict(
		"entity_class_name" => class_name, "name" => old_par_name)
	)
	check_run_request_return_value(run_request(db_url, "call_method", ("remove_parameter_definition_item", pdef["id"])))
end

# Go through the parameters, move to other classes and commit session
function move_parameters_to_other_classes(db_url, parameters_to_other_classes)
	for (old_par_def, new_par_def) in parameters_to_other_classes
		for new_par_def_part in new_par_def
			move_parameter_to_another_class(db_url, old_par_def[1], old_par_def[2], new_par_def_part[1], 
				new_par_def_part[2], new_par_def_part[3]
			)
		end
		# Remove old parameter definition
		pdef = run_request(db_url, "call_method", ("get_parameter_definition_item",), Dict(
			"entity_class_name" => old_par_def[1], "name" => old_par_def[2])
		)
		check_run_request_return_value(run_request(
			db_url, "call_method", ("remove_parameter_definition_item", pdef["id"]))
		)
	end
	run_request(db_url, "call_method", ("commit_session", "Move parameters to other classes."))
end

# Find parameter values and move them into another class
function move_parameter_to_another_class(db_url, old_class_name, old_par_name, new_class_name, new_par_name, 
	linking_dimension
)
	# Add new parameter definition
	try
		check_run_request_return_value(run_request(db_url, "call_method", ("add_parameter_definition_item",), Dict(
			"entity_class_name" => new_class_name, "name" => new_par_name))
		)
	catch
		println("skipping add_parameter_definition_item")
	end
	# Compute new_pvals
	old_entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict(
		"entity_class_name" => old_class_name)
	)
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for old_entity in old_entity_items
		for alternative in alternative_items
			# Get value of the old parameter
			pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
				"entity_class_name" => old_class_name, "parameter_definition_name" => old_par_name,
				"entity_byname" => (old_entity["name"],), "alternative_name" => alternative["name"])
			)
			if length(pval) > 0
				# Get the new entities
				new_entities = find_related_entities(db_url, new_class_name, old_entity, linking_dimension)
				for new_entity in new_entities
					# Add the new map type parameter value into the database
					check_run_request_return_value(run_request(
						db_url, "call_method", ("add_update_parameter_value_item",), Dict(
							"entity_class_name" => new_class_name, 
							"parameter_definition_name" => new_par_name, 
							"entity_byname" => (new_entity["element_name_list"]), 
							"alternative_name" => alternative["name"], 
							"value" => pval["value"], 
							"type" => pval["type"])
						)
					)
				end
			end
		end
	end

end

# Find entities in class_name which have entity_item in the linking_dimension dimension
function find_related_entities(db_url, class_name, entity_item, linking_dimension)
	related_entities = Array{Any}(undef, 0)
	entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict(
		"entity_class_name" => class_name)
	)
	for entity in entity_items
		if entity["element_name_list"][linking_dimension] == entity_item["name"]
			push!(related_entities, entity)
		end
	end
	return related_entities
end

# Always check the last item
function check_run_request_return_value(value_to_be_checked)
	if value_to_be_checked[end] != nothing && value_to_be_checked[end] != ""
		println(value_to_be_checked[end])
		throw(error())
	end
end

function run_migrations()
	copy_database(url_in, url_out)
	rename_parameters(url_out, parameters_to_be_renamed)
	transform_parameters_to_maps(url_out, parameters_to_maps)
	move_parameters_to_other_classes(url_out, parameters_to_other_classes)
end

url_in = ARGS[1]
url_out = ARGS[2]


run_migrations()

