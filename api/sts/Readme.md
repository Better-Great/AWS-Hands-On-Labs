## Create a user with no permissions

We need to create a new user with no permissions and generate out access keys. This is because this is the best way to really practice the **security token service** and apply it properly. 

```sh
aws iam create-user --user-name sts-machine-user
# This command below output it in a table format
aws iam create-access-key --user-name sts-machine-user --output table
```

Copy the access key and secret here
```sh
aws configure
```

Then edit credentials file to change away from default profile

```sh
open ~/.aws/credentials 
```

Test who you are:

```sh
aws sts get-caller-identity
aws sts get-caller-identity --profile sts
```

Ensure you have not granted the new user just created access to S3, the result of the command should be similar to somehting below. 

```sh
aws s3 ls --profile sts
```
> An error occurred (AccessDenied) when calling the ListBuckets operation: User: arn:aws:iam::053022822739:user/sts-machine-user is not authorized to perform: s3:ListAllMyBuckets because no identity-based policy allows the s3:ListAllMyBuckets action

## Create a Role

We need to create a role that will grant us access a new resource

```sh
chmod u+x bin/deploy
./bin/deploy
```

## Use new user crednetials and assume role

```sh
aws iam put-user-policy \
--user-name sts-machine-user  \
--policy-name StsAssumePolicy \
--policy-document file://policy.json
```

```sh
aws sts assume-role \
--role-arn arn:aws:iam::053022822739:role/sts-fun-stack-StsRole-nrzb7D0Iigpv \
--role-session-name s3-sts-fun \
--profile sts
```

```sh
aws sts get-caller-identity --profile assumed
```

```sh
aws s3 ls --profile assumed
```

## Cleanup

Delete the cloudformation stack via the AWS Managemnet Console and follow the commands below to delete other resources created as well as the machine user, we used for testing. 

```sh
aws iam delete-user-policy --user-name sts-machine-user --policy-name StsAssumePolicy
aws iam delete-access-key --access-key-id AKIAQYWDICFJV5DSSOPY --user-name sts-machine-user
aws iam delete-user --user-name sts-machine-user
```