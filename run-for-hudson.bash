#!/bin/bash
# Run build steps for Hudson

./run-nose.bash
./run-pylint.bash
./run-sloccount.bash

