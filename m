From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 1 Mar 2016 20:23:12 +0000 (UTC)
Message-ID: <676569856.13488.1456863792603.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com> <1401667361.10273.1456617236327.JavaMail.zimbra@efficios.com> <CA+55aFwcgwRxvVBz5kk_3O8dESXAGJ4KHBkf=pSXjiS7Xh4NwA@mail.gmail.com> <1082926946.10326.1456619994590.JavaMail.zimbra@efficios.com> <CA+55aFwZY1BR5NdjAP-rytd29hE2EZEXgcaBKjepWFFj+oR1SA@mail.gmail.com> <1538518747.10504.1456669948568.JavaMail.zimbra@efficios.com> <20160229103506.GJ6356@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160229103506.GJ6356-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Feb 29, 2016, at 5:35 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Sun, Feb 28, 2016 at 02:32:28PM +0000, Mathieu Desnoyers wrote:
>> The part of ABI I'm trying to express here is for discoverability
>> of available features by user-space. For instance, a kernel
>> could be configured with "CONFIG_RSEQ=n", and userspace should
>> not rely on the rseq fields of the thread-local ABI in that case.
> 
> Per the just proposed interface; discoverability would end with:
> 
>	thread_local_abi_register(NULL, TLA_ENABLE_RSEQ, 0);
> 
> failing. This would indicate your kernel does not support (or your glibc
> failed to register, depending on error code I suppose).
> 
> Then your program can either fall back to full atomics or just bail.

I think it's important that user-space fast-paths can quickly
detect whether the feature is enabled without having to rely on
always reading a separate cache-line. I've put together an ABI
proposal that take into account the feedback received so far.

The main trick here is to use "-1" value in cpu_id and rseq_seqnum
to mean "the feature is inactive" so user-space can call the system
call to register the feature, and the value "-2" can be set by the
kernel when it knows the feature is not available. It does mean
that seqnum would wrap from MAX_INT to 0 in the kernel, skipping
negative values.

Please let me know if I missed anything.

#ifdef __LP64__
# define TLABI_FIELD_u32_u64(field)     uint64_t field
#elif __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
# define TLABI_FIELD_u32_u64(field)     uint32_t field, _padding ## field
#else
# define TLABI_FIELD_u32_u64(field)     uint32_t _padding ## field, field
#endif

/*
 * The thread-local ABI structure needs to be aligned at least on 32
 * bytes multiples.
 */
#define TLABI_ALIGNMENT         32

struct thread_local_abi {
        /*
         * Thread-local ABI cpu_id field.
         * Updated by the kernel, and read by user-space with
         * single-copy atomicity semantics. Aligned on 32-bit.
         * Values:
         * >= 0: CPU number of running thread.
         * -1 (initial value): means the cpu_id feature is inactive.
         * -2: cpu_id feature is not available.
         */
        int32_t cpu_id;

        /*
         * Thread-local ABI rseq_seqnum field.
         * Updated by the kernel, and read by user-space with
         * single-copy atomicity semantics. Aligned on 32-bit.
         * Values:
         * >= 0: current seqnum for this thread (feature is active).
         * -1 (initial value): means the rseq feature is inactive.
         * -2: rseq feature is not available.
         */
        int32_t rseq_seqnum;

        /*
         * Thread-local ABI rseq_post_commit_ip field.
         * Updated by user-space, and read by the kernel with
         * single-copy atomicity semantics.
         * Aligned on 64-bit.
         */
        TLABI_FIELD_u32_u64(rseq_post_commit_ip);

        /* Add new fields at the end. */
} __attribute__ ((aligned(TLABI_ALIGNMENT)));

enum thread_local_abi_feature {
        TLA_FEATURE_NONE = 0,
        TLA_FEATURE_CPU_ID = (1 << 0),
        TLA_FEATURE_RSEQ = (1 << 1),
};

/*
 * Thread local ABI system call.
 *
 * First call with (NULL, 0, 0), returns the size of the struct
 * thread_local_abi expected by the kernel, or -1 on error.
 *
 * Second, allocate a memory area to hold the struct thread_local_abi,
 * and call with (ptr, 0, 0). Returns 0 on success, or -1 on error.
 *
 * Third, enable specific features by passing a mask, e.g. call with
 * (NULL, TLA_FEATURE_CPU_ID | TLA_FEATURE_RSEQ, 0).
 * Returns 0 on success, -1 on error.
 *
 * Then the fields associated with the enabled features are managed by
 * the kernel.
 */
ssize_t thread_local_abi(struct thread_local_abi *tlabi,
                uint64_t feature_mask, int flags);

Thanks for your feedback!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
