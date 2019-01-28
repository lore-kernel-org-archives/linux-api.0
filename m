From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v8] io_uring IO interface
Date: Mon, 28 Jan 2019 14:35:20 -0700
Message-ID: <20190128213538.13486-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

Here's v8 of the io_uring interface. Various little fixes all over
the map, and addressing various review concerns.

No new features, but the io_uring_enter(2) system call grew arguments
for a sigset_t so we can support poll properly.

For a general introduction to this patchset, see previous postings or
the LWN writeup here:

https://lwn.net/Articles/776703/

No new changes in the liburing user side library, but as a reference,
you can clone that here:

git://git.kernel.dk/liburing

We're still missing a man page for io_uring_enter(2), but the two other
system calls are documented.

Patches are against 5.0-rc4, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Changes since v7:
- Rebase on v5.0-rc4
- Add grace period control for SQ poll
- Add IORING_ENTER_SQ_WAKEUP instead of overloading 'to_submit'
- Address various minor review comments
- Use in_compat_syscall() instead of storing it in the ctx
- Remove now unneeded compat system call
- Ensure nops appropriately serialize the cq ring
- Add sigset_t support for wait side of io_uring_enter(2)
- Stop using page_frag_free()
- Remove duplicate include
- Make sure sq thread and application can't stomp on each other
- Add array_index_nospec() limiter for p->sq_thread_cpu

 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2550 ++++++++++++++++++++++++
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
 include/uapi/linux/io_uring.h          |  143 ++
 init/Kconfig                           |    9 +
 kernel/sys_ni.c                        |    3 +
 23 files changed, 2869 insertions(+), 41 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
