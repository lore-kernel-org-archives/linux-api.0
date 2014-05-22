From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Pondering per-process vsyscall disablement
Date: Thu, 22 May 2014 16:04:22 -0700
Message-ID: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It would be nice to have a way for new programs to declare that they
don't need vsyscalls.  What's the right way to do this?  An ELF header
entry in the loader?  An ELF header entry in the program?  A new
arch_prctl?

As background, there's an old part of the x86_64 ABI that allows
programs to do gettimeofday, clock_gettime, and getcpu by calling to
fixed addresses of the form 0xffffffffff600n00 where n indicates which
of those three syscalls is being invoked.  This is a security issue.

Since Linux 3.1, vsyscalls are emulated using NX and page faults.  As
a result, vsyscalls no longer offer any performance advantage over
normal syscalls; in fact, they're much slower.  As far as I know,
nothing newer than 2012 will attempt to use vsyscalls if a vdso is
present.  (Sadly, a lot of things will still fall back to the vsyscall
page if there is no vdso, but that shouldn't matter, since there is
always a vdso.)

Despite the emulation, they could still be used as a weird form of ROP
gadget that lives at a fixed address.  I'd like to offer a way for new
runtimes to indicate that they don't use vsyscalls so that the kernel
can selectively disable emulation and remove the fixed-address
executable code issue.


--Andy
