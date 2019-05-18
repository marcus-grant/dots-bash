#! /usr/bin/env bash
# Setup the timing and logging @ /tmp/bashstart.TIMESTAMP.log
PS4='+ $(date "+%s.%N")\011 '
exec 3>&2 2>/tmp/bashstart.$$.log
set -x
# Run bash_profile
source ~/.dots/bash/bash_profile
# End the profiler
set +x
exec 
