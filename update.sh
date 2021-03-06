#!/usr/bin/env bash
aws s3 sync . s3://hyrax-cf --profile dac \
                            --exclude ".git/*" --exclude "*.sh"
aws cloudformation update-stack --profile dac \
                          --template-file stack.yaml \
                          --stack-name stack \
                          --capabilities CAPABILITY_IAM
