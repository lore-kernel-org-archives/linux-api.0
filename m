From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH v4 0/4] fs: add flag to linkat() for replacing destination
Date: Wed, 29 Jan 2020 00:58:30 -0800
Message-ID: <cover.1580251857.git.osandov__34029.5823452593$1580288332$gmane$org@fb.com>
References: <cover.1580251857.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1580251857.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

[Sorry if you got this twice, I botched the Cc's on the previous
 submission.]

Hello,

This series adds an AT_LINK_REPLACE flag to linkat() which allows
atomically replacing the destination if it exists. This is a respin of
an old series [1] that I was convinced to resend due to some recent
interest [2][3].

Patch 1 adds a flags argument to i_ops->link() in preparation. Patch 2
adds the VFS support. Patch 3 fixes an inode leak in btrfs_link(),
included in this series because it conflicts with patch 4. Patch 4 adds
support for AT_LINK_REPLACE to Btrfs.

I've also included a man-page patch (with an example program), an xfs_io
patch, and an fstest.

Some outstanding issues:

- The Btrfs implementation does a d_drop() on the replaced dentry. We
  probably want a d_replace() helper for filesystems to use.
- Should AT_LINK_REPLACE be limited to O_TMPFILE? In my opinion, the
  answer is no. After all, `ln -f` is not that exotic.
- Should AT_LINK_REPLACE guarantee data integrity? Again, I think the
  answer is no. That's more suited to something like Amir's AT_ATOMIC
  proposal [4].

Changes since v3:

- Rebased on v5.5.
- Added patches 1 and 3.
- Incorporated Al's feedback on various error cases in patch 2.
- Renamed the flag to AT_LINK_REPLACE.

Thanks!

1: https://lore.kernel.org/linux-fsdevel/cover.1524549513.git.osandov-b10kYP2dOMg@public.gmane.org/
2: https://lore.kernel.org/linux-fsdevel/3326.1579019665-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org/
3: https://lore.kernel.org/linux-fsdevel/364531.1579265357-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org/
4: https://lore.kernel.org/linux-fsdevel/20190527172655.9287-1-amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

Omar Sandoval (4):
  fs: add flags argument to i_op->link()
  fs: add AT_LINK_REPLACE flag for linkat() which replaces the target
  Btrfs: fix inode reference count leak in btrfs_link() error path
  Btrfs: add support for linkat() AT_REPLACE

 fs/9p/vfs_inode.c          |   5 +-
 fs/9p/vfs_inode_dotl.c     |   5 +-
 fs/affs/affs.h             |   2 +-
 fs/affs/namei.c            |   6 +-
 fs/afs/dir.c               |   7 +-
 fs/bad_inode.c             |   2 +-
 fs/bfs/dir.c               |   7 +-
 fs/btrfs/inode.c           |  70 ++++++++++++++--
 fs/ceph/dir.c              |   5 +-
 fs/cifs/cifsfs.h           |   2 +-
 fs/cifs/link.c             |   5 +-
 fs/coda/dir.c              |   5 +-
 fs/ecryptfs/inode.c        |   7 +-
 fs/ext2/namei.c            |   5 +-
 fs/ext4/namei.c            |   7 +-
 fs/f2fs/namei.c            |   5 +-
 fs/fuse/dir.c              |   5 +-
 fs/gfs2/inode.c            |   5 +-
 fs/hfsplus/dir.c           |   5 +-
 fs/hostfs/hostfs_kern.c    |   5 +-
 fs/jffs2/dir.c             |   8 +-
 fs/jfs/namei.c             |   7 +-
 fs/libfs.c                 |   6 +-
 fs/minix/namei.c           |   5 +-
 fs/namei.c                 | 166 +++++++++++++++++++++++++++++--------
 fs/nfs/dir.c               |   6 +-
 fs/nfs/internal.h          |   2 +-
 fs/nfsd/vfs.c              |   2 +-
 fs/nilfs2/namei.c          |   5 +-
 fs/ocfs2/namei.c           |   6 +-
 fs/overlayfs/dir.c         |   5 +-
 fs/overlayfs/overlayfs.h   |   2 +-
 fs/reiserfs/namei.c        |   5 +-
 fs/sysv/namei.c            |   7 +-
 fs/ubifs/dir.c             |   5 +-
 fs/udf/namei.c             |   5 +-
 fs/ufs/namei.c             |   5 +-
 fs/xfs/xfs_iops.c          |   6 +-
 include/linux/fs.h         |   6 +-
 include/uapi/linux/fcntl.h |   1 +
 mm/shmem.c                 |   6 +-
 41 files changed, 341 insertions(+), 90 deletions(-)

-- 
2.25.0
