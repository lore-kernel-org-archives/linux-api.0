From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 0/3] fs: interface for directly writing encoded (e.g., compressed) data
Date: Wed, 18 Sep 2019 23:53:43 -0700
Message-ID: <cover.1568875700.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Hello,

This patch series adds an API for writing compressed data directly to
the filesystem. It is based on my previous series which added a
Btrfs-specific ioctl [1], but this is now an extension to pwritev2() as
suggested by Dave Chinner [2]. I've included a man page patch describing
the API in detail. A test case and example program are available [3].

The use case that I have in mind is Btrfs send/receive: currently, when
sending data from one compressed filesystem to another, the sending side
decompresses the data and the receiving side recompresses it before
writing it out. This is wasteful and can be avoided if we can just send
and write compressed extents. The send part will be implemented in a
separate series, as this API can stand alone.

Patch 1 is a prep patch. Patch 2 adds the interface in the VFS. Patch 3
implements it in Btrfs.

This series is based on Linus' tree as of commit
b41dae061bbd722b9d7fa828f35d22035b218e18.

Please share any comments on the API or implementation. Thanks!

1: https://lore.kernel.org/linux-fsdevel/cover.1567623877.git.osandov@fb.com/
2: https://lore.kernel.org/linux-fsdevel/20190906212710.GI7452@vader/
3: https://github.com/osandov/xfstests/tree/btrfs-compressed-write

Omar Sandoval (3):
  fs: pass READ/WRITE to kiocb_set_rw_flags()
  fs: add RWF_ENCODED for writing compressed data
  btrfs: implement encoded (compressed) writes

 fs/aio.c                |   9 +-
 fs/btrfs/compression.c  |   6 +-
 fs/btrfs/compression.h  |   5 +-
 fs/btrfs/ctree.h        |   4 +
 fs/btrfs/file.c         |  40 +++++++--
 fs/btrfs/inode.c        | 190 +++++++++++++++++++++++++++++++++++++++-
 fs/io_uring.c           |   9 +-
 fs/read_write.c         |   2 +-
 include/linux/fs.h      |  18 +++-
 include/uapi/linux/fs.h |  24 ++++-
 mm/filemap.c            |  75 +++++++++++++---
 11 files changed, 344 insertions(+), 38 deletions(-)

-- 
2.23.0
