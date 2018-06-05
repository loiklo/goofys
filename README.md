
# puppet-goofys

Module to manage Goofys, the S3 mounter for your AWS intance.






#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with puppet-goofys](#setup)
    * [What puppet-goofys affects](#what-goofys-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with goofys](#beginning-with-goofys)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This puppet 5 compatible module manage the installation of Goofys and the list of mount point.

## Setup

### What puppet-goofys affects

This module create a new directory in /opt and download the Goofys binary. Following the hiera configuration, it can handle the mount points in /etc/fstab and mount the S3 buckets.

### Setup Requirements

This module requires the installation of puppetlabs-stdlib and puppetlabs-mount_providers and puppet-awscredentials (github/loiklo/puppet-awscredentials).

Prior mounting the S3 bucket, Goofys requires to have the /root/.aws/credentials filled with an account with proper right on the S3 bucket. This is done in the module github/loiklo/puppet-awscredentials.

### Beginning with goofys

The very basic steps needed for a user to get the module up and running. This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

## Usage

1. On the puppet master:

```bash
cd /etc/puppetlabs/code/modules
git clone https://github.com/loiklo/puppet-awscredentials.git awscredentials
git clone https://github.com/loiklo/puppet-goofys.git goofys
```

2. Subscribe your instance to the puppet module

3. Fill the hiera file

```yaml
---
awscredentials::awsprofiles:
  default:
    aws_access_key_id: abcdefghijklmnopqrst
    aws_secret_access_key: abcdefghijklmnopqrstuvwxyz0123456789abcd
  goofys-aws:
    aws_access_key_id: zyxwvutsrqponmlkjihg
    aws_secret_access_key: dcba9876543210zyxwvutsrqponmlkjihgfedcba

goofys::version: 0.19.0
goofys::s3buckets:
  s3b001.bucket.demo.internal:
    mount_point: /aws/bucket-s3b001
    options: '--file-mode=0666,--profile=goofys-aws'
    ensure: present
  s3b002.bucket.demo.internal:
    mount_point: /aws/bucket-s3b002
```

## Reference

| Key | Value | Default | Example |
| --- | ----- | ------- | ------- |
| goofys::version | Version to intall | latest | latest / 0.19.0 |
| goofys::s3buckets | Hash of S3 buckets | mandatory | s3b001.bucket.demo.internal |
| mount_point | Where to mount the S3 bucket | mandatory | /aws/bucket-s3b001 |
| options | A single string containing options for the mount, as they would appear in fstab, see Goofys documentation | empty | --file-mode=0666,--profile=goofys-aws |
| ensure | State of the mount point (see bellow) | mounted | mounted / unmounted / absent / defined or present |

State of the ressource:

- mounted: add to fstab and for the ressource to be mounted
- unmounted: add to fstab but force the ressource to be unmounted
- absent: force umount and remove the fstab entry
- defined/present: add the fstab entry only


## Limitations

To prevent permanent re-download of the Goofys binary when the version 'latest' is specified, only the latest version when the module is instanciated will be downloaded. It's recommended to force the Goofys version instead.

## Development

If you want to contribute, just open a pull request with your improvement.

