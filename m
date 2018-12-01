From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 1 Dec 2018 09:51:18 +0100
Message-ID: <CAK8P3a1OX1Hb17=NbTYqZxgEM-sk5-dh_VeKa0bXJpq=k=KxHA@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
 <87y39b2lm2.fsf@xmission.com> <20181130065606.kmilbbq46oeycjp5@brauner.io>
 <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
 <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
 <CAK8P3a1isSRCd-OLJK15C+gSJdpeR=zEXghc8+AMM5QYYw3Tyg@mail.gmail.com> <CALCETrWcJCjNGEqgq57Bm8O3qWkfEwau2SiXAv+SNYvNmXnBCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWcJCjNGEqgq57Bm8O3qWkfEwau2SiXAv+SNYvNmXnBCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: christian@brauner.io, "Eric W . Biederman" <ebiederm@xmission.com>, Florian Weimer <fweimer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 1, 2018 at 12:54 AM Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Nov 30, 2018 at 2:10 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Fri, Nov 30, 2018 at 5:36 PM Andy Lutomirski <luto@kernel.org> wrote:
> > > On Fri, Nov 30, 2018 at 3:41 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > siginfo_t as it is now still has a number of other downsides, and Andy in
> > > > particular didn't like the idea of having three new variants on x86
> > > > (depending on how you count). His alternative suggestion of having
> > > > a single syscall entry point that takes a 'signfo_t __user *' but interprets
> > > > it as compat_siginfo depending on in_compat_syscall()/in_x32_syscall()
> > > > should work correctly, but feels wrong to me, or at least inconsistent
> > > > with how we do this elsewhere.

> > The '548 | 0x40000000' part seems to be the only sensible
> > way to handle x32 here. What exactly would you propose to
> > avoid defining the other entry points?
>
> I would propose that it should be 335 | 0x40000000.  I can't see any
> reasonable way to teach the kernel to reject 335 | 0x40000000 that
> wouldn't work just as well to accept it and make it do the right
> thing.  Currently we accept it and do the *wrong* thing, which is no
> good.
>
> > and we have to
> > add more complexity to the copy_siginfo_from_user()
> > implementation to duplicate the hack that exists in
> > copy_siginfo_from_user32().
>
> What hack are you referring to here?

I mean this part:

#ifdef CONFIG_COMPAT
int copy_siginfo_to_user32(struct compat_siginfo __user *to,
                           const struct kernel_siginfo *from)
#if defined(CONFIG_X86_X32_ABI) || defined(CONFIG_IA32_EMULATION)
{
        return __copy_siginfo_to_user32(to, from, in_x32_syscall());
}
int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
                             const struct kernel_siginfo *from, bool x32_ABI)
#endif
{
...
        case SIL_CHLD:
                new.si_pid    = from->si_pid;
                new.si_uid    = from->si_uid;
                new.si_status = from->si_status;
#ifdef CONFIG_X86_X32_ABI
                if (x32_ABI) {
                        new._sifields._sigchld_x32._utime = from->si_utime;
                        new._sifields._sigchld_x32._stime = from->si_stime;
                } else
#endif
                {
                        new.si_utime = from->si_utime;
                        new.si_stime = from->si_stime;
                }
                break;
...
}
#endif

If we have a '548 | 0x40000000' entry pointing to
__x32_compat_sys_procfd_kill, then that will do the right
thing. If you instead try to have x32 call into the native
sys_procfd_kill, then copy_siginfo_to_user() will also have
to know about x32, effectively duplicating that mess above,
unless you want to also change all users of
copy_siginfo_to_user32() to use copy_siginfo_to_user()
and handle all cases in one function.

        Arnd
