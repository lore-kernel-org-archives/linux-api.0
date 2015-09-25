From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/9] VFS: In-kernel copy system call
Date: Fri, 25 Sep 2015 16:48:06 -0400
Message-ID: <1443214096-12769-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Copy system calls came up during Plumbers a while ago, mostly because several
filesystems (including NFS and XFS) are currently working on copy acceleration
implementations.  We haven't heard from Zach Brown in a while, so I volunteered
to push his patches upstream so individual filesystems don't need to keep
writing their own ioctls. 

The question has come up about how vfs_copy_file_range() responds to signals,
and I don't have a good answer.  The pagecache copy option uses splice,
which (as far as I can tell) doesn't get interrupted.  Please let me know if
I'm missing something or completely misunderstanding the question!

Changes in v3:
- Update against the most recent Linus kernel
- Flags parameter should be an unsigned int
- Add COPY_FR_DEDUPE flag for Darrick
- Make each flag exclusive
- Update man page
- Added "Reiewed-by" tags

I tested the COPY_FR_COPY flag by using /dev/urandom to generate files of
varying sizes and copying them.  I compared the output from `time` against
that of `cp` to see if there is any noticable difference. Values in the
tables below are averages across multiple trials.

 /usr/bin/cp |   512  |  1024  |  1536  |  2048  |  2560  |  3072  |  5120
-------------|--------|--------|--------|--------|--------|--------|--------
        user |  0.00s |  0.00s |  0.01s |  0.01s |  0.01s |  0.01s |  0.02s
      system |  0.92s |  0.59s |  0.88s |  1.18s |  1.48s |  1.78s |  2.98s
         cpu |    43% |    18% |    17% |    18% |    18% |    18% |    17%
       total |  2.116 |  3.200 |  4.950 |  6.541 |  8.105 |  9.811 | 17.211


    VFS Copy |   512  |  1024  |  1536  |  2048  |  2560  |  3072  |  5120
-------------|--------|--------|--------|--------|--------|--------|--------
        user |  0.00s |  0.00s |  0.00s |  0.00s |  0.00s |  0.00s |  0.00s
      system |  0.80s |  0.56s |  0.84s |  1.10s |  1.39s |  1.67s |  2.81s
         cpu |    41% |    18% |    19% |    17% |    17% |    17% |    17%
       total |  1.922 |  2.990 |  4.448 |  6.292 |  7.855 |  9.480 | 15.944

Questions?  Comments?  Thoughts?

Anna


Anna Schumaker (6):
  vfs: Copy should check len after file open mode
  vfs: Copy shouldn't forbid ranges inside the same file
  vfs: Copy should use file_out rather than file_in
  vfs: Remove copy_file_range mountpoint checks
  vfs: copy_file_range() can do a pagecache copy with splice
  btrfs: btrfs_copy_file_range() only supports reflinks

Zach Brown (3):
  vfs: add copy_file_range syscall and vfs helper
  x86: add sys_copy_file_range to syscall tables
  btrfs: add .copy_file_range file operation

 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/btrfs/ctree.h                       |   3 +
 fs/btrfs/file.c                        |   1 +
 fs/btrfs/ioctl.c                       |  95 +++++++++++++---------
 fs/read_write.c                        | 141 +++++++++++++++++++++++++++++++++
 include/linux/copy.h                   |   6 ++
 include/linux/fs.h                     |   3 +
 include/uapi/asm-generic/unistd.h      |   2 +
 include/uapi/linux/Kbuild              |   1 +
 include/uapi/linux/copy.h              |   8 ++
 kernel/sys_ni.c                        |   1 +
 12 files changed, 224 insertions(+), 39 deletions(-)
 create mode 100644 include/linux/copy.h
 create mode 100644 include/uapi/linux/copy.h

-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
