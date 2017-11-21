From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Tue, 21 Nov 2017 11:25:58 +0000 (UTC)
Message-ID: <1830717892.19023.1511263558845.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <1766414702.18278.1511194398489.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711201831490.1734@nanos> <204285712.18480.1511203151076.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711202037280.2348@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711202037280.2348@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

----- On Nov 20, 2017, at 2:44 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Mon, 20 Nov 2017, Mathieu Desnoyers wrote:
>> ----- On Nov 20, 2017, at 12:48 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
>> The use-case for 4k memcpy operation is a per-cpu ring buffer where
>> the rseq fast-path does the following:
>> 
>> - ring buffer push: in the rseq asm instruction sequence, a memcpy of a
>>   given structure (limited to 4k in size) into a ring buffer,
>>   followed by the final commit instruction which increments the current
>>   position offset by the number of bytes pushed.
>> 
>> - ring buffer pop: in the rseq asm instruction sequence, a memcpy of
>>   a given structure (up to 4k) from the ring buffer, at "position" offset.
>>   The final commit instruction decrements the current position offset by
>>   the number of bytes pop'd.
>> 
>> Having cpu_opv do a 4k memcpy allow it to handle scenarios where
>> rseq fails to progress.
> 
> I'm still confused. Before you talked about the sequence:
> 
>    1) Reserve
> 
>    2) Commit
> 
> and both use rseq, but obviously you cannot do two "atomic" operation in
> one section.
> 
> So now you talk about push. Is that what you described earlier as commit?
> 
> Assumed that it is, I still have no idea why the memcpy needs to happen in
> that preempt disabled region.
> 
> If you have space reserved, then the copy does not have any dependencies
> neither on the cpu it runs on nor on anything else. So the only
> interresting operation is the final commit instruction which tells the
> consumer that its ready.
> 
> So what is the part I am missing here aside of having difficulties to map
> the constantly changing names of this stuff?

Let's clear up some confusion: those are two different use-cases. The
ring buffer with reserve+commit is a FIFO ring buffer, and the ring buffer
with memcpy+position update is a LIFO queue.

Let me explain the various use-cases here, so we know what we're talking
about.

rseq and cpu_opv use-cases

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

Thanks,

Mathieu


> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
