# Shell Library - bashlib
Used to store regular and repeated commands that can be imported into other bash scripts by way of the `source` command.

### Functions
    log:      write a string to a logfile that will be accessible in the console application.
    log_file: pass a file as the parameter and read it into the console as a log.
    error:    prints an error and code. Also prints reason with code to the console application as a log.
    notify:   use terminal-notifier to send a notification via notification centre
    pushover: send a notification via the pushover service. (Requires a pushover account)


### Usage:
Inside a script you wish to make use of this library drop the following line with arguments:

`source bashlib -args`

Using a function:

`log "this is a problem!"`

Output: `23 May 23:13:15 bashlib: this is a problem!` 

### Arguments:
	-v :  Verbose enabled, when using log, will also print to console.
	-n :  Invoking script name, this will be used to identify your script in the logs.
	-l :  Set log path to new value
	-p :  Enables the use of terminal-notifier for push notifications
	-o :  Use Pushover to send notifications
	
