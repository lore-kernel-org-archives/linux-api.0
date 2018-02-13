From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/3] arm64: signal: Ensure si_code is valid for
 all fault signals
Date: Tue, 13 Feb 2018 18:00:16 +0000
Message-ID: <5A8327B0.7080204@arm.com>
References: <1517338243-9749-1-git-send-email-Dave.Martin@arm.com> <1517338243-9749-4-git-send-email-Dave.Martin@arm.com> <5A82EF1F.8010701@arm.com> <20180213152207.GP5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213152207.GP5862-M5GwZQ6tE7x5pKCnmE3YQBJ8xKzm50AiAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dave,

On 13/02/18 15:22, Dave Martin wrote:
> On Tue, Feb 13, 2018 at 01:58:55PM +0000, James Morse wrote:
>> On 30/01/18 18:50, Dave Martin wrote:
>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>> index 9b7f89d..4baa922 100644
>>> --- a/arch/arm64/mm/fault.c
>>> +++ b/arch/arm64/mm/fault.c
>>> @@ -607,70 +607,70 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>> [..]
>>> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 0 (translation table walk)"	},
>>> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 1 (translation table walk)"	},
>>> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 2 (translation table walk)"	},
>>> +	{ do_sea,		SIGKILL, SI_KERNEL,	"level 3 (translation table walk)"	},
>>> +	{ do_sea,		SIGBUS,  BUS_OBJERR,	"synchronous parity or ECC error" },	// Reserved when RAS is implemented
>>
>> I agree the translation-table related external-aborts should end up with
>> SIGKILL: there is nothing user-space can do.
>>
>> You use the fault_info table to vary the signal and si_code that should be used,
>> but do_mem_abort() only uses these if the fn returns an error. For do_sea(),
>> regardless of the values in this table SIGBUS will be generated as it always
>> returns 0.
>>
>>
>>> @@ -596,7 +596,7 @@ static int do_sea(unsigned long addr, unsigned int esr,
>> struct pt_regs *regs)
>>>
>>>  	info.si_signo = SIGBUS;
>>>  	info.si_errno = 0;
>>> -	info.si_code  = 0;
>>> +	info.si_code  = BUS_OBJERR;
>>>  	if (esr & ESR_ELx_FnV)
>>>  		info.si_addr = NULL;
>>>  	else
>>
>> do_sea() has the right fault_info entry to hand, so I think these need to change
>> to inf->sig and inf->code. (I assume its not valid to set si_addr for SIGKILL...)
> 
> Yes, I guess that makes sense.
> 
> For SIGKILL, I'm assuming that it is harmless to populate si_addr: even
> though not strictly valid, the signal is never delivered to userspace.
> Even ptrace cannot see SIGKILL -- the trace just disappears and further
> ptrace calls fail with ESRCH.

Good point!


> If is matters, I guess we could prepopulate si_uid = si_pid = 0 for
> this case.  That's at least cleaner, so I might do that.
> 
> 
> For do_sea:
> 
> I was thinking of the fault_info[] table entries as for the fallback
> case only, but (a) I also try to use them to affect what do_sea() does
> (which, as you observe, doesn't work right now), and (b) there's no
> reason why they shouldn't inform what fn does.

Sure,


> However, rather than duplicate code I wonder whether we can just
> rearrange do_mem_abort() so that the lines
> 
> 	info.si_signo = inf->sig;
> 	info.si_errno = 0;
> 	info.si_code  = inf->code;
> 	info.si_addr  = (void __user *)addr;
> 
> are moved ahead of the call to inf->fn().
> 
> This would have the effect of pre-populating info with sane defaults
> while still allowing inf->fn() to override them if appropriate.

I like the idea. It's a bit strange that do_mem_abort() looks up the table entry
to call the handler, which looks up the table entry to find out what it should
do. (__do_user_fault() already does this).

This would change all of 'fn's prototypes, to save the struct-siginfo
duplication in do_sea() and __do_user_fault().

Should the 'leaf' helpers still send the signal, or update the siginfo and
return back to do_mem_abort()? Getting things like do_alignment_fault() in a
kernel stack trace is the only reason I can see...


Thanks,

James
