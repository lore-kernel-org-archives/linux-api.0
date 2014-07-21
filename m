From: Waiman Long <Waiman.Long@hp.com>
Subject: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 11:24:26 -0400
Message-ID: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

This patch series introduces two new futex command codes to support
a new optimistic spinning futex for implementing an exclusive lock
primitive that should perform better than the same primitive using
the wait-wake futex in cases where the lock owner is actively working
instead of waiting for I/O completion.

Optimistic spinning means that the waiting tasks spin within the
kernel for the lock owner to release the lock while it is running
instead of going to sleep and to be woken up later on. It is the same
mechanism that improves kernel mutex and rw semaphore performance,
especially on large system with many sockets and CPUs.

This patch series improves futex performance on two different fronts:
 1) Reducing the amount of the futex spinlock contention by using 2
    different spinlocks instead of just one for the wait-wake futex.
 2) Eliminating the context switching overhead and latency due to the
    sleeping and the waking of the waiting tasks.

The performance improvement varies depending on, to a certain extent,
the length of the critical section protected by futex.

Testing done on a 4-socket Westmere-EX boxes with 40 cores (HT off)
showed the following performance data (average kops/s) with various
load factor (number of pause instructions) used in the critical
section using an userspace mutex microbenchmark.

  Threads  Load	Waiting Futex	Spinning Futex 	  %Change
  -------  ----	-------------	--------------	  -------
    256	     1	     6894	    8883	    +29%
    256	    10	     3656	    4912	    +34%
    256	    50	     1332	    4358	   +227%
    256	   100	      792	    2753	   +248%
     10	     1	     6382	    4838	    -24%
     10	    10	     3614	    4748	    +31%
     10	    50	     1319	    3900	   +196%
     10	   100	      782	    2459	   +214%
      2	     1	     7905	    7194	   -9.0%
      2	    10	     4556	    4717	   +3.5%
      2	    50	     2191	    4167	    +90%
      2	   100	     1767	    2407	    +36%

Patch 1 introduces new futex command codes to provide a
mutex abstraction where the waiting tasks just go to sleep (no
spinning).

Patch 2 adds spinning to the mix.

Patch 3 enables wakened tasks to go back to the spinning state if
the owner is running.

Patch 4 changes sleeping queue from a simple FIFO list to an rbtree
sorted by process priority as well as the sequeunce the tasks enter
the kernel.

Patch 5 adds a new document file to describe the spinning futex.

Waiman Long (5):
  futex: add new exclusive lock & unlock command codes
  futex: add optimistic spinning to FUTEX_SPIN_LOCK
  spinning futex: move a wakened task to spinning
  spinning futex: put waiting tasks in a sorted rbtree
  futex, doc: add a document on how to use the spinning futexes

 Documentation/spinning-futex.txt |  109 +++++++
 include/uapi/linux/futex.h       |    4 +
 kernel/futex.c                   |  659 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 772 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/spinning-futex.txt

