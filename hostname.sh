#!/bin/bash

sed -i 's/\(127\.0\.0\.1\)\s*.*\s*\(localhost\)\s/\1\t\2 /' /etc/hosts
