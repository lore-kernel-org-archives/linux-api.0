From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Wed, 15 Nov 2017 14:30:47 +0000 (UTC)
Message-ID: <944566814.15745.1510756247179.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <CAKgNAkjrh_OMi+7EUJxqM0-84WUxL0d_vse4neOL93EB-sGKXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjrh_OMi+7EUJxqM0-84WUxL0d_vse4neOL93EB-sGKXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Nov 15, 2017, at 2:44 AM, Michael Kerrisk mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> Hi Matthieu
> 
> On 14 November 2017 at 21:03, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> This new cpu_opv system call executes a vector of operations on behalf
>> of user-space on a specific CPU with preemption disabled. It is inspired
>> from readv() and writev() system calls which take a "struct iovec" array
>> as argument.
> 
> Do you have a man page for this syscall already?

Hi Michael,

It's the next thing on my roadmap when the syscall reaches mainline.
That and membarrier commands man pages updates.

Thanks,

Mathieu

> 
> Thanks,
> 
> Michael
> 
> 
>> The operations available are: comparison, memcpy, add, or, and, xor,
>> left shift, right shift, and mb. The system call receives a CPU number
>> from user-space as argument, which is the CPU on which those operations
>> need to be performed. All preparation steps such as loading pointers,
>> and applying offsets to arrays, need to be performed by user-space
>> before invoking the system call. The "comparison" operation can be used
>> to check that the data used in the preparation step did not change
>> between preparation of system call inputs and operation execution within
>> the preempt-off critical section.
>>
>> The reason why we require all pointer offsets to be calculated by
>> user-space beforehand is because we need to use get_user_pages_fast() to
>> first pin all pages touched by each operation. This takes care of
>> faulting-in the pages. Then, preemption is disabled, and the operations
>> are performed atomically with respect to other thread execution on that
>> CPU, without generating any page fault.
>>
>> A maximum limit of 16 operations per cpu_opv syscall invocation is
>> enforced, so user-space cannot generate a too long preempt-off critical
>> section. Each operation is also limited a length of PAGE_SIZE bytes,
>> meaning that an operation can touch a maximum of 4 pages (memcpy: 2
>> pages for source, 2 pages for destination if addresses are not aligned
>> on page boundaries). Moreover, a total limit of 4216 bytes is applied
>> to operation lengths.
>>
>> If the thread is not running on the requested CPU, a new
>> push_task_to_cpu() is invoked to migrate the task to the requested CPU.
>> If the requested CPU is not part of the cpus allowed mask of the thread,
>> the system call fails with EINVAL. After the migration has been
>> performed, preemption is disabled, and the current CPU number is checked
>> again and compared to the requested CPU number. If it still differs, it
>> means the scheduler migrated us away from that CPU. Return EAGAIN to
>> user-space in that case, and let user-space retry (either requesting the
>> same CPU number, or a different one, depending on the user-space
>> algorithm constraints).
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
>> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
>> CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
>> CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
>> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>> CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
>> CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>> CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>
>> Changes since v1:
>> - handle CPU hotplug,
>> - cleanup implementation using function pointers: We can use function
>>   pointers to implement the operations rather than duplicating all the
>>   user-access code.
>> - refuse device pages: Performing cpu_opv operations on io map'd pages
>>   with preemption disabled could generate long preempt-off critical
>>   sections, which leads to unwanted scheduler latency. Return EFAULT if
>>   a device page is received as parameter
>> - restrict op vector to 4216 bytes length sum: Restrict the operation
>>   vector to length sum of:
>>   - 4096 bytes (typical page size on most architectures, should be
>>     enough for a string, or structures)
>>   - 15 * 8 bytes (typical operations on integers or pointers).
>>   The goal here is to keep the duration of preempt off critical section
>>   short, so we don't add significant scheduler latency.
>> - Add INIT_ONSTACK macro: Introduce the
>>   CPU_OP_FIELD_u32_u64_INIT_ONSTACK() macros to ensure that users
>>   correctly initialize the upper bits of CPU_OP_FIELD_u32_u64() on their
>>   stack to 0 on 32-bit architectures.
>> - Add CPU_MB_OP operation:
>>   Use-cases with:
>>   - two consecutive stores,
>>   - a mempcy followed by a store,
>>   require a memory barrier before the final store operation. A typical
>>   use-case is a store-release on the final store. Given that this is a
>>   slow path, just providing an explicit full barrier instruction should
>>   be sufficient.
>> - Add expect fault field:
>>   The use-case of list_pop brings interesting challenges. With rseq, we
>>   can use rseq_cmpnev_storeoffp_load(), and therefore load a pointer,
>>   compare it against NULL, add an offset, and load the target "next"
>>   pointer from the object, all within a single req critical section.
>>
>>   Life is not so easy for cpu_opv in this use-case, mainly because we
>>   need to pin all pages we are going to touch in the preempt-off
>>   critical section beforehand. So we need to know the target object (in
>>   which we apply an offset to fetch the next pointer) when we pin pages
>>   before disabling preemption.
>>
>>   So the approach is to load the head pointer and compare it against
>>   NULL in user-space, before doing the cpu_opv syscall. User-space can
>>   then compute the address of the head->next field, *without loading it*.
>>
>>   The cpu_opv system call will first need to pin all pages associated
>>   with input data. This includes the page backing the head->next object,
>>   which may have been concurrently deallocated and unmapped. Therefore,
>>   in this case, getting -EFAULT when trying to pin those pages may
>>   happen: it just means they have been concurrently unmapped. This is
>>   an expected situation, and should just return -EAGAIN to user-space,
>>   to user-space can distinguish between "should retry" type of
>>   situations and actual errors that should be handled with extreme
>>   prejudice to the program (e.g. abort()).
>>
>>   Therefore, add "expect_fault" fields along with op input address
>>   pointers, so user-space can identify whether a fault when getting a
>>   field should return EAGAIN rather than EFAULT.
>> - Add compiler barrier between operations: Adding a compiler barrier
>>   between store operations in a cpu_opv sequence can be useful when
>>   paired with membarrier system call.
>>
>>   An algorithm with a paired slow path and fast path can use
>>   sys_membarrier on the slow path to replace fast-path memory barriers
>>   by compiler barrier.
>>
>>   Adding an explicit compiler barrier between operations allows
>>   cpu_opv to be used as fallback for operations meant to match
>>   the membarrier system call.
>>
>> Changes since v2:
>>
>> - Fix memory leak by introducing struct cpu_opv_pinned_pages.
>>   Suggested by Boqun Feng.
>> - Cast argument 1 passed to access_ok from integer to void __user *,
>>   fixing sparse warning.
>> ---
>>  MAINTAINERS                  |   7 +
>>  include/uapi/linux/cpu_opv.h | 117 ++++++
>>  init/Kconfig                 |  14 +
>>  kernel/Makefile              |   1 +
>>  kernel/cpu_opv.c             | 968 +++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sched/core.c          |  37 ++
>>  kernel/sched/sched.h         |   2 +
>>  kernel/sys_ni.c              |   1 +
>>  8 files changed, 1147 insertions(+)
>>  create mode 100644 include/uapi/linux/cpu_opv.h
>>  create mode 100644 kernel/cpu_opv.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index c9f95f8b07ed..45a1bbdaa287 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3675,6 +3675,13 @@ B:       https://bugzilla.kernel.org
>>  F:     drivers/cpuidle/*
>>  F:     include/linux/cpuidle.h
>>
>> +CPU NON-PREEMPTIBLE OPERATION VECTOR SUPPORT
>> +M:     Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> +L:     linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> +S:     Supported
>> +F:     kernel/cpu_opv.c
>> +F:     include/uapi/linux/cpu_opv.h
>> +
>>  CRAMFS FILESYSTEM
>>  W:     http://sourceforge.net/projects/cramfs/
>>  S:     Orphan / Obsolete
>> diff --git a/include/uapi/linux/cpu_opv.h b/include/uapi/linux/cpu_opv.h
>> new file mode 100644
>> index 000000000000..17f7d46e053b
>> --- /dev/null
>> +++ b/include/uapi/linux/cpu_opv.h
>> @@ -0,0 +1,117 @@
>> +#ifndef _UAPI_LINUX_CPU_OPV_H
>> +#define _UAPI_LINUX_CPU_OPV_H
>> +
>> +/*
>> + * linux/cpu_opv.h
>> + *
>> + * CPU preempt-off operation vector system call API
>> + *
>> + * Copyright (c) 2017 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a copy
>> + * of this software and associated documentation files (the "Software"), to
>> deal
>> + * in the Software without restriction, including without limitation the rights
>> + * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>> + * copies of the Software, and to permit persons to whom the Software is
>> + * furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>> FROM,
>> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>> THE
>> + * SOFTWARE.
>> + */
>> +
>> +#ifdef __KERNEL__
>> +# include <linux/types.h>
>> +#else  /* #ifdef __KERNEL__ */
>> +# include <stdint.h>
>> +#endif /* #else #ifdef __KERNEL__ */
>> +
>> +#include <asm/byteorder.h>
>> +
>> +#ifdef __LP64__
>> +# define CPU_OP_FIELD_u32_u64(field)                   uint64_t field
>> +# define CPU_OP_FIELD_u32_u64_INIT_ONSTACK(field, v)   field = (intptr_t)v
>> +#elif defined(__BYTE_ORDER) ? \
>> +       __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
>> +# define CPU_OP_FIELD_u32_u64(field)   uint32_t field ## _padding, field
>> +# define CPU_OP_FIELD_u32_u64_INIT_ONSTACK(field, v)   \
>> +       field ## _padding = 0, field = (intptr_t)v
>> +#else
>> +# define CPU_OP_FIELD_u32_u64(field)   uint32_t field, field ## _padding
>> +# define CPU_OP_FIELD_u32_u64_INIT_ONSTACK(field, v)   \
>> +       field = (intptr_t)v, field ## _padding = 0
>> +#endif
>> +
>> +#define CPU_OP_VEC_LEN_MAX             16
>> +#define CPU_OP_ARG_LEN_MAX             24
>> +/* Max. data len per operation. */
>> +#define CPU_OP_DATA_LEN_MAX            PAGE_SIZE
>> +/*
>> + * Max. data len for overall vector. We to restrict the amount of
>> + * user-space data touched by the kernel in non-preemptible context so
>> + * we do not introduce long scheduler latencies.
>> + * This allows one copy of up to 4096 bytes, and 15 operations touching
>> + * 8 bytes each.
>> + * This limit is applied to the sum of length specified for all
>> + * operations in a vector.
>> + */
>> +#define CPU_OP_VEC_DATA_LEN_MAX                (4096 + 15*8)
>> +#define CPU_OP_MAX_PAGES               4       /* Max. pages per op. */
>> +
>> +enum cpu_op_type {
>> +       CPU_COMPARE_EQ_OP,      /* compare */
>> +       CPU_COMPARE_NE_OP,      /* compare */
>> +       CPU_MEMCPY_OP,          /* memcpy */
>> +       CPU_ADD_OP,             /* arithmetic */
>> +       CPU_OR_OP,              /* bitwise */
>> +       CPU_AND_OP,             /* bitwise */
>> +       CPU_XOR_OP,             /* bitwise */
>> +       CPU_LSHIFT_OP,          /* shift */
>> +       CPU_RSHIFT_OP,          /* shift */
>> +       CPU_MB_OP,              /* memory barrier */
>> +};
>> +
>> +/* Vector of operations to perform. Limited to 16. */
>> +struct cpu_op {
>> +       int32_t op;     /* enum cpu_op_type. */
>> +       uint32_t len;   /* data length, in bytes. */
>> +       union {
>> +               struct {
>> +                       CPU_OP_FIELD_u32_u64(a);
>> +                       CPU_OP_FIELD_u32_u64(b);
>> +                       uint8_t expect_fault_a;
>> +                       uint8_t expect_fault_b;
>> +               } compare_op;
>> +               struct {
>> +                       CPU_OP_FIELD_u32_u64(dst);
>> +                       CPU_OP_FIELD_u32_u64(src);
>> +                       uint8_t expect_fault_dst;
>> +                       uint8_t expect_fault_src;
>> +               } memcpy_op;
>> +               struct {
>> +                       CPU_OP_FIELD_u32_u64(p);
>> +                       int64_t count;
>> +                       uint8_t expect_fault_p;
>> +               } arithmetic_op;
>> +               struct {
>> +                       CPU_OP_FIELD_u32_u64(p);
>> +                       uint64_t mask;
>> +                       uint8_t expect_fault_p;
>> +               } bitwise_op;
>> +               struct {
>> +                       CPU_OP_FIELD_u32_u64(p);
>> +                       uint32_t bits;
>> +                       uint8_t expect_fault_p;
>> +               } shift_op;
>> +               char __padding[CPU_OP_ARG_LEN_MAX];
>> +       } u;
>> +};
>> +
>> +#endif /* _UAPI_LINUX_CPU_OPV_H */
>> diff --git a/init/Kconfig b/init/Kconfig
>> index cbedfb91b40a..e4fbb5dd6a24 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1404,6 +1404,7 @@ config RSEQ
>>         bool "Enable rseq() system call" if EXPERT
>>         default y
>>         depends on HAVE_RSEQ
>> +       select CPU_OPV
>>         select MEMBARRIER
>>         help
>>           Enable the restartable sequences system call. It provides a
>> @@ -1414,6 +1415,19 @@ config RSEQ
>>
>>           If unsure, say Y.
>>
>> +config CPU_OPV
>> +       bool "Enable cpu_opv() system call" if EXPERT
>> +       default y
>> +       help
>> +         Enable the CPU preempt-off operation vector system call.
>> +         It allows user-space to perform a sequence of operations on
>> +         per-cpu data with preemption disabled. Useful as
>> +         single-stepping fall-back for restartable sequences, and for
>> +         performing more complex operations on per-cpu data that would
>> +         not be otherwise possible to do with restartable sequences.
>> +
>> +         If unsure, say Y.
>> +
>>  config EMBEDDED
>>         bool "Embedded system"
>>         option allnoconfig_y
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 3574669dafd9..cac8855196ff 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -113,6 +113,7 @@ obj-$(CONFIG_TORTURE_TEST) += torture.o
>>
>>  obj-$(CONFIG_HAS_IOMEM) += memremap.o
>>  obj-$(CONFIG_RSEQ) += rseq.o
>> +obj-$(CONFIG_CPU_OPV) += cpu_opv.o
>>
>>  $(obj)/configs.o: $(obj)/config_data.h
>>
>> diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
>> new file mode 100644
>> index 000000000000..a81837a14b17
>> --- /dev/null
>> +++ b/kernel/cpu_opv.c
>> @@ -0,0 +1,968 @@
>> +/*
>> + * CPU preempt-off operation vector system call
>> + *
>> + * It allows user-space to perform a sequence of operations on per-cpu
>> + * data with preemption disabled. Useful as single-stepping fall-back
>> + * for restartable sequences, and for performing more complex operations
>> + * on per-cpu data that would not be otherwise possible to do with
>> + * restartable sequences.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * Copyright (C) 2017, EfficiOS Inc.,
>> + * Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> + */
>> +
>> +#include <linux/sched.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/syscalls.h>
>> +#include <linux/cpu_opv.h>
>> +#include <linux/types.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pagemap.h>
>> +#include <asm/ptrace.h>
>> +#include <asm/byteorder.h>
>> +
>> +#include "sched/sched.h"
>> +
>> +#define TMP_BUFLEN                     64
>> +#define NR_PINNED_PAGES_ON_STACK       8
>> +
>> +union op_fn_data {
>> +       uint8_t _u8;
>> +       uint16_t _u16;
>> +       uint32_t _u32;
>> +       uint64_t _u64;
>> +#if (BITS_PER_LONG < 64)
>> +       uint32_t _u64_split[2];
>> +#endif
>> +};
>> +
>> +struct cpu_opv_pinned_pages {
>> +       struct page **pages;
>> +       size_t nr;
>> +       bool is_kmalloc;
>> +};
>> +
>> +typedef int (*op_fn_t)(union op_fn_data *data, uint64_t v, uint32_t len);
>> +
>> +static DEFINE_MUTEX(cpu_opv_offline_lock);
>> +
>> +/*
>> + * The cpu_opv system call executes a vector of operations on behalf of
>> + * user-space on a specific CPU with preemption disabled. It is inspired
>> + * from readv() and writev() system calls which take a "struct iovec"
>> + * array as argument.
>> + *
>> + * The operations available are: comparison, memcpy, add, or, and, xor,
>> + * left shift, and right shift. The system call receives a CPU number
>> + * from user-space as argument, which is the CPU on which those
>> + * operations need to be performed. All preparation steps such as
>> + * loading pointers, and applying offsets to arrays, need to be
>> + * performed by user-space before invoking the system call. The
>> + * "comparison" operation can be used to check that the data used in the
>> + * preparation step did not change between preparation of system call
>> + * inputs and operation execution within the preempt-off critical
>> + * section.
>> + *
>> + * The reason why we require all pointer offsets to be calculated by
>> + * user-space beforehand is because we need to use get_user_pages_fast()
>> + * to first pin all pages touched by each operation. This takes care of
>> + * faulting-in the pages. Then, preemption is disabled, and the
>> + * operations are performed atomically with respect to other thread
>> + * execution on that CPU, without generating any page fault.
>> + *
>> + * A maximum limit of 16 operations per cpu_opv syscall invocation is
>> + * enforced, and a overall maximum length sum, so user-space cannot
>> + * generate a too long preempt-off critical section. Each operation is
>> + * also limited a length of PAGE_SIZE bytes, meaning that an operation
>> + * can touch a maximum of 4 pages (memcpy: 2 pages for source, 2 pages
>> + * for destination if addresses are not aligned on page boundaries).
>> + *
>> + * If the thread is not running on the requested CPU, a new
>> + * push_task_to_cpu() is invoked to migrate the task to the requested
>> + * CPU.  If the requested CPU is not part of the cpus allowed mask of
>> + * the thread, the system call fails with EINVAL. After the migration
>> + * has been performed, preemption is disabled, and the current CPU
>> + * number is checked again and compared to the requested CPU number. If
>> + * it still differs, it means the scheduler migrated us away from that
>> + * CPU. Return EAGAIN to user-space in that case, and let user-space
>> + * retry (either requesting the same CPU number, or a different one,
>> + * depending on the user-space algorithm constraints).
>> + */
>> +
>> +/*
>> + * Check operation types and length parameters.
>> + */
>> +static int cpu_opv_check(struct cpu_op *cpuop, int cpuopcnt)
>> +{
>> +       int i;
>> +       uint32_t sum = 0;
>> +
>> +       for (i = 0; i < cpuopcnt; i++) {
>> +               struct cpu_op *op = &cpuop[i];
>> +
>> +               switch (op->op) {
>> +               case CPU_MB_OP:
>> +                       break;
>> +               default:
>> +                       sum += op->len;
>> +               }
>> +               switch (op->op) {
>> +               case CPU_COMPARE_EQ_OP:
>> +               case CPU_COMPARE_NE_OP:
>> +               case CPU_MEMCPY_OP:
>> +                       if (op->len > CPU_OP_DATA_LEN_MAX)
>> +                               return -EINVAL;
>> +                       break;
>> +               case CPU_ADD_OP:
>> +               case CPU_OR_OP:
>> +               case CPU_AND_OP:
>> +               case CPU_XOR_OP:
>> +                       switch (op->len) {
>> +                       case 1:
>> +                       case 2:
>> +                       case 4:
>> +                       case 8:
>> +                               break;
>> +                       default:
>> +                               return -EINVAL;
>> +                       }
>> +                       break;
>> +               case CPU_LSHIFT_OP:
>> +               case CPU_RSHIFT_OP:
>> +                       switch (op->len) {
>> +                       case 1:
>> +                               if (op->u.shift_op.bits > 7)
>> +                                       return -EINVAL;
>> +                               break;
>> +                       case 2:
>> +                               if (op->u.shift_op.bits > 15)
>> +                                       return -EINVAL;
>> +                               break;
>> +                       case 4:
>> +                               if (op->u.shift_op.bits > 31)
>> +                                       return -EINVAL;
>> +                               break;
>> +                       case 8:
>> +                               if (op->u.shift_op.bits > 63)
>> +                                       return -EINVAL;
>> +                               break;
>> +                       default:
>> +                               return -EINVAL;
>> +                       }
>> +                       break;
>> +               case CPU_MB_OP:
>> +                       break;
>> +               default:
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +       if (sum > CPU_OP_VEC_DATA_LEN_MAX)
>> +               return -EINVAL;
>> +       return 0;
>> +}
>> +
>> +static unsigned long cpu_op_range_nr_pages(unsigned long addr,
>> +               unsigned long len)
>> +{
>> +       return ((addr + len - 1) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1;
>> +}
>> +
>> +static int cpu_op_check_page(struct page *page)
>> +{
>> +       struct address_space *mapping;
>> +
>> +       if (is_zone_device_page(page))
>> +               return -EFAULT;
>> +       page = compound_head(page);
>> +       mapping = READ_ONCE(page->mapping);
>> +       if (!mapping) {
>> +               int shmem_swizzled;
>> +
>> +               /*
>> +                * Check again with page lock held to guard against
>> +                * memory pressure making shmem_writepage move the page
>> +                * from filecache to swapcache.
>> +                */
>> +               lock_page(page);
>> +               shmem_swizzled = PageSwapCache(page) || page->mapping;
>> +               unlock_page(page);
>> +               if (shmem_swizzled)
>> +                       return -EAGAIN;
>> +               return -EFAULT;
>> +       }
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Refusing device pages, the zero page, pages in the gate area, and
>> + * special mappings. Inspired from futex.c checks.
>> + */
>> +static int cpu_op_check_pages(struct page **pages,
>> +               unsigned long nr_pages)
>> +{
>> +       unsigned long i;
>> +
>> +       for (i = 0; i < nr_pages; i++) {
>> +               int ret;
>> +
>> +               ret = cpu_op_check_page(pages[i]);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
>> +               struct cpu_opv_pinned_pages *pin_pages, int write)
>> +{
>> +       struct page *pages[2];
>> +       int ret, nr_pages;
>> +
>> +       if (!len)
>> +               return 0;
>> +       nr_pages = cpu_op_range_nr_pages(addr, len);
>> +       BUG_ON(nr_pages > 2);
>> +       if (!pin_pages->is_kmalloc && pin_pages->nr + nr_pages
>> +                       > NR_PINNED_PAGES_ON_STACK) {
>> +               struct page **pinned_pages =
>> +                       kzalloc(CPU_OP_VEC_LEN_MAX * CPU_OP_MAX_PAGES
>> +                               * sizeof(struct page *), GFP_KERNEL);
>> +               if (!pinned_pages)
>> +                       return -ENOMEM;
>> +               memcpy(pinned_pages, pin_pages->pages,
>> +                       pin_pages->nr * sizeof(struct page *));
>> +               pin_pages->pages = pinned_pages;
>> +               pin_pages->is_kmalloc = true;
>> +       }
>> +again:
>> +       ret = get_user_pages_fast(addr, nr_pages, write, pages);
>> +       if (ret < nr_pages) {
>> +               if (ret > 0)
>> +                       put_page(pages[0]);
>> +               return -EFAULT;
>> +       }
>> +       /*
>> +        * Refuse device pages, the zero page, pages in the gate area,
>> +        * and special mappings.
>> +        */
>> +       ret = cpu_op_check_pages(pages, nr_pages);
>> +       if (ret == -EAGAIN) {
>> +               put_page(pages[0]);
>> +               if (nr_pages > 1)
>> +                       put_page(pages[1]);
>> +               goto again;
>> +       }
>> +       if (ret)
>> +               goto error;
>> +       pin_pages->pages[pin_pages->nr++] = pages[0];
>> +       if (nr_pages > 1)
>> +               pin_pages->pages[pin_pages->nr++] = pages[1];
>> +       return 0;
>> +
>> +error:
>> +       put_page(pages[0]);
>> +       if (nr_pages > 1)
>> +               put_page(pages[1]);
>> +       return -EFAULT;
>> +}
>> +
>> +static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
>> +               struct cpu_opv_pinned_pages *pin_pages)
>> +{
>> +       int ret, i;
>> +       bool expect_fault = false;
>> +
>> +       /* Check access, pin pages. */
>> +       for (i = 0; i < cpuopcnt; i++) {
>> +               struct cpu_op *op = &cpuop[i];
>> +
>> +               switch (op->op) {
>> +               case CPU_COMPARE_EQ_OP:
>> +               case CPU_COMPARE_NE_OP:
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.compare_op.expect_fault_a;
>> +                       if (!access_ok(VERIFY_READ,
>> +                                       (void __user *)op->u.compare_op.a,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.compare_op.a,
>> +                                       op->len, pin_pages, 0);
>> +                       if (ret)
>> +                               goto error;
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.compare_op.expect_fault_b;
>> +                       if (!access_ok(VERIFY_READ,
>> +                                       (void __user *)op->u.compare_op.b,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.compare_op.b,
>> +                                       op->len, pin_pages, 0);
>> +                       if (ret)
>> +                               goto error;
>> +                       break;
>> +               case CPU_MEMCPY_OP:
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.memcpy_op.expect_fault_dst;
>> +                       if (!access_ok(VERIFY_WRITE,
>> +                                       (void __user *)op->u.memcpy_op.dst,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.memcpy_op.dst,
>> +                                       op->len, pin_pages, 1);
>> +                       if (ret)
>> +                               goto error;
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.memcpy_op.expect_fault_src;
>> +                       if (!access_ok(VERIFY_READ,
>> +                                       (void __user *)op->u.memcpy_op.src,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.memcpy_op.src,
>> +                                       op->len, pin_pages, 0);
>> +                       if (ret)
>> +                               goto error;
>> +                       break;
>> +               case CPU_ADD_OP:
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.arithmetic_op.expect_fault_p;
>> +                       if (!access_ok(VERIFY_WRITE,
>> +                                       (void __user *)op->u.arithmetic_op.p,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.arithmetic_op.p,
>> +                                       op->len, pin_pages, 1);
>> +                       if (ret)
>> +                               goto error;
>> +                       break;
>> +               case CPU_OR_OP:
>> +               case CPU_AND_OP:
>> +               case CPU_XOR_OP:
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.bitwise_op.expect_fault_p;
>> +                       if (!access_ok(VERIFY_WRITE,
>> +                                       (void __user *)op->u.bitwise_op.p,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.bitwise_op.p,
>> +                                       op->len, pin_pages, 1);
>> +                       if (ret)
>> +                               goto error;
>> +                       break;
>> +               case CPU_LSHIFT_OP:
>> +               case CPU_RSHIFT_OP:
>> +                       ret = -EFAULT;
>> +                       expect_fault = op->u.shift_op.expect_fault_p;
>> +                       if (!access_ok(VERIFY_WRITE,
>> +                                       (void __user *)op->u.shift_op.p,
>> +                                       op->len))
>> +                               goto error;
>> +                       ret = cpu_op_pin_pages(
>> +                                       (unsigned long)op->u.shift_op.p,
>> +                                       op->len, pin_pages, 1);
>> +                       if (ret)
>> +                               goto error;
>> +                       break;
>> +               case CPU_MB_OP:
>> +                       break;
>> +               default:
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +       return 0;
>> +
>> +error:
>> +       for (i = 0; i < pin_pages->nr; i++)
>> +               put_page(pin_pages->pages[i]);
>> +       pin_pages->nr = 0;
>> +       /*
>> +        * If faulting access is expected, return EAGAIN to user-space.
>> +        * It allows user-space to distinguish between a fault caused by
>> +        * an access which is expect to fault (e.g. due to concurrent
>> +        * unmapping of underlying memory) from an unexpected fault from
>> +        * which a retry would not recover.
>> +        */
>> +       if (ret == -EFAULT && expect_fault)
>> +               return -EAGAIN;
>> +       return ret;
>> +}
>> +
>> +/* Return 0 if same, > 0 if different, < 0 on error. */
>> +static int do_cpu_op_compare_iter(void __user *a, void __user *b, uint32_t len)
>> +{
>> +       char bufa[TMP_BUFLEN], bufb[TMP_BUFLEN];
>> +       uint32_t compared = 0;
>> +
>> +       while (compared != len) {
>> +               unsigned long to_compare;
>> +
>> +               to_compare = min_t(uint32_t, TMP_BUFLEN, len - compared);
>> +               if (__copy_from_user_inatomic(bufa, a + compared, to_compare))
>> +                       return -EFAULT;
>> +               if (__copy_from_user_inatomic(bufb, b + compared, to_compare))
>> +                       return -EFAULT;
>> +               if (memcmp(bufa, bufb, to_compare))
>> +                       return 1;       /* different */
>> +               compared += to_compare;
>> +       }
>> +       return 0;       /* same */
>> +}
>> +
>> +/* Return 0 if same, > 0 if different, < 0 on error. */
>> +static int do_cpu_op_compare(void __user *a, void __user *b, uint32_t len)
>> +{
>> +       int ret = -EFAULT;
>> +       union {
>> +               uint8_t _u8;
>> +               uint16_t _u16;
>> +               uint32_t _u32;
>> +               uint64_t _u64;
>> +#if (BITS_PER_LONG < 64)
>> +               uint32_t _u64_split[2];
>> +#endif
>> +       } tmp[2];
>> +
>> +       pagefault_disable();
>> +       switch (len) {
>> +       case 1:
>> +               if (__get_user(tmp[0]._u8, (uint8_t __user *)a))
>> +                       goto end;
>> +               if (__get_user(tmp[1]._u8, (uint8_t __user *)b))
>> +                       goto end;
>> +               ret = !!(tmp[0]._u8 != tmp[1]._u8);
>> +               break;
>> +       case 2:
>> +               if (__get_user(tmp[0]._u16, (uint16_t __user *)a))
>> +                       goto end;
>> +               if (__get_user(tmp[1]._u16, (uint16_t __user *)b))
>> +                       goto end;
>> +               ret = !!(tmp[0]._u16 != tmp[1]._u16);
>> +               break;
>> +       case 4:
>> +               if (__get_user(tmp[0]._u32, (uint32_t __user *)a))
>> +                       goto end;
>> +               if (__get_user(tmp[1]._u32, (uint32_t __user *)b))
>> +                       goto end;
>> +               ret = !!(tmp[0]._u32 != tmp[1]._u32);
>> +               break;
>> +       case 8:
>> +#if (BITS_PER_LONG >= 64)
>> +               if (__get_user(tmp[0]._u64, (uint64_t __user *)a))
>> +                       goto end;
>> +               if (__get_user(tmp[1]._u64, (uint64_t __user *)b))
>> +                       goto end;
>> +#else
>> +               if (__get_user(tmp[0]._u64_split[0], (uint32_t __user *)a))
>> +                       goto end;
>> +               if (__get_user(tmp[0]._u64_split[1], (uint32_t __user *)a + 1))
>> +                       goto end;
>> +               if (__get_user(tmp[1]._u64_split[0], (uint32_t __user *)b))
>> +                       goto end;
>> +               if (__get_user(tmp[1]._u64_split[1], (uint32_t __user *)b + 1))
>> +                       goto end;
>> +#endif
>> +               ret = !!(tmp[0]._u64 != tmp[1]._u64);
>> +               break;
>> +       default:
>> +               pagefault_enable();
>> +               return do_cpu_op_compare_iter(a, b, len);
>> +       }
>> +end:
>> +       pagefault_enable();
>> +       return ret;
>> +}
>> +
>> +/* Return 0 on success, < 0 on error. */
>> +static int do_cpu_op_memcpy_iter(void __user *dst, void __user *src,
>> +               uint32_t len)
>> +{
>> +       char buf[TMP_BUFLEN];
>> +       uint32_t copied = 0;
>> +
>> +       while (copied != len) {
>> +               unsigned long to_copy;
>> +
>> +               to_copy = min_t(uint32_t, TMP_BUFLEN, len - copied);
>> +               if (__copy_from_user_inatomic(buf, src + copied, to_copy))
>> +                       return -EFAULT;
>> +               if (__copy_to_user_inatomic(dst + copied, buf, to_copy))
>> +                       return -EFAULT;
>> +               copied += to_copy;
>> +       }
>> +       return 0;
>> +}
>> +
>> +/* Return 0 on success, < 0 on error. */
>> +static int do_cpu_op_memcpy(void __user *dst, void __user *src, uint32_t len)
>> +{
>> +       int ret = -EFAULT;
>> +       union {
>> +               uint8_t _u8;
>> +               uint16_t _u16;
>> +               uint32_t _u32;
>> +               uint64_t _u64;
>> +#if (BITS_PER_LONG < 64)
>> +               uint32_t _u64_split[2];
>> +#endif
>> +       } tmp;
>> +
>> +       pagefault_disable();
>> +       switch (len) {
>> +       case 1:
>> +               if (__get_user(tmp._u8, (uint8_t __user *)src))
>> +                       goto end;
>> +               if (__put_user(tmp._u8, (uint8_t __user *)dst))
>> +                       goto end;
>> +               break;
>> +       case 2:
>> +               if (__get_user(tmp._u16, (uint16_t __user *)src))
>> +                       goto end;
>> +               if (__put_user(tmp._u16, (uint16_t __user *)dst))
>> +                       goto end;
>> +               break;
>> +       case 4:
>> +               if (__get_user(tmp._u32, (uint32_t __user *)src))
>> +                       goto end;
>> +               if (__put_user(tmp._u32, (uint32_t __user *)dst))
>> +                       goto end;
>> +               break;
>> +       case 8:
>> +#if (BITS_PER_LONG >= 64)
>> +               if (__get_user(tmp._u64, (uint64_t __user *)src))
>> +                       goto end;
>> +               if (__put_user(tmp._u64, (uint64_t __user *)dst))
>> +                       goto end;
>> +#else
>> +               if (__get_user(tmp._u64_split[0], (uint32_t __user *)src))
>> +                       goto end;
>> +               if (__get_user(tmp._u64_split[1], (uint32_t __user *)src + 1))
>> +                       goto end;
>> +               if (__put_user(tmp._u64_split[0], (uint32_t __user *)dst))
>> +                       goto end;
>> +               if (__put_user(tmp._u64_split[1], (uint32_t __user *)dst + 1))
>> +                       goto end;
>> +#endif
>> +               break;
>> +       default:
>> +               pagefault_enable();
>> +               return do_cpu_op_memcpy_iter(dst, src, len);
>> +       }
>> +       ret = 0;
>> +end:
>> +       pagefault_enable();
>> +       return ret;
>> +}
>> +
>> +static int op_add_fn(union op_fn_data *data, uint64_t count, uint32_t len)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (len) {
>> +       case 1:
>> +               data->_u8 += (uint8_t)count;
>> +               break;
>> +       case 2:
>> +               data->_u16 += (uint16_t)count;
>> +               break;
>> +       case 4:
>> +               data->_u32 += (uint32_t)count;
>> +               break;
>> +       case 8:
>> +               data->_u64 += (uint64_t)count;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +       return ret;
>> +}
>> +
>> +static int op_or_fn(union op_fn_data *data, uint64_t mask, uint32_t len)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (len) {
>> +       case 1:
>> +               data->_u8 |= (uint8_t)mask;
>> +               break;
>> +       case 2:
>> +               data->_u16 |= (uint16_t)mask;
>> +               break;
>> +       case 4:
>> +               data->_u32 |= (uint32_t)mask;
>> +               break;
>> +       case 8:
>> +               data->_u64 |= (uint64_t)mask;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +       return ret;
>> +}
>> +
>> +static int op_and_fn(union op_fn_data *data, uint64_t mask, uint32_t len)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (len) {
>> +       case 1:
>> +               data->_u8 &= (uint8_t)mask;
>> +               break;
>> +       case 2:
>> +               data->_u16 &= (uint16_t)mask;
>> +               break;
>> +       case 4:
>> +               data->_u32 &= (uint32_t)mask;
>> +               break;
>> +       case 8:
>> +               data->_u64 &= (uint64_t)mask;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +       return ret;
>> +}
>> +
>> +static int op_xor_fn(union op_fn_data *data, uint64_t mask, uint32_t len)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (len) {
>> +       case 1:
>> +               data->_u8 ^= (uint8_t)mask;
>> +               break;
>> +       case 2:
>> +               data->_u16 ^= (uint16_t)mask;
>> +               break;
>> +       case 4:
>> +               data->_u32 ^= (uint32_t)mask;
>> +               break;
>> +       case 8:
>> +               data->_u64 ^= (uint64_t)mask;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +       return ret;
>> +}
>> +
>> +static int op_lshift_fn(union op_fn_data *data, uint64_t bits, uint32_t len)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (len) {
>> +       case 1:
>> +               data->_u8 <<= (uint8_t)bits;
>> +               break;
>> +       case 2:
>> +               data->_u16 <<= (uint16_t)bits;
>> +               break;
>> +       case 4:
>> +               data->_u32 <<= (uint32_t)bits;
>> +               break;
>> +       case 8:
>> +               data->_u64 <<= (uint64_t)bits;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +       return ret;
>> +}
>> +
>> +static int op_rshift_fn(union op_fn_data *data, uint64_t bits, uint32_t len)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (len) {
>> +       case 1:
>> +               data->_u8 >>= (uint8_t)bits;
>> +               break;
>> +       case 2:
>> +               data->_u16 >>= (uint16_t)bits;
>> +               break;
>> +       case 4:
>> +               data->_u32 >>= (uint32_t)bits;
>> +               break;
>> +       case 8:
>> +               data->_u64 >>= (uint64_t)bits;
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +       return ret;
>> +}
>> +
>> +/* Return 0 on success, < 0 on error. */
>> +static int do_cpu_op_fn(op_fn_t op_fn, void __user *p, uint64_t v,
>> +               uint32_t len)
>> +{
>> +       int ret = -EFAULT;
>> +       union op_fn_data tmp;
>> +
>> +       pagefault_disable();
>> +       switch (len) {
>> +       case 1:
>> +               if (__get_user(tmp._u8, (uint8_t __user *)p))
>> +                       goto end;
>> +               if (op_fn(&tmp, v, len))
>> +                       goto end;
>> +               if (__put_user(tmp._u8, (uint8_t __user *)p))
>> +                       goto end;
>> +               break;
>> +       case 2:
>> +               if (__get_user(tmp._u16, (uint16_t __user *)p))
>> +                       goto end;
>> +               if (op_fn(&tmp, v, len))
>> +                       goto end;
>> +               if (__put_user(tmp._u16, (uint16_t __user *)p))
>> +                       goto end;
>> +               break;
>> +       case 4:
>> +               if (__get_user(tmp._u32, (uint32_t __user *)p))
>> +                       goto end;
>> +               if (op_fn(&tmp, v, len))
>> +                       goto end;
>> +               if (__put_user(tmp._u32, (uint32_t __user *)p))
>> +                       goto end;
>> +               break;
>> +       case 8:
>> +#if (BITS_PER_LONG >= 64)
>> +               if (__get_user(tmp._u64, (uint64_t __user *)p))
>> +                       goto end;
>> +#else
>> +               if (__get_user(tmp._u64_split[0], (uint32_t __user *)p))
>> +                       goto end;
>> +               if (__get_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
>> +                       goto end;
>> +#endif
>> +               if (op_fn(&tmp, v, len))
>> +                       goto end;
>> +#if (BITS_PER_LONG >= 64)
>> +               if (__put_user(tmp._u64, (uint64_t __user *)p))
>> +                       goto end;
>> +#else
>> +               if (__put_user(tmp._u64_split[0], (uint32_t __user *)p))
>> +                       goto end;
>> +               if (__put_user(tmp._u64_split[1], (uint32_t __user *)p + 1))
>> +                       goto end;
>> +#endif
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               goto end;
>> +       }
>> +       ret = 0;
>> +end:
>> +       pagefault_enable();
>> +       return ret;
>> +}
>> +
>> +static int __do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt)
>> +{
>> +       int i, ret;
>> +
>> +       for (i = 0; i < cpuopcnt; i++) {
>> +               struct cpu_op *op = &cpuop[i];
>> +
>> +               /* Guarantee a compiler barrier between each operation. */
>> +               barrier();
>> +
>> +               switch (op->op) {
>> +               case CPU_COMPARE_EQ_OP:
>> +                       ret = do_cpu_op_compare(
>> +                                       (void __user *)op->u.compare_op.a,
>> +                                       (void __user *)op->u.compare_op.b,
>> +                                       op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret < 0)
>> +                               return ret;
>> +                       /*
>> +                        * Stop execution, return op index + 1 if comparison
>> +                        * differs.
>> +                        */
>> +                       if (ret > 0)
>> +                               return i + 1;
>> +                       break;
>> +               case CPU_COMPARE_NE_OP:
>> +                       ret = do_cpu_op_compare(
>> +                                       (void __user *)op->u.compare_op.a,
>> +                                       (void __user *)op->u.compare_op.b,
>> +                                       op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret < 0)
>> +                               return ret;
>> +                       /*
>> +                        * Stop execution, return op index + 1 if comparison
>> +                        * is identical.
>> +                        */
>> +                       if (ret == 0)
>> +                               return i + 1;
>> +                       break;
>> +               case CPU_MEMCPY_OP:
>> +                       ret = do_cpu_op_memcpy(
>> +                                       (void __user *)op->u.memcpy_op.dst,
>> +                                       (void __user *)op->u.memcpy_op.src,
>> +                                       op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_ADD_OP:
>> +                       ret = do_cpu_op_fn(op_add_fn,
>> +                                       (void __user *)op->u.arithmetic_op.p,
>> +                                       op->u.arithmetic_op.count, op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_OR_OP:
>> +                       ret = do_cpu_op_fn(op_or_fn,
>> +                                       (void __user *)op->u.bitwise_op.p,
>> +                                       op->u.bitwise_op.mask, op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_AND_OP:
>> +                       ret = do_cpu_op_fn(op_and_fn,
>> +                                       (void __user *)op->u.bitwise_op.p,
>> +                                       op->u.bitwise_op.mask, op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_XOR_OP:
>> +                       ret = do_cpu_op_fn(op_xor_fn,
>> +                                       (void __user *)op->u.bitwise_op.p,
>> +                                       op->u.bitwise_op.mask, op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_LSHIFT_OP:
>> +                       ret = do_cpu_op_fn(op_lshift_fn,
>> +                                       (void __user *)op->u.shift_op.p,
>> +                                       op->u.shift_op.bits, op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_RSHIFT_OP:
>> +                       ret = do_cpu_op_fn(op_rshift_fn,
>> +                                       (void __user *)op->u.shift_op.p,
>> +                                       op->u.shift_op.bits, op->len);
>> +                       /* Stop execution on error. */
>> +                       if (ret)
>> +                               return ret;
>> +                       break;
>> +               case CPU_MB_OP:
>> +                       smp_mb();
>> +                       break;
>> +               default:
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt, int cpu)
>> +{
>> +       int ret;
>> +
>> +       if (cpu != raw_smp_processor_id()) {
>> +               ret = push_task_to_cpu(current, cpu);
>> +               if (ret)
>> +                       goto check_online;
>> +       }
>> +       preempt_disable();
>> +       if (cpu != smp_processor_id()) {
>> +               ret = -EAGAIN;
>> +               goto end;
>> +       }
>> +       ret = __do_cpu_opv(cpuop, cpuopcnt);
>> +end:
>> +       preempt_enable();
>> +       return ret;
>> +
>> +check_online:
>> +       if (!cpu_possible(cpu))
>> +               return -EINVAL;
>> +       get_online_cpus();
>> +       if (cpu_online(cpu)) {
>> +               ret = -EAGAIN;
>> +               goto put_online_cpus;
>> +       }
>> +       /*
>> +        * CPU is offline. Perform operation from the current CPU with
>> +        * cpu_online read lock held, preventing that CPU from coming online,
>> +        * and with mutex held, providing mutual exclusion against other
>> +        * CPUs also finding out about an offline CPU.
>> +        */
>> +       mutex_lock(&cpu_opv_offline_lock);
>> +       ret = __do_cpu_opv(cpuop, cpuopcnt);
>> +       mutex_unlock(&cpu_opv_offline_lock);
>> +put_online_cpus:
>> +       put_online_cpus();
>> +       return ret;
>> +}
>> +
>> +/*
>> + * cpu_opv - execute operation vector on a given CPU with preempt off.
>> + *
>> + * Userspace should pass current CPU number as parameter. May fail with
>> + * -EAGAIN if currently executing on the wrong CPU.
>> + */
>> +SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
>> +               int, cpu, int, flags)
>> +{
>> +       struct cpu_op cpuopv[CPU_OP_VEC_LEN_MAX];
>> +       struct page *pinned_pages_on_stack[NR_PINNED_PAGES_ON_STACK];
>> +       struct cpu_opv_pinned_pages pin_pages = {
>> +               .pages = pinned_pages_on_stack,
>> +               .nr = 0,
>> +               .is_kmalloc = false,
>> +       };
>> +       int ret, i;
>> +
>> +       if (unlikely(flags))
>> +               return -EINVAL;
>> +       if (unlikely(cpu < 0))
>> +               return -EINVAL;
>> +       if (cpuopcnt < 0 || cpuopcnt > CPU_OP_VEC_LEN_MAX)
>> +               return -EINVAL;
>> +       if (copy_from_user(cpuopv, ucpuopv, cpuopcnt * sizeof(struct cpu_op)))
>> +               return -EFAULT;
>> +       ret = cpu_opv_check(cpuopv, cpuopcnt);
>> +       if (ret)
>> +               return ret;
>> +       ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &pin_pages);
>> +       if (ret)
>> +               goto end;
>> +       ret = do_cpu_opv(cpuopv, cpuopcnt, cpu);
>> +       for (i = 0; i < pin_pages.nr; i++)
>> +               put_page(pin_pages.pages[i]);
>> +end:
>> +       if (pin_pages.is_kmalloc)
>> +               kfree(pin_pages.pages);
>> +       return ret;
>> +}
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 6bba05f47e51..e547f93a46c2 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1052,6 +1052,43 @@ void do_set_cpus_allowed(struct task_struct *p, const
>> struct cpumask *new_mask)
>>                 set_curr_task(rq, p);
>>  }
>>
>> +int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
>> +{
>> +       struct rq_flags rf;
>> +       struct rq *rq;
>> +       int ret = 0;
>> +
>> +       rq = task_rq_lock(p, &rf);
>> +       update_rq_clock(rq);
>> +
>> +       if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)) {
>> +               ret = -EINVAL;
>> +               goto out;
>> +       }
>> +
>> +       if (task_cpu(p) == dest_cpu)
>> +               goto out;
>> +
>> +       if (task_running(rq, p) || p->state == TASK_WAKING) {
>> +               struct migration_arg arg = { p, dest_cpu };
>> +               /* Need help from migration thread: drop lock and wait. */
>> +               task_rq_unlock(rq, p, &rf);
>> +               stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
>> +               tlb_migrate_finish(p->mm);
>> +               return 0;
>> +       } else if (task_on_rq_queued(p)) {
>> +               /*
>> +                * OK, since we're going to drop the lock immediately
>> +                * afterwards anyway.
>> +                */
>> +               rq = move_queued_task(rq, &rf, p, dest_cpu);
>> +       }
>> +out:
>> +       task_rq_unlock(rq, p, &rf);
>> +
>> +       return ret;
>> +}
>> +
>>  /*
>>   * Change a given task's CPU affinity. Migrate the thread to a
>>   * proper CPU and schedule it away if the CPU it's executing on
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index 3b448ba82225..cab256c1720a 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -1209,6 +1209,8 @@ static inline void __set_task_cpu(struct task_struct *p,
>> unsigned int cpu)
>>  #endif
>>  }
>>
>> +int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu);
>> +
>>  /*
>>   * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
>>   */
>> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
>> index bfa1ee1bf669..59e622296dc3 100644
>> --- a/kernel/sys_ni.c
>> +++ b/kernel/sys_ni.c
>> @@ -262,3 +262,4 @@ cond_syscall(sys_pkey_free);
>>
>>  /* restartable sequence */
>>  cond_syscall(sys_rseq);
>> +cond_syscall(sys_cpu_opv);
>> --
>> 2.11.0
>>
>>
>>
> 
> 
> 
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
