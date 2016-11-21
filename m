From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Formal description of system call interface
Date: Mon, 21 Nov 2016 17:10:33 +0100
Message-ID: <20161121161032.GB27353@rei.lan>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
 <20161107103819.GA11374@rei.lan>
 <CACT4Y+aUzdX8NqMu+Y3s53vEmoBw7KysB3g2PEjZ6MyJimki1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+aUzdX8NqMu+Y3s53vEmoBw7KysB3g2PEjZ6MyJimki1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, scientist-b10kYP2dOMg@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Tavis Ormandy <taviso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> Description of "returns fd or this set of errors" looks simple and useful.
> Any test system or fuzzer will be able to verify that kernel actually returns
> claimed return values. Also Carlos expressed interested in errno values
> in the context of glibc.
> I would do it from day one.
> 
> Re more complex side effects. I always feared that a description suitable
> for automatic verification (i.e. zero false positives, otherwise it is useless)
> may be too difficult to achieve.

I'm afraid it may be as well. I would expect that we will end up with
something quite complex with a large set of exceptions from the rules.

> Cyril, Tavis, can you come up with some set of predicates that can be
> checked automatically yet still useful?
> We can start small, e.g. "must not alter virtual address space".

I will try to thing about this a bit.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
