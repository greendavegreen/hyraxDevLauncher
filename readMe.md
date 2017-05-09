# Hyrax Developer Templates

[![Launch VM](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxUserXXStack&templateURL=https://s3.amazonaws.com/hyrax-cf/stack.yaml) Create a hyrax Dev Node inside a VPC Stack

This AWS CloudFormation templates create a development VM for hyrax which runs on a single EC2 instance.  It requires that you have previously run the shared infrasctuture network creation script in your account.  You can do this by first following the instructions at the end of this page and using the button to launch said script.
 
## Creating a hyrax dev instance using the launch VM button

The script are generally only supported for running in the us-east-1 region.  The buttons above take care of launching there.

1. You will need to create an EC2 key-pair for SSH communications with your developer box.  Instructions for creating a keypair and downloading your private portion of the key can be found at [Create EC2 key-pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)


3. Using the dev node creation button above, request a new server.  If you are not logged into the AWS Console you will be asked to do so.  

4. You will be taken to the stack-launch page with the s3-location of the template filled in.  Select Next.

5. You will be asked to provide options/aguments/names:
 - a (unique) name this stack of resources you are creating (remember this to be able to clean up/terminate the stack later)
 - the ssh keypair name you have created or uploaded to the AWS Console
 - a unique name (user initials?) to use for your system.  The final VM will get tagged with the name hyrax-server-XXX where XXX is the string you provide.  This provides a hook for scripts to locate resources connected to a particular developer node for startup, shutdown, termination, cleanup later on.
 - With the above 3 items set, select next
 
6. You will be shown Options panel, accept defaults.  Sit Next.

7. On the Review Page, YOU MUST CHECK the box at the bottom to acknowledge that this is creating security roles and granting access to the VM to some resources inside your account.  Select Next.


9. You will be taken to the cloudformation console where you can watch the progress of the stack creation.  It usually takes approximately 5-10 minutes to complete.

You should now have a VM inside your account, that is running:
  - solr
  - redis
  - fedora
  - fits
  - and have a full copy of the hyrax-app checked out and installed.
  
You should see this instance in the ec2-instances panel of the AWS Console.

The Network Security Group attached to it will not allow ANY connections to the outside world by default.  If you are familiar with Security groups, you can open the machine to traffic using the functions of the EC2 console interface.  We also have a utility script from the command line that can find your VM, select its group, and add just your current IP to its list of granted ingress.

## Steps to get access to your new VM via the console and command line:

1. Install the AWS command line tools  [Install Instructions](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
2. Obtain a AccessKey/SecretAccessKey pair that allows usage of AWS APIs. [Getting API keys](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) 
3. Configure the command line tool with this keypair as your default keypair for api access. [Configure CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

4. Inside your accounts .aws directory, you need to create an empty cli directory and place a copy of the file named 'alias' from this github project into it.

```console
$ mkdir -p ~/.aws/cli
$ curl -o !/.aws/cli/alias https://raw.githubusercontent.com/greendavegreen/hyraxDevLauncher/master/alias
```

5. Do a quick check that you have the right identity, this should show the lnadac account and your IAM username

```console
$ aws whoami
{
    "Account": "xxxxxxxxxxxxxx", 
    "UserId": "yyyyyyyyyyyyy", 
    "Arn": "arn:aws:iam::xxxxxxxxxxxx:user/IAMUsername"
}
```

6. Use the hyrax-start script via the AWS cli to start your VM (where XXX is the name/initials you used for your VM)
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

7. All linux-vms created in AWS EC2 have a default user ec2-user upon creation.  The public portion of your SSH keypair is injected into this login.

8. If you placed the private side of your key into .ssh directory already, you can just ssh without other arguments.  Otherwise, specify the private side of your key using the -i flag.

```console
ssh ec2-user@XXX.cloud.lnadac.org
```

9. Once on your machine, you will find:
- solr running as an init.d service answering port 8983
- Fedora running inside Jetty service, answering port 8080
- redis, installed as service and running on standard port
- LibreOffice installed 
- FITS installed
- source code for a default [hyrax_app](https://github.com/greendavegreen/hyrax_app.git) checked out into /var/app/hyrax_app
- bundle install and rake db:migrate will have already been run for you
- to run the hyrax rails app from the app directory use the command `puma`
- it should then be running on port 3000 in development mode

It should be noted that REDIS, LibreOffice, and FITS might need to be introduced to the hyrax app.  Currently, they are invocable from the command line, but it is unclear if this is enough for Hyrax to engage with them.

10. Turn it off when not in use to reduce billing:
```console
$ aws hyrax-stop XXX
issuing stop request for i-035687e0a28d829ea
removing firewall hole for current ip
waiting for instance state to transition to stopped
```

11. Terminate it when you are really done with it.  This can be done in the cloudformation section of the AWS Console by requesting a delete of the StackName that you generated to start this in step 5 above.



# Shared network infrastructure stack

1. You will be asked to provide a stack name for this shared infrastructure.  The name is not important and up to you to settle upon.  Beyond that, all of the defaults should be accepted.  You will then have a network that is suitable for running hyrax servers and pulicly exported values will be available to the hyrax server creation script(s) you will run later.

[![Launch VPC](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=hyraxVPCStack&templateURL=https://s3.amazonaws.com/hyrax-cf/vpc.yaml)  Launch VPC_Setup stack
