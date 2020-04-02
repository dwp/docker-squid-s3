# docker-squid-s3
Docker container with Squid + config files retrieved from S3.
Container images are available via https://hub.docker.com/r/dwpdigital/squid-s3.

# Building
`docker build -t squid-s3 .`

# Running

The container takes the following environment settings.

## Squid configuration file location (required)

* `ECS_SQUID_CONFIG_S3_BUCKET` - Required - The name of the S3 bucket that contains
                             squid's configuration files
* `ECS_SQUID_CONFIG_S3_PREFIX` - Required - The S3 prefix of all of squid's
                             configuration files in the above bucket

## AWS authentication credentials (optional)

If your deployment environment doesn't use IAM profiles (task execution roles or
EC2 instance profiles) then you will need to supply the following:

* `AWS_ACCESS_KEY_ID`      - The access key ID to use to authenticate with S3
* `AWS_SECRET_ACCESS_KEY`  - The secret access key to use authenticate with S3

## Assume role configuration (optional)

If your deployment environment requires you to assume a role before being able
to access S3 resources then you will need to supply the following:

* `AWS_ASSUMEROLE_ACCOUNT` - The account owning the role to assume
* `AWS_ASSUMEROLE_ROLE`    - The role to assume

## Examples

### Running on EC2 with an instance profile, or ECS with a task execution role

```
ECS_SQUID_CONFIG_S3_BUCKET=config-files
ECS_SQUID_CONFIG_S3_PREFIX=squid squid
```

### Running locally; no assume role required

```
docker run \
  -e ECS_SQUID_CONFIG_S3_BUCKET=config-files \
  -e ECS_SQUID_CONFIG_S3_PREFIX=squid \
  -e AWS_ACCESS_KEY_ID=ASIAABCDEF00GHI0JK0L \
  -e AWS_SECRET_ACCESS_KEY=xaitooGheiJ4ieBaeshah3omush3Bei3wie6Ahz0 \
  squid
```

### Running locally; assuming role

 ```
 docker run \
   -e ECS_SQUID_CONFIG_S3_BUCKET=config-files
   -e ECS_SQUID_CONFIG_S3_PREFIX=squid
   -e AWS_ACCESS_KEY_ID=ASIAABCDEF00GHI0JK0L
   -e AWS_SECRET_ACCESS_KEY=xaitooGheiJ4ieBaeshah3omush3Bei3wie6Ahz0
   -e AWS_ASSUMEROLE_ACCOUNT=012345678901
   -e AWS_ASSUMEROLE_ROLE=s3_read_role squid
```

### Running locally; assuming role with MFA

```
docker run \
  -e ECS_SQUID_CONFIG_S3_BUCKET=config-files
  -e ECS_SQUID_CONFIG_S3_PREFIX=squid
  -e AWS_ACCESS_KEY_ID=ASIAABCDEF00GHI0JK0L
  -e AWS_SECRET_ACCESS_KEY=xaitooGheiJ4ieBaeshah3omush3Bei3wie6Ahz0
  -e AWS_ASSUMEROLE_ACCOUNT=012345678901
  -e AWS_ASSUMEROLE_ROLE=s3_read_role
  -e AWS_SESSION_TOKEN==aw8Gae3thagei6... squid
```
