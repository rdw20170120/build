#!/bin/bash
# Run pylint on this project

pylint -f parseable . | tee ./pylint.out

