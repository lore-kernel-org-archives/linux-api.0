From: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH v2 3/3] arm64: signal: Ensure si_code is valid for
 all fault signals
Date: Tue, 13 Feb 2018 13:58:55 +0000
Message-ID: <5A82EF1F.8010701@arm.com>
References: <1517338243-9749-1-git-send-email-Dave.Martin@arm.com> <1517338243-9749-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1517338243-9749-4-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

Hi Dave,

On 30/01/18 18:50, Dave Martin wrote:
> Currently, as reported by Eric, an invalid si_code value 0 is
> passed in many signals delivered to userspace in response to faults
> and other kernel errors.  Typically 0 is passed when the fault is
> insufficiently diagnosable or when there does not appear to be any
> sensible alternative value to choose.
> 
> This appears to violate POSIX, and is intuitively wrong for at
> least two reasons arising from the fact that 0 == SI_USER:
> 
>  1) si_code is a union selector, and SI_USER (and si_code <= 0 in
>     general) implies the existence of a different set of fields
>     (siginfo._kill) from that which exists for a fault signal
>     (siginfo._sigfault).  However, the code raising the signal
>     typically writes only the _sigfault fields, and the _kill
>     fields make no sense in this case.
> 
>     Thus when userspace sees si_code == 0 (SI_USER) it may
>     legitimately inspect fields in the inactive union member _kill
>     and obtain garbage as a result.
> 
>     There appears to be software in the wild relying on this,
>     albeit generally only for printing diagnostic messages.
> 
>  2) Software that wants to be robust against spurious signals may
>     discard signals where si_code == SI_USER (or <= 0), or may
>     filter such signals based on the si_uid and si_pid fields of
>     siginfo._sigkill.  In the case of fault signals, this means
>     that important (and usually fatal) error conditions may be
>     silently ignored.
> 
> In practice, many of the faults for which arm64 passes si_code == 0
> are undiagnosable conditions such as exceptions with syndrome
> values in ESR_ELx to which the architecture does not yet assign any
> meaning, or conditions indicative of a bug or error in the kernel
> or system and thus that are unrecoverable and should never occur in
> normal operation.
> 
> The approach taken in this patch is to translate all such
> undiagnosable or "impossible" synchronous fault conditions to
> SIGKILL, since these are at least probably localisable to a single
> process.  Some of these conditions should really result in a kernel
> panic, but due to the lack of diagnostic information it is
> difficult to be certain: this patch does not add any calls to
> panic(), but this could change later if justified.
> 
> Although si_code will not reach userspace in the case of SIGKILL,
> it is still desirable to pass a nonzero value so that the common
> siginfo handling code can detect incorrect use of si_code == 0
> without false positives.  In this case the si_code dependent
> siginfo fields will not be correctly initialised, but since they
> are not passed to userspace I deem this not to matter.
> 
> A few faults can reasonably occur in realistic userspace scenarios,
> and _should_ raise a regular, handleable (but perhaps not
> ignorable/blockable) signal: for these, this patch attempts to
> choose a suitable standard si_code value for the raised signal in
> each case instead of 0.


> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 9b7f89d..4baa922 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -607,70 +607,70 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
[..]
> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 0 (translation table walk)"	},
> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 1 (translation table walk)"	},
> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 2 (translation table walk)"	},
> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 3 (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  BUS_OBJERR,	"synchronous parity or ECC error" },	// Reserved when RAS is implemented

I agree the translation-table related external-aborts should end up with
SIGKILL: there is nothing user-space can do.

You use the fault_info table to vary the signal and si_code that should be used,
but do_mem_abort() only uses these if the fn returns an error. For do_sea(),
regardless of the values in this table SIGBUS will be generated as it always
returns 0.


> @@ -596,7 +596,7 @@ static int do_sea(unsigned long addr, unsigned int esr,
struct pt_regs *regs)
>
>  	info.si_signo = SIGBUS;
>  	info.si_errno = 0;
> -	info.si_code  = 0;
> +	info.si_code  = BUS_OBJERR;
>  	if (esr & ESR_ELx_FnV)
>  		info.si_addr = NULL;
>  	else

do_sea() has the right fault_info entry to hand, so I think these need to change
to inf->sig and inf->code. (I assume its not valid to set si_addr for SIGKILL...)


Thanks,

James
