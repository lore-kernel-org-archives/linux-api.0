From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Fri, 17 Nov 2017 00:26:26 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711162215100.2109@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200414.2188-9-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 14 Nov 2017, Mathieu Desnoyers wrote:
> +#ifdef __KERNEL__
> +# include <linux/types.h>
> +#else	/* #ifdef __KERNEL__ */

  		   Sigh.

> +# include <stdint.h>
> +#endif	/* #else #ifdef __KERNEL__ */
> +
> +#include <asm/byteorder.h>
> +
> +#ifdef __LP64__
> +# define CPU_OP_FIELD_u32_u64(field)			uint64_t field
> +# define CPU_OP_FIELD_u32_u64_INIT_ONSTACK(field, v)	field = (intptr_t)v
> +#elif defined(__BYTE_ORDER) ? \
> +	__BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
> +# define CPU_OP_FIELD_u32_u64(field)	uint32_t field ## _padding, field
> +# define CPU_OP_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
> +	field ## _padding = 0, field = (intptr_t)v
> +#else
> +# define CPU_OP_FIELD_u32_u64(field)	uint32_t field, field ## _padding
> +# define CPU_OP_FIELD_u32_u64_INIT_ONSTACK(field, v)	\
> +	field = (intptr_t)v, field ## _padding = 0
> +#endif

So in the rseq patch you have:

+#ifdef __LP64__
+# define RSEQ_FIELD_u32_u64(field)                     uint64_t field
+# define RSEQ_FIELD_u32_u64_INIT_ONSTACK(field, v)     field = (intptr_t)v
+#elif defined(__BYTE_ORDER) ? \
+       __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
+# define RSEQ_FIELD_u32_u64(field)     uint32_t field ## _padding, field
+# define RSEQ_FIELD_u32_u64_INIT_ONSTACK(field, v)     \
+       field ## _padding = 0, field = (intptr_t)v
+#else
+# define RSEQ_FIELD_u32_u64(field)     uint32_t field, field ## _padding
+# define RSEQ_FIELD_u32_u64_INIT_ONSTACK(field, v)     \
+       field = (intptr_t)v, field ## _padding = 0
+#endif

IOW the same macro maze. Please use a separate header file which provides
these macros once and share them between the two facilities.

> +#define CPU_OP_VEC_LEN_MAX		16
> +#define CPU_OP_ARG_LEN_MAX		24
> +/* Max. data len per operation. */
> +#define CPU_OP_DATA_LEN_MAX		PAGE_SIZE

That's something between 4K and 256K depending on the architecture. 

You really want to allow up to 256K data copy with preemption disabled?
Shudder.

> +/*
> + * Max. data len for overall vector. We to restrict the amount of

We to ?

> + * user-space data touched by the kernel in non-preemptible context so
> + * we do not introduce long scheduler latencies.
> + * This allows one copy of up to 4096 bytes, and 15 operations touching
> + * 8 bytes each.
> + * This limit is applied to the sum of length specified for all
> + * operations in a vector.
> + */
> +#define CPU_OP_VEC_DATA_LEN_MAX		(4096 + 15*8)

Magic numbers. Please use proper defines for heavens sake.

> +#define CPU_OP_MAX_PAGES		4	/* Max. pages per op. */
> +
> +enum cpu_op_type {
> +	CPU_COMPARE_EQ_OP,	/* compare */
> +	CPU_COMPARE_NE_OP,	/* compare */
> +	CPU_MEMCPY_OP,		/* memcpy */
> +	CPU_ADD_OP,		/* arithmetic */
> +	CPU_OR_OP,		/* bitwise */
> +	CPU_AND_OP,		/* bitwise */
> +	CPU_XOR_OP,		/* bitwise */
> +	CPU_LSHIFT_OP,		/* shift */
> +	CPU_RSHIFT_OP,		/* shift */
> +	CPU_MB_OP,		/* memory barrier */
> +};
> +
> +/* Vector of operations to perform. Limited to 16. */
> +struct cpu_op {
> +	int32_t op;	/* enum cpu_op_type. */
> +	uint32_t len;	/* data length, in bytes. */

Please get rid of these tail comments

> +	union {
> +#define TMP_BUFLEN			64
> +#define NR_PINNED_PAGES_ON_STACK	8

8 pinned pages on stack? Which stack?

> +/*
> + * The cpu_opv system call executes a vector of operations on behalf of
> + * user-space on a specific CPU with preemption disabled. It is inspired
> + * from readv() and writev() system calls which take a "struct iovec"

s/from/by/

> + * array as argument.
> + *
> + * The operations available are: comparison, memcpy, add, or, and, xor,
> + * left shift, and right shift. The system call receives a CPU number
> + * from user-space as argument, which is the CPU on which those
> + * operations need to be performed. All preparation steps such as
> + * loading pointers, and applying offsets to arrays, need to be
> + * performed by user-space before invoking the system call. The

loading pointers and applying offsets? That makes no sense.

> + * "comparison" operation can be used to check that the data used in the
> + * preparation step did not change between preparation of system call
> + * inputs and operation execution within the preempt-off critical
> + * section.
> + *
> + * The reason why we require all pointer offsets to be calculated by
> + * user-space beforehand is because we need to use get_user_pages_fast()
> + * to first pin all pages touched by each operation. This takes care of

That doesnt explain it either.

> + * faulting-in the pages.  Then, preemption is disabled, and the
> + * operations are performed atomically with respect to other thread
> + * execution on that CPU, without generating any page fault.
> + *
> + * A maximum limit of 16 operations per cpu_opv syscall invocation is
> + * enforced, and a overall maximum length sum, so user-space cannot
> + * generate a too long preempt-off critical section. Each operation is
> + * also limited a length of PAGE_SIZE bytes, meaning that an operation
> + * can touch a maximum of 4 pages (memcpy: 2 pages for source, 2 pages
> + * for destination if addresses are not aligned on page boundaries).

What's the critical section duration for operations which go to the limits
of this on a average x86 64 machine?

> + * If the thread is not running on the requested CPU, a new
> + * push_task_to_cpu() is invoked to migrate the task to the requested

new push_task_to_cpu()? Once that patch is merged push_task_to_cpu() is
hardly new.

Please refrain from putting function level details into comments which
describe the concept. The function name might change in 3 month from now
and the comment will stay stale, Its sufficient to say:

 * If the thread is not running on the requested CPU it is migrated
 * to it.

That explains the concept. It's completely irrelevant which mechanism is
used to achieve that.

> + * CPU.  If the requested CPU is not part of the cpus allowed mask of
> + * the thread, the system call fails with EINVAL. After the migration
> + * has been performed, preemption is disabled, and the current CPU
> + * number is checked again and compared to the requested CPU number. If
> + * it still differs, it means the scheduler migrated us away from that
> + * CPU. Return EAGAIN to user-space in that case, and let user-space
> + * retry (either requesting the same CPU number, or a different one,
> + * depending on the user-space algorithm constraints).

This mixture of imperative and impersonated mood is really hard to read.

> +/*
> + * Check operation types and length parameters.
> + */
> +static int cpu_opv_check(struct cpu_op *cpuop, int cpuopcnt)
> +{
> +	int i;
> +	uint32_t sum = 0;
> +
> +	for (i = 0; i < cpuopcnt; i++) {
> +		struct cpu_op *op = &cpuop[i];
> +
> +		switch (op->op) {
> +		case CPU_MB_OP:
> +			break;
> +		default:
> +			sum += op->len;
> +		}

Please separate the switch cases with an empty line.

> +static unsigned long cpu_op_range_nr_pages(unsigned long addr,
> +		unsigned long len)

Please align the arguments

static unsigned long cpu_op_range_nr_pages(unsigned long addr,
					   unsigned long len)

is way simpler to parse. All over the place please.

> +{
> +	return ((addr + len - 1) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1;

I'm surprised that there is no existing magic for this.

> +}
> +
> +static int cpu_op_check_page(struct page *page)
> +{
> +	struct address_space *mapping;
> +
> +	if (is_zone_device_page(page))
> +		return -EFAULT;
> +	page = compound_head(page);
> +	mapping = READ_ONCE(page->mapping);
> +	if (!mapping) {
> +		int shmem_swizzled;
> +
> +		/*
> +		 * Check again with page lock held to guard against
> +		 * memory pressure making shmem_writepage move the page
> +		 * from filecache to swapcache.
> +		 */
> +		lock_page(page);
> +		shmem_swizzled = PageSwapCache(page) || page->mapping;
> +		unlock_page(page);
> +		if (shmem_swizzled)
> +			return -EAGAIN;
> +		return -EFAULT;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Refusing device pages, the zero page, pages in the gate area, and
> + * special mappings. Inspired from futex.c checks.

That comment should be on the function above, because this loop does not
much checking. Aside of that a more elaborate explanation how those checks
are done and how that works would be appreciated. 

> + */
> +static int cpu_op_check_pages(struct page **pages,
> +		unsigned long nr_pages)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		int ret;
> +
> +		ret = cpu_op_check_page(pages[i]);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +static int cpu_op_pin_pages(unsigned long addr, unsigned long len,
> +		struct cpu_opv_pinned_pages *pin_pages, int write)
> +{
> +	struct page *pages[2];
> +	int ret, nr_pages;
> +
> +	if (!len)
> +		return 0;
> +	nr_pages = cpu_op_range_nr_pages(addr, len);
> +	BUG_ON(nr_pages > 2);

If that happens then you can emit a warning and return a proper error
code. BUG() is the last resort if there is no way to recover. This really
does not qualify.

> +	if (!pin_pages->is_kmalloc && pin_pages->nr + nr_pages
> +			> NR_PINNED_PAGES_ON_STACK) {

Now I see what this is used for. That's a complete misnomer.

And this check is of course completely self explaining..... NOT!

> +		struct page **pinned_pages =
> +			kzalloc(CPU_OP_VEC_LEN_MAX * CPU_OP_MAX_PAGES
> +				* sizeof(struct page *), GFP_KERNEL);
> +		if (!pinned_pages)
> +			return -ENOMEM;
> +		memcpy(pinned_pages, pin_pages->pages,
> +			pin_pages->nr * sizeof(struct page *));
> +		pin_pages->pages = pinned_pages;
> +		pin_pages->is_kmalloc = true;

I have no idea why this needs to be done here and cannot be done in a
preparation step. That's horrible. You allocate conditionally at some
random place and then free at the end of the syscall.

What's wrong with:

       prepare_stuff()
       pin_pages()
       do_ops()
       cleanup_stuff()

Hmm?

> +	}
> +again:
> +	ret = get_user_pages_fast(addr, nr_pages, write, pages);
> +	if (ret < nr_pages) {
> +		if (ret > 0)
> +			put_page(pages[0]);
> +		return -EFAULT;
> +	}
> +	/*
> +	 * Refuse device pages, the zero page, pages in the gate area,
> +	 * and special mappings.

So the same comment again. Really helpful.

> +	 */
> +	ret = cpu_op_check_pages(pages, nr_pages);
> +	if (ret == -EAGAIN) {
> +		put_page(pages[0]);
> +		if (nr_pages > 1)
> +			put_page(pages[1]);
> +		goto again;
> +	}

So why can't you propagate EAGAIN to the caller and use the error cleanup
label? Or put the sequence of get_user_pages_fast() and check_pages() into
one function and confine the mess there instead of having the same cleanup
sequence 3 times in this function.

> +	if (ret)
> +		goto error;
> +	pin_pages->pages[pin_pages->nr++] = pages[0];
> +	if (nr_pages > 1)
> +		pin_pages->pages[pin_pages->nr++] = pages[1];
> +	return 0;
> +
> +error:
> +	put_page(pages[0]);
> +	if (nr_pages > 1)
> +		put_page(pages[1]);
> +	return -EFAULT;
> +}
> +
> +static int cpu_opv_pin_pages(struct cpu_op *cpuop, int cpuopcnt,
> +		struct cpu_opv_pinned_pages *pin_pages)
> +{
> +	int ret, i;
> +	bool expect_fault = false;
> +
> +	/* Check access, pin pages. */
> +	for (i = 0; i < cpuopcnt; i++) {
> +		struct cpu_op *op = &cpuop[i];
> +
> +		switch (op->op) {
> +		case CPU_COMPARE_EQ_OP:
> +		case CPU_COMPARE_NE_OP:
> +			ret = -EFAULT;
> +			expect_fault = op->u.compare_op.expect_fault_a;
> +			if (!access_ok(VERIFY_READ,
> +					(void __user *)op->u.compare_op.a,
> +					op->len))
> +				goto error;
> +			ret = cpu_op_pin_pages(
> +					(unsigned long)op->u.compare_op.a,
> +					op->len, pin_pages, 0);

Bah, this sucks. Moving the switch() into a separate function spares you
one indentation level and all these horrible to read line breaks.

And again I really have to ask why all of this stuff needs to be type
casted for every invocation. If you use the proper type for the argument
and then do the cast at the function entry then you can spare all that hard
to read crap.

> +error:
> +	for (i = 0; i < pin_pages->nr; i++)
> +		put_page(pin_pages->pages[i]);
> +	pin_pages->nr = 0;

Sigh. Why can't you do that at the call site where you have exactly the
same thing?

> +	/*
> +	 * If faulting access is expected, return EAGAIN to user-space.
> +	 * It allows user-space to distinguish between a fault caused by
> +	 * an access which is expect to fault (e.g. due to concurrent
> +	 * unmapping of underlying memory) from an unexpected fault from
> +	 * which a retry would not recover.
> +	 */
> +	if (ret == -EFAULT && expect_fault)
> +		return -EAGAIN;
> +	return ret;
> +}
> +
> +/* Return 0 if same, > 0 if different, < 0 on error. */
> +static int do_cpu_op_compare_iter(void __user *a, void __user *b, uint32_t len)
> +{
> +	char bufa[TMP_BUFLEN], bufb[TMP_BUFLEN];
> +	uint32_t compared = 0;
> +
> +	while (compared != len) {
> +		unsigned long to_compare;
> +
> +		to_compare = min_t(uint32_t, TMP_BUFLEN, len - compared);
> +		if (__copy_from_user_inatomic(bufa, a + compared, to_compare))
> +			return -EFAULT;
> +		if (__copy_from_user_inatomic(bufb, b + compared, to_compare))
> +			return -EFAULT;
> +		if (memcmp(bufa, bufb, to_compare))
> +			return 1;	/* different */

These tail comments are really crap. It's entirely obvious that if memcmp
!= 0 the result is different. So what is the exact value aside of making it
hard to read?

> +		compared += to_compare;
> +	}
> +	return 0;	/* same */
> +}
> +
> +/* Return 0 if same, > 0 if different, < 0 on error. */
> +static int do_cpu_op_compare(void __user *a, void __user *b, uint32_t len)
> +{
> +	int ret = -EFAULT;
> +	union {
> +		uint8_t _u8;
> +		uint16_t _u16;
> +		uint32_t _u32;
> +		uint64_t _u64;
> +#if (BITS_PER_LONG < 64)
> +		uint32_t _u64_split[2];
> +#endif
> +	} tmp[2];

I've seen the same union before

> +union op_fn_data {

......

> +
> +	pagefault_disable();
> +	switch (len) {
> +	case 1:
> +		if (__get_user(tmp[0]._u8, (uint8_t __user *)a))
> +			goto end;
> +		if (__get_user(tmp[1]._u8, (uint8_t __user *)b))
> +			goto end;
> +		ret = !!(tmp[0]._u8 != tmp[1]._u8);
> +		break;
> +	case 2:
> +		if (__get_user(tmp[0]._u16, (uint16_t __user *)a))
> +			goto end;
> +		if (__get_user(tmp[1]._u16, (uint16_t __user *)b))
> +			goto end;
> +		ret = !!(tmp[0]._u16 != tmp[1]._u16);
> +		break;
> +	case 4:
> +		if (__get_user(tmp[0]._u32, (uint32_t __user *)a))
> +			goto end;
> +		if (__get_user(tmp[1]._u32, (uint32_t __user *)b))
> +			goto end;
> +		ret = !!(tmp[0]._u32 != tmp[1]._u32);
> +		break;
> +	case 8:
> +#if (BITS_PER_LONG >= 64)

We alredy prepare for 128 bit?

> +		if (__get_user(tmp[0]._u64, (uint64_t __user *)a))
> +			goto end;
> +		if (__get_user(tmp[1]._u64, (uint64_t __user *)b))
> +			goto end;
> +#else
> +		if (__get_user(tmp[0]._u64_split[0], (uint32_t __user *)a))
> +			goto end;
> +		if (__get_user(tmp[0]._u64_split[1], (uint32_t __user *)a + 1))
> +			goto end;
> +		if (__get_user(tmp[1]._u64_split[0], (uint32_t __user *)b))
> +			goto end;
> +		if (__get_user(tmp[1]._u64_split[1], (uint32_t __user *)b + 1))
> +			goto end;
> +#endif
> +		ret = !!(tmp[0]._u64 != tmp[1]._u64);

This really sucks.

        union foo va, vb;

	pagefault_disable();
	switch (len) {
	case 1:
	case 2:
	case 4:
	case 8:
		va._u64 = _vb._u64 = 0;
		if (op_get_user(&va, a, len))
			goto out;
		if (op_get_user(&vb, b, len))
			goto out;
		ret = !!(va._u64 != vb._u64);
		break;
	default:
		...

and have

int op_get_user(union foo *val, void *p, int len)
{
	switch (len) {
	case 1:
	     ......

And do the magic once in that function then you spare that copy and pasted
code above. It can be reused in the other ops as well and reduces the amount
of copy and paste code significantly.

> +		break;
> +	default:
> +		pagefault_enable();
> +		return do_cpu_op_compare_iter(a, b, len);
> +	}
> +end:
> +	pagefault_enable();
> +	return ret;
> +}

> +static int __do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < cpuopcnt; i++) {
> +		struct cpu_op *op = &cpuop[i];
> +
> +		/* Guarantee a compiler barrier between each operation. */
> +		barrier();
> +
> +		switch (op->op) {
> +		case CPU_COMPARE_EQ_OP:
> +			ret = do_cpu_op_compare(
> +					(void __user *)op->u.compare_op.a,
> +					(void __user *)op->u.compare_op.b,
> +					op->len);

I think you know by now how to spare an indentation level and type casts.

> +static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt, int cpu)
> +{
> +	int ret;
> +
> +	if (cpu != raw_smp_processor_id()) {
> +		ret = push_task_to_cpu(current, cpu);
> +		if (ret)
> +			goto check_online;
> +	}
> +	preempt_disable();
> +	if (cpu != smp_processor_id()) {
> +		ret = -EAGAIN;

This is weird. When the above raw_smp_processor_id() check fails you push,
but here you return. Not really consistent behaviour.

> +		goto end;
> +	}
> +	ret = __do_cpu_opv(cpuop, cpuopcnt);
> +end:
> +	preempt_enable();
> +	return ret;
> +
> +check_online:
> +	if (!cpu_possible(cpu))
> +		return -EINVAL;
> +	get_online_cpus();
> +	if (cpu_online(cpu)) {
> +		ret = -EAGAIN;
> +		goto put_online_cpus;
> +	}
> +	/*
> +	 * CPU is offline. Perform operation from the current CPU with
> +	 * cpu_online read lock held, preventing that CPU from coming online,
> +	 * and with mutex held, providing mutual exclusion against other
> +	 * CPUs also finding out about an offline CPU.
> +	 */

That's not mentioned in the comment at the top IIRC. 

> +	mutex_lock(&cpu_opv_offline_lock);
> +	ret = __do_cpu_opv(cpuop, cpuopcnt);
> +	mutex_unlock(&cpu_opv_offline_lock);
> +put_online_cpus:
> +	put_online_cpus();
> +	return ret;
> +}
> +
> +/*
> + * cpu_opv - execute operation vector on a given CPU with preempt off.
> + *
> + * Userspace should pass current CPU number as parameter. May fail with
> + * -EAGAIN if currently executing on the wrong CPU.
> + */
> +SYSCALL_DEFINE4(cpu_opv, struct cpu_op __user *, ucpuopv, int, cpuopcnt,
> +		int, cpu, int, flags)
> +{
> +	struct cpu_op cpuopv[CPU_OP_VEC_LEN_MAX];
> +	struct page *pinned_pages_on_stack[NR_PINNED_PAGES_ON_STACK];

Oh well.... Naming sucks. 

> +	struct cpu_opv_pinned_pages pin_pages = {
> +		.pages = pinned_pages_on_stack,
> +		.nr = 0,
> +		.is_kmalloc = false,
> +	};
> +	int ret, i;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +	if (unlikely(cpu < 0))
> +		return -EINVAL;
> +	if (cpuopcnt < 0 || cpuopcnt > CPU_OP_VEC_LEN_MAX)
> +		return -EINVAL;
> +	if (copy_from_user(cpuopv, ucpuopv, cpuopcnt * sizeof(struct cpu_op)))
> +		return -EFAULT;
> +	ret = cpu_opv_check(cpuopv, cpuopcnt);

AFAICT you can calculate the number of pages already in the check and then
do that allocation before pinning the pages.

> +	if (ret)
> +		return ret;
> +	ret = cpu_opv_pin_pages(cpuopv, cpuopcnt, &pin_pages);
> +	if (ret)
> +		goto end;
> +	ret = do_cpu_opv(cpuopv, cpuopcnt, cpu);
> +	for (i = 0; i < pin_pages.nr; i++)
> +		put_page(pin_pages.pages[i]);
> +end:
> +	if (pin_pages.is_kmalloc)
> +		kfree(pin_pages.pages);
> +	return ret;
> +}


> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 6bba05f47e51..e547f93a46c2 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1052,6 +1052,43 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
>  		set_curr_task(rq, p);
>  }

This is NOT part of this functionality. It's a prerequisite and wants to be
in a separate patch. And I'm dead tired by now so I leave that thing for
tomorrow or for Peter.

Thanks,

	tglx
