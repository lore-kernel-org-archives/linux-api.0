From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v6 4/4] arm64/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed, 5 Apr 2017 11:14:34 -0700
Message-ID: <CAJcbSZGYC4cKqyYDXh9LvDctnrGZGxxTSTmtaxMAipQgZ8A-pQ@mail.gmail.com>
References: <20170404174727.35478-1-thgarnie@google.com> <20170404174727.35478-4-thgarnie@google.com>
 <20170405142225.GA9072@e104818-lin.cambridge.arm.com> <CAJcbSZFeY-1ne1cYG0zW7ETRp1MyGkz7SSMzvWckWtUS82DMqg@mail.gmail.com>
 <20170405174921.GB2752@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405174921.GB2752@e104818-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 5, 2017 at 10:49 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Wed, Apr 05, 2017 at 07:36:17AM -0700, Thomas Garnier wrote:
>> On Wed, Apr 5, 2017 at 7:22 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > On Tue, Apr 04, 2017 at 10:47:27AM -0700, Thomas Garnier wrote:
>> >> +
>> >>       ldr     x1, [tsk, #TSK_TI_FLAGS]
>> >>       and     x2, x1, #_TIF_WORK_MASK
>> >>       cbnz    x2, work_pending
>> >> @@ -779,6 +788,12 @@ finish_ret_to_user:
>> >>       kernel_exit 0
>> >>  ENDPROC(ret_to_user)
>> >>
>> >> +addr_limit_fail:
>> >> +     stp     x0, lr, [sp,#-16]!
>> >> +     bl      asm_verify_pre_usermode_state
>> >> +     ldp     x0, lr, [sp],#16
>> >> +     ret     lr
>> >
>> > Where is this supposed to return? What is the value of lr when branching
>> > to addr_limit_fail?
>>
>> It is not supposed to return. Do you think I should remove stp, ldp,
>> ret and jut add a brk 0x100 or jmp/call a break/bug function?
>
> Can you not just make addr_limit_fail a C function which never returns
> (similar to what we to with bad_mode() on arm64)? Since addr_limit_fail
> is only called when the segment is not the right one, I don't really see
> why you need another call to asm_verify_pre_usermode_state() to do a
> similar check again. Just panic in addr_limit_fail (unless I
> misunderstood what you are trying to achieve).

Calling asm_verify_pre_usermode_state has the advantage of having a
clear BUG_ON for the error (versus a panic description).

What do you think about replacing asm_verify_pre_usermode_state by a
"address_limit_fail" function that still calls
verify_pre_usermode_state but panic afterwards (because it should
never return)?

The assembly code would be easier to understand and in case of error
the BUG_ON is clear for the user.

>
> --
> Catalin



-- 
Thomas
