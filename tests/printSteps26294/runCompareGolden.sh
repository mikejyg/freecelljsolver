#!/usr/bin/env bash

./run.sh | tee test.log
echo comparing against golden...
diff fc26294.log test.log
