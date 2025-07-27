%let pgm=utl-better-than-using-csv-files-to-transport-sas-datasets-sqlite-tables;

%stop_submission;

Better than using csv files to transport sas datasets sqlite tables;

PROCESS (this is a SQLITE SOLUTION BUT SHOULD APPLY WITH POSGRESQL)

SAS CREATE SQLITE TABLE

  1 SAS generate creatable code
  2 SQLITE CLi execute create table

R IMPORT TABLEE

  3 R covert sqlite table to r dataframe
    R covert r dataframe to sas dataset
  4 sqlite cli commands

github
https://tinyurl.com/bdd6c5vu
https://github.com/rogerjdeangelis/utl-better-than-using-csv-files-to-transport-sas-datasets-sqlite-table


SOAPBOX ON

Better sas transport file using sqlite file based database?

Note not all languages can read sas export format but can read either sqlite or postgresql tables.
Postgresql and Sqlite have excellent CLIs.
None of this can be done with the personal version of the Seimens/Altair SLC.
The SLC cannot access any operating system directly?
SLC is like SAS supermax lockdown.

Note sas generated create table code can be read by
python, excel(using r), perl, matlab(octave), spss(pspp), powershell,wps(seimens/altair)

The genenated create table code can be used with
  sqlite
  postgresql
  sql server
  oracle
  sqlplus
  access?
  mysql

SOPABOX OFF

github (has all the macros)
https://tinyurl.com/5mpbc23d
https://github.com/rogerjdeangelis/utl-creating-sqlite-and-postgresql-tables-from-sas-datasets-without-sas-access-and-a-blueprint

macros (also has all the macros)
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

github
https://github.com/rogerjdeangelis/utl-exporting-tables-from-seven-databses-to-csv-files
https://tinyurl.com/55ebehxx

/*                   _                              _        _        _     _
/ |  _ __ ___   __ _| | _____    ___ _ __ ___  __ _| |_ ___ | |_ __ _| |__ | | ___    __ _ _   _  ___ _ __ _   _
| | | `_ ` _ \ / _` | |/ / _ \  / __| `__/ _ \/ _` | __/ _ \| __/ _` | `_ \| |/ _ \  / _` | | | |/ _ \ `__| | | |
| | | | | | | | (_| |   <  __/ | (__| | |  __/ (_| | ||  __/| || (_| | |_) | |  __/ | (_| | |_| |  __/ |  | |_| |
|_| |_| |_| |_|\__,_|_|\_\___|  \___|_|  \___|\__,_|\__\___| \__\__,_|_.__/|_|\___|  \__, |\__,_|\___|_|   \__, |
                                                                                        |_|                |___/
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data class;
  input
    name$
    sex$ age;
cards4;
Alfred  M 14
Alice   F 13
Barbara F 13
Carol   F 13
Henry   M 14
James   M 14
;;;;
run;quit;

ods path (prepend) sasuser.templates(update);
%utl_sqlinsert(class,c:/temp/sqlcreins.sql);

OUTPUT (not much more wory than csv files and has typing)
varchar(255) is the odbc max?

c:/temp/sqlcreins.sql

Create table class(name varchar(255), sex varchar(255), age float);
Insert into class(name, sex, age) VALUES
('Alice', 'F', 13),
('Barbara', 'F', 13),
('Carol', 'F', 13),
('Henry', 'M', 14),
('James', 'M', 14);

/*___                    _                    _ _ _        _        _     _             _
|___ \   _ __ ___   __ _| | _____   ___  __ _| (_) |_ ___ | |_ __ _| |__ | | ___    ___| | __ _ ___ ___
  __) | | `_ ` _ \ / _` | |/ / _ \ / __|/ _` | | | __/ _ \| __/ _` | `_ \| |/ _ \  / __| |/ _` / __/ __|
 / __/  | | | | | | (_| |   <  __/ \__ \ (_| | | | ||  __/| || (_| | |_) | |  __/ | (__| | (_| \__ \__ \
|_____| |_| |_| |_|\__,_|_|\_\___| |___/\__, |_|_|\__\___| \__\__,_|_.__/|_|\___|  \___|_|\__,_|___/___/
                                           |_|
*/

/*--- for an easier interface yoy can use the sqlite dropdown macros utl_sqbegin/utl_sqend ----*/
/*--- remove cmd /K if you do not want to see the result of the commands                   ----*/

/*--- delete the entire tst.db sqlite file database                                        ----*/
%utlfkil(c:/temp/tst.db);

/*---- generate create table code fo 7 languages                                           ----*/

x 'cmd /K sqlite3 c:/temp/tst.db "drop table if exists class"';
x 'cmd /K sqlite3 c:/temp/tst.db < c:/temp/sqlcreins.sql';
x 'cmd /K sqlite3 c:/temp/tst.db ".tables"';

/*____          _                            _               _ _ _        _        _     _
|___ /   _ __  (_)_ __ ___  _ __   ___  _ __| |_   ___  __ _| (_) |_ ___ | |_ __ _| |__ | | ___
  |_ \  | `__| | | `_ ` _ \| `_ \ / _ \| `__| __| / __|/ _` | | | __/ _ \| __/ _` | `_ \| |/ _ \
 ___) | | |    | | | | | | | |_) | (_) | |  | |_  \__ \ (_| | | | ||  __/| || (_| | |_) | |  __/
|____/  |_|    |_|_| |_| |_| .__/ \___/|_|   \__| |___/\__, |_|_|\__\___| \__\__,_|_.__/|_|\___|
                           |_|                            |_|
*/

%utl_rbeginx;
parmcards4;
library(DBI)
library(RSQLite)
source("c:/oto/fn_tosas9x.R")
con <- dbConnect(SQLite()
  ,dbname = "c:/temp/tst.db")
tb<-dbListTables(con)
tb
want <- dbGetQuery(con
  ,"select * from class")
print(want)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;


/*  _               _ _ _              _ _                                                 _
| || |    ___  __ _| (_) |_ ___    ___| (_)   ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___
| || |_  / __|/ _` | | | __/ _ \  / __| | |  / __/ _ \| `_ ` _ \| `_ ` _ \ / _` | `_ \ / _` / __|
|__   _| \__ \ (_| | | | ||  __/ | (__| | | | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
   |_|   |___/\__, |_|_|\__\___|  \___|_|_|  \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
                 |_|
*/

SQLITE3 CLI

Option / Flag           Description
-init file              Read and execute commands from the specified file (can contain SQL and meta-commands).
-echo                   Print commands before execution.
-[no]header             Turn headers on or off in query output.
-column                 Display query results in a table-like format with aligned columns.
-html                   Output query results as simple HTML tables.
-line                   Display each value on a separate line, rows separated by a blank line.
-list                   Display results separated by the field separator (default: `
-separator SEP          Set the output field separator (default: `
-nullvalue STR          Set the string used to represent NULL values (default: empty string).
-version                Show the SQLite version and exit.
-help                   Show help on available options and exit.
-bail                   Stop after hitting an error.
-batch                  Force batch I/O mode (useful for scripts).
-cmd COMMAND            Run the specified command before reading from stdin. Can be used multiple times.
-csv                    Set output mode to CSV (comma-separated values).
-interactive            Force interactive I/O mode.
-mmap N                 Set the default memory-mapped I/O size to N.
-stats                  Print memory stats before each finalize.
-vfs NAME               Use the specified VFS (Virtual File System) implementation.


 META COMMANDS          DESCRIPTION

.backup ?DB? FILE       Backup DB (default "main") to FILE
.bail on                off
.clone NEWDB            Clone data into NEWDB from the existing database
.databases              List names and files of attached databases
.dump ?TABLE? ...       Dump the database in SQL text format
.echo on                off
.eqp on                 off
.exit, .quit            Exit the sqlite3 program
.explain ?on            off?
.fullschema             Show schema and content of sqlite_stat tables
.headers on             off
.help                   Show help for meta-commands
.import FILE TABLE      Import data from FILE into TABLE
.indices ?TABLE?        Show names of all indices (optionally for TABLE)
.load FILE ?ENTRY?      Load an extension library
.log FILE               off
.mode MODE              Set output mode (csv, column, html, insert, line, list, tabs, tcl)
.nullvalue STRING       Set string used to represent NULL values
.once FILENAME          Output next query to FILENAME
.open ?OPTIONS? FILE    Close existing and reopen FILE
.output FILENAME        Send output to FILENAME
.print STRING...        Print literal STRING
.prompt MAIN CONT       Replace the standard prompts
.read FILENAME          Execute commands from FILENAME
.restore ?DB? FILE      Restore DB (default "main") from FILE
.save FILE              Write database to FILE
.scanstats on           off
.schema ?PATTERN?       Show CREATE statements matching PATTERN
.separator COL ?ROW?    Change column/row separators
.session ?NAME? CMD     Create or control sessions
.sha3sum ...            Compute SHA3 hash of database content
.shell CMD ARGS...      Run CMD ARGS in a system shell
.show                   Show current settings
.stats ?ARG?            Show stats or turn stats on/off
.system CMD ARGS...     Run CMD ARGS in a system shell
.tables ?PATTERN?       List names of tables matching PATTERN
.timeout MS             Set busy timeout to MS milliseconds
.timer on               off
.trace ?OPTIONS?        Output each SQL statement as it is run
.unmodule NAME ...      Unregister virtual table modules

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
