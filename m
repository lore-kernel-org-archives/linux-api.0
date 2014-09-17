From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 22:34:18 -0700
Message-ID: <CALCETrU0=_9voz1bxbLom=y7qnk7RN7U5Bd2s+Dk_QQN2yYVfw@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
 <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
 <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com> <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 16, 2014 at 10:00 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, Sep 16, 2014 at 6:18 PM, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Tue, Sep 16, 2014 at 5:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> I think that the patch should instead tweak the vvar mapping to tell
> the vdso not to use rdtsc.  It should be based on this:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vsyscall
>
> and I'll talk to hpa tomorrow about about getting that, or something
> like it, into the tip tree.  In particular, you'll need this:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vsyscall&id=0cc410a05cb95e073ebfe099c9e03cef48d2be0f

Crud.  Now that I've said that, I realize that this won't work right
if rdtscp is off.  I'll drop that patch.

I don't think that this changes the conclusion.  It should be possible
to swap out the vvar page to keep the vdso working even without rdtsc
available.

--Andy

>
> Also, this kind of inheritable restriction may end up requiring
> no_new_privs or CAP_SYS_ADMIN to be secure.
>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
