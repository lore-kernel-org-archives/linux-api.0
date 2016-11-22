From: Szabolcs Nagy <nsz-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>
Subject: Re: Formal description of system call interface
Date: Tue, 22 Nov 2016 14:07:38 +0100
Message-ID: <20161122130738.GT5749@port70.net>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
 <20161107002839.GN5749@port70.net>
 <CACT4Y+bq97OPqW9nUoQWDdVfeCv6oOYT0=GeFmOu2rosBz4s2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bq97OPqW9nUoQWDdVfeCv6oOYT0=GeFmOu2rosBz4s2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, scientist-b10kYP2dOMg@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Tavis Ormandy <taviso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> [2016-11-21 16:03:04 +0100]:
> On Mon, Nov 7, 2016 at 1:28 AM, Szabolcs Nagy <nsz-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org> wrote:
> > * Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> [2016-11-06 14:39:28 -0800]:
> >> For the reference, current syzkaller descriptions are in txt files here:
> >> https://github.com/google/syzkaller/tree/master/sys
> > ...
> >> Taking the opportunity, if you see that something is missing/wrong
> >> in the descriptions of the subsystem you care about, or if it is not
> >> described at all, fixes are welcome.
> >
> > abi variants are missing (abi variation makes a lot of
> > syscall interface related work painful).
> 
> 
> What exactly do you mean by "abi variants"? Is it architecture?
> What exactly needs to be added to the descriptions support "abi variants?
> 

abi variant is a supported syscall abi
(linux supports several abis on the same arch:
e.g. x86 has i386,x86_64,x32 one might also
call different endianness a different abi, but
i'd expect le/be to be handled together.)

available syscalls, argument types and ordering
can be different across abis

i may be wrong, but i did not see those handled
in sys.txt, looking at it now i see missing
paddings in ipc structs (*_ds) so it may not
work the way i assumed (these are types which
have some abi variation).
