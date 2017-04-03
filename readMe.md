# Hyrax Developer Templates


[![Launch VPC](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxVPCStack&templateURL=https://s3.amazonaws.com/hyrax-cf/vpc.yaml)  Launch VPC_Setup stack

[![Launch VM](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxUserXXStack&templateURL=https://s3.amazonaws.com/hyrax-cf/stack.yaml) Create a hyrax Dev Node inside a VPC Stack

These AWS CloudFormation templates create a development VM for hyrax which runs on a single EC2 instance.
 
## Creating a dev instance using the AWS Console & the buttons above

The scripts are generally only supported for running in the us-east-1 region.  The buttons above take care of launching there.

1. You will need to create an EC2 key-pair for SSH communications with your developer box.  Instructions for creating a keypair and downloading your private portion of the key can be found at [Create EC2 key-pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

2. Nothing is required to create a new VPC setup.  This will establish a basic set of subnets and routings rules inside of which a hyrax node can run.  If you already have this stack deployed, just note the stack name for use in the hyrax creation step.

3. Using the dev node creation button above, request a new server.  If you are not logged into the AWS Console you will be asked to do so.  

4. You will be taken to the stack-launch page with the s3-location of the template filled in.  Select Next.

5. You will be asked to give:
 - a (unique) name this stack of resources you are creating (remember this to be able to clean up the stack later)
 - a name of the VPC stack (from above) to launch inside of
 - the ssh keypair name you have created or uploaded to the AWS Console
 - a unique name (user initials?) to use for your system.  The final VM will get tagged with the name hyrax-server-XXX where XXX is the string you provide.  This provides a hook for scripts to locate resources connected to a particular developer node for startup, shutdown, termination, cleanup later on.

6. Select Next.  you will have the chance to provide extra options on the Options panel.  Hit Next.

7. On the Review Page, YOU MUST CHECK the box at the bottom to acknowledge that this is creating security roles and granting access to the VM to some resources inside your account.  

8. Finally, hit create.

9. you will be taken to the cloudformation console where you can watch the progress of the stack creation.  It usually takes approximately 5 minutes to complete.


You should now have a VM inside your account, that is running:
  - solr
  - redis
  - fedora
  - fits
  - and have a full copy of the hyrax-app checked out and installed.
  
You should see this instance in the ec2-instances panel of the AWS Console.

The Network Security Group attached to it will not allow ANY connections to the outside world by default.  If you are familiar with Security groups, you can open the machine to traffic using the functions of the EC2 console interface.  We also have a utility script from the command line that can find your VM, select its group, and add just your current IP to its list of granted ingress.

Steps to get access to your new VM via the console and command line:

1. Install the AWS command line tools  [Install Instructions](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
2. Obtain a AccessKey/SecretAccessKey pair that allows usage of AWS APIs. [Getting API keys](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) 
3. Configure the command line tool with this keypair as your default keypair for api access. [Configure CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

4. Inside your accounts .aws directory, you need to create an empty cli directory and place a copy of the file named 'alias' from this github project into it.

```console
$ mkdir -p ~/.aws/cli
$ curl -o !/.aws/cli/alias https://raw.githubusercontent.com/greendavegreen/hyraxDevLauncher/master/alias
```

5. do a quick check that you have the right identity, this should show the lnadac account and your IAM username

```console
$ aws whoami
{
    "Account": "xxxxxxxxxxxxxx", 
    "UserId": "yyyyyyyyyyyyy", 
    "Arn": "arn:aws:iam::xxxxxxxxxxxx:user/IAMUsername"
}
```

6. use the hyrax-start script via the AWS cli to start your VM (where XXX is the name/initials you used for your VM)
```console
 ~ aws hyrax-start tt
------------------------
|    StartInstances    |
+----------+-----------+
|  current |   prior   |
+----------+-----------+
|  pending |  stopped  |
+----------+-----------+
Punching hole in firewall for your IP: 129.170.117.158
waiting for instance i-035687e0a28d829ea to start

Instance available publicly at ip 54.89.26.20
A record set for XXX.cloud.lnadac.org.


 connect via ssh using:
  ssh -i keyPairName.pem ec2-user@XXX.cloud.lnadac.org
```

7. all linux-vms created in AWS EC2 have a default user ec2-user upon creation.  The public portion of your SSH keypair is injected into this login.

8. If you placed the private side of your key into .ssh directory already, you can just ssh without other arguments.  Otherwise, specify the private side of your key using the -i flag.

```console
ssh ec2-user@XXX.cloud.lnadac.org
```

9. once on your machine, you will find:
- solr running as an init.d service answering port 8983
- Fedora running inside Jetty service, answering port 8080
- redis, installed as service and running on standar port
- source code for a default hyrax_app checked out into /var/app/hyrax_app
- to run the hyrax rails app from the app directory use the command `puma`
- it should then be running on port 3000 in development mode

10. turn it off when not in use to reduce billing:
```console
$ aws hyrax-stop XXX
issuing stop request for i-035687e0a28d829ea
removing firewall hole for current ip
waiting for instance state to transition to stopped
```
