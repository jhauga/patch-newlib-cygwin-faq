# patch-newlib-cygwin-faq

This is a support repo for newlib-cygwin patch **cygwin: faq-resources.xml add 3.4 reproduce local site**. 

Since this patch focuses on reproducing the website locally, there are three areas of interest:

1. The tool used (`sandbox`) to reproduce the site locally in a sandbox environment.
   
   - The tool utilizes:
      - the example `httpd.conf` (`cygwin: faq-resources-3.4 example httpd.conf`), 

      ```
      EXAMPLE HTTPD.CONF:
       sandbox/scripts/newlib-cygwin-current.bat
       - lines 99 to 130
      ```

      - instructions on reproducing newlib docs (`cygwin: faq-resources-3.4 reproduce site docs`), 

      ```
      INSTALL REQUIRED PACKAGES:
       sandbox/scripts/newlib-cygwin.bat
       - lines 81 to 88
      
      INSTALL NEWLIB-CYGWIN:
       sandbox/scripts/newlib-cygwin-install.bat
       - lines 11 to 43
      ```
      
      - and the command for starting a local host(`cygwin: faq-resources-3.4 start local server`).

      ```
      RUN LOCAL SITE:
       sandbox/scripts/newlib-cygwin-current.bat
       - lines 137 to 141
      ```

   - See the [sandbox/README.md](sandbox/README.md) for instructions on reproducing the local
   site in a Sandbox environment.

2. The local site that was reproduced from running the tool, with two alterations:
   
   - the `httpd.conf` built was renamed to `SANDBOX-httpd.conf`.
   - the current `httpd.conf` has been modified to account for GitHub Codespace so results can be
   seen running codespace in the browser. See [cygwin-htdocs/README.md](cygwin-htdocs/README.md)
   for running reporoduced local site in GitHub Codespaces.

3. The focal point of the patch; the built `faq.html`.
   
   - [doc build faq.html](https://jhauga.github.io/patch-newlib-cygwin-faq/faq.html) from newlib-cygwin build,
   - [modified index.html file](https://jhauga.github.io/patch-newlib-cygwin-faq/) to mimic the faq.html
   after version update.

Additionally, since running the site locally hinges on correctly configuring the `httpd.conf`
file; a copy of the `httpd.conf` built from the `sandbox` tool is included in the root of the repo.
