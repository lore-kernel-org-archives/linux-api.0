From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache only)
Date: Thu, 25 Sep 2014 11:48:41 -0400
Message-ID: <CANP1eJHy5QGbSH316h3kAvwW6NFZc7w4g-+17uATwzb=WrGHdg@mail.gmail.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1411594644.git.milosz@adfin.com>
	<CAHO5Pa2AbW+ndgUBjjB==NnwQjVuvbYaYdW8v0x-CjYYQEr9AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAHO5Pa2AbW+ndgUBjjB==NnwQjVuvbYaYdW8v0x-CjYYQEr9AA@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 25, 2014 at 12:06 AM, Michael Kerrisk
<mtk.manpages@gmail.com> wrote:
> Hello Milosz,
>
> On Wed, Sep 24, 2014 at 11:46 PM, Milosz Tanski <milosz@adfin.com> wrote:
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>>
>> It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
>> new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
>> extra flag argument (RWF_NONBLOCK).
>>
>> It's a very common patern today (samba, libuv, etc..) use a large threadpool to
>> perform buffered IO operations. They submit the work form another thread
>> that performs network IO and epoll or other threads that perform CPU work. This
>> leads to increased latency for processing, esp. in the case of data that's
>> already cached in the page cache.
>>
>> With the new interface the applications will now be able to fetch the data in
>> their network / cpu bound thread(s) and only defer to a threadpool if it's not
>> there. In our own application (VLDB) we've observed a decrease in latency for
>> "fast" request by avoiding unnecessary queuing and having to swap out current
>> tasks in IO bound work threads.
>
> Since this is a change to the user-space API, could you CC future
> versions of this patch set to linux-api@vgerr.kernel.org please, as
> per Documentation/SubmitChecklist. See also
> https://www.kernel.org/doc/man-pages/linux-api-ml.html.

Will do and sorry about this; also I noted Jan's correction.

>
> Thanks,
>
> Michael
>
>
>> Version 3 highlights:
>>  - Down to 2 syscalls from 4; can user fp or argument position.
>>  - RWF_NONBLOCK value flag is not the same O_NONBLOCK, per Jeff.
>>
>> Version 2 highlights:
>>  - Put the flags argument into kiocb (less noise), per. Al Viro
>>  - O_DIRECT checking early in the process, per. Jeff Moyer
>>  - Resolved duplicate (c&p) code in syscall code, per. Jeff
>>  - Included perf data in thread cover letter, per. Jeff
>>  - Created a new flag (not O_NONBLOCK) for readv2, perf Jeff
>>
>>
>> Some perf data generated using fio comparing the posix aio engine to a version
>> of the posix AIO engine that attempts to performs "fast" reads before
>> submitting the operations to the queue. This workflow is on ext4 partition on
>> raid0 (test / build-rig.) Simulating our database access patern workload using
>> 16kb read accesses. Our database uses a home-spun posix aio like queue (samba
>> does the same thing.)
>>
>> f1: ~73% rand read over mostly cached data (zipf med-size dataset)
>> f2: ~18% rand read over mostly un-cached data (uniform large-dataset)
>> f3: ~9% seq-read over large dataset
>>
>> before:
>>
>> f1:
>>     bw (KB  /s): min=   11, max= 9088, per=0.56%, avg=969.54, stdev=827.99
>>     lat (msec) : 50=0.01%, 100=1.06%, 250=5.88%, 500=4.08%, 750=12.48%
>>     lat (msec) : 1000=17.27%, 2000=49.86%, >=2000=9.42%
>> f2:
>>     bw (KB  /s): min=    2, max= 1882, per=0.16%, avg=273.28, stdev=220.26
>>     lat (msec) : 250=5.65%, 500=3.31%, 750=15.64%, 1000=24.59%, 2000=46.56%
>>     lat (msec) : >=2000=4.33%
>> f3:
>>     bw (KB  /s): min=    0, max=265568, per=99.95%, avg=174575.10,
>>                  stdev=34526.89
>>     lat (usec) : 2=0.01%, 4=0.01%, 10=0.02%, 20=0.27%, 50=10.82%
>>     lat (usec) : 100=50.34%, 250=5.05%, 500=7.12%, 750=6.60%, 1000=4.55%
>>     lat (msec) : 2=8.73%, 4=3.49%, 10=1.83%, 20=0.89%, 50=0.22%
>>     lat (msec) : 100=0.05%, 250=0.02%, 500=0.01%
>> total:
>>    READ: io=102365MB, aggrb=174669KB/s, minb=240KB/s, maxb=173599KB/s,
>>          mint=600001msec, maxt=600113msec
>>
>> after (with fast read using preadv2 before submit):
>>
>> f1:
>>     bw (KB  /s): min=    3, max=14897, per=1.28%, avg=2276.69, stdev=2930.39
>>     lat (usec) : 2=70.63%, 4=0.01%
>>     lat (msec) : 250=0.20%, 500=2.26%, 750=1.18%, 2000=0.22%, >=2000=25.53%
>> f2:
>>     bw (KB  /s): min=    2, max= 2362, per=0.14%, avg=249.83, stdev=222.00
>>     lat (msec) : 250=6.35%, 500=1.78%, 750=9.29%, 1000=20.49%, 2000=52.18%
>>     lat (msec) : >=2000=9.99%
>> f3:
>>     bw (KB  /s): min=    1, max=245448, per=100.00%, avg=177366.50,
>>                  stdev=35995.60
>>     lat (usec) : 2=64.04%, 4=0.01%, 10=0.01%, 20=0.06%, 50=0.43%
>>     lat (usec) : 100=0.20%, 250=1.27%, 500=2.93%, 750=3.93%, 1000=7.35%
>>     lat (msec) : 2=14.27%, 4=2.88%, 10=1.54%, 20=0.81%, 50=0.22%
>>     lat (msec) : 100=0.05%, 250=0.02%
>> total:
>>    READ: io=103941MB, aggrb=177339KB/s, minb=213KB/s, maxb=176375KB/s,
>>          mint=600020msec, maxt=600178msec
>>
>> Interpreting the results you can see total bandwidth stays the same but overall
>> request latency is decreased in f1 (random, mostly cached) and f3 (sequential)
>> workloads. There is a slight bump in latency for since it's random data that's
>> unlikely to be cached but we're always trying "fast read".
>>
>> In our application we have starting keeping track of "fast read" hits/misses
>> and for files / requests that have a lot hit ratio we don't do "fast reads"
>> mostly getting rid of extra latency in the uncached cases.
>>
>> I've performed other benchmarks and I have no observed any perf regressions in
>> any of the normal (old) code paths.
>>
>>
>> I have co-developed these changes with Christoph Hellwig.
>>
>> Milosz Tanski (4):
>>   vfs: Prepare for adding a new preadv/pwritev with user flags.
>>   vfs: Define new syscalls preadv2,pwritev2
>>   vfs: Export new vector IO syscalls (with flags) to userland
>>   vfs: RWF_NONBLOCK flag for preadv2
>>
>>  arch/x86/syscalls/syscall_32.tbl  |   2 +
>>  arch/x86/syscalls/syscall_64.tbl  |   2 +
>>  drivers/target/target_core_file.c |   6 +-
>>  fs/cifs/file.c                    |   6 ++
>>  fs/nfsd/vfs.c                     |   4 +-
>>  fs/ocfs2/file.c                   |   6 ++
>>  fs/pipe.c                         |   3 +-
>>  fs/read_write.c                   | 121 +++++++++++++++++++++++++++++---------
>>  fs/splice.c                       |   2 +-
>>  fs/xfs/xfs_file.c                 |   4 ++
>>  include/linux/aio.h               |   2 +
>>  include/linux/fs.h                |   7 ++-
>>  include/linux/syscalls.h          |   6 ++
>>  include/uapi/asm-generic/unistd.h |   6 +-
>>  mm/filemap.c                      |  22 ++++++-
>>  mm/shmem.c                        |   4 ++
>>  16 files changed, 163 insertions(+), 40 deletions(-)
>>
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-aio' in
>> the body to majordomo@kvack.org.  For more info on Linux AIO,
>> see: http://www.kvack.org/aio/
>> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
>
>
>
> --
> Michael Kerrisk Linux man-pages maintainer;
> http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface", http://blog.man7.org/



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
