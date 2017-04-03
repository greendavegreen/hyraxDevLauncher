# Hyrax Developer Templates


[![Launch VPC](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxVPCStack&templateURL=https://s3.amazonaws.com/hybox-deployment-artifacts/cloudformation/current/templates/stack.json)

[![Launch VM](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxUserXXStack&templateURL=https://s3.amazonaws.com/hybox-deployment-artifacts/cloudformation/current/templates/stack.json)

These AWS CloudFormation templates create a development VM for hyrax which runs on a single EC2 instance.
  
![AWS Stack Diagram](https://cloud.githubusercontent.com/assets/111218/16077301/e8a0dc6c-32ef-11e6-80b4-e9e74c18973e.png)


## Creating a dev instance
0. Select an AWS region, e.g.:

```
$ AWS_DEFAULT_REGION=us-east-1
```

1. Create or import an [EC2 key-pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) for that region.


4. Create the full application stack:

```console
$ aws --region $AWS_DEFAULT_REGION cloudformation create-stack --stack-name myStackName --template-body https://s3.amazonaws.com/hybox-deployment-artifacts/cloudformation/current/templates/stack.json --capabilities CAPABILITY_IAM --parameters file://params/private.json
```

You can also create (or update) your application from branches of the cloudformation repository:

```console
$ aws --region $AWS_DEFAULT_REGION cloudformation create-stack --stack-name hybox --template-body https://s3.amazonaws.com/hybox-deployment-artifacts/cloudformation/branch/branch-name/templates/stack.json --capabilities CAPABILITY_IAM --parameters file://params/my-hybox-environment.json
```

You can also deploy branches of the hybox application repository by setting the `WebappS3Key` parameter for your stack to point at the branch-specific deployment artifact (e.g. `hyku/branch/branch-name/hyku.zip`)

The stack will spin up in the following order:

```console
|- stack
   |- mail
   |- slack
   |- vpc
      |- securitygroups
          |- bastion
          |- zookeeper
              |- solr
          |- redis
          |- fcrepo
          |- postgres
              |- application
                  |- codepipeline
                      |- workers
                      |- webapp
```

## Travis deployment integration

The AWS CloudFormation stack must be deployed into an S3 bucket for CloudFormation to correctly resolve sub-stack references. The `templates/travis.json` stack will bootstrap the necessary buckets, IAM user, and access keys to support continuous deployment from both this CloudFormation repository and the Hydra-in-a-Box application repository.

This bootstrapping is already provided for the main repositories, but if you deploy a fork of this stack, you may need to create this stack and configure continuous deployment for your forks. These files will expire from S3 after a period of time, so pushing a change to the repository may be required to republish the templates.

```console
$ aws --region $AWS_DEFAULT_REGION cloudformation create-stack --stack-name travis --template-body file://templates/travis.json --capabilities CAPABILITY_IAM
```

You will need the outputs from this stack to create [deploy steps](https://docs.travis-ci.com/user/deployment/s3 ) for these repositories.
