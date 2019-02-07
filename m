From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v12] io_uring IO interface
Date: Thu,  7 Feb 2019 12:55:34 -0700
Message-ID: <20190207195552.22770-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

Here's v12 of the io_uring project. This is the Al Viro special, where
Al tries to beat into my head how UNIX fd passing will mess you up. I
think we have all cases handled now. I've added the resulting test case
into the liburing test/ directory.

Outside of that, various little cleanups and fixes, and a revert of
using FOLL_ANON to map IO buffers. This makes it fail with huge pages,
something that we can (and do want to) support. We're now back to just
checking for a file backing in the vma.

As far as I'm concerned, this project is ready to get staged for 5.1.
Please do review carefully so we can fix any minor nits that might still
exist.

The liburing git repo has a full set of man pages for this, though they
could probably still use a bit of polish. I'd also like to see a
io_uring(7) man page to describe the overall design of the project,
expect that in the not-so-distant future. You can clone that here:

git://git.kernel.dk/liburing

Patches are against 5.0-rc5, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Since v11:
- Get rid of the need for storing a files_struct
- Protect against release loop when UNIX fd passing is used
- Retain kiocb state for EAGAIN async retry
- Cleanup io memory accounting
- Revert to using non-FOLL_ANON, as we do want to support huge pages
- Fix uid leak
- Address various review comments
- Rebase on v5.0-rc5

 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2741 ++++++++++++++++++++++++
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
 net/unix/af_unix.c                     |    2 +-
 net/unix/garbage.c                     |    3 +
 26 files changed, 3073 insertions(+), 42 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
