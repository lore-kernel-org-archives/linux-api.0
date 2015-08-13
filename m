From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 0/3] fs: add O_BENEATH flag to openat(2)
Date: Thu, 13 Aug 2015 10:32:43 +0100
Message-ID: <1439458366-8223-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A couple of questions with this iteration:
 - Should we create a new errno (say ENOTBENEATH) for this policing, to
   make it easier to distinguish this case from other EPERM failures?
   (The FreeBSD implementation is considering this approach.)
 - Al, does the code look OK for (in particular) integrating with the
   shiny new re-worked fs/namei.c code?
Thanks.


This change adds a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EPERM) paths that are not beneath
the provided dfd.

This functionality was originally implemented as part of the internals
of the Capsicum security framework, which is available in FreeBSD 10.x
and which has previously had a Linux kernel port proposed [1].

However, as this behaviour is potentially useful as an independent feature,
this change exposes it via an openat(2) flag.  (This variant was not
originally exposed in FreeBSD, but is currently being proposed there
too [2].)

Various folks from Chrome[OS] have indicated an interest in having this
functionality -- when combined with a seccomp filter it allows a directory
to be more safely accessed by a sandboxed process.  Other folk have also
expressed an interest [3].


[1] https://lkml.org/lkml/2014/7/25/426
[2] https://reviews.freebsd.org/D2808
[3] https://groups.google.com/d/msg/capnproto/sKpzanYNZmQ/T9IbJIB-rqQJ

Changes since v3:
 - Merge up to v4.2-rc6
 - Reinstate local selftests (I'll send xfstest changes separately
   if and when this is merged)
 - Pull in common selftests makefile

Changes since v2:
 - Move tests into xfstests [Dave Chinner, with thanks for feedback
   on initial version]
 - Merge up to v4.0-rc3 & latest man-pages

Changes since v1:
 - Don't needlessly duplicate flags [Al Viro]
 - Use EPERM rather than EACCES as error code [Paolo Bonzini]
 - Disallow nd_jump_link for O_BENEATH [Al Viro/Andy Lutomirski]
 - Add test of a jumped symlink (/proc/self/root)

Changes since the version included in the Capsicum v2 patchset:
 - Add tests of normal symlinks
 - Fix man-page typo
 - Update patch to 3.17

Changes from v1 to v2 of Capsicum patchset:
 - renamed O_BENEATH_ONLY to O_BENEATH [Christoph Hellwig]


David Drysdale (2):
  fs: add O_BENEATH flag to openat(2)
  selftests: Add test of O_BENEATH & openat(2)

 arch/alpha/include/uapi/asm/fcntl.h       |   1 +
 arch/parisc/include/uapi/asm/fcntl.h      |   1 +
 arch/sparc/include/uapi/asm/fcntl.h       |   1 +
 fs/fcntl.c                                |   4 +-
 fs/namei.c                                |  12 +-
 fs/open.c                                 |   4 +-
 fs/proc/base.c                            |   4 +-
 fs/proc/namespaces.c                      |   8 +-
 include/linux/namei.h                     |   3 +-
 include/uapi/asm-generic/fcntl.h          |   4 +
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/openat/.gitignore |   4 +
 tools/testing/selftests/openat/Makefile   |  29 ++++
 tools/testing/selftests/openat/openat.c   | 258 ++++++++++++++++++++++++++++++
 14 files changed, 326 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/openat/.gitignore
 create mode 100644 tools/testing/selftests/openat/Makefile
 create mode 100644 tools/testing/selftests/openat/openat.c

--
1.9.1
