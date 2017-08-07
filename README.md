# LoRaWAN-NMS
LoRaWAN Network Management System
## Table of contents
[TOC]
## Management

### Overview

| METHOD | URL                                      | What to do      |
| ------ | ---------------------------------------- | --------------- |
| GET    | /app/ | Get the application list of a user |
| POST   | /create_app/ | Create a new application |


## Install

### Gem Dependency
Install this API by cloning the *relevant branch* and installing required gems
```
$ bundle install
```


### Database
#### Build up your local database
```
$ rake db:migrate
```
It will build `dev.db` sqlite database at  `db` folder.

#### Reset database
```
$ rake db:reset
```

## Execute
Run this API by using:

```
$ rackup
```

If you want to change your port
```
$ rackup -p <port>
```
