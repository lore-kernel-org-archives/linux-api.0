From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET v13] io_uring IO interface
Date: Fri,  8 Feb 2019 10:34:04 -0700
Message-ID: <20190208173423.27014-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

Here's v13 of the io_uring project, hot on the heels of v12. v12 had
a few silly regressions due to flipping things around for the SCM
fd passing changes. v13 also decouples the SCM fd management from
how many fixed files we support, so instead of a fairly random 253
file limit, we now impose a 1024 file limit for a file set.

The AF_UNIX scm parts have been split into its own file. This was
needed to prevent issues with CONFIG_UNIX=m, since io_uring is
always builtin.

Nothing major in here apart from that. Go forth and test and review,
so we can hopefully get this queued up sooner rather than later.

The liburing git repo has a full set of man pages for this, though they
could probably still use a bit of polish. I'd also like to see a
io_uring(7) man page to describe the overall design of the project,
expect that in the not-so-distant future. You can clone that here:

git://git.kernel.dk/liburing

Patches are against 5.0-rc5, and can also be found in my io_uring branch
here:

git://git.kernel.dk/linux-block io_uring

Changes since v12:
- Fix release of uid struct at buffer unregister time
- Fix leak of request for poll command on submission time errors
- Allow huge pages for pre-mapped buffers
- Use alloc_skb() instead of __alloc_skb()
- Make max fixed files independent of SCM_MAX_FD (now 1024)
- Use CONFIG_UNIX instead of CONFIG_NET
- Export io_uring_get_socket for CONFIG_UNIX=m
- Add net/unix/scm.c with the helpers io_uring needs
- Disallow registering the io_uring fd to prevent a deadlock
  with !CONFIG_UNIX

 Documentation/filesystems/vfs.txt      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl |    3 +
 block/bio.c                            |   59 +-
 fs/Makefile                            |    1 +
 fs/block_dev.c                         |   19 +-
 fs/file.c                              |   15 +-
 fs/file_table.c                        |    9 +-
 fs/gfs2/file.c                         |    2 +
 fs/io_uring.c                          | 2796 ++++++++++++++++++++++++
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
 net/unix/Kconfig                       |    5 +
 net/unix/Makefile                      |    2 +
 net/unix/af_unix.c                     |   63 +-
 net/unix/garbage.c                     |   68 +-
 net/unix/scm.c                         |  146 ++
 net/unix/scm.h                         |   10 +
 30 files changed, 3291 insertions(+), 168 deletions(-)

-- 
Jens Axboe


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
