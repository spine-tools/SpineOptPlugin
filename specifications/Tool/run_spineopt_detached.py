# Works only on Windows

import os
import tempfile
import sys
from subprocess import Popen, CREATE_NEW_CONSOLE
from spinedb_api.spine_db_client import get_db_url_from_server

url_in = get_db_url_from_server(sys.argv[1])
url_out = get_db_url_from_server(sys.argv[2])
(fd, filename) = tempfile.mkstemp()
(fd2, bat_filename) = tempfile.mkstemp()
try:
    tfile = os.fdopen(fd, "w")
    tfile.write("using SpineOpt\n")
    tfile.write(
        'm=run_spineopt(raw"' + url_in + '",raw"' + url_out + '",write_as_roll=30)\n'
    )
    tfile.close()
    Popen(["julia", "-i", filename, "--threads 2"], creationflags=CREATE_NEW_CONSOLE)
finally:
    print("done")
