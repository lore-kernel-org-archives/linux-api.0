From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2 0/3] fs: add O_BENEATH flag to openat(2)
Date: Tue,  4 Nov 2014 09:54:41 +0000
Message-ID: <1415094884-18349-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This change adds a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EACCES) paths that are not beneath
the provided dfd.

This change was previously included as part of a larger patchset
(https://lkml.org/lkml/2014/7/25/426) for Capsicum support; however, it
is potentially useful as an independent change so I've pulled it out
separately here.

In particular, various folks from Chrome[OS] have indicated an interest
in having this functionality -- when combined with a seccomp filter it
allows a directory to be accessed by a sandboxed process.


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
 fs/fcntl.c                                |   5 +-
 fs/namei.c                                |  43 ++++++---
 fs/open.c                                 |   4 +-
 include/linux/namei.h                     |   1 +
 include/uapi/asm-generic/fcntl.h          |   4 +
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/openat/.gitignore |   3 +
 tools/testing/selftests/openat/Makefile   |  24 +++++
 tools/testing/selftests/openat/openat.c   | 149 ++++++++++++++++++++++++++++++
 12 files changed, 220 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/openat/.gitignore
 create mode 100644 tools/testing/selftests/openat/Makefile
 create mode 100644 tools/testing/selftests/openat/openat.c

--
2.1.0.rc2.206.gedb03e5
