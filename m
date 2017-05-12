From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 12:01:59 -0700
Message-ID: <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com> <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com> <20170509111007.GA14702@kroah.com>
 <CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
 <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1> <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512075458.09a3a1ce@mschwideX1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>Pa
List-Id: linux-api@vger.kernel.org

On Thu, May 11, 2017 at 10:54 PM, Martin Schwidefsky
<schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 11 May 2017 22:34:31 -0700
> Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>
>> On Thu, May 11, 2017 at 10:28 PM, Martin Schwidefsky
>> <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Thu, 11 May 2017 16:44:07 -0700
>> > Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>> >
>> >> On Thu, May 11, 2017 at 4:17 PM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> >> >
>> >> > Ingo: Do you want the change as-is? Would you like it to be optional?
>> >> > What do you think?
>> >>
>> >> I'm not ingo, but I don't like that patch. It's in the wrong place -
>> >> that system call return code is too timing-critical to add address
>> >> limit checks.
>> >>
>> >> Now what I think you *could* do is:
>> >>
>> >>  - make "set_fs()" actually set a work flag in the current thread flags
>> >>
>> >>  - do the test in the slow-path (syscall_return_slowpath).
>> >>
>> >> Yes, yes, that ends up being architecture-specific, but it's fairly simple.
>> >>
>> >> And it only slows down the system calls that actually use "set_fs()".
>> >> Sure, it will slow those down a fair amount, but they are hopefully a
>> >> small subset of all cases.
>> >>
>> >> How does that sound to people?  Thats' where we currently do that
>> >>
>> >>         if (IS_ENABLED(CONFIG_PROVE_LOCKING) &&
>> >>             WARN(irqs_disabled(), "syscall %ld left IRQs disabled",
>> >> regs->orig_ax))
>> >>                 local_irq_enable();
>> >>
>> >> check too, which is a fairly similar issue.
>> >
>> > This is exactly what Heiko did for the s390 backend as a result of this
>> > discussion. See the _CIF_ASCE_SECONDARY bit in arch/s390/kernel/entry.S,
>> > for the hot patch the check for the bit is included in the general
>> > _CIF_WORK test. Only the slow patch gets a bit slower.
>> >
>> > git commit b5a882fcf146c87cb6b67c6df353e1c042b8773d
>> > "s390: restore address space when returning to user space".
>>
>> If I'm understanding this, it won't catch corruption of addr_limit
>> during fast-path syscalls, though (i.e. addr_limit changed without a
>> call to set_fs()). :( This addr_limit corruption is mostly only a risk
>> archs without THREAD_INFO_IN_TASK, but it would still be nice to catch
>> unbalanced set_fs() code, so I like the idea. I like getting rid of
>> addr_limit entirely even more, but that'll take some time. :)
>
> Well for s390 there is no addr_limit as we use two separate address space
> for kernel vs. user. The equivalent to the addr_limit corruption on a
> fast-path syscall would be changing CR7 outside of set_fs. This boils
> down to the question what we are protection against? Bad code with
> unbalanced set_fs or evil code that changes addr_limit/CR7 outside of
> set_fs

Yeah, the risk for "corrupted addr_limit" is mainly a concern for
archs with addr_limit on the kernel stack. If I'm reading things
correctly, that means, from the archs I've been paying closer
attention to, it's an issue for arm, mips, and powerpc:

arch/arm/include/asm/uaccess.h: current_thread_info()->addr_limit = fs;
arch/arm/include/asm/thread_info.h:             (current_stack_pointer
& ~(THREAD_SIZE - 1));

arch/mips/include/asm/uaccess.h:#define set_fs(x)
(current_thread_info()->addr_limit = (x))
arch/mips/kernel/process.c:        * task stacks at THREAD_SIZE - 32

arch/powerpc/include/asm/uaccess.h:#define set_fs(val)
(current->thread.fs = (val))
arch/powerpc/kernel/process.c:          struct pt_regs *regs =
task_stack_page(current) + THREAD_SIZE;

(s390 uses a register, x86 and arm64 implement THREAD_INFO_IN_TASK.)
Targeting addr_limit through arbitrary write attacks isn't too common
since ... it's an arbitrary write. The issue with addr_limit was that
it can live on the kernel stack, which meant all kinds of
stack-related bugs can lead to it getting stomped on.

So, two goals to protect addr_limit:

- get it off the stack to make the difficulty of corruption on par
with other sensitive things that would require an arbitrary write
flaw.

- detect/block unbalanced set_fs() calls.

If we can get the former addressed by the remaining architectures,
then that class of attack will go away. For the latter, it sounds like
Linus's slowpath-exit will work nicely.

To me it looks like he architectures with addr_limit still on the
stack would still benefit from always-check-addr_limit on syscall
exit, but that would be arch-specific anyway.

And then, of course, we've got the parallel task of just removing
set_fs() entirely. :)

-Kees

-- 
Kees Cook
Pixel Security
