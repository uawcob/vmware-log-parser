# VMware Log Parser

Scripts for extracting data from VMware log files.

After processing, the files will be compressed and moved to an archive folder.
Logs with errors will be moved to an errors folder.

## Installation

You should `git clone` this repository so that updates can easily be pulled.

### Requirements

Possibly compatible on older/newer versions, but your mileage may vary.

* GNU coreutils 8.25
* GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)
* GNU awk 4.1.3, API: 1.1 (GNU MPFR 3.1.4, GNU MP 6.1.0)
* GNU sed 4.2.2
* gzip 1.6
* mysql Ver 14.14 Distrib 5.7.20, for Linux (x86_64) using  EditLine wrapper

### Database

Create the necessary tables by executing the DDL in the [SQL folder](./sql).

### Environment Variables

Create the `.env` file from the [template](./example.env).

    cp example.env .env

Set the variables accordingly.

## Usage

Run the scripts contained within the [scripts folder](./scripts)
whenever it makes sense for your purposes.

For example, schedule an extraction for logon times every 5 minutes with cron.

```
*/5 * * * * /path/to/scripts/extract-logon-times.bash >> /path/to/error.log 2>&1
```

Analyze the data stored in MySQL using your tool of choice.
Here are some [example reports](./sql/reports.sql).
