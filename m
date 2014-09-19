From: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Fri, 19 Sep 2014 15:02:54 -0700
Message-ID: <CADU+-uBMc9THr0ADntsOqwh1--ULYMcssgPBvTesvFR+KQUfRg@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
	<CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
	<54194A4A.7030104@zytor.com>
	<CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
	<CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Fri, Sep 19, 2014 at 12:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> I have this (special mapping tracking) 3/4 implemented.  I'm planning
> on making it fully functional for 64-bit programs and almost correct
> for 32-bit.  (You'll still crash if you have multiple threads, you use
> sysenter, and you remap the vdso, but I think that this is essentially
> unavoidable until someone lets mremap work on multiple vmas at once.)

In case that's useful, I was looking at swapping the vvar page by
changing the vm_special_mapping to change the pages array between the
actual vvar page and the zero page and using zap_page_range to force
the next access to go through a page fault that would remap it.

I didn't have all the details figured out (I was closer to 1/4 of it
implemented) but I didn't see any issues on 32-bit programs.

Let me know if you'd like to see some of my patches or if you think I
should keep working on them.

Cheers,
Filipe
