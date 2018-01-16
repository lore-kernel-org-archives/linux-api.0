From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 00/30] ARM Scalable Vector Extension (SVE)
Date: Tue, 16 Jan 2018 16:05:05 +0000
Message-ID: <20180116160504.GY22781@e103592.cambridge.arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <20180108144905.qu5qbmaaglcgwvwq@yury-thinkpad>
 <20180109165120.6ravt4stp3654374@yury-thinkpad>
 <20180115172201.GW22781@e103592.cambridge.arm.com>
 <20180116101149.pyqbn3dkhnw5x2dv@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180116101149.pyqbn3dkhnw5x2dv@yury-thinkpad>
Sender: linux-arch-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Alan Hayward <alan.hayward@arm.com>, "H . J . Lu" <hjl.tools@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dmitry Safonov <dsafonov@virtuozzo.com>, Oleg Nesterov <oleg@redhat.com>, linux-api@v
List-Id: linux-api@vger.kernel.org

On Tue, Jan 16, 2018 at 01:11:49PM +0300, Yury Norov wrote:
> On Mon, Jan 15, 2018 at 05:22:01PM +0000, Dave Martin wrote:

[...]

> > I'll take a look at your code anyway in case there's something
> > else one of us didn't think of.
> 
> Thanks, Dave.
> 
> This is the branch:
> https://github.com/norov/linux/tree/ilp32-4.15-rc7
> 
> SVE-related changes are mostly in patches:
> arm64: ilp32: introduce ilp32-specific handlers for sigframe and ucontext
> arm64: signal32: move ilp32 and aarch32 common code to separated file
> arm64: signal: share lp64 signal structures and routines to ilp32
> arm64: ilp32: add sys_ilp32.c and a separate table (in entry.S) to use it

Thanks for the pointer.

Quick review of the relevant patches below.

> From 6f566a512cbac378ccee66094b5f9124b6069275 Mon Sep 17 00:00:00 2001
> From: Andrew Pinski <apinski@cavium.com>
> Date: Tue, 24 May 2016 03:04:47 +0300
> Subject: [PATCH 17/24] arm64: ilp32: add sys_ilp32.c and a separate table (in
>  entry.S) to use it
> 
> Add a separate syscall-table for ILP32, which dispatches either to native
> LP64 system call implementation or to compat-syscalls, as appropriate.
> 
> Signed-off-by: Andrew Pinski <Andrew.Pinski@caviumnetworks.com>
> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>

[...]

> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 778726d..d2d7336 100644

[...]

> @@ -864,14 +882,15 @@ ENDPROC(ret_to_user)
>  el0_svc:
>  	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
>  	adrp	stbl, sys_call_table		// load syscall table pointer
> +	ldr	x19, [tsk, #TSK_TI_FLAGS]
>  	mov	wscno, w8			// syscall number in w8
>  	mov	wsc_nr, #__NR_syscalls
>  
>  #ifdef CONFIG_ARM64_SVE
>  alternative_if_not ARM64_SVE
> -	b	el0_svc_naked
> +	b	el0_svc_select_table
>  alternative_else_nop_endif
> -	tbz	x16, #TIF_SVE, el0_svc_naked	// Skip unless TIF_SVE set:
> +	tbz	x16, #TIF_SVE, el0_svc_select_table	// Skip unless TIF_SVE set:
>  	bic	x16, x16, #_TIF_SVE		// discard SVE state
>  	str	x16, [tsk, #TSK_TI_FLAGS]
>  
> @@ -887,12 +906,19 @@ alternative_else_nop_endif
>  	msr	cpacr_el1, x9			// synchronised by eret to el0
>  #endif
>  
> +el0_svc_select_table:
> +#ifdef CONFIG_ARM64_ILP32
> +	tst	x19, #_TIF_32BIT_AARCH64
> +	b.eq	el0_svc_naked			// We are using LP64  syscall table

Can tbz be used here?

> +	adrp	stbl, sys_call_ilp32_table	// load ilp32 syscall table pointer
> +	delouse_input_regs
> +#endif
>  el0_svc_naked:					// compat entry point
>  	stp	x0, xscno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number

[...]


> From 6e55e1c381aa4b6e10ac5eda0a587adf5558f438 Mon Sep 17 00:00:00 2001
> From: Yury Norov <ynorov@caviumnetworks.com>
> Date: Mon, 26 Jun 2017 19:11:58 +0300
> Subject: [PATCH 18/24] arm64: signal: share lp64 signal structures and
>  routines to ilp32

Nit: Please ensure that the commit message makes sense without the
subject line, so that users of Mutt etc., can see all necessary context
in the message body when drafting a reply.

> After that, it will be possible to reuse it in ilp32.
> 
> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>


[...]

> +#define parse_user_sigcontext(user, sf)					\
> +	__parse_user_sigcontext(user, &(sf)->uc.uc_mcontext, sf)

Nit: can this #define be kept next to the function it wraps?

> +
> +struct user_ctxs {
> +	struct fpsimd_context __user *fpsimd;
> +	struct sve_context __user *sve;
> +};
> +
> +struct frame_record {
> +	u64 fp;
> +	u64 lr;
> +};
> +struct rt_sigframe_user_layout;
> +
> +int setup_extra_context(char __user *sfp, unsigned long users, char __user *userp);
> +int __parse_user_sigcontext(struct user_ctxs *user,
> +				   struct sigcontext __user const *sc,
> +				   void __user const *sigframe_base);

[...]

> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c

[...]

> +int setup_extra_context(char __user *sfp, unsigned long users, char __user *userp)
> +{
> +	int err =0;

Nit: missing space.

Also, while "user<blah>" seemed OK as a local variable name, it now
looks rather obscure as a function parameter name, since the meaning of
the parameter is not so obvious.

"users" is really the total sigframe size, so "sf_size" may be a
reasonable name.

"extrap" might be a slightly better name for "userp", since this is not
a general-purpose cursor and must point to the base address computed for
the extra_context block.

(I'm open to better suggestions though.)

> +	struct extra_context __user *extra;
> +	struct _aarch64_ctx __user *end;
> +	u64 extra_datap;
> +	u32 extra_size;
> +
> +	extra = (struct extra_context __user *)userp;
> +	userp += EXTRA_CONTEXT_SIZE;
> +
> +	end = (struct _aarch64_ctx __user *)userp;
> +	userp += TERMINATOR_SIZE;
> +
> +	/*
> +	 * extra_datap is just written to the signal frame.
> +	 * The value gets cast back to a void __user *
> +	 * during sigreturn.
> +	 */
> +	extra_datap = (__force u64)userp;
> +	extra_size = sfp + round_up(users, 16) - userp;
> +
> +	__put_user_error(EXTRA_MAGIC, &extra->head.magic, err);
> +	__put_user_error(EXTRA_CONTEXT_SIZE, &extra->head.size, err);
> +	__put_user_error(extra_datap, &extra->datap, err);
> +	__put_user_error(extra_size, &extra->size, err);
> +
> +	/* Add the terminator */
> +	__put_user_error(0, &end->magic, err);
> +	__put_user_error(0, &end->size, err);
> +
> +	return err;
> +}

[...]

> @@ -652,39 +656,9 @@ static int setup_sigframe(struct rt_sigframe_user_layout *user,
>  		err |= preserve_sve_context(sve_ctx);
>  	}
>  
> -	if (err == 0 && user->extra_offset) {
> -		char __user *sfp = (char __user *)user->sigframe;
> -		char __user *userp =
> -			apply_user_offset(user, user->extra_offset);
> -
> -		struct extra_context __user *extra;
> -		struct _aarch64_ctx __user *end;
> -		u64 extra_datap;
> -		u32 extra_size;
> -
> -		extra = (struct extra_context __user *)userp;
> -		userp += EXTRA_CONTEXT_SIZE;
> -
> -		end = (struct _aarch64_ctx __user *)userp;
> -		userp += TERMINATOR_SIZE;
> -
> -		/*
> -		 * extra_datap is just written to the signal frame.
> -		 * The value gets cast back to a void __user *
> -		 * during sigreturn.
> -		 */
> -		extra_datap = (__force u64)userp;
> -		extra_size = sfp + round_up(user->size, 16) - userp;
> -
> -		__put_user_error(EXTRA_MAGIC, &extra->head.magic, err);
> -		__put_user_error(EXTRA_CONTEXT_SIZE, &extra->head.size, err);
> -		__put_user_error(extra_datap, &extra->datap, err);
> -		__put_user_error(extra_size, &extra->size, err);
> -
> -		/* Add the terminator */
> -		__put_user_error(0, &end->magic, err);
> -		__put_user_error(0, &end->size, err);
> -	}
> +	if (err == 0 && user->extra_offset)
> +		setup_extra_context((char *) user->sigframe, user->size,
> +			(char *) apply_user_offset(user, user->extra_offset));

Nit: no space after (type *) please.

Also, can we have (char __user *)?  This is more "correct" because these
arguments are not valid kernel pointers.  Keeping the __user may avoid
sparse warnings.  (I've not tried to build the code yet, so I don't know
whether sparse actually complains about __user being cast on and off
here.)

[...]


> From 735931121210a692038859448bf9f4ac5905eb73 Mon Sep 17 00:00:00 2001
> From: Yury Norov <ynorov@caviumnetworks.comk>
> Date: Tue, 24 May 2016 03:04:50 +0300
> Subject: [PATCH 20/24] arm64: ilp32: introduce ilp32-specific handlers for
>  sigframe and ucontext
>
> ILP32 uses AARCH32 compat structures and syscall handlers for signals.
> But ILP32 struct rt_sigframe  and ucontext differs from both LP64 and
> AARCH32. So some specific mechanism is needed to take care of it.
>
> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>

The code here looks reasonably correct, but there is a lot of
unnecessary duplication of code that should really be common.

This code is security-critical and tricky to get right, so we don't
want to have to maintain and test two independent implementations of
anything if we can possibly avoid it.

I think there may at least one change in the LP64 code that has not
been propagated here (the call to
fpsimd_signal_preserve_current_state() in setup_rt_frame()).  There
will likely be more such cases in the future.

[...]

diff --git a/arch/arm64/kernel/signal_ilp32.c b/arch/arm64/kernel/signal_ilp32.c
new file mode 100644
index 0000000..a1cb058
> --- /dev/null
> +++ b/arch/arm64/kernel/signal_ilp32.c

[...]

> +#define BASE_SIGFRAME_SIZE round_up(sizeof(struct ilp32_rt_sigframe), 16)
> +
> +struct ilp32_ucontext {
> +        u32		uc_flags;
> +        u32		uc_link;
> +        compat_stack_t  uc_stack;
> +        compat_sigset_t uc_sigmask;
> +        /* glibc uses a 1024-bit sigset_t */
> +        __u8            __unused[1024 / 8 - sizeof(compat_sigset_t)];
> +        /* last for future expansion */
> +        struct sigcontext uc_mcontext;
> +};
> +
> +struct ilp32_rt_sigframe {
> +	struct compat_siginfo info;
> +	struct ilp32_ucontext uc;
> +};
> +
> +struct ilp32_rt_sigframe_user_layout {
> +	struct ilp32_rt_sigframe __user *sigframe;

I think much of the duplication here flows from the fact that this
struct currently has a different type for ILP32 versus LP64, even
though all the important contents of the structure are equivalent for
the two cases.

Can we replace the sigframe pointer with a void __user *, or union {
	struct rt_sigframe __user *;
	struct ilp32_rt_sigframe __user *;
} ?

Putting a pointer to sigcontext in here may also help, since it
looks the same for both cases: only its location changes (I think).


This would allow us to use the same sigframe_user_layout struct for
the lp64 and ilp32 cases, which will make it easier to share code.

The __reserved[] and extra_context blocks and the records in them
should be handled identically for the two ABIs: the only thing that
should differ is the offset of __reserved[] in the complete signal
frame.


We should try hard to make as much code as possible generic here.  I
won't comment on the individual functions for now: I think they can
all be mostly or completely eliminated.

[...]

Cheers
---Dave
