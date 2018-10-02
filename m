From: Laurent Vivier <laurent@vivier.eu>
Subject: [RFC v2 v2 0/1] ns: introduce binfmt_misc namespace
Date: Tue,  2 Oct 2018 12:20:53 +0200
Message-ID: <20181002102054.13245-1-laurent@vivier.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Andrei Vagin <avagin@openvz.org>, Eric Biederman <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Laurent Vivier <laurent@vivier.eu>
List-Id: linux-api@vger.kernel.org

v2: no new namespace, binfmt_misc data are now part of
    the mount namespace
    I put this in mount namespace instead of user namespace
    because the mount namespace is already needed and
    I don't want to force to have the user namespace for that.
    As this is a filesystem, it seems logic to have it here.

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
   --load-interp ":qemu-ppc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/qemu-ppc:OC" \
   --root=/chroot/powerpc/jessie /bin/bash -l
 # uname -a
 Linux fedora28-wor-2 4.19.0-rc5+ #18 SMP Mon Oct 1 00:32:34 CEST 2018 ppc GNU/Linux
 # id
uid=0(root) gid=0(root) groups=0(root),65534(nogroup)
 # ls -l
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

    --load-interp ":qemu-ppc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/bin/qemu-ppc-static:OCF"

With the 'F' flag, qemu-ppc-static will be then loaded from the main root
filesystem before switching to the chroot.

Laurent Vivier (1):
  ns: add binfmt_misc to the mount namespace

 fs/binfmt_misc.c | 50 +++++++++++++++++++++++++-----------------------
 fs/mount.h       |  8 ++++++++
 fs/namespace.c   |  6 ++++++
 3 files changed, 40 insertions(+), 24 deletions(-)

-- 
2.17.1
