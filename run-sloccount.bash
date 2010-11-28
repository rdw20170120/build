#!/bin/bash
# Run sloccount to count lines-of-code (LOC) in this project

sloccount --duplicates --wide --details . > ./sloccount.sc

