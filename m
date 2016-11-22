From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 0/3] fs: add AT_REPLACE flag for linkat()
Date: Tue, 22 Nov 2016 00:25:00 -0800
Message-ID: <cover.1479802448.git.osandov@fb.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, kernel-team@fb.com, Xi Wang <xi@cs.washington.edu>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

This is a proof-of-concept patch series implementing an AT_REPLACE flag
for linkat(2) which allows us to replace the target. This is a nice
primitive on its own, but it's most interesting when combined with
O_TMPFILE, as it allows you to do an atomic update of a file with an
O_TMPFILE.

Patch 1 implements the VFS support for this flag. The implementation
resembles sys_renameat2(), and I took care to preserve all of the
original error cases and make the new error cases consistent with
rename.

Patch 2 adds a dcache helper for filesystem implementations of
AT_REPLACE. I'm not entirely convinced that it's 100% correct.

Patch 3 adds support for AT_REPLACE to Btrfs. That's the codebase I'm
most familiar with so that's where I started, but it should be
straightforward to implement for other filesystems.

Any comments are welcome.

Cc: Xi Wang <xi@cs.washington.edu>

Omar Sandoval (3):
  fs: add AT_REPLACE flag for linkat() which replaces the target
  vfs: add d_replace()
  Btrfs: add support for linkat() AT_REPLACE

 fs/btrfs/inode.c           |  59 ++++++++++++++-
 fs/dcache.c                |  68 +++++++++++++++--
 fs/ecryptfs/inode.c        |   2 +-
 fs/namei.c                 | 180 +++++++++++++++++++++++++++++++++++----------
 fs/nfsd/vfs.c              |   2 +-
 fs/overlayfs/overlayfs.h   |   2 +-
 include/linux/dcache.h     |   1 +
 include/linux/fs.h         |   3 +-
 include/uapi/linux/fcntl.h |   1 +
 9 files changed, 267 insertions(+), 51 deletions(-)

-- 
2.10.2

