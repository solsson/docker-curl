# docker pull [solsson/curl](https://hub.docker.com/r/solsson/curl)

There's quite a bunch of curl images but none of them official. I didn't find any with all of the below:

 * Slim
 * Proper entrypoint
 * Recent version
 * Modern selection of protocols

Notably this image disables stuff like POP3, NTLM, GOPHER, FTP, SMB - absent in the environments I see today.

I'll enable support for [IDN](https://en.wikipedia.org/wiki/Internationalized_domain_name) once libidn2 is available as Alpine package.
