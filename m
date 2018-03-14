From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] x86: always use SYSCALL_DEFINE*
Date: Wed, 14 Mar 2018 06:48:02 +0100
Message-ID: <20180314054802.GC8354@light.dominikbrodowski.net>
References: <14A5C8D0-3F9D-486F-A20C-55849D70FC80@amazon.com>
 <CAG48ez1RBhBbH8jHwseeZMQwdKciLdjYhoy3O9yDs8WEpMk2TQ@mail.gmail.com>
 <CALCETrXh7BLrv4AsQm-Vpwmd=ttnGWQXV6dAxxi3GVevxnMO7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXh7BLrv4AsQm-Vpwmd=ttnGWQXV6dAxxi3GVevxnMO7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, "Tautschnig, Michael" <tautschn@amazon.co.uk>
Cc: Jann Horn <jannh@google.com>, "x86@kernel.org" <x86@kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jaswinder Singh <jaswinder@infradead.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Michael,

On Tue, Mar 13, 2018 at 11:18:08PM +0000, Andy Lutomirski wrote:
> On Tue, Mar 13, 2018 at 9:16 PM, Jann Horn <jannh@google.com> wrote:
> > On Sat, Mar 10, 2018 at 12:55 PM, Tautschnig, Michael
> > <tautschn@amazon.co.uk> wrote:
> >> All syscall arguments are passed in as types of the same byte size as
> >> unsigned long (width of full registers). Using a smaller type without a
> >> cast may result in losing bits of information. SYSCALL_DEFINE* introduce
> >> adequate type casts. All definitions of syscalls in x86 except for those
> >> patched here have already been using the appropriate SYSCALL_DEFINE*.
> > [...]
> >> diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
> >> index 2f72330..d98b2a3 100644
> >> --- a/arch/x86/kernel/ioport.c
> >> +++ b/arch/x86/kernel/ioport.c
> >> @@ -23,7 +23,8 @@
> >>  /*
> >>   * this changes the io permissions bitmap in the current task.
> >>   */
> >> -asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
> >> +SYSCALL_DEFINE3(sys_ioperm, unsigned long, from, unsigned long, num, int,
> >> +               turn_on)
> >
> > Shouldn't this be "SYSCALL_DEFINE3(ioperm, [...]", without the "sys_"?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-api" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I think this patch will be obsoleted by a series of patches from Dominik.

... the ioperm change is already in mainline (did an equivalent change a
couple of days ago), but the sigreturn/rt_sigreturn changes still seem
useful. Could you send a fresh patch with just these two changes; and -- if
the x86 maintainers agree -- I will push it with my syscall-related changes?

Thanks,
	Dominik
