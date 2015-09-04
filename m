From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Fri, 4 Sep 2015 16:25:27 -0600
Message-ID: <4B41043F-5D85-42D6-8F20-2DCC45930EF4@dilger.ca>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441397823-1203-1-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sep 4, 2015, at 2:16 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
> 
> Copy system calls came up during Plumbers a couple of weeks ago,
> because several filesystems (including NFS and XFS) are currently
> working on copy acceleration implementations.  We haven't heard from
> Zach Brown in a while, so I volunteered to push his patches upstream
> so individual filesystems don't need to keep writing their own ioctls.
> 
> The first three patches are a simple reposting of Zach's patches
> from several months ago, with one minor error code fix.  The remaining
> patches add in a fallback mechanism when filesystems don't provide a
> copy function.  This is especially useful when doing a server-side
> copy on NFS (using the new COPY operation in NFS v4.2).  This fallback
> can be disabled by passing the flag COPY_REFLINK to the system call.
> 
> The last patch is a man page patch documenting this new system call,
> including an example program.
> 
> I tested the fallback option by using /dev/urandom to generate files
> of varying sizes and copying them.  I compared the time to copy
> against that of `cp` just to see if there is a noticable difference.
> I found that runtimes are roughly the same, but in-kernel copy tends
> to use less of the cpu.  Values in the tables below are averages
> across multiple trials.
> 
> 
> /usr/bin/cp |   512 MB  |   1024 MB |   1536 MB |   2048 MB
> -------------|-----------|-----------|-----------|-----------
>       user  |   0.00s   |   0.00s   |   0.00s   |   0.00s
>     system  |   0.32s   |   0.52s   |   1.04s   |   1.04s
>        cpu  |     73%   |     69%   |     62%   |     62%
>      total  |   0.446   |   0.757   |   1.197   |   1.667
> 
> 
>   VFS copy  |   512 MB  |   1024 MB |   1536 MB |   2048 MB
> -------------|-----------|-----------|-----------|-----------
>       user  |   0.00s   |   0.00s   |   0.00s   |  0.00s
>     system  |   0.33s   |   0.49s   |   0.76s   |  0.99s
>        cpu  |     77%   |     62%   |     60%   |    59%
>      total  |   0.422   |   0.777   |   1.267   |  1.655
> 
> 
> Questions?  Comments?  Thoughts?

This is a bit of a surprising result, since in my testing in the
past, copy_{to/from}_user() is a major consumer of CPU time (50%
of a CPU core at 1GB/s).  What backing filesystem did you test on?

In theory, the VFS copy routines should save at least 50% of the
CPU usage since it only needs to make one copy (src->dest) instead
of two (kernel->user, user->kernel).  Ideally it wouldn't make any
data copies at all and just pass page references from the source
to the target.

Cheers, Andreas
> 
> Anna
> 
> 
> Anna Schumaker (5):
>  btrfs: Add mountpoint checking during btrfs_copy_file_range
>  vfs: Remove copy_file_range mountpoint checks
>  vfs: Copy should check len after file open mode
>  vfs: Copy should use file_out rather than file_in
>  vfs: Fall back on splice if no copy function defined
> 
> Zach Brown (3):
>  vfs: add copy_file_range syscall and vfs helper
>  x86: add sys_copy_file_range to syscall tables
>  btrfs: add .copy_file_range file operation
> 
> arch/x86/entry/syscalls/syscall_32.tbl |   1 +
> arch/x86/entry/syscalls/syscall_64.tbl |   1 +
> fs/btrfs/ctree.h                       |   3 +
> fs/btrfs/file.c                        |   1 +
> fs/btrfs/ioctl.c                       |  95 ++++++++++++++----------
> fs/read_write.c                        | 132 +++++++++++++++++++++++++++++++++
> include/linux/copy.h                   |   6 ++
> include/linux/fs.h                     |   3 +
> include/uapi/asm-generic/unistd.h      |   4 +-
> include/uapi/linux/Kbuild              |   1 +
> include/uapi/linux/copy.h              |   6 ++
> kernel/sys_ni.c                        |   1 +
> 12 files changed, 214 insertions(+), 40 deletions(-)
> create mode 100644 include/linux/copy.h
> create mode 100644 include/uapi/linux/copy.h
> 
> -- 
> 2.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
