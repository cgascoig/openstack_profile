# openstack_profile

## Overview

Puppet module containing profile classes for openstack installation. 

## Module Description

Profiles to install and configure the following OpenStack components:

* keystone
* glance
* horizon
* nova on a controller node
* neutron on a controller node
* nova on a compute node
* neutron on a compute node

As well as their major requirements such as:

* mysql
* rabbitmq

## Usage

See http://github.com/cgascoig/openstack_role for example role classes that use these profiles.

What these profiles do not do (now), that you should probably do manually:

* Interface configuration (importantly, MTU config - this will bite you if you use VXLAN)
* Create br-ex (ovs-vsctl add-br br-ex) on the network / controller node
* Upgrade all packages before adding the OpenStack repos
* Disable firewall on CentOS


Tested on CentOS 7, and partially on Ubuntu 14.04.3

