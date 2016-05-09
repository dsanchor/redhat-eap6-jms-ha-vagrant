#!/bin/bash

#provision variables
# TODO unify variables and properties (to be shared between sh and cli)
USER=admin
PASSWORD=admin.123
BASE_PROFILE=full-ha
TARGET_PROFILE=demo
TARGET_PROFILE_FILE=/tmp/create-profile-$TARGET_PROFILE.cli
JBOSS_HOME=/usr/share/jbossas
JBOSSSHARE_HOME=/jbossshare
DOMAIN_CONTROLLER_HOST=jbdc01.arch.redhat.dev

##########################
#  Global configuration  #
##########################

#create admin user
$JBOSS_HOME/bin/add-user.sh $USER $PASSWORD

# create global system properties
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$JBOSSSHARE_HOME/common/scripts/create-system-properties.cli

#clone profile BASE_PROFILE and create TARGET_PROFILE 
java -cp $JBOSS_HOME/bin/client/jboss-cli-client.jar:$JBOSSSHARE_HOME/common/lib/profilecloner.jar org.jboss.tfonteyne.profilecloner.Main  --controller=$DOMAIN_CONTROLLER_HOST --port=9999 --username=$USER --password=$PASSWORD --file=$TARGET_PROFILE_FILE /profile=$BASE_PROFILE $TARGET_PROFILE
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$TARGET_PROFILE_FILE
rm $TARGET_PROFILE_FILE

#configure server groups (remove default ones and create demosg01 & demosg02)
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$JBOSSSHARE_HOME/common/scripts/create-server-groups.cli


#configure mod cluster
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$JBOSSSHARE_HOME/common/scripts/configure-modcluster.cli


##########################
#   Demo customization   #
##########################

# create demo system properties
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$JBOSSSHARE_HOME/demo/scripts/create-system-properties.cli

#create JMS destinations queues/topics and configure backup
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$JBOSSSHARE_HOME/demo/scripts/configure-messaging.cli

#deploy apps 
$JBOSS_HOME/bin/jboss-cli.sh --connect controller=$DOMAIN_CONTROLLER_HOST:9999 --user=$USER --password=$PASSWORD --file=$JBOSSSHARE_HOME/demo/scripts/deploy-apps.cli


