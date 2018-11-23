From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Fri, 23 Nov 2018 12:15:39 -0800
Message-ID: <CAKOZuesFZqstO-9K2tLQ1sOOmYsN73QdTHNG0De0a=eq5BT99w@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <87efbbvrx9.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87efbbvrx9.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 23, 2018 at 5:34 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Daniel Colascione:
>
> > On Mon, Nov 12, 2018 at 12:11 AM, Florian Weimer <fweimer@redhat.com> wrote:
> >> * Daniel Colascione:
> >>
> >>> If the kernel provides a system call, libc should provide a C wrapper
> >>> for it, even if in the opinion of the libc maintainers, that system
> >>> call is flawed.
> >>
> >> It's not that simple, I think.  What about bdflush?  socketcall?
> >> getxpid?  osf_gettimeofday?  set_robust_list?
> >
> > What about them? Mentioning that these system calls exist is not in
> > itself an argument.
>
> But socketcall does not exist on all architectures.  Neither does
> getpid, it's called getxpid on some architectures.

So what? On systems on which a given system call does not exist,
attempts to link against that system call should fail, or attempts to
make that system call should fail at runtime with ENOSYS. That's
completely expected and unsurprising behavior, not some unavoidable
source of catastrophic confusion.

> >> There are quite a few irregularities
> >
> > So?
>
> I think it would be a poor approach to expose application developers to
> these portability issues.  We need to abstract over these differences at
> a certain layer, and applications are too late.

And glibc is too early. The purpose of the lowest-level user library
is not to provide an OS-agnostic portability layer. There are other
projects much better-suited to providing portability, including the
excellent GLib, Gnulib, and Qt. The purpose of the lowest-level user
library is to expose the interfaces of the underlying system, whatever
they are. That's a basic tenet of layered interface design.

Due to historical accident, the same library (on most Linux systems)
serves as both the lowest-level user library and an implementation of
some antiquated portability constructs from ANSI C and POSIX. That
this library provides these old portability interfaces is not a reason
for that library to neglect its responsibility as the lowest-level
system interface library. If people find that every attempt to expose
even trivial new kernel interfaces turns into an endless trek through
a swamp of specious objection (see the gettid debacle), then it
becomes perfectly reasonable to find an alternate route over firmer
ground.

Other glibc developers (e.g., Joseph Myers) have expressed support for
adding long-missing system call wrappers, like gettid, as long as the
functions are adequately documented. Would you make a sustained
objection to these additions?

> >> and some editorial discretion appears to be unavoidable.
> >
> > That's an assertion, not an argument, and I strongly disagree. *Why*
> > do you think "editorial discretion" is unavoidable?
>
> We do not want application authors to write code which uses socketcall,

That's an opinion on portability, not an argument for the necessity of
"editorial discretion". That you think an application calling
socketcall would somehow be a bad idea is not a justification for not
providing this interface. Low-level libraries must focus on mechanism,
not policy, if a system is to be flexible enough to accommodate
unanticipated needs.
