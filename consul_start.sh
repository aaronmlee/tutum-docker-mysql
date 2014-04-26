#!/bin/bash

exec /usr/bin/consul agent -config-dir=/etc/consul.d -data-dir=/tmp/consul -join $CONSUL_JOIN_IP 
