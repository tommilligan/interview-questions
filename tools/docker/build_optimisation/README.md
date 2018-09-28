# Optimising Dockerfiles

## Prelim

This dockerfile (`unoptimised.Dockerfile`) is responsible for building and serving a client side react.js application. The output image:

- is ~500 MB in size
- takes around 3 minutes to build

Suggest some root causes for this large size and build time, and what could be done to mitigate them.

## Further prompts

- are all files in the continer needed at run time?
- which parts of a build typically take longest?
- how do CI systems in general speed up build times?

## Specific example questions

In the better configuration (`optimised.Dockerfile`), suggest the significance of:

- what could invalidate a docker cache?
  - known different inputs
  - untrusted/unvalidated input (web urls always retrieved)
- why are we creating a new user and using `chown` on some files?
  - having a guest docker `root` user can easily lead to privilege escalation
  - what further setup might be required here?
  - we've assigned a known UID (10000), we should adjust host permissions accordingly/monitor behaviour
- why are we serving the application on port 3300
  - what is the default port for HTTP(S) traffic - 80 (443)
  - are any linux ports special apart from having well known tasks?
  - ports <1024 are only accessible with `root` permissions
  - UID of the `root` user? - `0`

## General discussion

- docker in production
  - why would we want to reduce size?
    - increase number of containers on host machine
    - improve deployment times
  - what security risks should we be thinking of?
    - guest container processes with root permissions
    - mapping of uids into host machine
- how does docker work?
  - and image consists of layers of filesystem
    - cacheable if inputs have not changes
    - "container" layer is disposed after stop
  - on top of a base kernel
    - linux
    - can be virtualised on other systems
- what are the aims of a CI system?
  - reliability
    - indempotency
    - determinism
  - security
    - builds unmonitored, and deployed to procuction
    - scripts and artefacts have access to sensitive data
