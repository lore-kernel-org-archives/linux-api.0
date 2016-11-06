From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Formal description of system call interface
Date: Sun, 6 Nov 2016 14:39:28 -0800
Message-ID: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, scientist-b10kYP2dOMg@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Tavis Ormandy <taviso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

This is notes from the discussion we had at Linux Plumbers this week
regarding providing a formal description of system calls (user API).

The idea come up in the context of syzkaller, syscall fuzzer, which
has descriptions for 1000+ syscalls mostly concentrating on types of
arguments and return values. However, problems are that a small group
of people can't write descriptions for all syscalls; can't keep them
up-to-date and doesn't have necessary domain expertise to do correct
descriptions in some cases.

We identified a surprisingly large number of potential users for such
descriptions:
 - fuzzers (syzkaller, trinity, iknowthis)
 - strace/syscall tracepoints (capturing indirect arguments and
   printing human-readable info)
 - generation of entry points for C libraries (glibc, liblinux
   (raw syscalls), Go runtime, clang/gcc sanitizers)
 - valgrind/sanitizers checking of input/output values of syscalls
 - seccomp filters (minijail, libseccomp) need to know interfaces
   to generate wrappers
 - safety certification (requires syscall specifications)
 - man pages (could provide actual syscall interface rather than
   glibc wrapper interface, it was noted that possible errno values
   is an important part here)
 - generation of syscall argument validation in kernel (fast version
   is enabled all the time, extended is optional)

It's worth noting that number of these users already have some
descriptions that suffer from the same problems of being
incomplete/outdated. See also linux-api mailing list description
which lists an overlapping set of cases:
https://www.kernel.org/doc/man-pages/linux-api-ml.html

We discussed several implementation approaches:
 - Extracting the interface from kernel code either by parsing
   sources or using dwarf. However, current source doesn't have
   enough info: fd are specified as int, while we need to know exact
   fd type (e.g. fd_epoll_t); not possible to extract flag set for
   'int flags'; don't know what is 'char*'.
 - Making the formal description the master copy and generating
   kernel code from it (structs, flags, syscall entry points).
   This is quite pervasive, but otherwise should work.
 - Doing what syzkaller currently does: providing the description
   on side. Verifying that description and implementation match
   is an important piece here. We can do dynamic checking in syscall
   entry points (print warnings on anything that does not match
   descriptions); or static checking (but again kernel code doesn't
   have enough info for checking).

We decided to pursue the last option as the least pervasive for now.
Several locations for the descriptions were proposed: with source code,
include/uapi, Documentation.

Action points:
 - polish DSL for description (must be extensible)
 - write a parser for DSL
 - provide definition for mm syscalls (mm is reasonably simple
   and self-contained)
 - see if we can do validation of mm arguments

It was acknowledged that whatever we do now it will probably
significantly change and evolve over time as we better understand
what we need and what works.

For the reference, current syzkaller descriptions are in txt files here:
https://github.com/google/syzkaller/tree/master/sys
The most generic syscalls are here:
https://github.com/google/syzkaller/blob/master/sys/sys.txt
Specific subsystems are described in separate files, e.g.:
https://github.com/google/syzkaller/blob/master/sys/bpf.txt
https://github.com/google/syzkaller/blob/master/sys/tty.txt
https://github.com/google/syzkaller/blob/master/sys/sndseq.txt
The descriptions should be self-explanatory, but just in case there
is also a semi-formal DSL specification here:
https://github.com/google/syzkaller/blob/master/sys/README.md

Taking the opportunity, if you see that something is missing/wrong
in the descriptions of the subsystem you care about, or if it is not
described at all, fixes are welcome.

Thanks
