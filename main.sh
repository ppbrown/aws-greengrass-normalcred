#!/bin/bash


# loop forever, attempting to keep the local credential file
# fresh

# Vars automatically provided by Greengrass are documented at
# https://docs.aws.amazon.com/greengrass/v2/developerguide/component-environment-variables.html
# We want to use:
# AWS_IOT_THING_NAME

seconds=${seconds:-1800} # 1800 seconds = 30 minutes
credentialfile=${credentialfile:-"/home/ggc_user/timestream.cred"}
role=${role:-TimestreamAccessRoleAlias}
region=${region:-us-west-2}


#################################################

echo Starting up at $(date)

# Check early for required programs
jq --help >/dev/null || exit 1
aws help >/dev/null || exit 1

ENDPOINT=$(aws iot describe-endpoint --endpoint-type iot:CredentialProvider| jq -r .endpointAddress)

# two debug output lines
echo DEBUG: $(aws sts get-caller-identity --query Arn --output text)
echo DEBUG: Endpoint is $ENDPOINT

if [[ "$ENDPOINT" == "" ]] ; then
	echo ERROR: Cant find required endpoint
	exit 1
fi

while getopts "s:c:r:R:" opt ; do
	case $opt in
		s) seconds=$OPTARG ;;
		c) credentialfile=$OPTARG ;;
		r) role=$OPTARG ;;
		R) region=$OPTARG ;;
	esac
done

shift $(($OPTIND - 1))



while true; do
	curl --cert /greengrass/v2/thingCert.crt --key /greengrass/v2/privKey.key -H "x-amzn-iot-thingname: ${AWS_IOT_THING_NAME}" --cacert ${GG_ROOT_CA_PATH} https://${ENDPOINT}/role-aliases/${role}/credentials > ${credentialfile}.json
jq -r '"[default]",
 "region = {region}",
 "aws_access_key_id=" + .credentials.accessKeyId, 
 "aws_secret_access_key=" + .credentials.secretAccessKey, 
 "aws_session_token=" + .credentials.sessionToken, 
 ""' < ${credentialfile}.json > ${credentialfile}.tmp
	mv ${credentialfile}.tmp  ${credentialfile}

	echo sleeping for $seconds seconds
	sleep $seconds
	date
done

