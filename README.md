Plugin to aquire and release resources in RunDeck using Consul.  Provides a shared resource semaphore mechanism.  

Requirements
------------
Consul installed in /usr/local/bin/ - hopefully configurable in the future as a global property
Consul MUST be greater than version 7
Connects to API via Localhost - this may be configurable in the future.  

Installation
------------
* Put the zip files from make zip into your libext folder in rundeck (e.g. /var/lib/rundeck/libext).  
* In consul (http://127.0.0.1:8500/ui/#/p/kv/ create a key resources/$PATH/limit with a value of the MAX number of concurrent processes you want to allow.
* In consul (http://127.0.0.1:8500/ui/#/p/kv/ create a key resources/$PATH/used with a value of 0 - this will track how many are currently in use


Usage
-----
In a job, add a step for acuiring a resource, and a step for releasing the resource.  NOTE!  UNLESS the release job completes, the resource will NOT be updated.
 * Path is the path in consul - e.g. resources/$PATH - locks are made at that path, and it reads limit and writes to used under that path


Thanks
------
Special thanks to https://github.com/ahonor/yana-rundeck-shell-plugin for Makefile and some basic examples of how to do a shell plugin
Thanks to rundeck team for an interesting piece of software...
