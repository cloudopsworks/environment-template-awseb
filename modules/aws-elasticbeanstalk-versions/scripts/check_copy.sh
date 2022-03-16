#!/usr/bin/env sh
#
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
##

from_dir=$1
to_dir=$2

if [ -d $from_dir ] ; then
  echo "Performing recursive copy $from_dir --> $to_dir"
  cp -pr $from_dir $to_dir
else
  echo "$from_dir NOT exists, skipping..."
fi