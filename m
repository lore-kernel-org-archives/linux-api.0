From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Fri, 30 Nov 2018 12:41:28 +0100
Message-ID: <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
 <87y39b2lm2.fsf@xmission.com> <20181130065606.kmilbbq46oeycjp5@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130065606.kmilbbq46oeycjp5@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: christian@brauner.io
Cc: "Eric W . Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 30, 2018 at 7:56 AM Christian Brauner <christian@brauner.io> wrote:
> On Thu, Nov 29, 2018 at 11:13:57PM -0600, Eric W. Biederman wrote:
> > Arnd Bergmann <arnd@arndb.de> writes:
> > > On Thu, Nov 29, 2018 at 9:14 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > >
> > > It looks like we already have a 'struct signalfd_siginfo' that is defined in a
> > > sane architecture-independent way, so I'd suggest we use that.
> >
> > Unfortunately it isn't maintained very well.  What you can
> > express with signalfd_siginfo is a subset what you can express with
> > siginfo.  Many of the linux extensions to siginfo for exception
> > information add pointers and have integers right after those pointers.
> > Not all of those linux specific extentions for exceptions are handled
> > by signalfd_siginfo (it needs new fields).

Would those fit in the 30 remaining padding bytes?

> > As originally defined siginfo had the sigval_t union at the end so it
> > was perfectly fine on both 32bit and 64bit as it only had a single
> > pointer in the structure and the other fields were 32bits in size.

The problem with sigval_t of course is that it is incompatible between
32-bit and 64-bit. We can add the same information, but at least on
the syscall level that would have to be a __u64.

> > Although I do feel the pain as x86_64 has to deal with 3 versions
> > of siginfo.  A 64bit one.  A 32bit one for ia32.  A 32bit one for x32
> > with a 64bit si_clock_t.

At least you and Al have managed to get it down to a single source-level
definition across all architectures, but there is also the (lesser) problem
that the structure has a slightly different binary layout on each of the
classic architectures.

If we go with Andy's suggestion of having only a single binary layout
on x86 for the new call, I'd argue that we should also make it have
the exact same layout on all other architectures.

> > > We may then also want to make sure that any system call that takes a
> > > siginfo has a replacement that takes a signalfd_siginfo, and that this
> > > replacement can be used to implement the old version purely in
> > > user space.
> >
> > If you are not implementing CRIU and reinserting exceptions to yourself.
> > At most user space wants the ability to implement sigqueue:
> >
> > AKA:
> > sigqueue(pid_t pid, int sig, const union sigval value);
> >
> > Well sigqueue with it's own si_codes so the following would cover all
> > the use cases I know of:
> > int sendnewsig(pid_t pid, int sig, int si_code, const union sigval value);
> >
> > The si_code could even be set to SI_USER to request that the normal
> > trusted SI_USER values be filled in.  si_code values of < 0 if not
> > recognized could reasonably safely be treated as the _rt member of
> > the siginfo union.  Or perhaps better we error out in such a case.
> >
> > If we want to be flexible and not have N kinds of system calls that
> > is the direction I would go.  That is simple, and you don't need any of
> > the rest.

I'm not sure I understand what you are suggesting here. Would the
low-level implementation of this be based on procfd, or do you
mean that would be done for pid_t at the kernel level, plus another
syscall for procfd?

> > Alternatively we abandon the mistake of sigqueueinfo and not allow
> > a signal number in the arguments that differs from the si_signo in the
> > siginfo and allow passing the entire thing unchanged from sender to
> > receiver.  That is maximum flexibility.

This would be regardless of which flavor of siginfo (today's arch
specific one, signalfd_siginfo, or a new one) we pass, right?

> > signalfd_siginfo just sucks in practice.  It is larger that siginfo 104
> > bytes versus 48.  We must deliver it to userspace as a siginfo so it
> > must be translated.  Because of the translation signalfd_siginfo adds
> > no flexiblity in practice, because it can not just be passed through.
> > Finallay signalfd_siginfo does not have encodings for all of the
> > siginfo union members, so it fails to be fully general.
> >
> > Personally if I was to define signalfd_siginfo today I would make it:
> > struct siginfo_subset {
> >       __u32 sis_signo;
> >       __s32 sis_errno;
> >       __s32 sis_code;
> >         __u32 sis_pad;
> >       __u32 sis_pid;
> >       __u32 sis_uid;
> >       __u64 sis_data (A pointer or integer data field);
> > };
> >
> > That is just 32bytes, and is all that is needed for everything
> > except for synchronous exceptions.  Oh and that happens to be a proper
> > subset of a any sane siginfo layout, on both 32bit and 64bit.

And that would work for signalfd and waitid_time64, but not for
procfd_signal/kill/sendsiginfo?

> > This is one of those rare times where POSIX is sane and what linux
> > has implemented is not.
>
> Thanks for the in-depth explanation. So your point is that we are better
> off if we stick with siginfo_t instead of struct signalfd_siginfo in
> procfd_signal()?

I think it means we still need more discussion. Using signalfd_siginfo
without further changes doesn't seem sufficient because of the missing
sigval and the excessive length adds some cost.

siginfo_t as it is now still has a number of other downsides, and Andy in
particular didn't like the idea of having three new variants on x86
(depending on how you count). His alternative suggestion of having
a single syscall entry point that takes a 'signfo_t __user *' but interprets
it as compat_siginfo depending on in_compat_syscall()/in_x32_syscall()
should work correctly, but feels wrong to me, or at least inconsistent
with how we do this elsewhere.

        Arnd
