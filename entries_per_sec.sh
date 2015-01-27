#!/bin/bash

# Every 10 s output number of new lines added to a text or log file.

tail -f $1 | pv -l -i10 -r >/dev/null
