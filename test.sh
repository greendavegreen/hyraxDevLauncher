#!/usr/bin/env bash
aws cloudformation deploy --profile dac \
                          --template-file test.yaml \
                          --stack-name stack \
                          --capabilities CAPABILITY_IAM
