From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH v2 0/2] fs: add AT_REPLACE flag for linkat()
Date: Tue, 21 Mar 2017 07:51:46 -0700
Message-ID: <cover.1490103963.git.osandov@fb.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

The goal of this series is to allow for updating a file atomically
in-place with an O_TMPFILE like so:

- open temporary file with O_TMPFILE
- write temporary file contents
- fsync temporary file
- atomically replace permanent location with the temporary file

This series implements atomic replace step with a new linkat(..., AT_REPLACE).

Al, I took a look at implementing this usecase with renameat2() after we
talked. Like you said, on the dcache side, "replace with tmpfile" looks
a lot like rename. However, on the filesystem side, trying to use rename
for this is much uglier than using link. We can't give i_op->rename() a
meaningful old_dir, and dealing with that new special case gets messy
fast.

So, here is the approach of having AT_REPLACE just unhash the replaced
dentry.

>From the original cover letter:

This is a proof-of-concept patch series implementing an AT_REPLACE flag for
linkat(2) which allows us to replace the target. This is a nice primitive on
its own, but it's most interesting when combined with O_TMPFILE, as it allows
you to do an atomic update of a file with an O_TMPFILE.

Patch 1 implements the VFS support for this flag. The implementation
resembles sys_renameat2(), and I took care to preserve all of the
original error cases and make the new error cases consistent with
rename.

Patch 2 adds support for AT_REPLACE to Btrfs. That's the codebase I'm
most familiar with so that's where I started, but it should be
straightforward to implement for other filesystems.

Cc: Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>

Omar Sandoval (2):
  fs: add AT_REPLACE flag for linkat() which replaces the target
  Btrfs: add support for linkat() AT_REPLACE

 fs/btrfs/inode.c           |  65 +++++++++++++++-
 fs/ecryptfs/inode.c        |   2 +-
 fs/namei.c                 | 181 ++++++++++++++++++++++++++++++++++++---------
 fs/nfsd/vfs.c              |   2 +-
 fs/overlayfs/overlayfs.h   |   2 +-
 include/linux/fs.h         |   3 +-
 include/uapi/linux/fcntl.h |   1 +
 7 files changed, 211 insertions(+), 45 deletions(-)

-- 
2.12.0
