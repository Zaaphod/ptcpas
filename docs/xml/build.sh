#! /bin/sh

# go to the ptc main src dir
cd ../..

# build the documentation
fpdoc --package=ptc \
      --input='-dfpdoc -Fi. -Ficore ptc.pp' \
      --descr=docs/xml/ptc.xml \
      --output=docs/api-reference \
      --format=html \
      --warn-no-node
