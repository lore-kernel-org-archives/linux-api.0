From: Zack Weinberg <zackw@panix.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 12:24:08 -0500
Message-ID: <CAKCAbMiHC9r54h=XeW7CkBZ1Z5eHr9MPH3Rn7KTc9DjoHG=8UA@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97167-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
To: dancol@google.com
Cc: Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, joelaf@google.com, linux-api@vger.kernel.org, w@1wt.eu, vbabka@suse.cz, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

Daniel Colascione <dancol@google.com> wrote:
> >> If the kernel provides a system call, libc should provide a C wrapper
> >> for it, even if in the opinion of the libc maintainers, that system
> >> call is flawed.

I would like to state general support for this principle; in fact, I
seriously considered preparing patches that made exactly this change,
about a year ago, posting them, and calling for objections.  Then
$dayjob ate all my hacking time (and is still doing so, alas).

Nonetheless I do think there are exceptions, such as those that are
completely obsolete (bdflush, socketcall) and those that cannot be
used without stomping on glibc's own data structures (set_robust_list
is the only one of these I know about off the top of my head, but
there may well be others).

Daniel Colascione <dancol@google.com> wrote:
> We can learn something from how Windows does things. On that system,
> what we think of as "libc" is actually two parts. (More, actually, but
> I'm simplifying.) At the lowest level, you have the semi-documented
> ntdll.dll, which contains raw system call wrappers and arcane
> kernel-userland glue. On top of ntdll live the "real" libc
> (msvcrt.dll, kernel32.dll, etc.) that provide conventional
> application-level glue.

This is an appealing idea at first sight; there are several other
constituencies for it besides frustrated kernel hackers, such as
alternative system programming languages (Rust, Go) that want to
minimize dependencies on legacy "C library" functionality.   If we
could find a clean way to do it, I would support it.

The trouble is that "raw system call wrappers and arcane
kernel-userland glue" turns out to be a lot more code, with a lot more
tentacles in both directions, than you might think.  If you compare
the sizes of the text sections of `ntdll.dll` and `libc.so.6` you will
notice that the former is _bigger_.  The reason for this, as far as I
can determine (without any access to Microsoft's internal
documentation or source code ;-) is that ntdll.dll contains the
dynamic linker-equivalent, a basic memory allocator, the stack
unwinder, and a good chunk of the core thread library. (It also has
stuff in it that's needed by programs that run early during boot and
can't use kernel32.dll, but that's not our problem.)  I don't think
this is an accident or an engineering compromise.  It is necessary for
the dynamic loader to understand threads, and the thread library to
understand shared library semantics.  It is necessary for both of
those components to allocate memory.  And both of those components are
naturally tightly coupled to the kernel, and in particular they have
to be up and running from the first user-space instruction executed in
a new process, so it's natural to put them in the component that is
responsible for talking directly to the kernel.

But the _consequence_ of this design is, ntdll.dll defines the
semantics of shared library loading, and the semantics of threads, for
the entire system.  A hypothetical equivalent liblinuxabi.so.1 would
have to do the same.  And that means you wouldn't get as much
decoupling from the C and POSIX standards -- both of which specify at
least part of those semantics -- as you want, and we would still be
having these arguments.  For example, it would be every bit as
troublesome for liblinuxabi.so.1 to export set_robust_list as it would
be for libc.so.6 to do that.

You might be able to get out of most of the tangle by putting the
dynamic loader in a separate process, and that's _also_ an appealing
idea for several other reasons, but it would still need to understand
some of the thread-related data structures within the processes it
manipulated, so I don't think it would help enough to be worth it (in
a complete greenfields design where I get to ignore POSIX and rewrite
the kernel API from scratch, now, that might be a different story).

On a larger note, the fundamental complaint here is a project process
/ communication complaint.  We haven't been communicating enough with
the kernel team, fair criticism.  We can do better.  But the
communication has to go both ways.  When, for instance, we tell you
that membarrier needs to have its semantics nailed down in terms of
the C++17 memory model, that actually needs to happen.  When we tell
you that we can't use UAPI headers directly unless you commit to
honoring all of the standard-sourced namespace constraints on
user-visible headers, that needs to end the argument unless and until
someone does commit to doing all of that work on the kernel side.  (We
could discuss things we could do to make that work easier from your
end -- the __USE macros could stand to be better documented, for
instance -- but ultimately someone has to do the work.)

And, because this is a process / communication problem, you cannot
expect there to be a purely technical fix.   Your position appears,
from where I'm sitting, to be something like "if we split glibc into
two pieces, then you and us will never have to talk to each other
again" which, I'm sorry, I can't see that working out in the long run.

> (For example, for a long time now, I've wanted to go
> beyond POSIX and improve the system's signal handling API, and this
> improvement requires userspace cooperation.)

This is also an appealing notion, but the first step should be to
eliminate all of the remaining uses for asynchronous signals: for
instance, give us process handles already!  Once a program only ever
needs to call sigaction() to deal with
SIGSEGV/SIGBUS/SIGILL/SIGFPE/SIGTRAP, then we can think about
inventing a better replacement for that scenario.

zw
