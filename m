From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 16 Mar 2015 14:27:10 -0400
Message-ID: <cover.1426528417.git.milosz@adfin.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

This patchset introduces two new syscalls preadv2 and pwritev2. They are the
same syscalls as preadv and pwrite but with a flag argument. Additionally,
preadv2 implements an extra RWF_NONBLOCK flag. 

The RWF_NONBLOCK flag in preadv2 introduces an ability to perform a
non-blocking read from regular files in buffered IO mode. This works by only
for those filesystems that have data in the page cache.

We discussed these changes at this year's LSF/MM summit in Boston. More details
on the Samba use case, the numbers, and presentation is available at this link:
https://lists.samba.org/archive/samba-technical/2015-March/106290.html

Please stayed tune for man pages patches and xfstest patches. They will be sent
as In-Reply-To.


Latest changes highlight:
 - Drops RWF_DSYNC from pwritev2, per Christoph and Andrew
 - Updated man pages
 - Added tests for this functionality to xfstests, per Dave Chinner
 - Based on top of 4.1-rc3
 - Tests / numbers using samba and a CIFS client FIO engine

Forward looking:

 Christoph committed to sending a separate patch series for the RWF_DSYNC for
 pwritev2 implementation so it can be evaluated independently. This helps
 with implementing userspace file servers for protocols that have a per operation
 sync flag (CIFS).

 Additionally, Christoph committed to implementing RWF_NONBLOCK for the write
 case as well (in pwritev2) at a later date.


Background:

 Using a threadpool to emulate non-blocking operations on regular buffered
 files is a common pattern today (samba, libuv, etc...) Applications split the
 work between network bound threads (epoll) and IO threadpool. Not every
 application can use sendfile syscall (TLS / post-processing).

 This common pattern leads to increased request latency. Latency can be due to
 additional synchronization between the threads or fast (cached data) request
 stuck behind slow request (large / uncached data).

 The preadv2 syscall with RWF_NONBLOCK lets userspace applications bypass
 enqueuing operation in the threadpool if it's already available in the
 pagecache.


Performance numbers (newer Samba):

 https://drive.google.com/file/d/0B3maCn0jCvYncndGbXJKbGlhejQ/view?usp=sharing
 https://docs.google.com/spreadsheets/d/1GGTivi-MfZU0doMzomG4XUo9ioWtRvOGQ5FId042L6s/edit?usp=sharing


Performance number (older):

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


Full change log:

 Version 7 highlight:
  - Drops RWF_DSYNC from pwritev2, per Christoph and Andrew
  - Updated man pages
  - Added tests for this functionality to xfstests, per Dave Chinner
  - Based on top of 4.1-rc3
  - Tests / numbers using samba and a CIFS client FIO engine

 Version 6 highlight:
  - Compat syscall flag checks, per. Jeff.
  - Minor stylistic suggestions.

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


I have co-developed these changes with Christoph Hellwig.


Christoph Hellwig (1):
  xfs: add RWF_NONBLOCK support

Milosz Tanski (4):
  vfs: Prepare for adding a new preadv/pwritev with user flags.
  vfs: Define new syscalls preadv2,pwritev2
  x86: wire up preadv2 and pwritev2
  vfs: RWF_NONBLOCK flag for preadv2

 arch/x86/syscalls/syscall_32.tbl  |   2 +
 arch/x86/syscalls/syscall_64.tbl  |   2 +
 drivers/target/target_core_file.c |   6 +-
 fs/ceph/file.c                    |   2 +
 fs/cifs/file.c                    |   6 +
 fs/nfs/file.c                     |   5 +-
 fs/nfsd/vfs.c                     |   4 +-
 fs/ocfs2/file.c                   |   6 +
 fs/pipe.c                         |   3 +-
 fs/read_write.c                   | 229 +++++++++++++++++++++++++++++---------
 fs/splice.c                       |   2 +-
 fs/xfs/xfs_file.c                 |  28 ++++-
 include/linux/aio.h               |   2 +
 include/linux/compat.h            |   6 +
 include/linux/fs.h                |   6 +-
 include/linux/syscalls.h          |   6 +
 include/uapi/asm-generic/unistd.h |   6 +-
 mm/filemap.c                      |  23 +++-
 mm/shmem.c                        |   4 +
 19 files changed, 279 insertions(+), 69 deletions(-)

-- 
1.9.1
