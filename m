From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v3 19/24] x86/cet/shstk: Introduce WRUSS instruction
Date: Fri, 31 Aug 2018 14:49:40 -0700
Message-ID: <1535752180.31230.4.camel@intel.com>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
         <20180830143904.3168-20-yu-cheng.yu@intel.com>
         <CAG48ez3uZrC-9uJ0uMoVPTtxRXRN8D+3zs5FknZD2woTT6mazg@mail.gmail.com>
         <CALCETrW78UKt6AQJeN8GkhtxjuASnH1PV5QSpzQtDz9-2d3Asw@mail.gmail.com>
         <1535646146.26689.11.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535646146.26689.11.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>
List-Id: linux-api@vger.kernel.org

On Thu, 2018-08-30 at 09:22 -0700, Yu-cheng Yu wrote:
> On Thu, 2018-08-30 at 08:55 -0700, Andy Lutomirski wrote:
> > 
> > On Thu, Aug 30, 2018 at 8:39 AM, Jann Horn <jannh@google.com>
> > wrote:
> > > 
> > > 
> > > On Thu, Aug 30, 2018 at 4:44 PM Yu-cheng Yu <yu-cheng.yu@intel.c
> > > om
> > > > 
> > > > wrote:
> > > > 
> > > > 
> > > > WRUSS is a new kernel-mode instruction but writes directly
> > > > to user shadow stack memory.  This is used to construct
> > > > a return address on the shadow stack for the signal
> > > > handler.
> > > > 
> > > > This instruction can fault if the user shadow stack is
> > > > invalid shadow stack memory.  In that case, the kernel does
> > > > fixup.
> > > > 
> > > > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> > > [...]
> > > > 
> > > > 
> > > > +static inline int write_user_shstk_64(unsigned long addr,
> > > > unsigned long val)
> > > > +{
> > > > +       int err = 0;
> > > > +
> > > > +       asm volatile("1: wrussq %1, (%0)\n"
> > > > +                    "2:\n"
> > > > +                    _ASM_EXTABLE_HANDLE(1b, 2b,
> > > > ex_handler_wruss)
> > > > +                    :
> > > > +                    : "r" (addr), "r" (val));
> > > > +
> > > > +       return err;
> > > > +}
> > > What's up with "err"? You set it to zero, and then you return
> > > it,
> > > but
> > > nothing can ever set it to non-zero, right?
> > > 
> > > > 
> > > > 
> > > > +__visible bool ex_handler_wruss(const struct
> > > > exception_table_entry *fixup,
> > > > +                               struct pt_regs *regs, int
> > > > trapnr)
> > > > +{
> > > > +       regs->ip = ex_fixup_addr(fixup);
> > > > +       regs->ax = -1;
> > > > +       return true;
> > > > +}
> > > And here you just write into regs->ax, but your "asm volatile"
> > > doesn't
> > > reserve that register. This looks wrong to me.
> > > 
> > > I think you probably want to add something like an explicit
> > > `"+&a"(err)` output to the asm statements.
> > We require asm goto support these days.  How about using
> > that?  You
> > won't even need a special exception handler.

Maybe something like this?  It looks simple now.

static inline int write_user_shstk_64(unsigned long addr, unsigned
long val)
{
	asm_volatile_goto("wrussq %1, (%0)\n"
		     "jmp %l[ok]\n"
		     ".section .fixup,\"ax\"n"
		     "jmp %l[fail]\n"
		     ".previous\n"
		     :: "r" (addr), "r" (val)
		     :: ok, fail);
ok:
	return 0;
fail:
	return -1;
}
