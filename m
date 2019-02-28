From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH man-pages] Add rseq manpage
Date: Thu, 28 Feb 2019 09:42:58 +0100
Message-ID: <f6512944-26e1-6231-87b3-b30a2017b4b8@gmail.com>
References: <20181206144228.9656-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181206144228.9656-1-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On 12/6/18 3:42 PM, Mathieu Desnoyers wrote:
> [ Michael, rseq(2) was merged into 4.18. Can you have a look at this
>   patch which adds rseq documentation to the man-pages project ? ]
Hi Matthieu

Sorry for the long delay. I've merged this page into a private
branch and have done quite a lot of editing. I have many
questions :-).

In the first instance, I think it is probably best to have
a free-form text discussion rather than firing patches
back and forward. Could you take a look at the questions below
and respond?

Thanks,

Michael


RSEQ(2)                    Linux Programmer's Manual                   RSEQ(2)

NAME
       rseq - Restartable sequences and CPU number cache

SYNOPSIS
       #include <linux/rseq.h>

       int rseq(struct rseq *rseq, uint32_t rseq_len, int flags, uint32_t sig);

DESCRIPTION
       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │Imagine  you  are  someone who is pretty new to this │
       │idea...  What is notably lacking from this  page  is │
       │an overview explaining:                              │
       │                                                     │
       │    * What a restartable sequence actually is.       │
       │                                                     │
       │    * An outline of the steps to perform when using  │
       │    restartable sequences / rseq(2).                 │
       │                                                     │
       │I.e.,  something  along  the  lines  of Jon Corbet's │
       │https://lwn.net/Articles/697979/.  Can you  come  up │
       │with something? (Part of it might be at the start of │
       │this page, and the rest in NOTES; it need not be all │
       │in one place.)                                       │
       └─────────────────────────────────────────────────────┘
       The  rseq()  ABI  accelerates  user-space operations on per-CPU data by
       defining a shared data structure ABI between each user-space thread and
       the kernel.

       It allows user-space to perform update operations on per-CPU data with‐
       out requiring heavy-weight atomic operations.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In the following para: "a  hardware  execution  con‐ │
       │text"?   What  is  the contrast being drawn here? It │
       │would be good to state it more explicitly.           │
       └─────────────────────────────────────────────────────┘
       The term CPU used in this documentation refers to a hardware  execution
       context.

       Restartable  sequences are atomic with respect to preemption (making it
       atomic with respect to other threads running on the same CPU), as  well
       as  signal delivery (user-space execution contexts nested over the same
       thread).  They either complete atomically with respect to preemption on
       the current CPU and signal delivery, or they are aborted.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In  the  preceding sentence, we need a definition of │
       │"current CPU".                                       │
       └─────────────────────────────────────────────────────┘

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In the following, does "It  is"  means  "Restartable │
       │sequences are"?                                      │
       └─────────────────────────────────────────────────────┘
       It is suited for update operations on per-CPU data.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In  the  following,  does "It is" means "Restartable │
       │sequences are"?                                      │
       └─────────────────────────────────────────────────────┘
       It can be used on data  structures  shared  between  threads  within  a
       process, and on data structures shared between threads across different
       processes.

       Some examples of operations that can be accelerated or improved by this
       ABI:

       · Memory allocator per-CPU free-lists

       · Querying the current CPU number

       · Incrementing per-CPU counters

       · Modifying data protected by per-CPU spinlocks

       · Inserting/removing elements in per-CPU linked-lists

       · Writing/reading per-CPU ring buffers content

       · Accurately  reading performance monitoring unit counters with respect
         to thread migration

       Restartable sequences must not perform  system  calls.   Doing  so  may
       result in termination of the process by a segmentation fault.

       The rseq argument is a pointer to the thread-local rseq structure to be
       shared between kernel and user-space.  The layout of this structure  is
       shown below.

       The rseq_len argument is the size of the struct rseq to register.

       The  flags  argument is 0 for registration, or RSEQ_FLAG_UNREGISTER for
       unregistration.

       The sig argument is the 32-bit signature  to  be  expected  before  the
       abort handler code.

   The rseq structure
       The  struct  rseq  is aligned on a 32-byte boundary.  This structure is
       extensible.  Its size is passed as parameter to the rseq() system call.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │Below, I added the structure definition (in abbrevi‐ │
       │ated form).  Is there any reason not to do this?     │
       └─────────────────────────────────────────────────────┘

           struct rseq {
               __u32             cpu_id_start;
               __u32             cpu_id;
               union {
                   __u64 ptr64;
           #ifdef __LP64__
                   __u64 ptr;
           #else
                   ....
           #endif
               }                 rseq_cs;
               __u32             flags;
           } __attribute__((aligned(4 * sizeof(__u64))));

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In  the  text  below, I think it would be helpful to │
       │explicitly note which of these fields are set by the │
       │kernel  (on  return from the reseq() call) and which │
       │are set by the caller (before  calling  rseq()).  Is │
       │the following correct:                               │
       │                                                     │
       │    cpu_id_start - initialized by caller to possible │
       │    CPU number (e.g., 0), updated by kernel          │
       │    on return                                        │
       │                                                     │
       │    cpu_id - initialized to -1 by caller,            │
       │    updated by kernel on return                      │
       │                                                     │
       │    rseq_cs - initialized by caller, either to NULL  │
       │    or a pointer to an 'rseq_cs' structure           │
       │    that is initialized by the caller                │
       │                                                     │
       │    flags - initialized by caller, used by kernel    │
       └─────────────────────────────────────────────────────┘

       The structure fields are as follows:

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In  the  following paragraph, and in later places, I │
       │changed "current thread" to "calling thread". Okay?  │
       └─────────────────────────────────────────────────────┘

       cpu_id_start
              Optimistic cache of the CPU number on which the  calling  thread
              is  running.  The value in this field is guaranteed to always be
              a possible CPU number, even when rseq is not  initialized.   The
              value  it  contains  should  always  be confirmed by reading the
              cpu_id field.

              ┌─────────────────────────────────────────────────────┐
              │FIXME                                                │
              ├─────────────────────────────────────────────────────┤
              │What does the last sentence mean?                    │
              └─────────────────────────────────────────────────────┘

              This field is an optimistic cache in the sense that it is always
              guaranteed  to hold a valid CPU number in the range [0..(nr_pos‐
              sible_cpus - 1)].  It can therefore be loaded by user-space  and
              used  as  an offset in per-CPU data structures without having to
              check whether its value is within the valid bounds  compared  to
              the number of possible CPUs in the system.

              For  user-space  applications  executed on a kernel without rseq
              support, the cpu_id_start field stays initialized at 0, which is
              indeed  a  valid CPU number.  It is therefore valid to use it as
              an offset in per-CPU data structures, and only validate  whether
              it's  actually  the  current CPU number by comparing it with the
              cpu_id field within the rseq critical section.

              If the kernel does not provide rseq support, that  cpu_id  field
              stays  initialized  at  -1,  so  the comparison always fails, as
              intended.  It is then up to user-space to use a fall-back mecha‐
              nism, considering that rseq is not available.

              ┌─────────────────────────────────────────────────────┐
              │FIXME                                                │
              ├─────────────────────────────────────────────────────┤
              │The  last  sentence is rather difficult to grok. Can │
              │we say some more here?                               │
              └─────────────────────────────────────────────────────┘

       cpu_id Cache of the CPU number on which the calling thread is  running.
              -1 if uninitialized.

       rseq_cs
              The  rseq_cs  field  is a pointer to a struct rseq_cs (described
              below).  It is NULL when no rseq assembly block critical section
              is  active  for  the  calling  thread.  Setting it to point to a
              critical section descriptor (struct rseq_cs) marks the beginning
              of the critical section.

       flags  Flags  indicating  the  restart behavior for the calling thread.
              This is mainly used for debugging purposes.  Can be either:

              RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT

              RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL

              RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │Each of the above values needs an explanation.       │
       │                                                     │
       │Is it correct that only one of  the  values  may  be │
       │specified in 'flags'? I ask because in the 'rseq_cs' │
       │structure below, the 'flags' field  is  a  bit  mask │
       │where  any  combination  of  these flags may be ORed │
       │together.                                            │
       │                                                     │
       └─────────────────────────────────────────────────────┘

   The rseq_cs structure
       The struct rseq_cs is aligned on a 32-byte boundary  and  has  a  fixed
       size of 32 bytes.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │Below, I added the structure definition (in abbrevi‐ │
       │ated form).  Is there any reason not to do this?     │
       └─────────────────────────────────────────────────────┘

           struct rseq_cs {
               __u32   version;
               __u32   flags;
               __u64   start_ip;
               __u64   post_commit_offset;
               __u64   abort_ip;
           } __attribute__((aligned(4 * sizeof(__u64))));

       The structure fields are as follows:

       version
              Version of this structure.

              ┌─────────────────────────────────────────────────────┐
              │FIXME                                                │
              ├─────────────────────────────────────────────────────┤
              │What does 'version' need to be initialized to?       │
              └─────────────────────────────────────────────────────┘

       flags  Flags indicating the restart behavior of this structure.  Can be
              a combination of:

              RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT

              RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL

              RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │Each of the above values needs an explanation.       │
       └─────────────────────────────────────────────────────┘

       start_ip
              Instruction  pointer  address  of  the  first instruction of the
              sequence of consecutive assembly instructions.

       post_commit_offset
              Offset (from start_ip address) of the  address  after  the  last
              instruction  of  the  sequence  of consecutive assembly instruc‐
              tions.

       abort_ip
              Instruction pointer address where to move the execution flow  in
              case  of  abort of the sequence of consecutive assembly instruc‐
              tions.

NOTES
       A single library per process  should  keep  the  rseq  structure  in  a
       thread-local  storage variable.  The cpu_id field should be initialized
       to -1, and the cpu_id_start field should be initialized to  a  possible
       CPU value (typically 0).

       Each  thread  is responsible for registering and unregistering its rseq
       structure.  No more than one rseq structure address can  be  registered
       per thread at a given time.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In  the  following paragraph, what is the difference │
       │between "freed" and "reclaim"?  I'm  supposing  they │
       │mean the same thing, but it's not clear. And if they │
       │do mean the same thing, then the first two sentences │
       │appear to contain contradictory information.         │
       └─────────────────────────────────────────────────────┘

       Memory  of a registered rseq object must not be freed before the thread
       exits.  Reclaim of rseq object's memory must only be done after  either
       an explicit rseq unregistration is performed or after the thread exits.
       Keep in mind that the implementation of  the  Thread-Local  Storage  (C
       language  __thread)  lifetime  does  not guarantee existence of the TLS
       area up until the thread exits.

       In a typical usage scenario, the thread registering the rseq  structure
       will be performing loads and stores from/to that structure.  It is how‐
       ever also allowed to read that structure from other threads.  The  rseq
       field  updates performed by the kernel provide relaxed atomicity seman‐
       tics, which guarantee that  other  threads  performing  relaxed  atomic
       reads of the CPU number cache will always observe a consistent value.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │In  the  preceding  paragraph, can we reasonably add │
       │some words to explain "relaxed atomicity  semantics" │
       │and "relaxed atomic reads"?                          │
       └─────────────────────────────────────────────────────┘

RETURN VALUE
       A  return  value of 0 indicates success.  On error, -1 is returned, and
       errno is set appropriately.

ERRORS
       EBUSY  Restartable sequence is already registered for this thread.

       EFAULT rseq is an invalid address.

       EINVAL Either flags contains an invalid  value,  or  rseq  contains  an
              address which is not appropriately aligned, or rseq_len contains
              a size that does not match the size received on registration.

              ┌─────────────────────────────────────────────────────┐
              │FIXME                                                │
              ├─────────────────────────────────────────────────────┤
              │The last case "rseq_len contains a  size  that  does │
              │not  match  the  size  received on registration" can │
              │occur only on RSEQ_FLAG_UNREGISTER, tight?           │
              └─────────────────────────────────────────────────────┘

       ENOSYS The rseq() system call is not implemented by this kernel.

       EPERM  The sig argument on unregistration does not match the  signature
              received on registration.

VERSIONS
       The rseq() system call was added in Linux 4.18.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │What is the current state of library support?        │
       └─────────────────────────────────────────────────────┘

CONFORMING TO
       rseq() is Linux-specific.

       ┌─────────────────────────────────────────────────────┐
       │FIXME                                                │
       ├─────────────────────────────────────────────────────┤
       │Is  there  any  example  code that can reasonably be │
       │included in this manual page? Or some  example  code │
       │that can be referred to?                             │
       └─────────────────────────────────────────────────────┘

SEE ALSO
       sched_getcpu(3), membarrier(2)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
