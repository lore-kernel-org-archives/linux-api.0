From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v11] io_uring IO interface
Date: Fri,  1 Feb 2019 08:23:56 -0700
Message-ID: <20190201152414.23296-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

Here's v11 of the io_uring project. Main fixes in this release is a
rework of how we grab the ctx->uring_lock, never using trylock for it in
a user visible way. Outside of that, fixes around locking for the polled
list when we hit -EAGAIN conditions on IO submit. This fixes list
corruption issues with polling that some users have reported.

As far as I'm concerned, this project is ready to get staged for 5.1.
Please do review carefully so we can fix any minor nits that might still
exist.

The liburing git repo has a full set of man pages for this, though they
could probably still use a bit of polish. I'd also like to see a
io_uring(7) man page to describe the overall design of the project,
expect that in the not-so-distant future. You can clone that here:

git://git.kernel.dk/liburing

Patches are against 5.0-rc4, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Changes since v10:
- Rework uring_lock locking
- Ensure that async contexts lock when fiddling with polled lists
- Minor tweak to io_iopoll_check() continue looping condition
- Fold __io_uring_enter() into io_uring_enter()


 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2621 ++++++++++++++++++++++++
 fs/iomap.c                             |   48 +-
 fs/xfs/xfs_file.c                      |    1 +
 include/linux/bio.h                    |   14 +
 include/linux/blk_types.h              |    1 +
 include/linux/file.h                   |    2 +
 include/linux/fs.h                     |    6 +-
 include/linux/iomap.h                  |    1 +
 include/linux/sched/user.h             |    2 +-
 include/linux/syscalls.h               |    8 +
 include/uapi/asm-generic/unistd.h      |    8 +-
 include/uapi/linux/io_uring.h          |  141 ++
 init/Kconfig                           |    9 +
 kernel/sys_ni.c                        |    3 +
 23 files changed, 2938 insertions(+), 41 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
