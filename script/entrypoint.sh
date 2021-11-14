#!/bin/bash
set -e

cp /data/apps/servicerepo/.bundle/config /usr/local/bundle/config

exec "$@"
