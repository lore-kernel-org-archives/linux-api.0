From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 2/3] arm64: fpsimd: Fix bad si_code for undiagnosed
 SIGFPE
Date: Thu, 08 Mar 2018 16:37:02 -0600
Message-ID: <87zi3imbxt.fsf@xmission.com>
References: <1519926248-12591-1-git-send-email-Dave.Martin@arm.com>
 <1519926248-12591-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1519926248-12591-3-git-send-email-Dave.Martin@arm.com> (Dave
 Martin's message of "Thu, 1 Mar 2018 17:44:07 +0000")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Dave Martin <Dave.Martin@arm.com> writes:

> Currently a SIGFPE delivered in response to a floating-point
> exception trap may have si_code set to 0 on arm64.  As reported by
> Eric, this is a bad idea since this is the value of SI_USER -- yet
> this signal is definitely not the result of kill(2), tgkill(2) etc.
> and si_uid and si_pid make limited sense whereas we do want to
> yield a value for si_addr (which doesn't exist for SI_USER).
>
> It's not entirely clear whether the architecure permits a
> "spurious" fp exception trap where none of the exception flag bits
> in ESR_ELx is set.  (IMHO the architectural intent is to forbid
> this.)  However, it does permit those bits to contain garbage if
> the TFV bit in ESR_ELx is 0.  That case isn't currently handled at
> all and may result in si_code == 0 or si_code containing a FPE_FLT*
> constant corresponding to an exception that did not in fact happen.
>
> There is nothing sensible we can return for si_code in such cases,
> but SI_USER is certainly not appropriate and will lead to violation
> of legitimate userspace assumptions.
>
> This patch allocates a new si_code value FPE_UNKNOWN that at least
> does not conflict with any existing SI_* or FPE_* code, and yields
> this in si_code for undiagnosable cases.  This is probably the best
> simplicity/incorrectness tradeoff achieveable without relying on
> implementation-dependent features or adding a lot of code.  In any
> case, there appears to be no perfect solution possible that would
> justify a lot of effort here.
>
> Yielding FPE_UNKNOWN when some well-defined fp exception caused the
> trap is a violation of POSIX, but this is forced by the
> architecture.  We have no realistic prospect of yielding the
> correct code in such cases.  At present I am not aware of any ARMv8
> implementation that supports trapped floating-point exceptions in
> any case.
>
> The new code may be applicable to other architectures for similar
> reasons.
>
> No attempt is made to provide ESR_ELx to userspace in the signal
> frame, since architectural limitations mean that it is unlikely to
> provide much diagnostic value, doesn't benefit existing software
> and would create ABI with no proven purpose.  The existing
> mechanism for passing it also has problems of its own which may
> result in the wrong value being passed to userspace due to
> interaction with mm faults.  The implied rework does not appear
> justified.
>
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>  arch/arm64/include/asm/esr.h          |  9 +++++++++
>  arch/arm64/include/uapi/asm/siginfo.h |  7 -------
>  arch/arm64/kernel/fpsimd.c            | 27 +++++++++++++++------------
>  3 files changed, 24 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 803443d..ce70c3f 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -240,6 +240,15 @@
>  		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
>  		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
>  
> +/*
> + * ISS field definitions for floating-point exception traps
> + * (FP_EXC_32/FP_EXC_64).
> + *
> + * (The FPEXC_* constants are used instead for common bits.)
> + */
> +
> +#define ESR_ELx_FP_EXC_TFV	(UL(1) << 23)
> +
>  #ifndef __ASSEMBLY__
>  #include <asm/types.h>
>  
> diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
> index 9b4d912..157e6a8 100644
> --- a/arch/arm64/include/uapi/asm/siginfo.h
> +++ b/arch/arm64/include/uapi/asm/siginfo.h
> @@ -22,13 +22,6 @@
>  #include <asm-generic/siginfo.h>
>  
>  /*
> - * SIGFPE si_codes
> - */
> -#ifdef __KERNEL__
> -#define FPE_FIXME	0	/* Broken dup of SI_USER */
> -#endif /* __KERNEL__ */
> -
> -/*
>   * SIGBUS si_codes
>   */
>  #ifdef __KERNEL__
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index e7226c4..9040038 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -39,6 +39,7 @@
>  #include <linux/slab.h>
>  #include <linux/sysctl.h>
>  
> +#include <asm/esr.h>
>  #include <asm/fpsimd.h>
>  #include <asm/cputype.h>
>  #include <asm/simd.h>
> @@ -867,18 +868,20 @@ asmlinkage void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
>  asmlinkage void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
>  {
>  	siginfo_t info;
> -	unsigned int si_code = FPE_FIXME;
> -
> -	if (esr & FPEXC_IOF)
> -		si_code = FPE_FLTINV;
> -	else if (esr & FPEXC_DZF)
> -		si_code = FPE_FLTDIV;
> -	else if (esr & FPEXC_OFF)
> -		si_code = FPE_FLTOVF;
> -	else if (esr & FPEXC_UFF)
> -		si_code = FPE_FLTUND;
> -	else if (esr & FPEXC_IXF)
> -		si_code = FPE_FLTRES;
> +	unsigned int si_code = FPE_FLTUNK;
> +
> +	if (esr & ESR_ELx_FP_EXC_TFV) {
> +		if (esr & FPEXC_IOF)
> +			si_code = FPE_FLTINV;
> +		else if (esr & FPEXC_DZF)
> +			si_code = FPE_FLTDIV;
> +		else if (esr & FPEXC_OFF)
> +			si_code = FPE_FLTOVF;
> +		else if (esr & FPEXC_UFF)
> +			si_code = FPE_FLTUND;
> +		else if (esr & FPEXC_IXF)
> +			si_code = FPE_FLTRES;
> +	}
>  
>  	memset(&info, 0, sizeof(info));
>  	info.si_signo = SIGFPE;
