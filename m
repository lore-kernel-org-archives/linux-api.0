From: Laurent Vivier <laurent@vivier.eu>
Subject: [RFC 0/2] ns: introduce binfmt_misc namespace
Date: Mon,  1 Oct 2018 01:46:26 +0200
Message-ID: <20180930234628.25528-1-laurent@vivier.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, Andrei Vagin <avagin@openvz.org>, containers@lists.linux-foundation.org, Laurent Vivier <laurent@vivier.eu>
List-Id: linux-api@vger.kernel.org

This series introduces a new namespace for binfmt_misc.

This allows to define a new interpreter for each new container.

But the main goal is to be able to chroot to a directory
using a binfmt_misc interpreter without being root.

I have a modified version of unshare at:

  git@github.com:vivier/util-linux.git branch unshare-chroot

with some new options to unshare binfmt_misc namespace and to chroot
to a directory.

If you have a directory /chroot/powerpc/jessie containing debian for powerpc
binaries and a qemu-ppc interpreter, you can do for instance:

$ uname -a
Linux fedora28-wor-2 4.19.0-rc5+ #18 SMP Mon Oct 1 00:32:34 CEST 2018 x86_64 x86_64 x86_64 GNU/Linux
$ ./unshare --map-root-user --fork --pid \
  --load-binfmt ":qemu-ppc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/qemu-ppc:OC" \
  --root=/chroot/powerpc/jessie /bin/bash -l
Linux fedora28-wor-2 4.19.0-rc5+ #18 SMP Mon Oct 1 00:32:34 CEST 2018 ppc GNU/Linux
uid=0(root) gid=0(root) groups=0(root),65534(nogroup)
total 5940
drwxr-xr-x.   2 nobody nogroup    4096 Aug 12 00:58 bin
drwxr-xr-x.   2 nobody nogroup    4096 Jun 17 20:26 boot
drwxr-xr-x.   4 nobody nogroup    4096 Aug 12 00:08 dev
drwxr-xr-x.  42 nobody nogroup    4096 Sep 28 07:25 etc
drwxr-xr-x.   3 nobody nogroup    4096 Sep 28 07:25 home
drwxr-xr-x.   9 nobody nogroup    4096 Aug 12 00:58 lib
drwxr-xr-x.   2 nobody nogroup    4096 Aug 12 00:08 media
drwxr-xr-x.   2 nobody nogroup    4096 Aug 12 00:08 mnt
drwxr-xr-x.   3 nobody nogroup    4096 Aug 12 13:09 opt
dr-xr-xr-x. 143 nobody nogroup       0 Sep 30 23:02 proc
-rwxr-xr-x.   1 nobody nogroup 6009712 Sep 28 07:22 qemu-ppc
drwx------.   3 nobody nogroup    4096 Aug 12 12:54 root
drwxr-xr-x.   3 nobody nogroup    4096 Aug 12 00:08 run
drwxr-xr-x.   2 nobody nogroup    4096 Aug 12 00:58 sbin
drwxr-xr-x.   2 nobody nogroup    4096 Aug 12 00:08 srv
drwxr-xr-x.   2 nobody nogroup    4096 Apr  6  2015 sys
drwxrwxrwt.   2 nobody nogroup    4096 Sep 28 10:31 tmp
drwxr-xr-x.  10 nobody nogroup    4096 Aug 12 00:08 usr
drwxr-xr-x.  11 nobody nogroup    4096 Aug 12 00:08 var

If you want to use the qemu binary provided by your distro, you can use

    --load-binfmt ":qemu-ppc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/bin/qemu-ppc-static:OCF"

With the 'F' flag, qemu-ppc-static will be then loaded from the main root
filesystem before switching to the chroot.

Laurent Vivier (2):
  ns: introduce binfmt_misc namespace
  binfmt_misc: move data to binfmt_namespace

 fs/binfmt_misc.c                 |  50 +++++-----
 fs/proc/namespaces.c             |   3 +
 include/linux/binfmt_namespace.h |  63 ++++++++++++
 include/linux/nsproxy.h          |   2 +
 include/linux/proc_ns.h          |   2 +
 include/linux/user_namespace.h   |   1 +
 include/uapi/linux/sched.h       |   1 +
 init/Kconfig                     |   8 ++
 kernel/Makefile                  |   1 +
 kernel/binfmt_namespace.c        | 164 +++++++++++++++++++++++++++++++
 kernel/fork.c                    |   3 +-
 kernel/nsproxy.c                 |  18 +++-
 12 files changed, 289 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/binfmt_namespace.h
 create mode 100644 kernel/binfmt_namespace.c

-- 
2.17.1
