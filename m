From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 3/3] arm64: signal: Ensure si_code is valid for
 all fault signals
Date: Tue, 13 Feb 2018 15:22:08 +0000
Message-ID: <20180213152207.GP5862@e103592.cambridge.arm.com>
References: <1517338243-9749-1-git-send-email-Dave.Martin@arm.com>
 <1517338243-9749-4-git-send-email-Dave.Martin@arm.com>
 <5A82EF1F.8010701@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5A82EF1F.8010701@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 13, 2018 at 01:58:55PM +0000, James Morse wrote:
> Hi Dave,
> 
> On 30/01/18 18:50, Dave Martin wrote:

[...]

> > The approach taken in this patch is to translate all such
> > undiagnosable or "impossible" synchronous fault conditions to
> > SIGKILL, since these are at least probably localisable to a single
> > process.  Some of these conditions should really result in a kernel
> > panic, but due to the lack of diagnostic information it is
> > difficult to be certain: this patch does not add any calls to
> > panic(), but this could change later if justified.
> > 
> > Although si_code will not reach userspace in the case of SIGKILL,
> > it is still desirable to pass a nonzero value so that the common
> > siginfo handling code can detect incorrect use of si_code == 0
> > without false positives.  In this case the si_code dependent
> > siginfo fields will not be correctly initialised, but since they
> > are not passed to userspace I deem this not to matter.
> > 
> > A few faults can reasonably occur in realistic userspace scenarios,
> > and _should_ raise a regular, handleable (but perhaps not
> > ignorable/blockable) signal: for these, this patch attempts to
> > choose a suitable standard si_code value for the raised signal in
> > each case instead of 0.
> 
> 
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index 9b7f89d..4baa922 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -607,70 +607,70 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
> [..]
> > +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 0 (translation table walk)"	},
> > +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 1 (translation table walk)"	},
> > +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 2 (translation table walk)"	},
> > +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 3 (translation table walk)"	},
> > +	{ do_sea,		SIGBUS,  BUS_OBJERR,	"synchronous parity or ECC error" },	// Reserved when RAS is implemented
> 
> I agree the translation-table related external-aborts should end up with
> SIGKILL: there is nothing user-space can do.
> 
> You use the fault_info table to vary the signal and si_code that should be used,
> but do_mem_abort() only uses these if the fn returns an error. For do_sea(),
> regardless of the values in this table SIGBUS will be generated as it always
> returns 0.
> 
> 
> > @@ -596,7 +596,7 @@ static int do_sea(unsigned long addr, unsigned int esr,
> struct pt_regs *regs)
> >
> >  	info.si_signo = SIGBUS;
> >  	info.si_errno = 0;
> > -	info.si_code  = 0;
> > +	info.si_code  = BUS_OBJERR;
> >  	if (esr & ESR_ELx_FnV)
> >  		info.si_addr = NULL;
> >  	else
> 
> do_sea() has the right fault_info entry to hand, so I think these need to change
> to inf->sig and inf->code. (I assume its not valid to set si_addr for SIGKILL...)

Yes, I guess that makes sense.

For SIGKILL, I'm assuming that it is harmless to populate si_addr: even
though not strictly valid, the signal is never delivered to userspace.
Even ptrace cannot see SIGKILL -- the trace just disappears and further
ptrace calls fail with ESRCH.

If is matters, I guess we could prepopulate si_uid = si_pid = 0 for
this case.  That's at least cleaner, so I might do that.


For do_sea:

I was thinking of the fault_info[] table entries as for the fallback
case only, but (a) I also try to use them to affect what do_sea() does
(which, as you observe, doesn't work right now), and (b) there's no
reason why they shouldn't inform what fn does.

So I think you're right.

However, rather than duplicate code I wonder whether we can just
rearrange do_mem_abort() so that the lines

	info.si_signo = inf->sig;
	info.si_errno = 0;
	info.si_code  = inf->code;
	info.si_addr  = (void __user *)addr;

are moved ahead of the call to inf->fn().

This would have the effect of pre-populating info with sane defaults
while still allowing inf->fn() to override them if appropriate.

Thoughts?


Cheers
---Dave
