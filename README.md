# aws-greengrass-normalcred

Provides an AWS Greengrass component, that uses its IoT based
authentication, to request and generate a AWS credential
file in a more "normal" format. 
eg: something you could put in $HOME/.aws/credential

This is useful if you have a program that wont use the
automatic auth present inside a Component.
Or, if for some reason, you want to run it outside of
a Component environment, to access AWS services directly

Additionally, it exports env vars you would normally see inside
a greengrass component
Turns out this is *really useful for debugging code*. 
You can keep iterating over versions of a python script that
would normally run inside a component, for example...
without having to rebuild and redeploy your actual component.


# Usage

Once you install the container, and start it up, you can choose to either use the cred file, or the environment file.

If you want to use the cred file rather than the env file, 
you will need the following programs installed to parse out the values:

* aws
* jq

You will also need to have created the ggc_user and home directory

Alternatively, to use the environment variable method, just source the env file that the running container creates in
/home/ggc_user/env_export

Either way, you should then be able to use your choice of AWS code from your normal shell prompt, but using the credentials for the greengrass component


## High level summary of AWS permissions:

Basically, all the AWS requirements detailed in the document at

https://docs.aws.amazon.com/iot/latest/developerguide/authorizing-direct-aws.html

* Create a role that has access for the service you want, if you dont
have one already

* In IoT -> Security -> Role Aliases, create an alias pointing to the above

* In IoT -> Security -> Policies, create the permissions for your IoT device
to take advantage of the Role Alias

# Customization

By default, the component will generate the cred file in

/home/ggc_user/timestream.cred

It should refresh it every 30 minutes


To customize the roles and service this component sets up, you can either
edit the main.sh script, or edit the recipe to change the calling arguments
using -s, -c, -r, and/or -R

