From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v9] io_uring IO interface
Date: Tue, 29 Jan 2019 12:26:44 -0700
Message-ID: <20190129192702.3605-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

Following up on all the great review from yesterday (and today),
here's a v9 that addresses all known review concerns so far.
A particular big thanks to Jann Horn for looking into the grittier
details, which resulted in a slew of fixes. Also thanks to Christoph
for working through the patches. I feel like we're making good
progress here.

A note on ctx->compat still being there - we could store this in
struct sqe_submit, but this doesn't work for the io_sq_thread()
polled submission. Additionally, makes more sense to keep this in
the ctx instead of once per IO.

No new changes in the liburing user side library, but as a reference,
you can clone that here:

git://git.kernel.dk/liburing

We're still missing a man page for io_uring_enter(2), but the two other
system calls are documented.

Patches are against 5.0-rc4, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Changes since v8:
- Check for p->sq_thread_cpu being possible
- Check for valid flags in io_uring_enter(2)
- Cap 'to_submit' at SQ ring size in io_uring_enter(2)
- Fix files/mm references
- Don't bother with ctx referencing in io_uring_register(2)
- Use READ/WRITE_ONCE for ring updates/reads
- Use percpu_ref_tryget() for io_get_req()
- Protect sqe reads (that matter) with READ_ONCE()
- Store compat syscall info in the ctx. Still derived from
  in_compat_syscall(), but we need access to it from the io_sq_thread()
  as well.
- Don't make IORING_MAX_ENTRIES user visible
- Address various review comments

 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2599 ++++++++++++++++++++++++
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
 23 files changed, 2916 insertions(+), 41 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
