From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v15] io_uring IO interface
Date: Mon, 11 Feb 2019 12:00:29 -0700
Message-ID: <20190211190049.7888-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

Some final tweaks, mostly cosmetic, but also two important fixes:

1) Ensure that we account the skb appropriately against the socket.
   Some network config options apparently return is an skb with
   ->truesize != 0 when allocated with a size of 0, ensure we add
   those as references against sock->sk_wmem_alloc. Reported by
   Matt Mullins.

2) Ensure that ANY async punt of an sqe operates on a copy. We've
   already committed the SQ ring change at this point, we don't want
   the application inadvertently reusing the SQE causing issues for
   an SQE that got punted with -EAGAIN. This change ensures that
   whatever io_uring_enter(2) returned that got submitted, it's
   totally safe to reuse those SQE entries in the ring.

Outside of that, just cosmetic changes and additions of comments. I've
run this version in various torture overnight, using the various modes
(polled, buffered, sq thread, any combination thereof) and it's help up
perfectly. As far as I'm concerned, this is ready to get staged for 5.1.

The liburing git repo has a full set of man pages for this, though they
could probably still use a bit of polish. I'd also like to see a
io_uring(7) man page to describe the overall design of the project,
expect that in the not-so-distant future. You can clone that here:

git://git.kernel.dk/liburing

Patches are against 5.0-rc6, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Changes since v14:
- Fix skb/sock referencing if skb->truesize != 0
- Add comments on memory ordering
- Add comments on READ/WRITE_ONCE()
- Various function comments
- Align struct members of io_poll_iocb and io_submit_state
- Use io_fput() in two places where it was open-coded
- Make async context always use a copy of the sqe
- Don't reset s->needs_fixed_file for async context
- Rebase on v5.0-rc6

 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2920 ++++++++++++++++++++++++
 fs/iomap.c                             |   48 +-
 fs/xfs/xfs_file.c                      |    1 +
 include/linux/bio.h                    |   14 +
 include/linux/blk_types.h              |    1 +
 include/linux/file.h                   |    2 +
 include/linux/fs.h                     |   15 +-
 include/linux/iomap.h                  |    1 +
 include/linux/sched/user.h             |    2 +-
 include/linux/syscalls.h               |    8 +
 include/net/af_unix.h                  |    1 +
 include/uapi/asm-generic/unistd.h      |    8 +-
 include/uapi/linux/io_uring.h          |  142 ++
 init/Kconfig                           |    9 +
 kernel/sys_ni.c                        |    3 +
 net/Makefile                           |    2 +-
 net/unix/Kconfig                       |    5 +
 net/unix/Makefile                      |    2 +
 net/unix/af_unix.c                     |   63 +-
 net/unix/garbage.c                     |   68 +-
 net/unix/scm.c                         |  151 ++
 net/unix/scm.h                         |   10 +
 31 files changed, 3421 insertions(+), 169 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
