# Jboss EAP 6 and Hornetq HA

Vagrant multimachine demo environment for demostrating hornetq messaging HA and backup capabilities. It is also demostrable within this project the capability of managing different messaging clusters, isolated per each server group.
We are using same applications and complexity as in redhat-jboss-mw-arch-vagrant project.

###Prerequisites

Host manager plugin => https://github.com/devopsgroup-io/vagrant-hostmanager

Landrush plugin => https://github.com/vagrant-landrush/landrush

**Linux users:** follow next steps in order to make landrush work:

First, try: http://lameter.rssing.com/browser.php?indx=1151212&item=14728

Fedora:

1. In /etc/NetworkManager/NetworkManager.conf set dns=dnsmasq under [main] section:

  [main]
  plugins=ifcfg-rh,ibft
  dns=dnsmasq

2. Create file /etc/NetworkManager/dnsmasq.d/vagrant-landrush.conf with following content:

  server=/.arch.redhat.dev/127.0.0.1#10053

3. Restart NetworkManager 

  systemctl restart NetworkManager

## Test messaging LB

1. Send messages to the demo app:

  wget http://jblb01.arch.redhat.dev:6666/sender/rest/send

2. Validate that the following message "Received Message from queue:" appears in /var/log/jbossas/domain/console.log (Round Robin LB) in each server

  vagrant ssh jbch01 // vagrant ssh jbhc02

  -bash-4.2$ tail -f /var/log/jbossas/domain/console.log


## Test cluster failure: live-backup pair servers (collocated topology)

1. Disable consumer.ear first (via web or CLI)

2. Send 3 messages and validate content of queues

  wget http://jblb01.arch.redhat.dev:6666/sender/rest/send (x3)

  In jbhc01:

  -bash-4.2$ cd /usr/share/jbossas/bin/
  -bash-4.2$ ./jboss-cli.sh --connect controller=jbhc01.arch.redhat.dev:9999

  [domain@jbhc01.arch.redhat.dev:9999 /] /host=jbhc01/server=demoserver01/subsystem=messaging/hornetq-server=live/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => 2L
  
  [domain@jbhc01.arch.redhat.dev:9999 /] /host=jbhc01/server=demoserver01/subsystem=messaging/hornetq-server=backup/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => undefined
  }
  
  In jbhc02:

  -bash-4.2$ cd /usr/share/jbossas/bin/
  -bash-4.2$ ./jboss-cli.sh --connect controller=jbhc02.arch.redhat.dev:9999
  
  [domain@jbhc02.arch.redhat.dev:9999 /] /host=jbhc02/server=demoserver01/subsystem=messaging/hornetq-server=live/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => 1L
  }

  [domain@jbhc02.arch.redhat.dev:9999 /] /host=jbhc02/server=demoserver01/subsystem=messaging/hornetq-server=backup/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => undefined
  }

3. Stop demoserver01 in jbhc01 (via web or CLI) and verify content of backup queue in jbhc02 and live queue in jbhc01.

  [domain@jbhc02.arch.redhat.dev:9999 /] /host=jbhc02/server=demoserver01/subsystem=messaging/hornetq-server=backup/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => 2L
  }
  
  [domain@jbhc01.arch.redhat.dev:9999 /] /host=jbhc01/server=demoserver01/subsystem=messaging/hornetq-server=live/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  Failed to get the list of the operation properties: "JBAS014883: No resource definition is registered for address [
      ("host" => "jbhc01"),
      ("server" => "demoserver01"),
      ("subsystem" => "messaging"),
      ("hornetq-server" => "live"),
      ("runtime-queue" => "jms.queue.DemoQueue")
  ]"

4. Start demoserver01 in jbhc01 (via web or CLI) again and validate content of backup queue in jbhc02 and live queu in jbhc01.

  [domain@jbhc02.arch.redhat.dev:9999 /] /host=jbhc02/server=demoserver01/subsystem=messaging/hornetq-server=backup/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => undefined
  }
  
  [domain@jbhc01.arch.redhat.dev:9999 /] /host=jbhc01/server=demoserver01/subsystem=messaging/hornetq-server=live/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => 2L
  }

5. Enable consumer.ear  (via web or CLI) and check messages consumption in live hornet queue servers

  [domain@jbhc01.arch.redhat.dev:9999 /] /host=jbhc01/server=demoserver01/subsystem=messaging/hornetq-server=live/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => 0L
  }
  
  [domain@jbhc02.arch.redhat.dev:9999 /] /host=jbhc02/server=demoserver01/subsystem=messaging/hornetq-server=live/runtime-queue=jms.queue.DemoQueue:read-attribute(name=message-count)
  {
      "outcome" => "success",
      "result" => 0L
  }

You could do the same using jbhc03/jbhc04 pair or even with demosg02 (server group) which keeps its own messaging cluster.

