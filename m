From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Fri, 30 Nov 2018 15:05:36 -0800
Message-ID: <CAKOZuesEPFnkd7YGbu82TRQwhR=KPwNW8GpYTw=719_xmJx9FA@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
 <87y39b2lm2.fsf@xmission.com> <20181130065606.kmilbbq46oeycjp5@brauner.io>
 <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
 <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
 <CAK8P3a1isSRCd-OLJK15C+gSJdpeR=zEXghc8+AMM5QYYw3Tyg@mail.gmail.com> <EC87B1BE-BDD0-414F-85F8-806C3CC4DD07@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EC87B1BE-BDD0-414F-85F8-806C3CC4DD07@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Florian Weimer <fweimer@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 30, 2018 at 2:26 PM Christian Brauner <christian@brauner.io> wrote:
>
> On December 1, 2018 11:09:58 AM GMT+13:00, Arnd Bergmann <arnd@arndb.de> wrote:
> >On Fri, Nov 30, 2018 at 5:36 PM Andy Lutomirski <luto@kernel.org>
> >wrote:
> >>
> >> On Fri, Nov 30, 2018 at 3:41 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >> > siginfo_t as it is now still has a number of other downsides, and
> >Andy in
> >> > particular didn't like the idea of having three new variants on x86
> >> > (depending on how you count). His alternative suggestion of having
> >> > a single syscall entry point that takes a 'signfo_t __user *' but
> >interprets
> >> > it as compat_siginfo depending on
> >in_compat_syscall()/in_x32_syscall()
> >> > should work correctly, but feels wrong to me, or at least
> >inconsistent
> >> > with how we do this elsewhere.
> >>
> >> If everyone else is okay with it, I can get on board with three
> >> variants on x86.  What I can't get on board with is *five* variants
> >on
> >> x86, which would be:
> >>
> >> procfd_signal via int80 / the 32-bit vDSO: the ia32 structure
> >>
> >> syscall64 with nr == 335 (presumably): 64-bit
> >
> >These seem unavoidable
> >
> >> syscall64 with nr == 548 | 0x40000000: x32
> >>
> >> syscall64 with nr == 548: 64-bit entry but in_compat_syscall() ==
> >> true, behavior is arbitrary
> >>
> >> syscall64 with nr == 335 | 0x40000000: x32 entry, but
> >> in_compat_syscall() == false, behavior is arbitrary
> >
> >Am I misreading the code? The way I understand it, setting the
> >0x40000000 bit means that both in_compat_syscall() and
> >in_x32_syscall become() true, based on
> >
> >static inline bool in_x32_syscall(void)
> >{
> >#ifdef CONFIG_X86_X32_ABI
> >        if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
> >                return true;
> >#endif
> >        return false;
> >}
> >
> >The '548 | 0x40000000' part seems to be the only sensible
> >way to handle x32 here. What exactly would you propose to
> >avoid defining the other entry points?
> >
> >> This mess isn't really Christian's fault -- it's been there for a
> >> while, but it's awful and I don't think we want to perpetuate it.
> >
> >I'm not convinced that not assigning an x32 syscall number
> >improves the situation, it just means that we now have one
> >syscall that behaves completely differently from all others,
> >in that the x32 version requires being called through a
> >SYSCALL_DEFINE() entry point rather than a
> >COMPAT_SYSCALL_DEFINE() one, and we have to
> >add more complexity to the copy_siginfo_from_user()
> >implementation to duplicate the hack that exists in
> >copy_siginfo_from_user32().
> >
> >Of course, the nicest option would be to completely remove
> >x32 so we can stop worrying about it.
>
> One humble point I would like to make is that what I care about most is a sensible way forward without having to redo essential parts of how syscalls work.
> I don't want to introduce a sane, small syscall that ends up breaking all over the place because we decided to fix past mistakes that technically have nothing to do with the patch itself.
> However, I do sympathize and understand these concerns.

IMHO, it's fine to just replicate all the splits we have for the
existing signal system calls. It's ugly, but once it's done, it'll be
done for a long time. I can't see a need to add even more signal
system calls after this one.
