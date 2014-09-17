From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Wed, 17 Sep 2014 01:46:02 -0700
Message-ID: <54194A4A.7030104@zytor.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com> <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/16/2014 11:21 PM, Filipe Brandenburger wrote:
> Hi Andy,
> 
> On Tue, Sep 16, 2014 at 10:00 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> I think that the patch should instead tweak the vvar mapping to tell
>> the vdso not to use rdtsc.  It should be based on this:
> 
> I've been working on this approach which extends the vvar from 2 to 3
> pages. The third page would initially be mapped to a zero page but
> then through a prctl a task could replace it with a real page that
> could then be inherited through fork and exec.
> 
> That would make it possible to have per-task vvar contents.
> 
> We could use some of those values as flags to indicate whether vdso
> routines may use RDTSC or not.
> 
> In the future, we're planning to also use that to store clock offsets
> so that we can ensure CLOCK_MONOTONIC works after CRIU migration
> without having to turn off the VDSO or have to always fallback to full
> syscalls on every case.
> 
> Do you think that would be a reasonable way to accomplish that?
> 

Why would we need/want per process vvar contents?  It seems better to
have the code swapped out.

	-hpa
