From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call (v7)
Date: Thu, 12 Apr 2018 15:27:49 -0400
Message-ID: <20180412192800.15708-13-mathieu.desnoyers@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

The cpu_opv system call executes a vector of operations on behalf of
user-space on a specific CPU with preemption disabled. It is inspired
by readv() and writev() system calls which take a "struct iovec"
array as argument.

The operations available are: comparison, memcpy, add, or, and, xor,
left shift, right shift, and memory barrier. The system call receives
a CPU number from user-space as argument, which is the CPU on which
those operations need to be performed.  All pointers in the ops must
have been set up to point to the per CPU memory of the CPU on which
the operations should be executed. The "comparison" operation can be
used to check that the data used in the preparation step did not
change between preparation of system call inputs and operation
execution within the preempt-off critical section.

The reason why we require all pointer offsets to be calculated by
user-space beforehand is because we need to use get_user_pages()
to first pin all pages touched by each operation. This takes care of
faulting-in the pages. Then, preemption is disabled, and the
operations are performed atomically with respect to other thread
execution on that CPU, without generating any page fault.

An overall maximum of 4216 bytes in enforced on the sum of operation
length within an operation vector, so user-space cannot generate a
too long preempt-off critical section (cache cold critical section
duration measured as 4.7µs on x86-64). Each operation is also limited
a length of 4096 bytes, meaning that an operation can touch a
maximum of 4 pages (memcpy: 2 pages for source, 2 pages for
destination if addresses are not aligned on page boundaries).

If the thread is not running on the requested CPU, it is migrated to
it.

**** Justification for cpu_opv ****

Here are a few reasons justifying why the cpu_opv system call is
needed in addition to rseq:

1) Allow algorithms to perform per-cpu data migration without relying on
   sched_setaffinity()

The use-cases are migrating memory between per-cpu memory free-lists, or
stealing tasks from other per-cpu work queues: each require that
accesses to remote per-cpu data structures are performed.

Just rseq is not enough to cover those use-cases without additionally
relying on sched_setaffinity, which is unfortunately not
CPU-hotplug-safe.

The cpu_opv system call receives a CPU number as argument, and migrates
the current task to the right CPU to perform the operation sequence. If
the requested CPU is offline, it performs the operations from the
current CPU while preventing CPU hotplug, and with a mutex held.

2) Handling single-stepping from tools

Tools like debuggers, and simulators use single-stepping to run through
existing programs. If core libraries start to use restartable sequences
for e.g. memory allocation, this means pre-existing programs cannot be
single-stepped, simply because the underlying glibc or jemalloc has
changed.

The rseq user-space does expose a __rseq_table section for the sake of
debuggers, so they can skip over the rseq critical sections if they
want.  However, this requires upgrading tools, and still breaks
single-stepping in case where glibc or jemalloc is updated, but not the
tooling.

Having a performance-related library improvement break tooling is likely
to cause a big push-back against wide adoption of rseq.

3) Forward-progress guarantee

Having a piece of user-space code that stops progressing due to external
conditions is pretty bad. Developers are used to think of fast-path and
slow-path (e.g. for locking), where the contended vs uncontended cases
have different performance characteristics, but each need to provide
some level of progress guarantees.

There are concerns about proposing just "rseq" without the associated
slow-path (cpu_opv) that guarantees progress. It's just asking for
trouble when real-life will happen: page faults, uprobes, and other
unforeseen conditions that would seldom cause a rseq fast-path to never
progress.

4) Handling page faults

It's pretty easy to come up with corner-case scenarios where rseq does
not progress without the help from cpu_opv. For instance, a system with
swap enabled which is under high memory pressure could trigger page
faults at pretty much every rseq attempt. Although this scenario
is extremely unlikely, rseq becomes the weak link of the chain.

5) Comparison with LL/SC

The layman versed in the load-link/store-conditional instructions in
RISC architectures will notice the similarity between rseq and LL/SC
critical sections. The comparison can even be pushed further: since
debuggers can handle those LL/SC critical sections, they should be
able to handle rseq c.s. in the same way.

First, the way gdb recognises LL/SC c.s. patterns is very fragile:
it's limited to specific common patterns, and will miss the pattern
in all other cases. But fear not, having the rseq c.s. expose a
__rseq_table to debuggers removes that guessing part.

The main difference between LL/SC and rseq is that debuggers had
to support single-stepping through LL/SC critical sections from the
get go in order to support a given architecture. For rseq, we're
adding critical sections into pre-existing applications/libraries,
so the user expectation is that tools don't break due to a library
optimization.

6) Perform maintenance operations on per-cpu data

rseq c.s. are quite limited feature-wise: they need to end with a
*single* commit instruction that updates a memory location. On the other
hand, the cpu_opv system call can combine a sequence of operations that
need to be executed with preemption disabled. While slower than rseq,
this allows for more complex maintenance operations to be performed on
per-cpu data concurrently with rseq fast-paths, in cases where it's not
possible to map those sequences of ops to a rseq.

7) Use cpu_opv as generic implementation for architectures not
   implementing rseq assembly code

rseq critical sections require architecture-specific user-space code to
be crafted in order to port an algorithm to a given architecture.  In
addition, it requires that the kernel architecture implementation adds
hooks into signal delivery and resume to user-space.

In order to facilitate integration of rseq into user-space, cpu_opv can
provide a (relatively slower) architecture-agnostic implementation of
rseq. This means that user-space code can be ported to all architectures
through use of cpu_opv initially, and have the fast-path use rseq
whenever the asm code is implemented.

8) Allow libraries with multi-part algorithms to work on same per-cpu
   data without affecting the allowed cpu mask

The lttng-ust tracer presents an interesting use-case for per-cpu
buffers: the algorithm needs to update a "reserve" counter, serialize
data into the buffer, and then update a "commit" counter _on the same
per-cpu buffer_. Using rseq for both reserve and commit can bring
significant performance benefits.

Clearly, if rseq reserve fails, the algorithm can retry on a different
per-cpu buffer. However, it's not that easy for the commit. It needs to
be performed on the same per-cpu buffer as the reserve.

The cpu_opv system call solves that problem by receiving the cpu number
on which the operation needs to be performed as argument. It can push
the task to the right CPU if needed, and perform the operations there
with preemption disabled.

Changing the allowed cpu mask for the current thread is not an
acceptable alternative for a tracing library, because the application
being traced does not expect that mask to be changed by libraries.

9) Ensure that data structures don't need store-release/load-acquire
   semantic to handle fall-back

cpu_opv performs the fall-back on the requested CPU by migrating the
task to that CPU. Executing the slow-path on the right CPU ensures that
store-release/load-acquire semantic is not required neither on the
fast-path nor slow-path.

**** rseq and cpu_opv use-cases ****

1) per-cpu spinlock

A per-cpu spinlock can be implemented as a rseq consisting of a
comparison operation (== 0) on a word, and a word store (1), followed
by an acquire barrier after control dependency. The unlock path can be
performed with a simple store-release of 0 to the word, which does
not require rseq.

The cpu_opv fallback requires a single-word comparison (== 0) and a
single-word store (1).

2) per-cpu statistics counters

A per-cpu statistics counters can be implemented as a rseq consisting
of a final "add" instruction on a word as commit.

The cpu_opv fallback can be implemented as a "ADD" operation.

Besides statistics tracking, these counters can be used to implement
user-space RCU per-cpu grace period tracking for both single and
multi-process user-space RCU.

3) per-cpu LIFO linked-list (unlimited size stack)

A per-cpu LIFO linked-list has a "push" and "pop" operation,
which respectively adds an item to the list, and removes an
item from the list.

The "push" operation can be implemented as a rseq consisting of
a word comparison instruction against head followed by a word store
(commit) to head. Its cpu_opv fallback can be implemented as a
word-compare followed by word-store as well.

The "pop" operation can be implemented as a rseq consisting of
loading head, comparing it against NULL, loading the next pointer
at the right offset within the head item, and the next pointer as
a new head, returning the old head on success.

The cpu_opv fallback for "pop" differs from its rseq algorithm:
considering that cpu_opv requires to know all pointers at system
call entry so it can pin all pages, so cpu_opv cannot simply load
head and then load the head->next address within the preempt-off
critical section. User-space needs to pass the head and head->next
addresses to the kernel, and the kernel needs to check that the
head address is unchanged since it has been loaded by user-space.
However, when accessing head->next in a ABA situation, it's
possible that head is unchanged, but loading head->next can
result in a page fault due to a concurrently freed head object.
This is why the "expect_fault" operation field is introduced: if a
fault is triggered by this access, "-EAGAIN" will be returned by
cpu_opv rather than -EFAULT, thus indicating the the operation
vector should be attempted again. The "pop" operation can thus be
implemented as a word comparison of head against the head loaded
by user-space, followed by a load of the head->next pointer (which
may fault), and a store of that pointer as a new head.

4) per-cpu LIFO ring buffer with pointers to objects (fixed-sized stack)

This structure is useful for passing around allocated objects
by passing pointers through per-cpu fixed-sized stack.

The "push" side can be implemented with a check of the current
offset against the maximum buffer length, followed by a rseq
consisting of a comparison of the previously loaded offset
against the current offset, a word "try store" operation into the
next ring buffer array index (it's OK to abort after a try-store,
since it's not the commit, and its side-effect can be overwritten),
then followed by a word-store to increment the current offset (commit).

The "push" cpu_opv fallback can be done with the comparison, and
two consecutive word stores, all within the preempt-off section.

The "pop" side can be implemented with a check that offset is not
0 (whether the buffer is empty), a load of the "head" pointer before the
offset array index, followed by a rseq consisting of a word
comparison checking that the offset is unchanged since previously
loaded, another check ensuring that the "head" pointer is unchanged,
followed by a store decrementing the current offset.

The cpu_opv "pop" can be implemented with the same algorithm
as the rseq fast-path (compare, compare, store).

5) per-cpu LIFO ring buffer with pointers to objects (fixed-sized stack)
   supporting "peek" from remote CPU

In order to implement work queues with work-stealing between CPUs, it is
useful to ensure the offset "commit" in scenario 4) "push" have a
store-release semantic, thus allowing remote CPU to load the offset
with acquire semantic, and load the top pointer, in order to check if
work-stealing should be performed. The task (work queue item) existence
should be protected by other means, e.g. RCU.

If the peek operation notices that work-stealing should indeed be
performed, a thread can use cpu_opv to move the task between per-cpu
workqueues, by first invoking cpu_opv passing the remote work queue
cpu number as argument to pop the task, and then again as "push" with
the target work queue CPU number.

6) per-cpu LIFO ring buffer with data copy (fixed-sized stack)
   (with and without acquire-release)

This structure is useful for passing around data without requiring
memory allocation by copying the data content into per-cpu fixed-sized
stack.

The "push" operation is performed with an offset comparison against
the buffer size (figuring out if the buffer is full), followed by
a rseq consisting of a comparison of the offset, a try-memcpy attempting
to copy the data content into the buffer (which can be aborted and
overwritten), and a final store incrementing the offset.

The cpu_opv fallback needs to same operations, except that the memcpy
is guaranteed to complete, given that it is performed with preemption
disabled. This requires a memcpy operation supporting length up to 4kB.

The "pop" operation is similar to the "push, except that the offset
is first compared to 0 to ensure the buffer is not empty. The
copy source is the ring buffer, and the destination is an output
buffer.

7) per-cpu FIFO ring buffer (fixed-sized queue)

This structure is useful wherever a FIFO behavior (queue) is needed.
One major use-case is tracer ring buffer.

An implementation of this ring buffer has a "reserve", followed by
serialization of multiple bytes into the buffer, ended by a "commit".
The "reserve" can be implemented as a rseq consisting of a word
comparison followed by a word store. The reserve operation moves the
producer "head". The multi-byte serialization can be performed
non-atomically. Finally, the "commit" update can be performed with
a rseq "add" commit instruction with store-release semantic. The
ring buffer consumer reads the commit value with load-acquire
semantic to know whenever it is safe to read from the ring buffer.

This use-case requires that both "reserve" and "commit" operations
be performed on the same per-cpu ring buffer, even if a migration
happens between those operations. In the typical case, both operations
will happens on the same CPU and use rseq. In the unlikely event of a
migration, the cpu_opv system call will ensure the commit can be
performed on the right CPU by migrating the task to that CPU.

On the consumer side, an alternative to using store-release and
load-acquire on the commit counter would be to use cpu_opv to
ensure the commit counter load is performed on the right CPU. This
effectively allows moving a consumer thread between CPUs to execute
close to the ring buffer cache lines it will read.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Hunter <ahh@google.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org
---
Changes since v1:
- handle CPU hotplug,
- cleanup implementation using function pointers: We can use function
  pointers to implement the operations rather than duplicating all the
  user-access code.
- refuse device pages: Performing cpu_opv operations on io map'd pages
  with preemption disabled could generate long preempt-off critical
  sections, which leads to unwanted scheduler latency. Return EFAULT if
  a device page is received as parameter
- restrict op vector to 4216 bytes length sum: Restrict the operation
  vector to length sum of:
  - 4096 bytes (typical page size on most architectures, should be
    enough for a string, or structures)
  - 15 * 8 bytes (typical operations on integers or pointers).
  The goal here is to keep the duration of preempt off critical section
  short, so we don't add significant scheduler latency.
- Add INIT_ONSTACK macro: Introduce the
  CPU_OP_FIELD_u32_u64_INIT_ONSTACK() macros to ensure that users
  correctly initialize the upper bits of CPU_OP_FIELD_u32_u64() on their
  stack to 0 on 32-bit architectures.
- Add CPU_MB_OP operation:
  Use-cases with:
  - two consecutive stores,
  - a mempcy followed by a store,
  require a memory barrier before the final store operation. A typical
  use-case is a store-release on the final store. Given that this is a
  slow path, just providing an explicit full barrier instruction should
  be sufficient.
- Add expect fault field:
  The use-case of list_pop brings interesting challenges. With rseq, we
  can use rseq_cmpnev_storeoffp_load(), and therefore load a pointer,
  compare it against NULL, add an offset, and load the target "next"
  pointer from the object, all within a single req critical section.

  Life is not so easy for cpu_opv in this use-case, mainly because we
  need to pin all pages we are going to touch in the preempt-off
  critical section beforehand. So we need to know the target object (in
  which we apply an offset to fetch the next pointer) when we pin pages
  before disabling preemption.

  So the approach is to load the head pointer and compare it against
  NULL in user-space, before doing the cpu_opv syscall. User-space can
  then compute the address of the head->next field, *without loading it*.

  The cpu_opv system call will first need to pin all pages associated
  with input data. This includes the page backing the head->next object,
  which may have been concurrently deallocated and unmapped. Therefore,
  in this case, getting -EFAULT when trying to pin those pages may
  happen: it just means they have been concurrently unmapped. This is
  an expected situation, and should just return -EAGAIN to user-space,
  to user-space can distinguish between "should retry" type of
  situations and actual errors that should be handled with extreme
  prejudice to the program (e.g. abort()).

  Therefore, add "expect_fault" fields along with op input address
  pointers, so user-space can identify whether a fault when getting a
  field should return EAGAIN rather than EFAULT.
- Add compiler barrier between operations: Adding a compiler barrier
  between store operations in a cpu_opv sequence can be useful when
  paired with membarrier system call.

  An algorithm with a paired slow path and fast path can use
  sys_membarrier on the slow path to replace fast-path memory barriers
  by compiler barrier.

  Adding an explicit compiler barrier between operations allows
  cpu_opv to be used as fallback for operations meant to match
  the membarrier system call.

Changes since v2:

- Fix memory leak by introducing struct cpu_opv_pinned_pages.
  Suggested by Boqun Feng.
- Cast argument 1 passed to access_ok from integer to void __user *,
  fixing sparse warning.

Changes since v3:

- Fix !SMP by adding push_task_to_cpu() empty static inline.
- Add missing sys_cpu_opv() asmlinkage declaration to
  include/linux/syscalls.h.

Changes since v4:

- Cleanup based on Thomas Gleixner's feedback.
- Handle retry in case where the scheduler migrates the thread away
  from the target CPU after migration within the syscall rather than
  returning EAGAIN to user-space.
- Move push_task_to_cpu() to its own patch.
- New scheme for touching user-space memory:
   1) get_user_pages_fast() to pin/get all pages (which can sleep),
   2) vm_map_ram() those pages
   3) grab mmap_sem (read lock)
   4) __get_user_pages_fast() (or get_user_pages() on failure)
      -> Confirm that the same page pointers are returned. This
         catches cases where COW mappings are changed concurrently.
      -> If page pointers differ, or on gup failure, release mmap_sem,
         vm_unmap_ram/put_page and retry from step (1).
      -> perform put_page on the extra reference immediately for each
         page.
   5) preempt disable
   6) Perform operations on vmap. Those operations are normal
      loads/stores/memcpy.
   7) preempt enable
   8) release mmap_sem
   9) vm_unmap_ram() all virtual addresses
  10) put_page() all pages
- Handle architectures with VIVT caches along with vmap(): call
  flush_kernel_vmap_range() after each "write" operation. This
  ensures that the user-space mapping and vmap reach a consistent
  state between each operation.
- Depend on MMU for is_zero_pfn(). e.g. Blackfin and SH architectures
  don't provide the zero_pfn symbol.

Changes since v5:

- Fix handling of push_task_to_cpu() when argument is a cpu which is
  not part of the task's allowed cpu mask.
- Add CPU_OP_NR_FLAG flag, which returns the number of operations
  supported by the system call.

Changes since v6:

- Use __u* in public uapi header rather than uint*_t.
- Disallow cpu_opv targeting noncached vma, which requires using
  get_user_pages() rather than get_user_pages_fast() to get the
  vma.
- Fix handling of vm_map_ram() errors by increasing nr_vaddr only after
  success.
- Issue vm_unmap_aliases() after each cpu_opv system call, thus ensuring
  lazy unmapping does not exhaust vmalloc address space in stress-tests on
  32-bit systems.
- Use vm_map_user_ram() and vm_unmap_user_ram() to ensure cache coherency
  on virtually aliased architectures.

---
Man page associated:

CPU_OPV(2)             Linux Programmer's Manual            CPU_OPV(2)

NAME
       cpu_opv - CPU preempt-off operation vector system call

SYNOPSIS
       #include <linux/cpu_opv.h>

       int cpu_opv(struct cpu_op * cpu_opv, int cpuopcnt, int cpu, int f
lags);

DESCRIPTION
       The  cpu_opv  system  call  executes  a vector of operations on
       behalf of user-space on a specific  CPU  with  preemption  dis‐
       abled.

       The  term  CPU  used in this documentation refers to a hardware
       execution context.

       The operations available are: comparison, memcpy, add, or, and,
       xor, left shift, right shift, and memory  barrier.  The  system
       call  receives  a CPU number from user-space as argument, which
       is the CPU on which those operations need to be performed.  All
       pointers  in  the ops must have been set up to point to the per
       CPU memory of the CPU on which the operations  should  be  exe‐
       cuted. The "comparison" operation can be used to check that the
       data used in the preparation step did not change between prepa‐
       ration of system call inputs and operation execution within the
       preempt-off critical section.

       An overall maximum of 4216 bytes in  enforced  on  the  sum  of
       operation length within an operation vector, so user-space can‐
       not generate a too  long  preempt-off  critical  section.  Each
       operation  is  also  limited  a length of 4096 bytes. A maximum
       limit of  16  operations  per  cpu_opv  syscall  invocation  is
       enforced.

       If  the  thread  is  not  running  on  the requested CPU, it is
       migrated to it.

       The layout of struct cpu_opv is as follows:

       Fields

          op Operation of type  enum  cpu_op_type  to  perform.  This
              operation type selects the associated "u" union field.

           len
              Length  (in  bytes)  of data to consider for this opera‐
              tion.

           u.compare_op
              For a CPU_COMPARE_EQ_OP , and CPU_COMPARE_NE_OP  ,  con‐
              tains   the   a   and   b   pointers   to  compare.  The
              expect_fault_a  and   expect_fault_b   fields   indicate
              whether  a  page  fault  should  be expected for each of
              those pointers.  If expect_fault_a ,  or  expect_fault_b
              is  set,  EAGAIN  is  returned  on fault, else EFAULT is
              returned. The len field is allowed to take values from 0
              to 4096 for comparison operations.

           u.memcpy_op
              For a CPU_MEMCPY_OP , contains the dst and src pointers,
              expressing a copy of src into dst. The  expect_fault_dst
              and  expect_fault_src  fields  indicate  whether  a page
              fault should be expected for each of those pointers.  If
              expect_fault_dst , or expect_fault_src is set, EAGAIN is
              returned on fault, else  EFAULT  is  returned.  The  len
              field  is allowed to take values from 0 to 4096 for mem‐
              cpy operations.

           u.arithmetic_op
              For a  CPU_ADD_OP  ,  contains  the  p  ,  count  ,  and
              expect_fault_p  fields, which are respectively a pointer
              to the memory location to increment, the  64-bit  signed
              integer value to add, and whether a page fault should be
              expected for p .  If expect_fault_p is  set,  EAGAIN  is
              returned  on  fault,  else  EFAULT  is returned. The len
              field is allowed to take values of 1, 2, 4, 8 bytes  for
              arithmetic operations.

           u.bitwise_op
              For a CPU_OR_OP , CPU_AND_OP , and CPU_XOR_OP , contains
              the p , mask ,  and  expect_fault_p  fields,  which  are
              respectively a pointer to the memory location to target,
              the mask to apply, and whether a page  fault  should  be
              expected  for  p  .  If expect_fault_p is set, EAGAIN is
              returned on fault, else  EFAULT  is  returned.  The  len
              field  is allowed to take values of 1, 2, 4, 8 bytes for
              bitwise operations.

           u.shift_op
              For a CPU_LSHIFT_OP , and CPU_RSHIFT_OP , contains the p
              ,  bits  ,  and expect_fault_p fields, which are respec‐
              tively a pointer to the memory location to  target,  the
              number  of  bits  to  shift  either  left  of right, and
              whether a page fault should be  expected  for  p  .   If
              expect_fault_p is set, EAGAIN is returned on fault, else
              EFAULT is returned. The len field  is  allowed  to  take
              values  of  1,  2,  4, 8 bytes for shift operations. The
              bits field is allowed to take values between 0 and 63.

       The enum cpu_op_types contains the following operations:

       · CPU_COMPARE_EQ_OP: Compare whether two memory  locations  are
         equal,

       · CPU_COMPARE_NE_OP:  Compare whether two memory locations dif‐
         fer,

       · CPU_MEMCPY_OP: Copy a source memory location into a  destina‐
         tion,

       · CPU_ADD_OP:  Increment  a  target  memory location of a given
         count,

       · CPU_OR_OP: Apply a "or" mask to a memory location,

       · CPU_AND_OP: Apply a "and" mask to a memory location,

       · CPU_XOR_OP: Apply a "xor" mask to a memory location,

       · CPU_LSHIFT_OP: Shift a memory location left of a given number
         of bits,

       · CPU_RSHIFT_OP:  Shift a memory location right of a given num‐
         ber of bits.

       · CPU_MB_OP: Issue a memory barrier.

         All of the operations  above  provide  single-copy  atomicity
         guarantees  for word-sized, word-aligned target pointers, for
         both loads and stores.

       The cpuopcnt argument is the number of elements in the  cpu_opv
       array. It can take values from 0 to 16.

       The  cpu  argument  is  the  CPU  number on which the operation
       sequence needs to be executed.

       The flags argument is a bitmask. When  CPU_OP_NR_FLAG  is  set,
       the  cpu_opv()  system  call  returns  the number of operations
       available. When flags is 0, the sequence of operations received
       as parameter is performed.

RETURN VALUE
       A  return  value  of  0  indicates  success.  On  error,  -1 is
       returned, and errno is set appropriately. If a comparison oper‐
       ation  fails, execution of the operation vector is stopped, and
       the return value is the index after  the  comparison  operation
       (values between 1 and 16).

ERRORS
       EAGAIN cpu_opv() system call should be attempted again.

       EINVAL Either  flags contains an invalid value, or cpu contains
              an invalid value or a value not allowed by  the  current
              thread's  allowed  cpu  mask,  or  cpuopcnt  contains an
              invalid value, or the cpu_opv operation vector  contains
              an  invalid  op  value,  or the cpu_opv operation vector
              contains an invalid len value, or the cpu_opv  operation
              vector sum of len values is too large.

       ENOSYS The  cpu_opv()  system  call  is not implemented by this
              kernel.

       EFAULT cpu_opv is an invalid address, or  a  pointer  contained
              within  an  operation  is  invalid  (and  a fault is not
              expected for that pointer). Pointers to device and  non‐
              cached   memory   within  an  operation  are  considered
              invalid.

VERSIONS
       The cpu_opv() system call was added in Linux 4.X (TODO).

CONFORMING TO
       cpu_opv() is Linux-specific.

SEE ALSO
       membarrier(2), rseq(2)

Linux                         2018-03-22                    CPU_OPV(2)
---
 MAINTAINERS                  |    7 +
 include/linux/syscalls.h     |    3 +
 include/uapi/linux/cpu_opv.h |  120 +++++
 init/Kconfig                 |   17 +
 kernel/Makefile              |    1 +
 kernel/cpu_opv.c             | 1107 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c              |    1 +
 7 files changed, 1256 insertions(+)
 create mode 100644 include/uapi/linux/cpu_opv.h
 create mode 100644 kernel/cpu_opv.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 01d81ed89676..7ab90224634c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3744,6 +3744,13 @@ B:	https://bugzilla.kernel.org
 F:	drivers/cpuidle/*
 F:	include/linux/cpuidle.h
 
+CPU NON-PREEMPTIBLE OPERATION VECTOR SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/cpu_opv.c
+F:	include/uapi/linux/cpu_opv.h
+
 CRAMFS FILESYSTEM
 M:	Nicolas Pitre <nico@linaro.org>
 S:	Maintained
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 340650b4ec54..32d289f41f62 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -67,6 +67,7 @@ struct perf_event_attr;
 struct file_handle;
 struct sigaltstack;
 struct rseq;
+struct cpu_op;
 union bpf_attr;
 
 #include <linux/types.h>
@@ -943,5 +944,7 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
 asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
 			int flags, uint32_t sig);
+asmlinkage long sys_cpu_opv(struct cpu_op __user *ucpuopv, int cpuopcnt,
+			int cpu, int flags);
 
 #endif
diff --git a/include/uapi/linux/cpu_opv.h b/include/uapi/linux/cpu_opv.h
new file mode 100644
index 000000000000..360170ca513b
--- /dev/null
+++ b/include/uapi/linux/cpu_opv.h
@@ -0,0 +1,120 @@
+#ifndef _UAPI_LINUX_CPU_OPV_H
+#define _UAPI_LINUX_CPU_OPV_H
+
+/*
+ * linux/cpu_opv.h
+ *
+ * CPU preempt-off operation vector system call API
+ *
+ * Copyright (c) 2017 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifdef __KERNEL__
+# include <linux/types.h>
+#else
+# include <stdint.h>
+#endif
+
+#include <linux/types_32_64.h>
+
+#define CPU_OP_VEC_LEN_MAX		16
+#define CPU_OP_ARG_LEN_MAX		24
+/* Maximum data len per operation. */
+#define CPU_OP_DATA_LEN_MAX		4096
+/*
+ * Maximum data len for overall vector. Restrict the amount of user-space
+ * data touched by the kernel in non-preemptible context, so it does not
+ * introduce long scheduler latencies.
+ * This allows one copy of up to 4096 bytes, and 15 operations touching 8
+ * bytes each.
+ * This limit is applied to the sum of length specified for all operations
+ * in a vector.
+ */
+#define CPU_OP_MEMCPY_EXPECT_LEN	4096
+#define CPU_OP_EXPECT_LEN		8
+#define CPU_OP_VEC_DATA_LEN_MAX		\
+	(CPU_OP_MEMCPY_EXPECT_LEN +	\
+	 (CPU_OP_VEC_LEN_MAX - 1) * CPU_OP_EXPECT_LEN)
+
+enum cpu_op_flags {
+	CPU_OP_NR_FLAG =	(1U << 0),
+};
+
+enum cpu_op_type {
+	/* compare */
+	CPU_COMPARE_EQ_OP,
+	CPU_COMPARE_NE_OP,
+	/* memcpy */
+	CPU_MEMCPY_OP,
+	/* arithmetic */
+	CPU_ADD_OP,
+	/* bitwise */
+	CPU_OR_OP,
+	CPU_AND_OP,
+	CPU_XOR_OP,
+	/* shift */
+	CPU_LSHIFT_OP,
+	CPU_RSHIFT_OP,
+	/* memory barrier */
+	CPU_MB_OP,
+
+	NR_CPU_OPS,
+};
+
+/* Vector of operations to perform. Limited to 16. */
+struct cpu_op {
+	/* enum cpu_op_type. */
+	__s32 op;
+	/* data length, in bytes. */
+	__u32 len;
+	union {
+		struct {
+			LINUX_FIELD_u32_u64(a);
+			LINUX_FIELD_u32_u64(b);
+			__u8 expect_fault_a;
+			__u8 expect_fault_b;
+		} compare_op;
+		struct {
+			LINUX_FIELD_u32_u64(dst);
+			LINUX_FIELD_u32_u64(src);
+			__u8 expect_fault_dst;
+			__u8 expect_fault_src;
+		} memcpy_op;
+		struct {
+			LINUX_FIELD_u32_u64(p);
+			__s64 count;
+			__u8 expect_fault_p;
+		} arithmetic_op;
+		struct {
+			LINUX_FIELD_u32_u64(p);
+			__u64 mask;
+			__u8 expect_fault_p;
+		} bitwise_op;
+		struct {
+			LINUX_FIELD_u32_u64(p);
+			__u32 bits;
+			__u8 expect_fault_p;
+		} shift_op;
+		char __padding[CPU_OP_ARG_LEN_MAX];
+	} u;
+};
+
+#endif /* _UAPI_LINUX_CPU_OPV_H */
diff --git a/init/Kconfig b/init/Kconfig
index c94d0f59b898..fc1ca5fa804f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1422,6 +1422,8 @@ config RSEQ
 	bool "Enable rseq() system call" if EXPERT
 	default y
 	depends on HAVE_RSEQ
+	depends on MMU
+	select CPU_OPV
 	select MEMBARRIER
 	help
 	  Enable the restartable sequences system call. It provides a
@@ -1441,6 +1443,21 @@ config DEBUG_RSEQ
 
 	  If unsure, say N.
 
+# CPU_OPV depends on MMU for is_zero_pfn()
+config CPU_OPV
+	bool "Enable cpu_opv() system call" if EXPERT
+	default y
+	depends on MMU
+	help
+	  Enable the CPU preempt-off operation vector system call.
+	  It allows user-space to perform a sequence of operations on
+	  per-cpu data with preemption disabled. Useful as
+	  single-stepping fall-back for restartable sequences, and for
+	  performing more complex operations on per-cpu data that would
+	  not be otherwise possible to do with restartable sequences.
+
+	  If unsure, say Y.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/Makefile b/kernel/Makefile
index 7085c841c413..9075436afc2e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_TORTURE_TEST) += torture.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
 obj-$(CONFIG_RSEQ) += rseq.o
+obj-$(CONFIG_CPU_OPV) += cpu_opv.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
new file mode 100644
index 000000000000..adb9eb49fb56
--- /dev/null
+++ b/kernel/cpu_opv.c
@@ -0,0 +1,1107 @@
+/*
+ * CPU preempt-off operation vector system call
+ *
+ * It allows user-space to perform a sequence of operations on per-cpu
+ * data with preemption disabled. Useful as single-stepping fall-back
+ * for restartable sequences, and for performing more complex operations
+ * on per-cpu data that would not be otherwise possible to do with
+ * restartable sequences.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2017, EfficiOS Inc.,
+ * Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/cpu_opv.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/pagemap.h>
+#include <linux/mm.h>
+#include <asm/ptrace.h>
+#include <asm/byteorder.h>
+#include <asm/cacheflush.h>
+
+#include "sched/sched.h"
+
+/*
+ * Typical invocation of cpu_opv need few virtual address pointers. Keep
+ * those in an array on the stack of the cpu_opv system call up to
+ * this limit, beyond which the array is dynamically allocated.
+ */
+#define NR_VADDR_ON_STACK		8
+
+/* Maximum pages per op. */
+#define CPU_OP_MAX_PAGES		4
+
+/* Maximum number of virtual addresses per op. */
+#define CPU_OP_VEC_MAX_ADDR		(2 * CPU_OP_VEC_LEN_MAX)
+
+union op_fn_data {
+	uint8_t _u8;
+	uint16_t _u16;
+	uint32_t _u32;
+	uint64_t _u64;
+#if (BITS_PER_LONG < 64)
+	uint32_t _u64_split[2];
+#endif
+};
+
+struct vaddr {
+	unsigned long mem;
+	unsigned long uaddr;
+	struct page *pages[2];
+	unsigned int nr_pages;
+	int write;
+};
+
+struct cpu_opv_vaddr {
+	struct vaddr *addr;
+	size_t nr_vaddr;
+	bool is_kmalloc;
+};
+
+typedef int (*op_fn_t)(union op_fn_data *data, uint64_t v, uint32_t len);
+
+/*
+ * Provide mutual exclution for threads executing a cpu_opv against an
+ * offline CPU.
+ */
+static DEFINE_MUTEX(cpu_opv_offline_lock);
+
+/*
+ * The cpu_opv system call executes a vector of operations on behalf of
+ * user-space on a specific CPU with preemption disabled. It is inspired
+ * by readv() and writev() system calls which take a "struct iovec"
+ * array as argument.
+ *
+ * The operations available are: comparison, memcpy, add, or, and, xor,
+ * left shift, right shift, and memory barrier. The system call receives
+ * a CPU number from user-space as argument, which is the CPU on which
+ * those operations need to be performed.  All pointers in the ops must
+ * have been set up to point to the per CPU memory of the CPU on which
+ * the operations should be executed. The "comparison" operation can be
+ * used to check that the data used in the preparation step did not
+ * change between preparation of system call inputs and operation
+ * execution within the preempt-off critical section.
+ *
+ * The reason why we require all pointer offsets to be calculated by
+ * user-space beforehand is because we need to use get_user_pages()
+ * to first pin all pages touched by each operation. This takes care of
+ * faulting-in the pages. Then, preemption is disabled, and the
+ * operations are performed atomically with respect to other thread
+ * execution on that CPU, without generating any page fault.
+ *
+ * An overall maximum of 4216 bytes in enforced on the sum of operation
+ * length within an operation vector, so user-space cannot generate a
+ * too long preempt-off critical section (cache cold critical section
+ * duration measured as 4.7µs on x86-64). Each operation is also limited
+ * a length of 4096 bytes, meaning that an operation can touch a
+ * maximum of 4 pages (memcpy: 2 pages for source, 2 pages for
+ * destination if addresses are not aligned on page boundaries).
+ *
+ * If the thread is not running on the requested CPU, it is migrated to
+ * it.
+ */
+
+static unsigned long cpu_op_range_nr_pages(unsigned long addr,
+					   unsigned long len)
+{
+	return ((addr + len - 1) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1;
+}
+
+static int cpu_op_count_pages(unsigned long addr, unsigned long len)
+{
+	unsigned long nr_pages;
+
+	if (!len)
+		return 0;
+	nr_pages = cpu_op_range_nr_pages(addr, len);
+	if (nr_pages > 2) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return nr_pages;
+}
+
+static struct vaddr *cpu_op_alloc_vaddr_vector(int nr_vaddr)
+{
+	return kzalloc(nr_vaddr * sizeof(struct vaddr), GFP_KERNEL);
+}
+
+/*
+ * Check operation types and length parameters. Count number of pages.
+ */
+static int cpu_opv_check_op(struct cpu_op *op, int *nr_vaddr, uint32_t *sum)
+{
+	int ret;
+
+	switch (op->op) {
+	case CPU_MB_OP:
+		break;
+	default:
+		*sum += op->len;
+	}
+
+	/* Validate inputs. */
+	switch (op->op) {
+	case CPU_COMPARE_EQ_OP:
+	case CPU_COMPARE_NE_OP:
+	case CPU_MEMCPY_OP:
+		if (op->len > CPU_OP_DATA_LEN_MAX)
+			return -EINVAL;
+		break;
+	case CPU_ADD_OP:
+	case CPU_OR_OP:
+	case CPU_AND_OP:
+	case CPU_XOR_OP:
+		switch (op->len) {
+		case 1:
+		case 2:
+		case 4:
+		case 8:
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case CPU_LSHIFT_OP:
+	case CPU_RSHIFT_OP:
+		switch (op->len) {
+		case 1:
+			if (op->u.shift_op.bits > 7)
+				return -EINVAL;
+			break;
+		case 2:
+			if (op->u.shift_op.bits > 15)
+				return -EINVAL;
+			break;
+		case 4:
+			if (op->u.shift_op.bits > 31)
+				return -EINVAL;
+			break;
+		case 8:
+			if (op->u.shift_op.bits > 63)
+				return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case CPU_MB_OP:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Count pages and virtual addresses. */
+	switch (op->op) {
+	case CPU_COMPARE_EQ_OP:
+	case CPU_COMPARE_NE_OP:
+		ret = cpu_op_count_pages(op->u.compare_op.a, op->len);
+		if (ret < 0)
+			return ret;
+		ret = cpu_op_count_pages(op->u.compare_op.b, op->len);
+		if (ret < 0)
+			return ret;
+		*nr_vaddr += 2;
+		break;
+	case CPU_MEMCPY_OP:
+		ret = cpu_op_count_pages(op->u.memcpy_op.dst, op->len);
+		if (ret < 0)
+			return ret;
+		ret = cpu_op_count_pages(op->u.memcpy_op.src, op->len);
+		if (ret < 0)
+			return ret;
+		*nr_vaddr += 2;
+		break;
+	case CPU_ADD_OP:
+		ret = cpu_op_count_pages(op->u.arithmetic_op.p, op->len);
+		if (ret < 0)
+			return ret;
+		(*nr_vaddr)++;
+		break;
+	case CPU_OR_OP:
+	case CPU_AND_OP:
+	case CPU_XOR_OP:
+		ret = cpu_op_count_pages(op->u.bitwise_op.p, op->len);
+		if (ret < 0)
+			return ret;
+		(*nr_vaddr)++;
+		break;
+	case CPU_LSHIFT_OP:
+	case CPU_RSHIFT_OP:
+		ret = cpu_op_count_pages(op->u.shift_op.p, op->len);
+		if (ret < 0)
+			return ret;
+		(*nr_vaddr)++;
+		break;
+	case CPU_MB_OP:
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Check operation types and length parameters. Count number of pages.
+ */
+static int cpu_opv_check(struct cpu_op *cpuopv, int cpuopcnt, int *nr_vaddr)
+{
+	uint32_t sum = 0;
+	int i, ret;
+
+	for (i = 0; i < cpuopcnt; i++) {
+		ret = cpu_opv_check_op(&cpuopv[i], nr_vaddr, &sum);
+		if (ret)
+			return ret;
+	}
+	if (sum > CPU_OP_VEC_DATA_LEN_MAX)
+		return -EINVAL;
+	return 0;
+}
+
+static int cpu_op_check_page(struct page *page, int write)
+{
+	struct address_space *mapping;
+
+	if (is_zone_device_page(page))
+		return -EFAULT;
+
+	/*
+	 * The page lock protects many things but in this context the page
+	 * lock stabilizes mapping, prevents inode freeing in the shared
+	 * file-backed region case and guards against movement to swap
+	 * cache.
+	 *
+	 * Strictly speaking the page lock is not needed in all cases being
+	 * considered here and page lock forces unnecessarily serialization
+	 * From this point on, mapping will be re-verified if necessary and
+	 * page lock will be acquired only if it is unavoidable
+	 *
+	 * Mapping checks require the head page for any compound page so the
+	 * head page and mapping is looked up now.
+	 */
+	page = compound_head(page);
+	mapping = READ_ONCE(page->mapping);
+
+	/*
+	 * If page->mapping is NULL, then it cannot be a PageAnon page;
+	 * but it might be the ZERO_PAGE (which is OK to read from), or
+	 * in the gate area or in a special mapping (for which this
+	 * check should fail); or it may have been a good file page when
+	 * get_user_pages found it, but truncated or holepunched or
+	 * subjected to invalidate_complete_page2 before the page lock
+	 * is acquired (also cases which should fail). Given that a
+	 * reference to the page is currently held, refcount care in
+	 * invalidate_complete_page's remove_mapping prevents
+	 * drop_caches from setting mapping to NULL concurrently.
+	 *
+	 * The case to guard against is when memory pressure cause
+	 * shmem_writepage to move the page from filecache to swapcache
+	 * concurrently: an unlikely race, but a retry for page->mapping
+	 * is required in that situation.
+	 */
+	if (!mapping) {
+		int shmem_swizzled;
+
+		/*
+		 * Check again with page lock held to guard against
+		 * memory pressure making shmem_writepage move the page
+		 * from filecache to swapcache.
+		 */
+		lock_page(page);
+		shmem_swizzled = PageSwapCache(page) || page->mapping;
+		unlock_page(page);
+		if (shmem_swizzled)
+			return -EAGAIN;
+		/*
+		 * It is valid to read from, but invalid to write to the
+		 * ZERO_PAGE.
+		 */
+		if (!(is_zero_pfn(page_to_pfn(page)) ||
+		      is_huge_zero_page(page)) || write)
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int cpu_op_check_pages(struct page **pages,
+			      unsigned long nr_pages,
+			      int write)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; i++) {
+		int ret;
+
+		ret = cpu_op_check_page(pages[i], write);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
+			    struct cpu_opv_vaddr *vaddr_ptrs,
+			    unsigned long *vaddr, int write)
+{
+	struct page *pages[2];
+	struct vm_area_struct *vmas[2];
+	int ret, nr_pages, nr_put_pages, n;
+	unsigned long _vaddr;
+	struct vaddr *va;
+	struct mm_struct *mm = current->mm;
+
+	nr_pages = cpu_op_count_pages(addr, len);
+	if (!nr_pages)
+		return 0;
+again:
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(addr, nr_pages, write ? FOLL_WRITE : 0, pages,
+			     vmas);
+	if (ret < nr_pages) {
+		if (ret >= 0) {
+			nr_put_pages = ret;
+			ret = -EFAULT;
+		} else {
+			nr_put_pages = 0;
+		}
+		up_read(&mm->mmap_sem);
+		goto error;
+	}
+	/*
+	 * cpu_opv() accesses its own cached mapping of the userspace pages.
+	 * Considering that concurrent noncached and cached accesses may yield
+	 * to unexpected results in terms of memory consistency, explicitly
+	 * disallow cpu_opv on noncached memory.
+	 */
+	for (n = 0; n < nr_pages; n++) {
+		if (is_vma_noncached(vmas[n])) {
+			nr_put_pages = nr_pages;
+			ret = -EFAULT;
+			up_read(&mm->mmap_sem);
+			goto error;
+		}
+	}
+	up_read(&mm->mmap_sem);
+	ret = cpu_op_check_pages(pages, nr_pages, write);
+	if (ret) {
+		nr_put_pages = nr_pages;
+		goto error;
+	}
+	_vaddr = (unsigned long)vm_map_user_ram(pages, nr_pages, addr,
+						numa_node_id(), PAGE_KERNEL);
+	if (!_vaddr) {
+		nr_put_pages = nr_pages;
+		ret = -ENOMEM;
+		goto error;
+	}
+	va = &vaddr_ptrs->addr[vaddr_ptrs->nr_vaddr++];
+	va->mem = _vaddr;
+	va->uaddr = addr;
+	for (n = 0; n < nr_pages; n++)
+		va->pages[n] = pages[n];
+	va->nr_pages = nr_pages;
+	va->write = write;
+	*vaddr = _vaddr + (addr & ~PAGE_MASK);
+	return 0;
+
+error:
+	for (n = 0; n < nr_put_pages; n++)
+		put_page(pages[n]);
+	/*
+	 * Retry if a page has been faulted in, or is being swapped in.
+	 */
+	if (ret == -EAGAIN)
+		goto again;
+	return ret;
+}
+
+static int cpu_opv_pin_pages_op(struct cpu_op *op,
+				struct cpu_opv_vaddr *vaddr_ptrs,
+				bool *expect_fault)
+{
+	int ret;
+	unsigned long vaddr = 0;
+
+	switch (op->op) {
+	case CPU_COMPARE_EQ_OP:
+	case CPU_COMPARE_NE_OP:
+		ret = -EFAULT;
+		*expect_fault = op->u.compare_op.expect_fault_a;
+		if (!access_ok(VERIFY_READ,
+			       (void __user *)op->u.compare_op.a,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.compare_op.a, op->len,
+				       vaddr_ptrs, &vaddr, 0);
+		if (ret)
+			return ret;
+		op->u.compare_op.a = vaddr;
+		ret = -EFAULT;
+		*expect_fault = op->u.compare_op.expect_fault_b;
+		if (!access_ok(VERIFY_READ,
+			       (void __user *)op->u.compare_op.b,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.compare_op.b, op->len,
+				       vaddr_ptrs, &vaddr, 0);
+		if (ret)
+			return ret;
+		op->u.compare_op.b = vaddr;
+		break;
+	case CPU_MEMCPY_OP:
+		ret = -EFAULT;
+		*expect_fault = op->u.memcpy_op.expect_fault_dst;
+		if (!access_ok(VERIFY_WRITE,
+			       (void __user *)op->u.memcpy_op.dst,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.memcpy_op.dst, op->len,
+				       vaddr_ptrs, &vaddr, 1);
+		if (ret)
+			return ret;
+		op->u.memcpy_op.dst = vaddr;
+		ret = -EFAULT;
+		*expect_fault = op->u.memcpy_op.expect_fault_src;
+		if (!access_ok(VERIFY_READ,
+			       (void __user *)op->u.memcpy_op.src,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.memcpy_op.src, op->len,
+				       vaddr_ptrs, &vaddr, 0);
+		if (ret)
+			return ret;
+		op->u.memcpy_op.src = vaddr;
+		break;
+	case CPU_ADD_OP:
+		ret = -EFAULT;
+		*expect_fault = op->u.arithmetic_op.expect_fault_p;
+		if (!access_ok(VERIFY_WRITE,
+			       (void __user *)op->u.arithmetic_op.p,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.arithmetic_op.p, op->len,
+				       vaddr_ptrs, &vaddr, 1);
+		if (ret)
+			return ret;
+		op->u.arithmetic_op.p = vaddr;
+		break;
+	case CPU_OR_OP:
+	case CPU_AND_OP:
+	case CPU_XOR_OP:
+		ret = -EFAULT;
+		*expect_fault = op->u.bitwise_op.expect_fault_p;
+		if (!access_ok(VERIFY_WRITE,
+			       (void __user *)op->u.bitwise_op.p,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.bitwise_op.p, op->len,
+				       vaddr_ptrs, &vaddr, 1);
+		if (ret)
+			return ret;
+		op->u.bitwise_op.p = vaddr;
+		break;
+	case CPU_LSHIFT_OP:
+	case CPU_RSHIFT_OP:
+		ret = -EFAULT;
+		*expect_fault = op->u.shift_op.expect_fault_p;
+		if (!access_ok(VERIFY_WRITE,
+			       (void __user *)op->u.shift_op.p,
+			       op->len))
+			return ret;
+		ret = cpu_op_pin_pages(op->u.shift_op.p, op->len,
+				       vaddr_ptrs, &vaddr, 1);
+		if (ret)
+			return ret;
+		op->u.shift_op.p = vaddr;
+		break;
+	case CPU_MB_OP:
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
+			     struct cpu_opv_vaddr *vaddr_ptrs)
+{
+	int ret, i;
+	bool expect_fault = false;
+
+	/* Check access, pin pages. */
+	for (i = 0; i < cpuopcnt; i++) {
+		ret = cpu_opv_pin_pages_op(&cpuop[i], vaddr_ptrs,
+					   &expect_fault);
+		if (ret)
+			goto error;
+	}
+	return 0;
+
+error:
+	/*
+	 * If faulting access is expected, return EAGAIN to user-space.
+	 * It allows user-space to distinguish between a fault caused by
+	 * an access which is expect to fault (e.g. due to concurrent
+	 * unmapping of underlying memory) from an unexpected fault from
+	 * which a retry would not recover.
+	 */
+	if (ret == -EFAULT && expect_fault)
+		return -EAGAIN;
+	return ret;
+}
+
+static int __op_get(union op_fn_data *data, void *p, size_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 = READ_ONCE(*(uint8_t *)p);
+		break;
+	case 2:
+		data->_u16 = READ_ONCE(*(uint16_t *)p);
+		break;
+	case 4:
+		data->_u32 = READ_ONCE(*(uint32_t *)p);
+		break;
+	case 8:
+#if (BITS_PER_LONG == 64)
+		data->_u64 = READ_ONCE(*(uint64_t *)p);
+#else
+	{
+		data->_u64_split[0] = READ_ONCE(*(uint32_t *)p);
+		data->_u64_split[1] = READ_ONCE(*((uint32_t *)p + 1));
+	}
+#endif
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int __op_put(union op_fn_data *data, void *p, size_t len)
+{
+	switch (len) {
+	case 1:
+		WRITE_ONCE(*(uint8_t *)p, data->_u8);
+		break;
+	case 2:
+		WRITE_ONCE(*(uint16_t *)p, data->_u16);
+		break;
+	case 4:
+		WRITE_ONCE(*(uint32_t *)p, data->_u32);
+		break;
+	case 8:
+#if (BITS_PER_LONG == 64)
+		WRITE_ONCE(*(uint64_t *)p, data->_u64);
+#else
+	{
+		WRITE_ONCE(*(uint32_t *)p, data->_u64_split[0]);
+		WRITE_ONCE(*((uint32_t *)p + 1), data->_u64_split[1]);
+	}
+#endif
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Return 0 if same, > 0 if different, < 0 on error. */
+static int do_cpu_op_compare(unsigned long _a, unsigned long _b, uint32_t len)
+{
+	void *a = (void *)_a;
+	void *b = (void *)_b;
+	union op_fn_data tmp[2];
+	int ret;
+
+	switch (len) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		if (!IS_ALIGNED(_a, len) || !IS_ALIGNED(_b, len))
+			goto memcmp;
+		break;
+	default:
+		goto memcmp;
+	}
+
+	ret = __op_get(&tmp[0], a, len);
+	if (ret)
+		return ret;
+	ret = __op_get(&tmp[1], b, len);
+	if (ret)
+		return ret;
+
+	switch (len) {
+	case 1:
+		ret = !!(tmp[0]._u8 != tmp[1]._u8);
+		break;
+	case 2:
+		ret = !!(tmp[0]._u16 != tmp[1]._u16);
+		break;
+	case 4:
+		ret = !!(tmp[0]._u32 != tmp[1]._u32);
+		break;
+	case 8:
+		ret = !!(tmp[0]._u64 != tmp[1]._u64);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return ret;
+
+memcmp:
+	if (memcmp(a, b, len))
+		return 1;
+	return 0;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_memcpy(unsigned long _dst, unsigned long _src,
+			    uint32_t len)
+{
+	void *dst = (void *)_dst;
+	void *src = (void *)_src;
+	union op_fn_data tmp;
+	int ret;
+
+	switch (len) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		if (!IS_ALIGNED(_dst, len) || !IS_ALIGNED(_src, len))
+			goto memcpy;
+		break;
+	default:
+		goto memcpy;
+	}
+
+	ret = __op_get(&tmp, src, len);
+	if (ret)
+		return ret;
+	return __op_put(&tmp, dst, len);
+
+memcpy:
+	memcpy(dst, src, len);
+	return 0;
+}
+
+static int op_add_fn(union op_fn_data *data, uint64_t count, uint32_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 += (uint8_t)count;
+		break;
+	case 2:
+		data->_u16 += (uint16_t)count;
+		break;
+	case 4:
+		data->_u32 += (uint32_t)count;
+		break;
+	case 8:
+		data->_u64 += (uint64_t)count;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int op_or_fn(union op_fn_data *data, uint64_t mask, uint32_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 |= (uint8_t)mask;
+		break;
+	case 2:
+		data->_u16 |= (uint16_t)mask;
+		break;
+	case 4:
+		data->_u32 |= (uint32_t)mask;
+		break;
+	case 8:
+		data->_u64 |= (uint64_t)mask;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int op_and_fn(union op_fn_data *data, uint64_t mask, uint32_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 &= (uint8_t)mask;
+		break;
+	case 2:
+		data->_u16 &= (uint16_t)mask;
+		break;
+	case 4:
+		data->_u32 &= (uint32_t)mask;
+		break;
+	case 8:
+		data->_u64 &= (uint64_t)mask;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int op_xor_fn(union op_fn_data *data, uint64_t mask, uint32_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 ^= (uint8_t)mask;
+		break;
+	case 2:
+		data->_u16 ^= (uint16_t)mask;
+		break;
+	case 4:
+		data->_u32 ^= (uint32_t)mask;
+		break;
+	case 8:
+		data->_u64 ^= (uint64_t)mask;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int op_lshift_fn(union op_fn_data *data, uint64_t bits, uint32_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 <<= (uint8_t)bits;
+		break;
+	case 2:
+		data->_u16 <<= (uint16_t)bits;
+		break;
+	case 4:
+		data->_u32 <<= (uint32_t)bits;
+		break;
+	case 8:
+		data->_u64 <<= (uint64_t)bits;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int op_rshift_fn(union op_fn_data *data, uint64_t bits, uint32_t len)
+{
+	switch (len) {
+	case 1:
+		data->_u8 >>= (uint8_t)bits;
+		break;
+	case 2:
+		data->_u16 >>= (uint16_t)bits;
+		break;
+	case 4:
+		data->_u32 >>= (uint32_t)bits;
+		break;
+	case 8:
+		data->_u64 >>= (uint64_t)bits;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Return 0 on success, < 0 on error. */
+static int do_cpu_op_fn(op_fn_t op_fn, unsigned long _p, uint64_t v,
+			uint32_t len)
+{
+	union op_fn_data tmp;
+	void *p = (void *)_p;
+	int ret;
+
+	ret = __op_get(&tmp, p, len);
+	if (ret)
+		return ret;
+	ret = op_fn(&tmp, v, len);
+	if (ret)
+		return ret;
+	ret = __op_put(&tmp, p, len);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+/*
+ * Return negative value on error, positive value if comparison
+ * fails, 0 on success.
+ */
+static int __do_cpu_opv_op(struct cpu_op *op)
+{
+	/* Guarantee a compiler barrier between each operation. */
+	barrier();
+
+	switch (op->op) {
+	case CPU_COMPARE_EQ_OP:
+		return do_cpu_op_compare(op->u.compare_op.a,
+					 op->u.compare_op.b,
+					 op->len);
+	case CPU_COMPARE_NE_OP:
+	{
+		int ret;
+
+		ret = do_cpu_op_compare(op->u.compare_op.a,
+					op->u.compare_op.b,
+					op->len);
+		if (ret < 0)
+			return ret;
+		/*
+		 * Stop execution, return positive value if comparison
+		 * is identical.
+		 */
+		if (ret == 0)
+			return 1;
+		return 0;
+	}
+	case CPU_MEMCPY_OP:
+		return do_cpu_op_memcpy(op->u.memcpy_op.dst,
+					op->u.memcpy_op.src,
+					op->len);
+	case CPU_ADD_OP:
+		return do_cpu_op_fn(op_add_fn, op->u.arithmetic_op.p,
+				    op->u.arithmetic_op.count, op->len);
+	case CPU_OR_OP:
+		return do_cpu_op_fn(op_or_fn, op->u.bitwise_op.p,
+				    op->u.bitwise_op.mask, op->len);
+	case CPU_AND_OP:
+		return do_cpu_op_fn(op_and_fn, op->u.bitwise_op.p,
+				    op->u.bitwise_op.mask, op->len);
+	case CPU_XOR_OP:
+		return do_cpu_op_fn(op_xor_fn, op->u.bitwise_op.p,
+				    op->u.bitwise_op.mask, op->len);
+	case CPU_LSHIFT_OP:
+		return do_cpu_op_fn(op_lshift_fn, op->u.shift_op.p,
+				    op->u.shift_op.bits, op->len);
+	case CPU_RSHIFT_OP:
+		return do_cpu_op_fn(op_rshift_fn, op->u.shift_op.p,
+				    op->u.shift_op.bits, op->len);
+	case CPU_MB_OP:
+		/* Memory barrier provided by this operation. */
+		smp_mb();
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int __do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt)
+{
+	int i, ret;
+
+	for (i = 0; i < cpuopcnt; i++) {
+		ret = __do_cpu_opv_op(&cpuop[i]);
+		/* If comparison fails, stop execution and return index + 1. */
+		if (ret > 0)
+			return i + 1;
+		/* On error, stop execution. */
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * Check that the page pointers pinned by get_user_pages()
+ * are still in the page table. Invoked with mmap_sem held.
+ * Return 0 if pointers match, -EAGAIN if they don't.
+ */
+static int vaddr_check(struct vaddr *vaddr)
+{
+	struct page *pages[2];
+	int ret, n;
+
+	ret = __get_user_pages_fast(vaddr->uaddr, vaddr->nr_pages,
+				    vaddr->write, pages);
+	for (n = 0; n < ret; n++)
+		put_page(pages[n]);
+	if (ret < vaddr->nr_pages) {
+		ret = get_user_pages(vaddr->uaddr, vaddr->nr_pages,
+				     vaddr->write ? FOLL_WRITE : 0,
+				     pages, NULL);
+		if (ret < 0)
+			return -EAGAIN;
+		for (n = 0; n < ret; n++)
+			put_page(pages[n]);
+		if (ret < vaddr->nr_pages)
+			return -EAGAIN;
+	}
+	for (n = 0; n < vaddr->nr_pages; n++) {
+		if (pages[n] != vaddr->pages[n])
+			return -EAGAIN;
+	}
+	return 0;
+}
+
+static int vaddr_ptrs_check(struct cpu_opv_vaddr *vaddr_ptrs)
+{
+	int i;
+
+	for (i = 0; i < vaddr_ptrs->nr_vaddr; i++) {
+		int ret;
+
+		ret = vaddr_check(&vaddr_ptrs->addr[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt,
+		      struct cpu_opv_vaddr *vaddr_ptrs, int cpu)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+retry:
+	if (cpu != raw_smp_processor_id()) {
+		ret = push_task_to_cpu(current, cpu);
+		if (ret)
+			goto check_online;
+	}
+	down_read(&mm->mmap_sem);
+	ret = vaddr_ptrs_check(vaddr_ptrs);
+	if (ret)
+		goto end;
+	preempt_disable();
+	if (cpu != smp_processor_id()) {
+		preempt_enable();
+		up_read(&mm->mmap_sem);
+		goto retry;
+	}
+	ret = __do_cpu_opv(cpuop, cpuopcnt);
+	preempt_enable();
+end:
+	up_read(&mm->mmap_sem);
+	return ret;
+
+check_online:
+	/*
+	 * push_task_to_cpu() returns -EINVAL if the requested cpu is not part
+	 * of the current thread's cpus_allowed mask.
+	 */
+	if (ret == -EINVAL)
+		return ret;
+	get_online_cpus();
+	if (cpu_online(cpu)) {
+		put_online_cpus();
+		goto retry;
+	}
+	/*
+	 * CPU is offline. Perform operation from the current CPU with
+	 * cpu_online read lock held, preventing that CPU from coming online,
+	 * and with mutex held, providing mutual exclusion against other
+	 * CPUs also finding out about an offline CPU.
+	 */
+	down_read(&mm->mmap_sem);
+	ret = vaddr_ptrs_check(vaddr_ptrs);
+	if (ret)
+		goto offline_end;
+	mutex_lock(&cpu_opv_offline_lock);
+	ret = __do_cpu_opv(cpuop, cpuopcnt);
+	mutex_unlock(&cpu_opv_offline_lock);
+offline_end:
+	up_read(&mm->mmap_sem);
+	put_online_cpus();
+	return ret;
+}
+
+/*
+ * cpu_opv - execute operation vector on a given CPU with preempt off.
+ *
+ * Userspace should pass current CPU number as parameter.
+ */
+SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
+		int, cpu, int, flags)
+{
+	struct vaddr vaddr_on_stack[NR_VADDR_ON_STACK];
+	struct cpu_op cpuopv[CPU_OP_VEC_LEN_MAX];
+	struct cpu_opv_vaddr vaddr_ptrs = {
+		.addr = vaddr_on_stack,
+		.nr_vaddr = 0,
+		.is_kmalloc = false,
+	};
+	int ret, i, nr_vaddr = 0;
+	bool retry = false;
+
+	if (unlikely(flags & ~CPU_OP_NR_FLAG))
+		return -EINVAL;
+	if (flags & CPU_OP_NR_FLAG)
+		return NR_CPU_OPS;
+	if (unlikely(cpu < 0))
+		return -EINVAL;
+	if (cpuopcnt < 0 || cpuopcnt > CPU_OP_VEC_LEN_MAX)
+		return -EINVAL;
+	if (copy_from_user(cpuopv, ucpuopv, cpuopcnt * sizeof(struct cpu_op)))
+		return -EFAULT;
+	ret = cpu_opv_check(cpuopv, cpuopcnt, &nr_vaddr);
+	if (ret)
+		return ret;
+	if (nr_vaddr > NR_VADDR_ON_STACK) {
+		vaddr_ptrs.addr = cpu_op_alloc_vaddr_vector(nr_vaddr);
+		if (!vaddr_ptrs.addr) {
+			ret = -ENOMEM;
+			goto end;
+		}
+		vaddr_ptrs.is_kmalloc = true;
+	}
+again:
+	ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &vaddr_ptrs);
+	if (ret)
+		goto end;
+	ret = do_cpu_opv(cpuopv, cpuopcnt, &vaddr_ptrs, cpu);
+	if (ret == -EAGAIN)
+		retry = true;
+end:
+	for (i = 0; i < vaddr_ptrs.nr_vaddr; i++) {
+		struct vaddr *vaddr = &vaddr_ptrs.addr[i];
+		int j;
+
+		vm_unmap_user_ram((void *)vaddr->mem, vaddr->nr_pages);
+		for (j = 0; j < vaddr->nr_pages; j++) {
+			if (vaddr->write)
+				set_page_dirty(vaddr->pages[j]);
+			put_page(vaddr->pages[j]);
+		}
+	}
+	/*
+	 * Force vm_map flush to ensure we don't exhaust available vmalloc
+	 * address space.
+	 */
+	if (vaddr_ptrs.nr_vaddr)
+		vm_unmap_aliases();
+	if (retry) {
+		retry = false;
+		vaddr_ptrs.nr_vaddr = 0;
+		goto again;
+	}
+	if (vaddr_ptrs.is_kmalloc)
+		kfree(vaddr_ptrs.addr);
+	return ret;
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bfa1ee1bf669..59e622296dc3 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -262,3 +262,4 @@ cond_syscall(sys_pkey_free);
 
 /* restartable sequence */
 cond_syscall(sys_rseq);
+cond_syscall(sys_cpu_opv);
-- 
2.11.0
