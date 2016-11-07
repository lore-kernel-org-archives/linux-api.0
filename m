From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Formal description of system call interface
Date: Mon, 7 Nov 2016 11:38:20 +0100
Message-ID: <20161107103819.GA11374@rei.lan>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, scientist-b10kYP2dOMg@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Tavis Ormandy <taviso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> We identified a surprisingly large number of potential users for such
> descriptions:
>  - fuzzers (syzkaller, trinity, iknowthis)
>  - strace/syscall tracepoints (capturing indirect arguments and
>    printing human-readable info)
>  - generation of entry points for C libraries (glibc, liblinux
>    (raw syscalls), Go runtime, clang/gcc sanitizers)
>  - valgrind/sanitizers checking of input/output values of syscalls
>  - seccomp filters (minijail, libseccomp) need to know interfaces
>    to generate wrappers
>  - safety certification (requires syscall specifications)
>  - man pages (could provide actual syscall interface rather than
>    glibc wrapper interface, it was noted that possible errno values
>    is an important part here)
>  - generation of syscall argument validation in kernel (fast version
>    is enabled all the time, extended is optional)

I was thinking of generating LTP testcases from a well defined format for
quite some time. Maybe that would be a good way how to keep the
descriptions to match the reality.

LTP test would however need a bit more information that just syscall
parameter anotation. We would need also description of the expected
return value in some cases, annotating it as "returns fd" or "zero on
success" would be good enough for basic tests. Better testing would need
to describe the "side efect" as well (file was created, filesystem
mounted, etc.) then we could write a classes of verify functions,
something as check_file_exits() and use them to check the results
accordingly.

I'm not sure if something like this is really doable or in the scope of
this project, but it may be worth a try.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
