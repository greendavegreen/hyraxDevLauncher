#!/usr/bin/env bash
aws s3 sync . s3://hyrax-cf --profile dac --exclude ".git/*" --exclude ".idea/*" --exclude "*.sh"
