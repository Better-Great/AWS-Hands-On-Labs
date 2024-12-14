#!/usr/bin/env bash

aws cloudformation deploy \
--template-file template.yaml \
--stack-name sts-fun-stack \
--capabilities CAPABILITY_IAM