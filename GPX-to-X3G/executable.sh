#!/bin/bash

if [ -x $1 ]; then
    echo YES, it is executable
else
    echo NO, it is not executable
fi