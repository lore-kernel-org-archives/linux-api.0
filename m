From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Thu, 29 Nov 2018 20:55:55 +0100
Message-ID: <20181129195551.woe2bl3z3yaysqb6@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io>
 <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
 <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Florian Weimer <fweimer@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 29, 2018 at 11:22:58AM -0800, Andy Lutomirski wrote:
> On Thu, Nov 29, 2018 at 11:17 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > On November 30, 2018 5:54:18 AM GMT+13:00, Andy Lutomirski <luto@amacapital.net> wrote:
> > >
> > >
> > >> On Nov 29, 2018, at 4:28 AM, Florian Weimer <fweimer@redhat.com>
> > >wrote:
> > >>
> > >> Disclaimer: I'm looking at this patch because Christian requested it.
> > >> I'm not a kernel developer.
> > >>
> > >> * Christian Brauner:
> > >>
> > >>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl
> > >b/arch/x86/entry/syscalls/syscall_32.tbl
> > >>> index 3cf7b533b3d1..3f27ffd8ae87 100644
> > >>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> > >>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> > >>> @@ -398,3 +398,4 @@
> > >>> 384    i386    arch_prctl        sys_arch_prctl
> > >__ia32_compat_sys_arch_prctl
> > >>> 385    i386    io_pgetevents        sys_io_pgetevents
> > >__ia32_compat_sys_io_pgetevents
> > >>> 386    i386    rseq            sys_rseq            __ia32_sys_rseq
> > >>> +387    i386    procfd_signal        sys_procfd_signal
> > >__ia32_compat_sys_procfd_signal
> > >>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
> > >b/arch/x86/entry/syscalls/syscall_64.tbl
> > >>> index f0b1709a5ffb..8a30cde82450 100644
> > >>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> > >>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> > >>> @@ -343,6 +343,7 @@
> > >>> 332    common    statx            __x64_sys_statx
> > >>> 333    common    io_pgetevents        __x64_sys_io_pgetevents
> > >>> 334    common    rseq            __x64_sys_rseq
> > >>> +335    64    procfd_signal        __x64_sys_procfd_signal
> > >>>
> > >>> #
> > >>> # x32-specific system call numbers start at 512 to avoid cache
> > >impact
> > >>> @@ -386,3 +387,4 @@
> > >>> 545    x32    execveat        __x32_compat_sys_execveat/ptregs
> > >>> 546    x32    preadv2            __x32_compat_sys_preadv64v2
> > >>> 547    x32    pwritev2        __x32_compat_sys_pwritev64v2
> > >>> +548    x32    procfd_signal        __x32_compat_sys_procfd_signal
> > >>
> > >> Is there a reason why these numbers have to be different?
> > >>
> > >> (See the recent discussion with Andy Lutomirski.)
> > >
> > >Hah, I missed this part of the patch.  Let’s not add new x32 syscall
> > >numbers.
> > >
> > >Also, can we perhaps rework this a bit to get rid of the compat entry
> > >point?  The easier way would be to check in_compat_syscall(). The nicer
> > >way IMO would be to use the 64-bit structure for 32-bit as well.
> >
> > Do you have a syscall which set precedence/did this before I could look at?
> > Just if you happen to remember one.
> > Fwiw, I followed the other signal syscalls.
> > They all introduce compat syscalls.
> >
> 
> Not really.
> 
> Let me try to explain.  I have three issues with the approach in your patchset:
> 
> 1. You're introducing a new syscall, and it behaves differently on
> 32-bit and 64-bit because the structure you pass in is different.
> This is necessary for old syscalls where compatibility matters, but
> maybe we can get rid of it for new syscalls.   Could we define a
> siginfo64_t that is identical to the 64-bit siginfo_t and just use
> that in all cases?
> 
> 2. Assuming that #1 doesn't work, then we need compat support.  But
> you're doing it by having two different entry points.  Instead, you
> could have a single entry point that calls in_compat_syscall() to
> decide which structure to read.  This would simplify things because
> x86 doesn't really support the separate compat entry points, which
> leads me to #3.
> 
> 3. The separate x32 numbers are a huge turd that may have security
> holes and certainly have comprehensibility holes.  I will object to
> any patch that adds a new one (like yours).  Fixing #1 or #2 makes
> this problem go away.
> 
> Does that make any sense?  The #2 fix would be something like:
> 
> if (in_compat_syscall)
>   copy...user32();
> else
>   copy_from_user();
> 
> The #1 fix would add a copy_siginfo_from_user64() or similar.

Thanks very much! That all helped a bunch already! I'll try to go the
copy_siginfo_from_user64() way first and see if I can make this work. If
we do this I would however only want to use it for the new syscall first
and not change all other signal syscalls over to it too. I'd rather keep
this patchset focussed and small and do such conversions caused by the
new approach later. Does that sound reasonable?
