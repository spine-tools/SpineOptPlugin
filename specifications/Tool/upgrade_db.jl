using SpineOpt

for url in ARGS
    SpineOpt.upgrade_db(url)
end