#! /bin/sh

# go to the ptc main src dir
cd ../..

# generate ptc-update.xml, which has all the missing nodes, that need to be
# added to ptc.xml
makeskel --package=ptc \
         --input='-dfpdoc -Fi. -Ficore ptc.pp' \
         --descr=docs/xml/ptc.xml \
         --output=docs/xml/ptc-update.xml \
         --update
