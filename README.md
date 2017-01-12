Plugin to aquire and release resources in RunDeck using Consul.  Provides a shared resource semaphore mechanism.  

Dependencies
------------
You MUST have consul installed on local host - right now in /usr/local/bin/ - this may be configurable in the future.  It'll try and connect via localhost.  

Installation
------------
* Put the zip files from make zip into your libext folder in rundeck (e.g. /var/lib/rundeck/libext).  
* In consul (http://127.0.0.1:8500/ui/#/p/kv/ create a key resources/$PATH/limit with a value of the MAX number of concurrent processes you want to allow.
* In consul (http://127.0.0.1:8500/ui/#/p/kv/ create a key resources/$PATH/used with a value of 0 - this will track how many are currently in use


Usage
-----
In a job, add a step for acuiring a resource, and a step for releasing the resource.  NOTE!  UNLESS the release job completes, the resource will NOT be updated.

