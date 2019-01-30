From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v10] io_uring IO interface
Date: Wed, 30 Jan 2019 14:55:22 -0700
Message-ID: <20190130215540.20871-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

Keeping the review train hot, this has all review comments addressed
from v9, with a few other fixes on top.

Outside of review comments, this fixes a few annoyances with the
SQPOLL thread. We now shut it down quick, regardless of idle setting,
and I got rid of the silly need to park it for exit.

Also fixed a case with SQPOLL where we'd get -EAGAIN due to request
shortage in the block layer, and we didn't handle that properly. Now
we do.

The liburing git repo now has a io_uring_setup(2) man page, but
otherwise no changes. You can clone that here:

git://git.kernel.dk/liburing

Patches are against 5.0-rc4, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Since v9:
- Use FOLL_ANON instead of checking vmas for file backing
- Fix bad nospec index limiter
- Address various minor review comments
- Fix drop extra file reference in case of submission error
- Fix race with sqe->opcode and "needs mm" checks without sqe copy
- Un-unionize io_kiocb->submit, from the async path it's almost
  impossible to do this safely.
- Clear io_kiocb->error for polled IO
- Fix EAGAIN for polled IO and SQPOLL for the !force_nonblock case of
  running out of block requests
- Remove need for kthread parking
- Ensure sqo thread exits as quickly as possible


 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2611 ++++++++++++++++++++++++
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
 23 files changed, 2928 insertions(+), 41 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
