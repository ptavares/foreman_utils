# foreman_utils

Simple bash script to call foreman api to retrieve some information

## Installation
Clone git repository

```bash
 git clone https://github.com/ptavares/foreman_utils
```

## Configure foreman connection
Create a folder in your home:

```bash
 mkdir ~/.foreman
```
Create two files like below:

```bash
 cat ~/.foreman/config

url=https://foreman.ippon-hosting.net


 cat ~/.foreman/credentials

user=<user_name>
password=<password>

```

User must be authorized to connect to foreman API.

 ## Execute

Run foreman.sh script to print usage

```bash
 ./foreman.sh
```

