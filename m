From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 0/3] vfs: have syncfs() return error when there are writeback errors
Date: Fri,  7 Feb 2020 12:04:20 -0500
Message-ID: <20200207170423.377931-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, andres@anarazel.de, willy@infradead.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

You're probably wondering -- Where are v1 and v2 sets?

I did the first couple of versions of this set back in 2018, and then
got dragged off to work on other things. I'd like to resurrect this set
though, as I think it's valuable overall, and I have need of it for some
other work I'm doing.

Currently, syncfs does not return errors when one of the inodes fails to
be written back. It will return errors based on the legacy AS_EIO and
AS_ENOSPC flags when syncing out the block device fails, but that's not
particularly helpful for filesystems that aren't backed by a blockdev.
It's also possible for a stray sync to lose those errors.

The basic idea is to track writeback errors at the superblock level,
so that we can quickly and easily check whether something bad happened
without having to fsync each file individually. syncfs is then changed
to reliably report writeback errors, and a new ioctl is added to allow
userland to get at the current errseq_t value w/o having to sync out
anything.

I do have a xfstest for this. I do not yet have manpage patches, but
I'm happy to roll some once there is consensus on the interface.

Caveats:

- Having different behavior for an O_PATH descriptor in syncfs is
  a bit odd, but it means that we don't have to grow struct file. Is
  that acceptable from an API standpoint?

- This adds a new generic fs ioctl to allow userland to scrape the
  current superblock's errseq_t value. It may be best to present this
  to userland via fsinfo() instead (once that's merged). I'm fine with
  dropping the last patch for now and reworking it for fsinfo if so.

Jeff Layton (3):
  vfs: track per-sb writeback errors and report them to syncfs
  buffer: record blockdev write errors in super_block that it backs
  vfs: add a new ioctl for fetching the superblock's errseq_t

 fs/buffer.c             |  2 ++
 fs/ioctl.c              |  4 ++++
 fs/open.c               |  6 +++---
 fs/sync.c               |  9 ++++++++-
 include/linux/errseq.h  |  1 +
 include/linux/fs.h      |  3 +++
 include/linux/pagemap.h |  5 ++++-
 include/uapi/linux/fs.h |  1 +
 lib/errseq.c            | 33 +++++++++++++++++++++++++++++++--
 9 files changed, 57 insertions(+), 7 deletions(-)

-- 
2.24.1
