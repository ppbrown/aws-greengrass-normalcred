# aws-greengrass-normalcred

Provides an AWS Greengrass component, that uses its IoT based
authentication, to request and generate a AWS credential
file in a more "normal" format. 
eg: something you could put in $HOME/.aws/credential

This is useful if you have a program that wont use the
automatic auth present inside a Component.
Or, if for some reason, you want to run it outside of
a Component environment, to access AWS services directly


# Requirements

Basically, all the AWS requirements detailed in the document at


https://docs.aws.amazon.com/iot/latest/developerguide/authorizing-direct-aws.html

However, locally, you will need the following programs installed:

* aws
* jq

You will also need to have created the ggc_user and home directory


## High level summary:

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

