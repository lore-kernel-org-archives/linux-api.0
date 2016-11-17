From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC][PATCH 0/4] Enhanced file stat system call
Date: Thu, 17 Nov 2016 16:10:13 +0100
Message-ID: <CAHO5Pa17hOWFOzp1N8fvzk8ikrH-masjfTewNKRJ4A6dWz2dng@mail.gmail.com>
References: <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi David,

Can you please CC linux-api@ on all future iterations of this patch!

Thanks,

Michael


On Thu, Nov 17, 2016 at 2:34 PM, David Howells <dhowells@redhat.com> wrote:
>
> Implement a new system call to provide enhanced file stats.  The patches can
> be found here:
>
>         http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=xstat
>
>
> ===========
> DESCRIPTION
> ===========
>
> The first patch provides this new system call:
>
>         long ret = statx(int dfd,
>                          const char *filename,
>                          unsigned atflag,
>                          unsigned mask,
>                          struct statx *buffer);
>
> This is an enhanced file stat function that provides a number of useful
> features, in summary:
>
>  (1) More information: creation time, data version number and attributes.
>      A subset of these is available through a number of filesystems (such
>      as CIFS, NFS, AFS, Ext4 and BTRFS).
>
>  (2) Lightweight stat (AT_STATX_DONT_SYNC): Ask for just those details of
>      interest, and allow a network fs to approximate anything not of
>      interest, without going to the server.
>
>  (3) Heavyweight stat (AT_STATX_FORCE_SYNC): Force a network fs to flush
>      buffers and go to the server, even if it thinks its cached attributes
>      are up to date.
>
>  (4) Allow the filesystem to indicate what it can/cannot provide: A
>      filesystem can now say it doesn't support a standard stat feature if
>      that isn't available.
>
>  (5) Make the fields a consistent size on all arches, and make them large.
>
>  (6) Can be extended by using more request flags and using up the padding
>      space in the statx struct.
>
> Note that no lstat() equivalent is required as that can be implemented
> through statx() with atflag == 0.  There is also no fstat() equivalent as
> that can be implemented through statx() with filename == NULL and the
> relevant fd passed as dfd.
>
>
> =======
> TESTING
> =======
>
> A test program is added into samples/statx/ by the first patch.
>
> David
> ---
> David Howells (4):
>       statx: Add a system call to make enhanced file info available
>       statx: Ext4: Return enhanced file attributes
>       statx: NFS: Return enhanced file attributes
>       statx: AFS: Return enhanced file attributes
>
>
>  arch/x86/entry/syscalls/syscall_32.tbl |    1
>  arch/x86/entry/syscalls/syscall_64.tbl |    1
>  fs/afs/inode.c                         |   21 ++
>  fs/exportfs/expfs.c                    |    4
>  fs/ext4/ext4.h                         |    2
>  fs/ext4/file.c                         |    2
>  fs/ext4/inode.c                        |   38 ++++
>  fs/ext4/namei.c                        |    2
>  fs/ext4/symlink.c                      |    2
>  fs/nfs/inode.c                         |   41 ++++
>  fs/stat.c                              |  294 +++++++++++++++++++++++++++++---
>  include/linux/fs.h                     |    5 -
>  include/linux/stat.h                   |   19 +-
>  include/linux/syscalls.h               |    3
>  include/uapi/linux/fcntl.h             |    2
>  include/uapi/linux/stat.h              |  124 +++++++++++++
>  samples/Kconfig                        |    5 +
>  samples/Makefile                       |    3
>  samples/statx/Makefile                 |   10 +
>  samples/statx/test-statx.c             |  248 +++++++++++++++++++++++++++
>  20 files changed, 771 insertions(+), 56 deletions(-)
>  create mode 100644 samples/statx/Makefile
>  create mode 100644 samples/statx/test-statx.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
