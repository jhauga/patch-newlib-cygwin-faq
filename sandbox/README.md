# cygwin: faq-resources.xml add 3.4 reproduce local site

## Instructions for Use:

**IMPORTANT** - ensure Windows supports Sandbox, and the **Windows Sandbox**
feature is on in `Turn Windows features on or off`.

1. Clone or download repo:

`git clone https://github.com/jhauga/patch-newlib-cygwin-faq/tree/reproduce-local-site`

2. Open or navigate to `patch-newlib-cygwin-faq/sandbox`, and run or double click
`cygwin.bat`, then read prompt instruction.

3. Focus on Sandbox window, and follow instructions from the prior
`cygwin` prompt.

4. First `winget` will be installed, then `cygwin`, then the process to install `newlib-cygwin` from 
the source files will begin. **NOTE** - this will take a while (*at least 30 minutes until next step*).

5. After `newlib` is installed the process will pause with an update, here:
   - read instructions, press enter.
   - Then `httpd` will be installed.

6. After `httpd` is installed, another pause will happen in the process.
   - **IMPORTANT** - here you must run `current.bat` for the httpd.conf file to be properly configurred
   as `httpd` is not in `PATH` and cannot be used in current proces. 
   - For your convenience a File Explorer window will open where you can run `current.bat`.

7. Double click `current.bat` to clone `cygwin-htdocs`, generate `httpd.conf`, and copy the built
`newlib-cygwin` html files to the local site; and lastly open and start `localhost:8000`.

**NOTE** - I have run and tested this in my Windows Sandbox environment, and have suceeded without
having to make in alterations, but if an error happens, `Notepadd++` was also installed; so you can
use it to make edits to debug the process.