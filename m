From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v5 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Wed,  5 Nov 2014 16:14:46 -0500
Message-ID: <cover.1415220890.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patcheset introduces an ability to perform a non-blocking read from
regular files in buffered IO mode. This works by only for those filesystems
that have data in the page cache.

It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
extra flag argument (RWF_NONBLOCK).

It's a very common patern today (samba, libuv, etc..) use a large threadpool to
perform buffered IO operations. They submit the work form another thread
that performs network IO and epoll or other threads that perform CPU work. This
leads to increased latency for processing, esp. in the case of data that's
already cached in the page cache.

With the new interface the applications will now be able to fetch the data in
their network / cpu bound thread(s) and only defer to a threadpool if it's not
there. In our own application (VLDB) we've observed a decrease in latency for
"fast" request by avoiding unnecessary queuing and having to swap out current
tasks in IO bound work threads.

Version 5 highlight:
 - XFS support for RWF_NONBLOCK. from Christoph.
 - RWF_DSYNC flag and support for pwritev2, from Christoph.
 - Implemented compat syscalls, per. Jeff.
 - Missing nfs, ceph changes from older patchset.

Version 4 highlight:
 - Updated for 3.18-rc1.
 - Performance data from our application.
 - First stab at man page with Jeff's help. Patch is in-reply to.

RFC Version 3 highlights:
 - Down to 2 syscalls from 4; can user fp or argument position.
 - RWF_NONBLOCK value flag is not the same O_NONBLOCK, per Jeff.

RFC Version 2 highlights:
 - Put the flags argument into kiocb (less noise), per. Al Viro
 - O_DIRECT checking early in the process, per. Jeff Moyer
 - Resolved duplicate (c&p) code in syscall code, per. Jeff
 - Included perf data in thread cover letter, per. Jeff
 - Created a new flag (not O_NONBLOCK) for readv2, perf Jeff


Some perf data generated using fio comparing the posix aio engine to a version
of the posix AIO engine that attempts to performs "fast" reads before
submitting the operations to the queue. This workflow is on ext4 partition on
raid0 (test / build-rig.) Simulating our database access patern workload using
16kb read accesses. Our database uses a home-spun posix aio like queue (samba
does the same thing.)

f1: ~73% rand read over mostly cached data (zipf med-size dataset)
f2: ~18% rand read over mostly un-cached data (uniform large-dataset)
f3: ~9% seq-read over large dataset

before:

f1:
    bw (KB  /s): min=   11, max= 9088, per=0.56%, avg=969.54, stdev=827.99
    lat (msec) : 50=0.01%, 100=1.06%, 250=5.88%, 500=4.08%, 750=12.48%
    lat (msec) : 1000=17.27%, 2000=49.86%, >=2000=9.42%
f2:
    bw (KB  /s): min=    2, max= 1882, per=0.16%, avg=273.28, stdev=220.26
    lat (msec) : 250=5.65%, 500=3.31%, 750=15.64%, 1000=24.59%, 2000=46.56%
    lat (msec) : >=2000=4.33%
f3:
    bw (KB  /s): min=    0, max=265568, per=99.95%, avg=174575.10,
                 stdev=34526.89
    lat (usec) : 2=0.01%, 4=0.01%, 10=0.02%, 20=0.27%, 50=10.82%
    lat (usec) : 100=50.34%, 250=5.05%, 500=7.12%, 750=6.60%, 1000=4.55%
    lat (msec) : 2=8.73%, 4=3.49%, 10=1.83%, 20=0.89%, 50=0.22%
    lat (msec) : 100=0.05%, 250=0.02%, 500=0.01%
total:
   READ: io=102365MB, aggrb=174669KB/s, minb=240KB/s, maxb=173599KB/s,
         mint=600001msec, maxt=600113msec

after (with fast read using preadv2 before submit):

f1:
    bw (KB  /s): min=    3, max=14897, per=1.28%, avg=2276.69, stdev=2930.39
    lat (usec) : 2=70.63%, 4=0.01%
    lat (msec) : 250=0.20%, 500=2.26%, 750=1.18%, 2000=0.22%, >=2000=25.53%
f2:
    bw (KB  /s): min=    2, max= 2362, per=0.14%, avg=249.83, stdev=222.00
    lat (msec) : 250=6.35%, 500=1.78%, 750=9.29%, 1000=20.49%, 2000=52.18%
    lat (msec) : >=2000=9.99%
f3:
    bw (KB  /s): min=    1, max=245448, per=100.00%, avg=177366.50,
                 stdev=35995.60
    lat (usec) : 2=64.04%, 4=0.01%, 10=0.01%, 20=0.06%, 50=0.43%
    lat (usec) : 100=0.20%, 250=1.27%, 500=2.93%, 750=3.93%, 1000=7.35%
    lat (msec) : 2=14.27%, 4=2.88%, 10=1.54%, 20=0.81%, 50=0.22%
    lat (msec) : 100=0.05%, 250=0.02%
total:
   READ: io=103941MB, aggrb=177339KB/s, minb=213KB/s, maxb=176375KB/s,
         mint=600020msec, maxt=600178msec

Interpreting the results you can see total bandwidth stays the same but overall
request latency is decreased in f1 (random, mostly cached) and f3 (sequential)
workloads. There is a slight bump in latency for since it's random data that's
unlikely to be cached but we're always trying "fast read".

In our application we have starting keeping track of "fast read" hits/misses
and for files / requests that have a lot hit ratio we don't do "fast reads"
mostly getting rid of extra latency in the uncached cases. In our real world
work load we were able to reduce average response time by 20 to 30% (depends
on amount of IO done by request).

I've performed other benchmarks and I have no observed any perf regressions in
any of the normal (old) code paths.

I have co-developed these changes with Christoph Hellwig.

Christoph Hellwig (3):
  xfs: add RWF_NONBLOCK support
  fs: pass iocb to generic_write_sync
  fs: add a flag for per-operation O_DSYNC semantics

Milosz Tanski (4):
  vfs: Prepare for adding a new preadv/pwritev with user flags.
  vfs: Define new syscalls preadv2,pwritev2
  x86: wire up preadv2 and pwritev2
  vfs: RWF_NONBLOCK flag for preadv2

 arch/x86/syscalls/syscall_32.tbl  |   2 +
 arch/x86/syscalls/syscall_64.tbl  |   2 +
 drivers/target/target_core_file.c |   6 +-
 fs/block_dev.c                    |   8 +-
 fs/btrfs/file.c                   |   7 +-
 fs/ceph/file.c                    |   6 +-
 fs/cifs/file.c                    |  14 +--
 fs/direct-io.c                    |   8 +-
 fs/ext4/file.c                    |   8 +-
 fs/fuse/file.c                    |   2 +
 fs/gfs2/file.c                    |   9 +-
 fs/nfs/file.c                     |  15 ++-
 fs/nfsd/vfs.c                     |   4 +-
 fs/ntfs/file.c                    |   8 +-
 fs/ocfs2/file.c                   |  12 +-
 fs/pipe.c                         |   3 +-
 fs/read_write.c                   | 239 +++++++++++++++++++++++++++++---------
 fs/splice.c                       |   2 +-
 fs/udf/file.c                     |  11 +-
 fs/xfs/xfs_file.c                 |  36 ++++--
 include/linux/aio.h               |   2 +
 include/linux/compat.h            |   6 +
 include/linux/fs.h                |  16 ++-
 include/linux/syscalls.h          |   6 +
 include/uapi/asm-generic/unistd.h |   6 +-
 mm/filemap.c                      |  55 +++++++--
 mm/shmem.c                        |   4 +
 27 files changed, 346 insertions(+), 151 deletions(-)

-- 
1.9.1
