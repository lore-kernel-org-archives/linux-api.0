From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 10 Nov 2014 11:40:23 -0500
Message-ID: <cover.1415636409.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patcheset introduces an ability to perform a non-blocking read from
regular files in buffered IO mode. This works by only for those filesyste=
ms
that have data in the page cache.

It does this by introducing new syscalls new syscalls preadv2/pwritev2. T=
hese
new syscalls behave like the network sendmsg, recvmsg syscalls that accep=
t an
extra flag argument (RWF_NONBLOCK).

It's a very common patern today (samba, libuv, etc..) use a large threadp=
ool to
perform buffered IO operations. They submit the work form another thread
that performs network IO and epoll or other threads that perform CPU work=
. This
leads to increased latency for processing, esp. in the case of data that'=
s
already cached in the page cache.

With the new interface the applications will now be able to fetch the dat=
a in
their network / cpu bound thread(s) and only defer to a threadpool if it'=
s not
there. In our own application (VLDB) we've observed a decrease in latency=
 for
"fast" request by avoiding unnecessary queuing and having to swap out cur=
rent
tasks in IO bound work threads.

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


Some perf data generated using fio comparing the posix aio engine to a ve=
rsion
of the posix AIO engine that attempts to performs "fast" reads before
submitting the operations to the queue. This workflow is on ext4 partitio=
n on
raid0 (test / build-rig.) Simulating our database access patern workload =
using
16kb read accesses. Our database uses a home-spun posix aio like queue (s=
amba
does the same thing.)

f1: ~73% rand read over mostly cached data (zipf med-size dataset)
f2: ~18% rand read over mostly un-cached data (uniform large-dataset)
f3: ~9% seq-read over large dataset

before:

f1:
    bw (KB  /s): min=3D   11, max=3D 9088, per=3D0.56%, avg=3D969.54, std=
ev=3D827.99
    lat (msec) : 50=3D0.01%, 100=3D1.06%, 250=3D5.88%, 500=3D4.08%, 750=3D=
12.48%
    lat (msec) : 1000=3D17.27%, 2000=3D49.86%, >=3D2000=3D9.42%
f2:
    bw (KB  /s): min=3D    2, max=3D 1882, per=3D0.16%, avg=3D273.28, std=
ev=3D220.26
    lat (msec) : 250=3D5.65%, 500=3D3.31%, 750=3D15.64%, 1000=3D24.59%, 2=
000=3D46.56%
    lat (msec) : >=3D2000=3D4.33%
f3:
    bw (KB  /s): min=3D    0, max=3D265568, per=3D99.95%, avg=3D174575.10=
,
                 stdev=3D34526.89
    lat (usec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.02%, 20=3D0.27%, 50=3D10.82=
%
    lat (usec) : 100=3D50.34%, 250=3D5.05%, 500=3D7.12%, 750=3D6.60%, 100=
0=3D4.55%
    lat (msec) : 2=3D8.73%, 4=3D3.49%, 10=3D1.83%, 20=3D0.89%, 50=3D0.22%
    lat (msec) : 100=3D0.05%, 250=3D0.02%, 500=3D0.01%
total:
   READ: io=3D102365MB, aggrb=3D174669KB/s, minb=3D240KB/s, maxb=3D173599=
KB/s,
         mint=3D600001msec, maxt=3D600113msec

after (with fast read using preadv2 before submit):

f1:
    bw (KB  /s): min=3D    3, max=3D14897, per=3D1.28%, avg=3D2276.69, st=
dev=3D2930.39
    lat (usec) : 2=3D70.63%, 4=3D0.01%
    lat (msec) : 250=3D0.20%, 500=3D2.26%, 750=3D1.18%, 2000=3D0.22%, >=3D=
2000=3D25.53%
f2:
    bw (KB  /s): min=3D    2, max=3D 2362, per=3D0.14%, avg=3D249.83, std=
ev=3D222.00
    lat (msec) : 250=3D6.35%, 500=3D1.78%, 750=3D9.29%, 1000=3D20.49%, 20=
00=3D52.18%
    lat (msec) : >=3D2000=3D9.99%
f3:
    bw (KB  /s): min=3D    1, max=3D245448, per=3D100.00%, avg=3D177366.5=
0,
                 stdev=3D35995.60
    lat (usec) : 2=3D64.04%, 4=3D0.01%, 10=3D0.01%, 20=3D0.06%, 50=3D0.43=
%
    lat (usec) : 100=3D0.20%, 250=3D1.27%, 500=3D2.93%, 750=3D3.93%, 1000=
=3D7.35%
    lat (msec) : 2=3D14.27%, 4=3D2.88%, 10=3D1.54%, 20=3D0.81%, 50=3D0.22=
%
    lat (msec) : 100=3D0.05%, 250=3D0.02%
total:
   READ: io=3D103941MB, aggrb=3D177339KB/s, minb=3D213KB/s, maxb=3D176375=
KB/s,
         mint=3D600020msec, maxt=3D600178msec

Interpreting the results you can see total bandwidth stays the same but o=
verall
request latency is decreased in f1 (random, mostly cached) and f3 (sequen=
tial)
workloads. There is a slight bump in latency for since it's random data t=
hat's
unlikely to be cached but we're always trying "fast read".

In our application we have starting keeping track of "fast read" hits/mis=
ses
and for files / requests that have a lot hit ratio we don't do "fast read=
s"
mostly getting rid of extra latency in the uncached cases. In our real wo=
rld
work load we were able to reduce average response time by 20 to 30% (depe=
nds
on amount of IO done by request).

I've performed other benchmarks and I have no observed any perf regressio=
ns in
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
 fs/read_write.c                   | 233 +++++++++++++++++++++++++++++---=
------
 fs/splice.c                       |   2 +-
 fs/udf/file.c                     |  11 +-
 fs/xfs/xfs_file.c                 |  36 ++++--
 include/linux/aio.h               |   2 +
 include/linux/compat.h            |   6 +
 include/linux/fs.h                |  16 ++-
 include/linux/syscalls.h          |   6 +
 include/uapi/asm-generic/unistd.h |   6 +-
 mm/filemap.c                      |  56 +++++++--
 mm/shmem.c                        |   4 +
 27 files changed, 343 insertions(+), 149 deletions(-)

--=20
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=3Dmailto:"aart@kvack.org">aart@kvack.org</a>
