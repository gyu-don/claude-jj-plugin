#!/bin/bash
# jj automatically tracks changes; running status triggers snapshot
jj st >/dev/null 2>&1 || exit 0
