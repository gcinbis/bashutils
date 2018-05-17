How to share printer from Linux to Mac
======================================

## Things to do on Linux machine

* Execute `sudo ufw allow 631/udp`
* Execute `sudo ufw allow 631/tcp`
* Execute `sudo cupsctl WebInterface=Yes`

## Things to do on Mac

* Make sure you can access "http://LXIP:631" via a web-browser where LXIP is the IP address of the Linux machine.
* Through the web interface, browse to the printer that you want to add (eg, "http://LXIP:631/printers/MyLaserPrinter")
* Through System Preferences / Printers, add the printer using the following options:
  * Address = LXIP
  * Protocol = Internet Printing Protocol - IPP
  * Queue = /printers/MyLaserPrinter
* Print a test page. Voila!

## Final things to do on Linux machine

* Execute `sudo cupsctl WebInterface=No`

