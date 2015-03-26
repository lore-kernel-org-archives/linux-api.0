From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Thu, 26 Mar 2015 16:02:22 +0900
Message-ID: <20150326070221.GA26725@blaptop>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com>
 <20150318153100.5658b741277f3717b52e42d9@linux-foundation.org>
 <550A5FF8.90504@gmail.com>
 <CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com>
 <20150323051731.GA2616341@devbig257.prn2.facebook.com>
 <CADpJO7zk8J3q7Bw9NibV9CzLarO+YkfeshyFTTq=XeS5qziBiA@mail.gmail.com>
 <55117724.6030102@gmail.com>
 <20150326005009.GA7658@blaptop>
 <55135F06.4000906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55135F06.4000906-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 09:21:10PM -0400, Daniel Micay wrote:
> > I didn't follow this thread. However, as you mentioned MADV_FREE will
> > make many page fault, I jump into here.
> > One of the benefit with MADV_FREE in current implementation is to
> > avoid page fault as well as no zeroing.
> > Why did you see many page fault?
> 
> I think I just misunderstood why it was still so much slower than not
> using purging at all.
> 
> >> I get ~20k requests/s with jemalloc on the ebizzy benchmark with this
> >> dual core ivy bridge laptop. It jumps to ~60k requests/s with MADV_FREE
> >> IIRC, but disabling purging via MALLOC_CONF=lg_dirty_mult:-1 leads to
> >> 3.5 *million* requests/s. It has a similar impact with TCMalloc.
> > 
> > When I tested MADV_FREE with ebizzy, I saw similar result two or three
> > times fater than MADV_DONTNEED. But It's no free cost. It incurs MADV_FREE
> > cost itself*(ie, enumerating all of page table in the range and clear
> > dirty bit and tlb flush). Of course, it has mmap_sem with read-side lock.
> > If you see great improve when you disable purging, I guess mainly it's
> > caused by no lock of mmap_sem so some threads can allocate while other
> > threads can do page fault. The reason I think so is I saw similar result
> > when I implemented vrange syscall which hold mmap_sem read-side lock
> > during very short time(ie, marking the volatile into vma, ie O(1) while
> > MADV_FREE holds a lock during enumerating all of pages in the range, ie O(N))
> 
> It stops doing mmap after getting warmed up since it never unmaps so I
> don't think mmap_sem is a contention issue. It could just be caused by
> the cost of the system call itself and TLB flush. I found perf to be
> fairly useless in identifying where the time was being spent.
> 
> It might be much more important to purge very large ranges in one go
> with MADV_FREE. It's a different direction than the current compromises
> forced by MADV_DONTNEED.
> 

I tested ebizzy + recent jemalloc in my KVM guest.

Apparently, no purging was best(ie, 4925 records/s) while purging with
MADV_DONTNEED was worst(ie, 1814 records/s).
However, in my machine, purging with MADV_FREE was not bad as yourr.

        4338 records/s vs 4925 records/s.

Still, no purging was win but if we consider the num of madvise syscall
between no purging and MADV_FREE purging, it would be better than now.

        0 vs 43724

One thing I am wondering is why the madvise syscall count is increased
when we turns on MADV_FREE compared to MADV_DONTNEED. It might be
aggressive dirty puring rule in jemalloc internal?

Anyway, my point is gap between MADV_FREE and no puring in my machine
is not much like you said.

********
#> lscpu

Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                12
On-line CPU(s) list:   0-11
Thread(s) per core:    2
Core(s) per socket:    6
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 45
Stepping:              7
CPU MHz:               1200.000
BogoMIPS:              6399.71
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              12288K
NUMA node0 CPU(s):     0-11

*****

ebizzy 0.2 
(C) 2006-7 Intel Corporation
(C) 2007 Valerie Henson <val-/gER7w9Thpc@public.gmane.org>
always_mmap 0
never_mmap 0
chunks 10
prevent coalescing using permissions 0
prevent coalescing using holes 0
random_size 0
chunk_size 5242880
seconds 10
threads 24
verbose 1
linear 0
touch_pages 0
page size 4096
Allocated memory
Wrote memory
Threads starting
Threads finished

******

jemalloc git head
commit 65db63cf3f0c5dd5126a1b3786756486eaf931ba
Author: Jason Evans <je-b10kYP2dOMg@public.gmane.org>
Date:   Wed Mar 25 18:56:55 2015 -0700

    Fix in-place shrinking huge reallocation purging bugs.


******
1) LD_PRELOAD="/jemalloc/lib/libjemalloc.so.dontneed" strace -c -f ./ebizzy -s $((5<<20))

1814 records/s
real 10.00 s
user 28.18 s
sys  90.08 s
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 90.78   99.368420        5469     18171           madvise
  9.14   10.001131    10001131         1           nanosleep
  0.05    0.050037         807        62        10 futex
  0.03    0.031721         291       109           mmap
  0.00    0.004455         178        25           set_robust_list
  0.00    0.000129           5        24           clone
  0.00    0.000000           0         4           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         6           open
  0.00    0.000000           0         6           close
  0.00    0.000000           0         6           fstat
  0.00    0.000000           0        32           mprotect
  0.00    0.000000           0        35           munmap
  0.00    0.000000           0         2           brk
  0.00    0.000000           0         3           rt_sigaction
  0.00    0.000000           0         3           rt_sigprocmask
  0.00    0.000000           0         4         3 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1         1 readlink
  0.00    0.000000           0         1           getrlimit
  0.00    0.000000           0         2           getrusage
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           set_tid_address
------ ----------- ----------- --------- --------- ----------------
100.00  109.455893                 18501        14 total

2) LD_PRELOAD="/jemalloc/lib/libjemalloc.so.dontneed" MALLOC_CONF=lg_dirty_mult:-1 strace -c -f ./ebizzy -s $((5<<20))

4925 records/s
real 10.00 s
user 119.83 s
sys   0.16 s
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 82.73    0.821804       15804        52         6 futex
 15.70    0.156000      156000         1           nanosleep
  1.53    0.015186         115       132           mmap
  0.04    0.000349           4        87           munmap
  0.00    0.000000           0         4           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         6           open
  0.00    0.000000           0         6           close
  0.00    0.000000           0         6           fstat
  0.00    0.000000           0        32           mprotect
  0.00    0.000000           0         2           brk
  0.00    0.000000           0         3           rt_sigaction
  0.00    0.000000           0         3           rt_sigprocmask
  0.00    0.000000           0         4         3 access
  0.00    0.000000           0        24           madvise
  0.00    0.000000           0        24           clone
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1         1 readlink
  0.00    0.000000           0         1           getrlimit
  0.00    0.000000           0         2           getrusage
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0        25           set_robust_list
------ ----------- ----------- --------- --------- ----------------
100.00    0.993339                   419        10 total

3) LD_PRELOAD="/jemalloc/lib/libjemalloc.so.free" strace -c -f ./ebizzy -s $((5<<20))

4338 records/s
real 10.00 s
user 91.40 s
sys  12.58 s
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 78.39   36.433483         839     43408           madvise
 21.53   10.004889    10004889         1           nanosleep
  0.04    0.020472         394        52        15 futex
  0.03    0.015464         145       107           mmap
  0.00    0.000041           2        24           clone
  0.00    0.000000           0         4           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         6           open
  0.00    0.000000           0         6           close
  0.00    0.000000           0         6           fstat
  0.00    0.000000           0        32           mprotect
  0.00    0.000000           0        33           munmap
  0.00    0.000000           0         2           brk 
  0.00    0.000000           0         3           rt_sigaction
  0.00    0.000000           0         3           rt_sigprocmask
  0.00    0.000000           0         4         3 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1         1 readlink
  0.00    0.000000           0         1           getrlimit
  0.00    0.000000           0         2           getrusage
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         1           set_tid_address
  0.00    0.000000           0        25           set_robust_list
------ ----------- ----------- --------- --------- ----------------
100.00   46.474349                 43724        19 total

-- 
Kind regards,
Minchan Kim
