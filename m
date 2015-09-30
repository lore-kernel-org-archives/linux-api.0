From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/9] VFS: In-kernel copy system call
Date: Wed, 30 Sep 2015 13:26:44 -0400
Message-ID: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
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

This posting fixes a few issues that popped up after I submitted v4 yesterday.

Changes in v5:
- Bump syscall number (again)
- Add sys_copy_file_range() to include/linux/syscalls.h
- Change flags parameter on btrfs to an unsigned int


Anna Schumaker (6):
  vfs: Copy should check len after file open mode
  vfs: Copy shouldn't forbid ranges inside the same file
  vfs: Copy should use file_out rather than file_in
  vfs: Remove copy_file_range mountpoint checks
  vfs: Add vfs_copy_file_range() support for pagecache copies
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
 include/linux/syscalls.h               |   3 +
 include/uapi/asm-generic/unistd.h      |   4 +-
 include/uapi/linux/Kbuild              |   1 +
 include/uapi/linux/copy.h              |   8 ++
 kernel/sys_ni.c                        |   1 +
 13 files changed, 228 insertions(+), 40 deletions(-)
 create mode 100644 include/linux/copy.h
 create mode 100644 include/uapi/linux/copy.h

-- 
2.6.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
