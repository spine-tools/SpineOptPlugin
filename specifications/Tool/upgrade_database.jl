using SpineInterface

# (original class, original parameter name), new parameter name, merge method("sum")
parameters_to_be_renamed = [
    (("unit", "number_of_units"), "existing_units", ""),
    (("unit", "unit_availability_factor"), "availability_factor", ""),
    (("unit", "unit_investment_lifetime"), "lifetime", ""),
    (("unit", "unit_investment_variable_type"), "investment_method", ""),

	(("node", "balance_type"), "node_type", ""),
	(("node", "frac_state_loss"), "storage_self_discharge", ""),
	(("node", "state_coeff"), "storage_state_coeff", ""),
	(("node", "storage_investment_lifetime"), "storage_lifetime", ""),

    (("connection", "connection_availability_factor"), "availability_factor", ""),
    (("connection", "connection_investment_lifetime"), "lifetime", ""),
    (("connection", "connection_reactance"), "reactance", ""),
    (("connection", "connection_resistance"), "resistance", ""),

	(("unit__to_node", "unit_capacity"), "capacity_per_unit", ""),
	(("unit__to_node", "vom_cost"), "flow_cost", ""),
	(("node__to_unit", "unit_capacity"), "capacity_per_unit", ""),
	(("node__to_unit", "vom_cost"), "flow_cost", ""),

	(("unit__to_node", "fuel_cost"), "flow_cost", "sum"),
	(("node__to_unit", "fuel_cost"), "flow_cost", "sum")	
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
	(("unit", "units_invested_mga_weight"), ("mga", ["investment_weight"])),

	# Node investments
	(("node", "candidate_storages"), ("storage_investment_limits", ["max_new"])),
	(("node", "fix_storages_invested"), ("storage_investment_limits", ["fix_new"])),
	(("node", "fix_storages_invested_available"), ("storage_investment_limits", ["fix_cumulative"])),
	(("node", "initial_storages_invested"), ("storage_investment_limits", ["min_new"])),
	(("node", "initial_storages_invested_available"), ("storage_investment_limits", ["min_cumulative"])),

	# Node limits
	(("node", "fix_node_pressure"), ("pressure_limits", ["fix"])),
	(("node", "fix_node_state"), ("storage_state_limits", ["fix"])),
	(("node", "fix_node_voltage_angle"), ("voltage_angle_limits", ["fix"])),
	(("node", "initial_node_pressure"), ("pressure_limits", ["initial"])),
	(("node", "initial_node_state"), ("storage_state_limits", ["initial"])),
	(("node", "initial_node_voltage_angle"), ("voltage_angle_limits", ["initial"])),
	(("node", "max_node_pressure"), ("pressure_limits", ["max"])),
	(("node", "max_voltage_angle"), ("voltage_angle_limits", ["max"])),
	(("node", "min_node_pressure"), ("pressure_limits", ["min"])),
	(("node", "min_voltage_angle"), ("voltage_angle_limits", ["min"])),
	(("node", "node_state_cap"), ("storage_state_limits", ["max"])),
	(("node", "node_state_min"), ("storage_state_limits", ["min"])),

	# Node mga
	(("node", "storages_invested_big_m_mga"), ("storage_mga", ["investment_big_m"])),
	(("node", "storages_invested_mga"), ("storage_mga", ["investment"])),
	(("node", "storages_invested_mga_weight"), ("storage_mga", ["investment_weight"])),

	# Connection investments
	(("connection", "candidate_connections"), ("investment_limits", ["max_new"])),
	(("connection", "fix_connections_invested"), ("investment_limits", ["fix_new"])),
	(("connection", "fix_connections_invested_available"), ("investment_limits", ["fix_cumulative"])),
	(("connection", "initial_connections_invested"), ("investment_limits", ["min_new"])),
	(("connection", "initial_connections_invested_available"), ("investment_limits", ["min_cumulative"])),

	# Connection mga
	(("connection", "connections_invested_big_m_mga"), ("mga", ["investment_big_m"])),
	(("connection", "connections_invested_mga"), ("mga", ["investment"])),
	(("connection", "connections_invested_mga_weight"), ("mga", ["investment_weight"])),

	# Unit__to_node
	(("unit__to_node", "fix_unit_flow"), ("flow_limits", ["fix"])),
	(("unit__to_node", "initial_unit_flow"), ("flow_limits", ["initial"])),
	(("unit__to_node", "max_total_cumulated_unit_flow_to_node"), ("flow_limits", ["max_cumulative"])),
	(("unit__to_node", "min_total_cumulated_unit_flow_to_node"), ("flow_limits", ["min_cumulative"])),
	(("unit__to_node", "min_unit_flow"), ("flow_limits", ["min"])),
	(("unit__to_node", "ramp_down_limit"), ("ramp_limits", ["ramp_down"])),
	(("unit__to_node", "ramp_up_limit"), ("ramp_limits", ["ramp_up"])),
	(("unit__to_node", "shut_down_limit"), ("ramp_limits", ["shutdown"])),
	(("unit__to_node", "start_up_limit"), ("ramp_limits", ["startup"])),

	# node__to_unit
	(("node__to_unit", "fix_unit_flow"), ("flow_limits", ["fix"])),
	(("node__to_unit", "initial_unit_flow"), ("flow_limits", ["initial"])),
	(("node__to_unit", "max_total_cumulated_unit_flow_from_node"), ("flow_limits", ["max_cumulative"])),
	(("node__to_unit", "min_total_cumulated_unit_flow_from_node"), ("flow_limits", ["min_cumulative"])),
	(("node__to_unit", "min_unit_flow"), ("flow_limits", ["min"])),
	(("node__to_unit", "ramp_down_limit"), ("ramp_limits", ["ramp_down"])),
	(("node__to_unit", "ramp_up_limit"), ("ramp_limits", ["ramp_up"])),
	(("node__to_unit", "shut_down_limit"), ("ramp_limits", ["shutdown"])),
	(("node__to_unit", "start_up_limit"), ("ramp_limits", ["startup"])),

]

# (original class, original parameter name), [(new class, new parameter name, linking dimension)]
parameters_to_other_classes = [
	# Unit --> unit__to_node / node__to_unit
	(("unit", "curtailment_cost"), 
		[("unit__to_node", "curtailment_cost", 1), ("node__to_unit", "curtailment_cost", 2)]),
	(("unit", "fom_cost"), 
		[("unit__to_node", "fixed_annual_cost", 1), ("node__to_unit", "fixed_annual_cost", 2)]),
	(("unit", "shut_down_cost"), 
		[("unit__to_node", "shutdown_cost", 1), ("node__to_unit", "shutdown_cost", 2)]),
	(("unit", "start_up_cost"), 
		[("unit__to_node", "startup_cost", 1), ("node__to_unit", "startup_cost", 2)])

]

# (original class, original parameter name),
# 	[(new class, new parameter name, linking dimension)],
#	(multiplication type, [(multiplication parameter class, multiplication parameter name, linking dimension)])
parameter_multiplications = [
	(("unit", "unit_investment_cost"), 
		[("unit__to_node", "investment_cost", 1), ("node__to_unit", "investment_cost", 2)],
		("first", [("unit__to_node", "unit_capacity", 1), ("node__to_unit", "unit_capacity", 2)] )
	),
	(("unit", "units_on_cost"), 
		[("unit__to_node", "online_cost", 1), ("node__to_unit", "online_cost", 2)],
		("first", [("unit__to_node", "unit_capacity", 1), ("node__to_unit", "unit_capacity", 2)] )
	)
]

# (original class, original parameter name), (new class, list of dimensions, new parameter name, mapping of dimensions)
parameters_to_multidimensional_classes = [
	# Unit__node1__node2 --> unit__node1, unit__node2 ratios
	(("unit__node__node", "fix_ratio_out_in_unit_flow"), 
		("unit_flow__unit_flow", ["unit__to_node", "node__to_unit"], "equality_constraint", [1, 2, 3, 1])),
	(("unit__node__node", "fix_ratio_in_out_unit_flow"), 
		("unit_flow__unit_flow", ["node__to_unit", "unit__to_node"], "equality_constraint", [2, 1, 1, 3])),
	(("unit__node__node", "fix_ratio_in_in_unit_flow"), 
		("unit_flow__unit_flow", ["node__to_unit", "node__to_unit"], "equality_constraint", [2, 1, 3, 1])),
	(("unit__node__node", "fix_ratio_out_out_unit_flow"), 
		("unit_flow__unit_flow", ["unit__to_node", "unit__to_node"], "equality_constraint", [1, 2, 1, 3])),
	(("unit__node__node", "min_ratio_out_in_unit_flow"), 
		("unit_flow__unit_flow", ["unit__to_node", "node__to_unit"], "less_than_constraint", [1, 2, 3, 1])),
	(("unit__node__node", "min_ratio_in_out_unit_flow"), 
		("unit_flow__unit_flow", ["node__to_unit", "unit__to_node"], "less_than_constraint", [2, 1, 1, 3])),
	(("unit__node__node", "min_ratio_in_in_unit_flow"), 
		("unit_flow__unit_flow", ["node__to_unit", "node__to_unit"], "less_than_constraint", [2, 1, 3, 1])),
	(("unit__node__node", "min_ratio_out_out_unit_flow"), 
		("unit_flow__unit_flow", ["unit__to_node", "unit__to_node"], "less_than_constraint", [1, 2, 1, 3])),
	(("unit__node__node", "max_ratio_out_in_unit_flow"), 
		("unit_flow__unit_flow", ["unit__to_node", "node__to_unit"], "greater_than_constraint", [1, 2, 3, 1])),
	(("unit__node__node", "max_ratio_in_out_unit_flow"), 
		("unit_flow__unit_flow", ["node__to_unit", "unit__to_node"], "greater_than_constraint", [2, 1, 1, 3])),
	(("unit__node__node", "max_ratio_in_in_unit_flow"), 
		("unit_flow__unit_flow", ["node__to_unit", "node__to_unit"], "greater_than_constraint", [2, 1, 3, 1])),
	(("unit__node__node", "max_ratio_out_out_unit_flow"), 
		("unit_flow__unit_flow", ["unit__to_node", "unit__to_node"], "greater_than_constraint", [1, 2, 1, 3])),

	# Unit__node1__node2 --> unit__node1, unit__node2 coefficients
	(("unit__node__node", "fix_units_on_coefficient_out_in"), 
		("unit_flow__unit_flow", ["unit__to_node", "node__to_unit"], "equality_constant", [1, 2, 3, 1])),
	(("unit__node__node", "fix_units_on_coefficient_in_out"), 
		("unit_flow__unit_flow", ["node__to_unit", "unit__to_node"], "equality_constant", [2, 1, 1, 3])),
	(("unit__node__node", "fix_units_on_coefficient_in_in"), 
		("unit_flow__unit_flow", ["node__to_unit", "node__to_unit"], "equality_constant", [2, 1, 3, 1])),
	(("unit__node__node", "fix_units_on_coefficient_out_out"), 
		("unit_flow__unit_flow", ["unit__to_node", "unit__to_node"], "equality_constant", [1, 2, 1, 3])),
	(("unit__node__node", "min_units_on_coefficient_out_in"), 
		("unit_flow__unit_flow", ["unit__to_node", "node__to_unit"], "less_than_constant", [1, 2, 3, 1])),
	(("unit__node__node", "min_units_on_coefficient_in_out"), 
		("unit_flow__unit_flow", ["node__to_unit", "unit__to_node"], "less_than_constant", [2, 1, 1, 3])),
	(("unit__node__node", "min_units_on_coefficient_in_in"), 
		("unit_flow__unit_flow", ["node__to_unit", "node__to_unit"], "less_than_constant", [2, 1, 3, 1])),
	(("unit__node__node", "min_units_on_coefficient_out_out"), 
		("unit_flow__unit_flow", ["unit__to_node", "unit__to_node"], "less_than_constant", [1, 2, 1, 3])),
	(("unit__node__node", "max_units_on_coefficient_out_in"), 
		("unit_flow__unit_flow", ["unit__to_node", "node__to_unit"], "greater_than_constant", [1, 2, 3, 1])),
	(("unit__node__node", "max_units_on_coefficient_in_out"), 
		("unit_flow__unit_flow", ["node__to_unit", "unit__to_node"], "greater_than_constant", [2, 1, 1, 3])),
	(("unit__node__node", "max_units_on_coefficient_in_in"), 
		("unit_flow__unit_flow", ["node__to_unit", "node__to_unit"], "greater_than_constant", [2, 1, 3, 1])),
	(("unit__node__node", "max_units_on_coefficient_out_out"), 
		("unit_flow__unit_flow", ["unit__to_node", "unit__to_node"], "greater_than_constant", [1, 2, 1, 3]))
]

# (original class, new class, dimensions, mapping of dimensions)
classes_to_be_updated = [
	("unit__from_node", "node__to_unit", ["node", "unit"], [2, 1])
]




# Copy the db from url_in to url_out
function copy_database(url_in, url_out)
	data = export_data(url_in)
	import_data(url_out, data, "Imported data from an old SpineOpt database.")
end


# Go through the parameters, rename them and commit session
function rename_parameters(db_url, parameters_to_be_renamed)
	for (old_par_def, new_par_name, merge_method) in parameters_to_be_renamed
		rename_parameter(db_url, old_par_def[1], old_par_def[2], new_par_name, merge_method)
	end
	run_request(db_url, "call_method", ("commit_session", "Rename parameters."))
end

# Find the parameter id and rename the parameter
function rename_parameter(db_url, class_name, old_par_name, new_par_name, merge_method)
	pdef = run_request(db_url, "call_method", ("get_item", "parameter_definition"), Dict(
		"entity_class_name" => class_name, "name" => old_par_name)
	)
	try
		check_run_request_return_value(run_request(db_url, "call_method", ("update_item", "parameter_definition"), Dict(
			"id" => pdef["id"], "name" => new_par_name))
		)
	catch
		if merge_method == "sum"
			sum_to_existing_parameter(db_url, class_name, old_par_name, new_par_name)
		end
		# Remove old parameter definition
		pdef = run_request(db_url, "call_method", ("get_parameter_definition_item",), Dict(
			"entity_class_name" => class_name, "name" => old_par_name)
		)
		check_run_request_return_value(run_request(
			db_url, "call_method", ("remove_parameter_definition_item", pdef["id"]))
		)
	end
end

# Sum old_par_name values to new_par_name values
function sum_to_existing_parameter(db_url, class_name, old_par_name, new_par_name)
	entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict(
		"entity_class_name" => class_name)
	)
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for entity in entity_items
		# Find existing parameters in all alternatives
		existing_values = find_existing_values(db_url, entity, class_name, new_par_name)
		for alternative in alternative_items
			# Get value of the old parameter
			pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
				"entity_class_name" => class_name, "parameter_definition_name" => old_par_name, 
				"entity_byname" => (entity["element_name_list"]), "alternative_name" => alternative["name"])
			)
			if length(pval) > 0
				parsed_pval = parse_db_value(pval["value"], pval["type"])
				base_alternative_added = false
				# Find if entity in existing_values
				if haskey(existing_values, entity)
					summed_parsed_pval = parsed_pval
					# Loop over alternatives in existing_values[entity]
					for existing_value in existing_values[entity]
						if existing_value[1] == alternative["name"]
							alternative_updated = alternative["name"]
							base_alternative_added = true
						else
							# Create a new alternative based on the two and add
							alternative_updated = string(alternative["name"], "__", existing_value[1])
							try
								println("Warning: Creating a new alternative $alternative_updated, add manually to \
									the scenarios.")
								check_run_request_return_value(run_request(
									db_url, "call_method", ("add_alternative_item",), Dict(
										"name" => alternative_updated)
									)
								)
							catch
								println("Warning: Could not create alternative $alternative_updated.")
							end
						end							
						summed_parsed_pval += existing_value[2]
						summed_pval_value, summed_pval_type = unparse_db_value(summed_parsed_pval)
						# Add the new parameter value into the database
						check_run_request_return_value(run_request(
							db_url, "call_method", ("add_update_parameter_value_item",), Dict(
								"entity_class_name" => class_name, "parameter_definition_name" => new_par_name, 
								"entity_byname" => (entity["element_name_list"]), 
								"alternative_name" => alternative_updated, 	
								"value" => summed_pval_value, "type" => summed_pval_type)
							)
						)
					end
				end
				pval_value2, pval_type2 = unparse_db_value(parsed_pval)
				if !base_alternative_added
					# Add the new parameter value into the database
					check_run_request_return_value(run_request(
						db_url, "call_method", ("add_update_parameter_value_item",), Dict(
							"entity_class_name" => class_name, "parameter_definition_name" => new_par_name, 
							"entity_byname" => (entity["element_name_list"]), "alternative_name" => alternative["name"], 
							"value" => pval_value2, "type" => pval_type2)
						)
					)
				end						
			end
		end
	end
end

# Find existing parameter_name values of entity in all alternatives
function find_existing_values(db_url, entity, class_name, parameter_name)
	existing_values = Dict()
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for alternative in alternative_items
		pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
			"entity_class_name" => class_name, "parameter_definition_name" => parameter_name,
			"entity_byname" => (entity["element_name_list"]), "alternative_name" => alternative["name"])
		)
		if length(pval) > 0
			parsed_value = parse_db_value(pval["value"], pval["type"])
			if !haskey(existing_values, entity)
				existing_values[entity] = [(alternative["name"], parsed_value)]
			else
				push!(existing_values[entity], (alternative["name"], parsed_value))
			end
			break
		end
	end
	return existing_values
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
	# Compute new parameter values
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
	# Compute new parameter values
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


# Go through the parameters, move to other classes while multiplying and commit session
function move_parameters_to_other_classes_and_multiply(db_url, parameters_to_other_classes)
	for (old_par_def, new_par_def, multiplication_def) in parameters_to_other_classes
		for new_par_def_part in new_par_def
			move_parameter_to_another_class_and_multiply(db_url, old_par_def[1], old_par_def[2], new_par_def_part[1], 
				new_par_def_part[2], new_par_def_part[3], multiplication_def
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
	run_request(db_url, "call_method", ("commit_session", "Move parameters to other classes while multiplying."))
end

# Find parameter values and move them into another class while multiplying
function move_parameter_to_another_class_and_multiply(db_url, old_class_name, old_par_name, new_class_name, 
	new_par_name, linking_dimension, multiplication_def
)
	# Add new parameter definition
	try
		check_run_request_return_value(run_request(db_url, "call_method", ("add_parameter_definition_item",), Dict(
			"entity_class_name" => new_class_name, "name" => new_par_name))
		)
	catch
		println("skipping add_parameter_definition_item")
	end
	# Compute new parameter values
	old_entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict(
		"entity_class_name" => old_class_name)
	)
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for old_entity in old_entity_items
		if multiplication_def[1] == "first"
			multipliers = find_multiplier_first(db_url, old_entity, multiplication_def[2])
		else
			break
		end
		for alternative in alternative_items
			# Get value of the old parameter
			pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
				"entity_class_name" => old_class_name, "parameter_definition_name" => old_par_name,
				"entity_byname" => (old_entity["name"],), "alternative_name" => alternative["name"])
			)
			if length(pval) > 0
				parsed_value = parse_db_value(pval["value"], pval["type"])
				# Get the new entities
				new_entities = find_related_entities(db_url, new_class_name, old_entity, linking_dimension)
				for new_entity in new_entities
					# Find if (new_class_name, new_entity) in multipliers
					if haskey(multipliers, (new_class_name, new_entity))
						# Loop over alternatives in multipliers[(new_class_name, new_entity)]
						for multiplier in multipliers[(new_class_name, new_entity)]
							if multiplier[1] == alternative["name"]
								alternative_updated = alternative["name"]
							else
								# Create a new alternative based on the two and add
								alternative_updated = string(alternative["name"], "__", multiplier[1])
								try
									println("Warning: Creating a new alternative $alternative_updated, add manually to \
										the scenarios.")
									check_run_request_return_value(run_request(
										db_url, "call_method", ("add_alternative_item",), Dict(
											"name" => alternative_updated)
										)
									)
								catch
									println("Warning: Could not create alternative $alternative_updated, alternative \
										already exists.")
								end
							end							
							new_value = parsed_value * multiplier[2]
							db_value, db_type = unparse_db_value(new_value)
							# Add the new parameter value into the database
							check_run_request_return_value(run_request(
								db_url, "call_method", ("add_update_parameter_value_item",), Dict(
									"entity_class_name" => new_class_name, 
									"parameter_definition_name" => new_par_name, 
									"entity_byname" => (new_entity["element_name_list"]), 
									"alternative_name" => alternative_updated, 
									"value" => db_value, 
									"type" => db_type)
								)
							)
						end
					end
				end
			end
		end
	end
end

function find_multiplier_first(db_url, entity_item, multiplier_items)
	multipliers = Dict()
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for alternative in alternative_items
		multiplier_found = false
		for multiplier_item in multiplier_items
			related_entities = find_related_entities(db_url, multiplier_item[1], entity_item, multiplier_item[3])
			for related_entity in related_entities
				pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
					"entity_class_name" => multiplier_item[1], "parameter_definition_name" => multiplier_item[2],
					"entity_byname" => (related_entity["element_name_list"]), "alternative_name" => alternative["name"])
				)
				if length(pval) > 0
					parsed_value = parse_db_value(pval["value"], pval["type"])
					if !haskey(multipliers, (multiplier_item[1], related_entity))
						multipliers[(multiplier_item[1], related_entity)] = [(alternative["name"], 1 / parsed_value)]
					else
						push!(multipliers[(multiplier_item[1], related_entity)], (alternative["name"], 1 / parsed_value))
					end
					multiplier_found = true
					break
				end
			end
			if multiplier_found
				break
			end
		end

	end
	return multipliers
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

# Go through the parameters, move to other classes depending on dimension list and commit session
function move_parameters_to_multidimensional_classes(db_url, parameters_to_multidimensional_classes)
	for (old_par_def, new_par_def) in parameters_to_multidimensional_classes
		move_parameter_to_multidimensional_class(db_url, old_par_def[1], old_par_def[2], new_par_def[1], 
			new_par_def[2], new_par_def[3], new_par_def[4]
		)
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
function move_parameter_to_multidimensional_class(db_url, old_class_name, old_par_name, new_class_name, 
	dimension_name_list, new_par_name, mapping
)
	# Add new parameter definition
	try
		check_run_request_return_value(run_request(db_url, "call_method", ("add_parameter_definition_item",), Dict(
			"entity_class_name" => new_class_name, "name" => new_par_name))
		)
	catch
		println("skipping add_parameter_definition_item")
	end
	# Compute new parameter values
	old_entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict(
		"entity_class_name" => old_class_name)
	)
	alternative_items = run_request(db_url, "call_method", ("get_alternative_items",))
	for old_entity in old_entity_items
		for alternative in alternative_items
			# Get value of the old parameter
			pval = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
				"entity_class_name" => old_class_name, "parameter_definition_name" => old_par_name,
				"entity_byname" => (old_entity["element_name_list"]), "alternative_name" => alternative["name"])
			)
			if length(pval) > 0
				# Determine element name list
				new_element_name_list = [old_entity["element_name_list"][i] for i in mapping]
				# Add the entity into the database
				check_run_request_return_value(run_request(
					db_url, "call_method", ("add_entity_item",), Dict(
						"entity_class_name" => new_class_name, 
						"entity_byname" => (new_element_name_list),
						"description" => old_entity["description"])
					)
				)
				# Add the new parameter value into the database
				check_run_request_return_value(run_request(
					db_url, "call_method", ("add_update_parameter_value_item",), Dict(
						"entity_class_name" => new_class_name, 
						"parameter_definition_name" => new_par_name, 
						"entity_byname" => (new_element_name_list), 
						"alternative_name" => alternative["name"], 
						"value" => pval["value"], 
						"type" => pval["type"])
					)
				)
			end
		end
	end

end

function update_ordering_of_multidimensional_classes(db_url, classes_to_be_updated)
	for (old_class, new_class, dimensions, mapping) in classes_to_be_updated
		update_ordering_of_multidimensional_class(db_url, old_class, new_class, dimensions, mapping)
		# Remove old class
		class_item = run_request(db_url, "call_method", ("get_entity_class_item",), Dict("name" => old_class))
		check_run_request_return_value(run_request(
			db_url, "call_method", ("remove_entity_class_item", class_item["id"]))
		)
	end
	run_request(db_url, "call_method", ("commit_session", "Update classes."))
end

function update_ordering_of_multidimensional_class(db_url, old_class, new_class, dimensions, mapping)
	try
		# Create new class
		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => new_class, "dimension_name_list" => dimensions))
		)
	catch
		println("skipping add_entity_class_item")
	end
	try
		# Get entities, alternatives and parameter definitions
		entity_items = run_request(db_url, "call_method", ("get_entity_items",), Dict("entity_class_name" => old_class))
		alternatives = run_request(db_url, "call_method", ("get_alternative_items",))
		pdefs = run_request(db_url, "call_method", ("get_parameter_definition_items",), Dict(
			"entity_class_name" => old_class)
		)
		for pdef in pdefs
			check_run_request_return_value(run_request(db_url, "call_method", ("add_parameter_definition_item",), Dict(
				"entity_class_name" => new_class,
				"name" => pdef["name"],
				"default_value" => pdef["default_value"],
				"default_type" => pdef["default_type"],
				#"parameter_value_list_name" => pdef["parameter_value_list_name"], #does not work
				"description" => pdef["description"]))
			)
		end
		for entity_item in entity_items
			# Add entities
			new_entity_byname = [entity_item["element_name_list"][i] for i in mapping]
			check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_item",), Dict(
				"entity_class_name" => new_class, 
				"entity_byname" => (new_entity_byname),
				"description" => entity_item["description"]))
			)
			for pdef in pdefs
				for alternative in alternatives
					pvals = run_request(db_url, "call_method", ("get_parameter_value_item",), Dict(
						"entity_byname" => (entity_item["element_name_list"]),
						"entity_class_name" => old_class,
						"alternative_name" => alternative["name"],
						"parameter_definition_name" => pdef["name"]
						)
					)
					if length(pvals) > 0
						check_run_request_return_value(run_request(
							db_url, "call_method", ("add_parameter_value_item",), Dict(
							"entity_class_name" => new_class,
							"entity_byname" => (new_entity_byname),
							"alternative_name" => alternative["name"],
							"parameter_definition_name" => pdef["name"],
							"value" => pvals["value"],
							"type" => pvals["type"]))
						)
					end
				end
			end
		end
	catch
		println("Could not update ordering of a multidimensional class.")
	end
end

function create_superclasses_and_subclasses(db_url)
	# Add new classes
	try
		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => "unit"))
		)
		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => "node"))
		)
		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => "unit__to_node", "dimension_name_list" => ["unit", "node"]))
		)
		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => "node__to_unit", "dimension_name_list" => ["node", "unit"]))
		)
 		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => "unit_flow", "dimension_name_list" => ["unit", "node"]))
		)
		check_run_request_return_value(run_request(db_url, "call_method", ("add_entity_class_item",), Dict(
			"name" => "unit_flow__unit_flow", "dimension_name_list" => ["unit_flow", "unit_flow"]))
		)
		check_run_request_return_value(run_request(db_url, "call_method", ("add_superclass_subclass_item",), Dict(
			"superclass_name" => "unit_flow", "subclass_name" => "node__to_unit"))
		)
		check_run_request_return_value(run_request(db_url, "call_method", ("add_superclass_subclass_item",), Dict(
			"superclass_name" => "unit_flow", "subclass_name" => "unit__to_node"))
		)
	catch
		println("Could not add superclasses and subclasses.")
	end
end

# Always check the last item
function check_run_request_return_value(value_to_be_checked)
	if value_to_be_checked[end] != nothing && value_to_be_checked[end] != ""
		println(value_to_be_checked[end])
		throw(error())
	end
end

function run_migrations()
	create_superclasses_and_subclasses(url_out)
	copy_database(url_in, url_out)
	update_ordering_of_multidimensional_classes(url_out, classes_to_be_updated)
	rename_parameters(url_out, parameters_to_be_renamed)
	transform_parameters_to_maps(url_out, parameters_to_maps)
	move_parameters_to_other_classes(url_out, parameters_to_other_classes)
	move_parameters_to_other_classes_and_multiply(url_out, parameter_multiplications)
	move_parameters_to_multidimensional_classes(url_out, parameters_to_multidimensional_classes)
end

url_in = ARGS[1]
url_out = ARGS[2]


run_migrations()
