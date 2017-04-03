# Hyrax Developer Templates


[![Launch VPC](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxVPCStack&templateURL=https://s3.amazonaws.com/hyrax-cf/vpc.yaml)  Launch VPC_Setup stack

[![Launch VM](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxUserXXStack&templateURL=https://s3.amazonaws.com/hyrax-cf/stack.yaml) Create a hyrax Dev Node inside a VPC Stack

These AWS CloudFormation templates create a development VM for hyrax which runs on a single EC2 instance.
  
![AWS Stack Diagram](https://cloud.githubusercontent.com/assets/111218/16077301/e8a0dc6c-32ef-11e6-80b4-e9e74c18973e.png)

## Creating a dev instance using the AWS Console & the buttons above

The scripts are generally only supported for running in the us-east-1 region.  The buttons above take care of launching there.

1. You will need to create an EC2 key-pair for SSH communications with your developer box.  Instructions for creating a keypair and downloading your private portion of the key can be found at [Create EC2 key-pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

2. Nothing is required to create a new VPC setup.  This will establish a basic set of subnets and routings rules inside of which a hyrax node can run.  If you already have this stack deployed, just note the stack name for use in the hyrax creation step.

3. Using the dev node creation button above, request a new server by specifying the name of the VPC stack, the keypair name you have posession of, and a set of initials or unique name to use for your system.  The final VM will get tagged with the name hyrax-server-XXX where XXX is the string you provide.  This provides a hook for scripts to locate resources connected to a particular developer node for startup, shutdown, termination, cleanup later on.


