From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 07:54:58 +0200
Message-ID: <20170512075458.09a3a1ce@mschwideX1>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com>
 <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com>
 <20170509111007.GA14702@kroah.com>
 <CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
 <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1>
 <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, Greg KH <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?B?UmVuw6k=?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Pao
List-Id: linux-api@vger.kernel.org

On Thu, 11 May 2017 22:34:31 -0700
Kees Cook <keescook@chromium.org> wrote:

> On Thu, May 11, 2017 at 10:28 PM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> > On Thu, 11 May 2017 16:44:07 -0700
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >  
> >> On Thu, May 11, 2017 at 4:17 PM, Thomas Garnier <thgarnie@google.com> wrote:  
> >> >
> >> > Ingo: Do you want the change as-is? Would you like it to be optional?
> >> > What do you think?  
> >>
> >> I'm not ingo, but I don't like that patch. It's in the wrong place -
> >> that system call return code is too timing-critical to add address
> >> limit checks.
> >>
> >> Now what I think you *could* do is:
> >>
> >>  - make "set_fs()" actually set a work flag in the current thread flags
> >>
> >>  - do the test in the slow-path (syscall_return_slowpath).
> >>
> >> Yes, yes, that ends up being architecture-specific, but it's fairly simple.
> >>
> >> And it only slows down the system calls that actually use "set_fs()".
> >> Sure, it will slow those down a fair amount, but they are hopefully a
> >> small subset of all cases.
> >>
> >> How does that sound to people?  Thats' where we currently do that
> >>
> >>         if (IS_ENABLED(CONFIG_PROVE_LOCKING) &&
> >>             WARN(irqs_disabled(), "syscall %ld left IRQs disabled",
> >> regs->orig_ax))
> >>                 local_irq_enable();
> >>
> >> check too, which is a fairly similar issue.  
> >
> > This is exactly what Heiko did for the s390 backend as a result of this
> > discussion. See the _CIF_ASCE_SECONDARY bit in arch/s390/kernel/entry.S,
> > for the hot patch the check for the bit is included in the general
> > _CIF_WORK test. Only the slow patch gets a bit slower.
> >
> > git commit b5a882fcf146c87cb6b67c6df353e1c042b8773d
> > "s390: restore address space when returning to user space".  
> 
> If I'm understanding this, it won't catch corruption of addr_limit
> during fast-path syscalls, though (i.e. addr_limit changed without a
> call to set_fs()). :( This addr_limit corruption is mostly only a risk
> archs without THREAD_INFO_IN_TASK, but it would still be nice to catch
> unbalanced set_fs() code, so I like the idea. I like getting rid of
> addr_limit entirely even more, but that'll take some time. :)

Well for s390 there is no addr_limit as we use two separate address space
for kernel vs. user. The equivalent to the addr_limit corruption on a
fast-path syscall would be changing CR7 outside of set_fs. This boils
down to the question what we are protection against? Bad code with 
unbalanced set_fs or evil code that changes addr_limit/CR7 outside of
set_fs

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
