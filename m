From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC][PATCH 0/4] Enhanced file stat system call [ver #3]
Date: Wed, 23 Nov 2016 00:55:44 +0000
Message-ID: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Implement a new system call to provide enhanced file stats.  The patches can
be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=xstat


===========
DESCRIPTION
===========

The first patch provides this new system call:

	long ret = statx(int dfd,
			 const char *filename,
			 unsigned atflag,
			 unsigned mask,
			 struct statx *buffer);

This is an enhanced file stat function that provides a number of useful
features, in summary:

 (1) More information: creation time, data version number and attributes.
     A subset of these is available through a number of filesystems (such
     as CIFS, NFS, AFS, Ext4 and BTRFS).

 (2) Lightweight stat (AT_STATX_DONT_SYNC): Ask for just those details of
     interest, and allow a network fs to approximate anything not of
     interest, without going to the server.

 (3) Heavyweight stat (AT_STATX_FORCE_SYNC): Force a network fs to flush
     buffers and go to the server, even if it thinks its cached attributes
     are up to date.

 (4) Allow the filesystem to indicate what it can/cannot provide: A
     filesystem can now say it doesn't support a standard stat feature if
     that isn't available.

 (5) Make the fields a consistent size on all arches, and make them large.

 (6) Can be extended by using more request flags and using up the padding
     space in the statx struct.

 (7) Takes dfd, filename and flags in a similar way to fstatat().

Note that no lstat() equivalent is required as that can be implemented
through statx() with atflag == 0.  There is also no fstat() equivalent as
that can be implemented through statx() with filename == NULL and the
relevant fd passed as dfd.


=======
TESTING
=======

A test program is added into samples/statx/ by the first patch.


=======
CHANGES
=======

Ver #3:

 - Make the timestamps structures with second, nanosecond and reserved
   fields so that we can introduce femtosecond resolution in the future if
   we need to.

Ver #2:

 - Turn the AT_STATX_*_SYNC flags into a 2-bit field with three options and
   give EINVAL if the undefined option in that field is specified.   

 - Removed various STATX_ATTR_* flags for lack of definition - can be
   reinstated later.

 - Removed stx_version and STATX_VERSION for lack of a way to make it
   consistent - can be reinstated later.

David
---
David Howells (4):
      statx: Add a system call to make enhanced file info available
      statx: Ext4: Return enhanced file attributes
      statx: NFS: Return enhanced file attributes
      statx: AFS: Return enhanced file attributes


 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/afs/inode.c                         |   11 +
 fs/exportfs/expfs.c                    |    4 
 fs/ext4/ext4.h                         |    2 
 fs/ext4/file.c                         |    2 
 fs/ext4/inode.c                        |   36 ++++
 fs/ext4/namei.c                        |    2 
 fs/ext4/symlink.c                      |    2 
 fs/nfs/inode.c                         |   32 +++
 fs/stat.c                              |  297 +++++++++++++++++++++++++++++---
 include/linux/fs.h                     |    5 -
 include/linux/stat.h                   |   19 +-
 include/linux/syscalls.h               |    3 
 include/uapi/linux/fcntl.h             |    5 +
 include/uapi/linux/stat.h              |  120 +++++++++++++
 samples/Kconfig                        |    5 +
 samples/Makefile                       |    3 
 samples/statx/Makefile                 |   10 +
 samples/statx/test-statx.c             |  248 +++++++++++++++++++++++++++
 20 files changed, 751 insertions(+), 57 deletions(-)
 create mode 100644 samples/statx/Makefile
 create mode 100644 samples/statx/test-statx.c
