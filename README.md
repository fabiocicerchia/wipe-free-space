> [!WARNING]
> **Moved.** This script now lives in
> [fabiocicerchia/utils](https://github.com/fabiocicerchia/utils) as
> [`wipe_free_space`](https://github.com/fabiocicerchia/utils/blob/master/wipe_free_space).
> This repository is archived and will not be updated.

# WipeFreeSpace

Idea taken from [David Spillett](https://superuser.com/users/4129/david-spillett) on his answer to [How to wipe free disk space in Linux?](https://superuser.com/a/19488).

POSIX `sh`, so it runs under busybox `ash` as well as bash — free space usually
needs wiping inside a minimal container image, which is where bash is not.

## Usage

```
WipeFreeSpace
(C) 2020 Fabio Cicerchia.

Usage:
./wiper.sh [-r X] [-s]
  -r X   Number of rounds
  -s     Secure way (uses random instead of zero fillings)
```
