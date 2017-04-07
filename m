From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 4/4] arm64/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Fri, 7 Apr 2017 17:11:59 +0100
Message-ID: <20170407161159.GB20645@e104818-lin.cambridge.arm.com>
References: <20170404174727.35478-1-thgarnie@google.com>
 <20170404174727.35478-4-thgarnie@google.com>
 <20170405142225.GA9072@e104818-lin.cambridge.arm.com>
 <CAJcbSZFeY-1ne1cYG0zW7ETRp1MyGkz7SSMzvWckWtUS82DMqg@mail.gmail.com>
 <20170405174921.GB2752@e104818-lin.cambridge.arm.com>
 <CAJcbSZGYC4cKqyYDXh9LvDctnrGZGxxTSTmtaxMAipQgZ8A-pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-7296-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZGYC4cKqyYDXh9LvDctnrGZGxxTSTmtaxMAipQgZ8A-pQ@mail.gmail.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Brian Gerst <brgerst@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Heiko Carstens <heiko.carstens@de.ibm.com>, Borislav Petkov <bp@alien8.de>, Al
List-Id: linux-api@vger.kernel.org

On Wed, Apr 05, 2017 at 11:14:34AM -0700, Thomas Garnier wrote:
> On Wed, Apr 5, 2017 at 10:49 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Wed, Apr 05, 2017 at 07:36:17AM -0700, Thomas Garnier wrote:
> >> On Wed, Apr 5, 2017 at 7:22 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >> > On Tue, Apr 04, 2017 at 10:47:27AM -0700, Thomas Garnier wrote:
> >> >> +
> >> >>       ldr     x1, [tsk, #TSK_TI_FLAGS]
> >> >>       and     x2, x1, #_TIF_WORK_MASK
> >> >>       cbnz    x2, work_pending
> >> >> @@ -779,6 +788,12 @@ finish_ret_to_user:
> >> >>       kernel_exit 0
> >> >>  ENDPROC(ret_to_user)
> >> >>
> >> >> +addr_limit_fail:
> >> >> +     stp     x0, lr, [sp,#-16]!
> >> >> +     bl      asm_verify_pre_usermode_state
> >> >> +     ldp     x0, lr, [sp],#16
> >> >> +     ret     lr
> >> >
> >> > Where is this supposed to return? What is the value of lr when branching
> >> > to addr_limit_fail?
> >>
> >> It is not supposed to return. Do you think I should remove stp, ldp,
> >> ret and jut add a brk 0x100 or jmp/call a break/bug function?
> >
> > Can you not just make addr_limit_fail a C function which never returns
> > (similar to what we to with bad_mode() on arm64)? Since addr_limit_fail
> > is only called when the segment is not the right one, I don't really see
> > why you need another call to asm_verify_pre_usermode_state() to do a
> > similar check again. Just panic in addr_limit_fail (unless I
> > misunderstood what you are trying to achieve).
> 
> Calling asm_verify_pre_usermode_state has the advantage of having a
> clear BUG_ON for the error (versus a panic description).
> 
> What do you think about replacing asm_verify_pre_usermode_state by a
> "address_limit_fail" function that still calls
> verify_pre_usermode_state but panic afterwards (because it should
> never return)?
> 
> The assembly code would be easier to understand and in case of error
> the BUG_ON is clear for the user.

It looks fine to me, though I'd have to see the patch.

-- 
Catalin
