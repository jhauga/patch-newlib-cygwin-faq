# cygwin: faq-resources.xml add 3.4 reproduce local site

This directory works as a proof of concept, where you can see the resulte
in GitHub Codespaces. 

**NOTE** - the httpd.conf file has been edited to account for a Linux
environment, but the same elements are used (*essentially*).  

Also the command line tool (*name*) is different. Here you have to use:

    apache2 -f ./httpd.conf -DFOREGROUND

instead of

    httpd.exe -f "%cd%\httpd.conf" -DFOREGROUND

to start the local server.

## Instructions for Use:

1. Open a new GitHub Codespace.

2. Run:

```
    cd cygwin-htdocs
    sudo apt update
    sudo apt install apache2
    apache2 -f /workspaces/test-repo/cygwin-htdocs/httpd.conf -DFOREGROUND
```

3. A GitHub popup or notification will appear where you can open the local
site in the browser.
 