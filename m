From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Fri, 21 Sep 2018 12:29:24 -0400 (EDT)
Message-ID: <1370210961.9271.1537547364295.JavaMail.zimbra@efficios.com>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1809191630260.26757@digraph.polyomino.org.uk> <67473000.8399.1537375994645.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1809191706090.26757@digraph.polyomino.org.uk> <1619649568.9014.1537474457166.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1809202016270.17228@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809202016270.17228@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


----- On Sep 20, 2018, at 4:20 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Thu, 20 Sep 2018, Mathieu Desnoyers wrote:
> 
>> Are you saying glibc has an explicit check for the kernel version visible
>> from /proc before using specific features ? If so, how can this work with
>> the variety of feature backports we find in the distribution kernels out
>> there ?
> 
> See sysdeps/unix/sysv/linux/dl-sysdep.c and
> sysdeps/unix/sysv/linux/dl-osinfo.h.  As I said, Carlos has proposed
> removing that check.

For the system calls I implement and maintain, I typically ensure there is
a set of parameters that can be used when issuing the system call so it
can either succeed or fail with ENOSYS without having side-effects. It's
specifically meant to be used for feature discovery in a library
initialization phase. It's especially useful if the application needs to
keep state around related to the system call across its execution, e.g.
robust futexes.

> 
>> For too-old headers at compile time, one possibility is that we don't event
>> expose the __rseq_abi TLS symbol. OTOH, if we need to keep exposing it anyway
>> for ABI consistency purposes, then we'd leave its cpu_id field at the initial
>> value (-1). But that would require that we copy linux/rseq.h into the glibc
>> source tree.
> 
> The ABI needs to be independent of the kernel headers used.  I don't think
> you need to copy linux/rseq.h; all you should need is to e.g. define an
> array of suitable size and alignment with the relevant member initialized
> and a suitable explanatory comment.

In that case, I'm thinking declaring a minimal structure in glibc code may be
clearer than the array, e.g.:

[pthreadP.h]

enum libc_rseq_cpu_id_state {
  LIBC_RSEQ_CPU_ID_UNINITIALIZED = -1,
  LIBC_RSEQ_CPU_ID_REGISTRATION_FAILED = -2,
};

/* linux/rseq.h defines struct rseq as aligned on 32 bytes. The kernel ABI
   size is 20 bytes. For support of multiple rseq users within a process,
   user-space defines an extra 4 bytes field as a reference count, for a
   total of 24 bytes.  */
struct libc_rseq {
  /* kernel-userspace ABI. */
  uint32_t cpu_id_start;
  uint32_t cpu_id;
  uint64_t rseq_cs;
  uint32_t flags;
  /* user-space ABI. */
  uint32_t refcount;
} __attribute__((aligned(4 * sizeof(uint64_t))));

[pthread_create.h]

__thread volatile struct libc_rseq __rseq_abi = {
  .cpu_id = LIBC_RSEQ_CPU_ID_UNINITIALIZED,
};

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
