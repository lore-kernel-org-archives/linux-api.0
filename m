From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v14] io_uring IO interface
Date: Sat,  9 Feb 2019 14:13:27 -0700
Message-ID: <20190209211346.26060-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

Another day, another spin. This is v14, and it fixes a few silly
issues with fsync, mainly, but also various little fixes and tweaks
all over the map.

The liburing git repo has a full set of man pages for this, though they
could probably still use a bit of polish. I'd also like to see a
io_uring(7) man page to describe the overall design of the project,
expect that in the not-so-distant future. You can clone that here:

git://git.kernel.dk/liburing

Patches are against 5.0-rc5, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring


Changes since v13:
- Use READ/WRITE_ONCE anywhere we touch the shared data
- Cache if we need to account/unaccount memory
- Fix fsync file grabbing
- Fix oops with fsync and deferred async list
- Fix final fput() of fixed files AFTER adding to socket
- Use correct iterator to free fixed user bufs
- up/down_read() for mmap_sem when mapping buffers
- completion -> complete in Kconfig help entry
- Ensure malicious app can't trick NOP into leaking a file
- Add a few comments, address a few review comments


 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2853 ++++++++++++++++++++++++
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
 31 files changed, 3354 insertions(+), 169 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
