From: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Fri, 19 Sep 2014 20:10:18 -0700
Message-ID: <CADU+-uBoMrF=vbOM4TW7YzD5cdHSn8BJdfs5nnPM6uS9-6n_Ag@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
	<CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
	<54194A4A.7030104@zytor.com>
	<CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
	<CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com>
	<CADU+-uBMc9THr0ADntsOqwh1--ULYMcssgPBvTesvFR+KQUfRg@mail.gmail.com>
	<CALCETrXOeD=zBPvYV+-j0Ok6MXNZwdjRaz73rjuLGShx+o6Y0w@mail.gmail.com>
	<CADU+-uBmQdKSX==5NrYfSEWLg-X4cvJYXj=N8UdMdN_rHnWk4w@mail.gmail.com>
	<CALCETrV7thL-0mST4O6YZgDNm1LyLqB=_bQ3vwwrAPYZCB=W+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV7thL-0mST4O6YZgDNm1LyLqB=_bQ3vwwrAPYZCB=W+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Fri, Sep 19, 2014 at 3:31 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> Sorry if I wasn't clear... That's the exact point of my patch, to make
>> vm_special_mapping local to the task.
>>
>> I started with an approach of keeping a struct vm_special_mapping + a
>> struct page * array per mm_struct.
>>
>> I was also looking at keeping two static vm_special_mapping structs,
>> one with the actual vvar page and the other with the zero page and
>> then swapping vma->vm_private_data to point to the appropriate one.
>
> This sounds like it may be more complicated than necessary.  Is there
> any reason that just doing remap_pfn_range on the vvar page isn't
> enough?

I thought of doing that from the prctl but AFAICT remap_pfn_range
requires that it's unmapped before the call (remap_pte_range has
BUG_ON(!pte_none(*pte));) and doing a zap_page_range followed by
remap_pfn_range might incur a race condition if another thread of the
same process is accessing the vvar page at that time... Am I wrong
about that race?

> Changing out the text is a whole can of worms involving self-modifying
> code, although it may be completely safe if done through the page
> tables.  But I don't think you can't use remap_pfn_range for that.

No, I'm not planning to change the text, just replacing the vvar page
swapping the one where the vsyscall_gtod_data lives with a zero page
(and back depending on the parameter of the prctl.)

> Maybe better: what exactly are you trying to do?

Just replace the page mapped to the vvar address.

But nevermind my ramblings here, looks like you're almost there so go
ahead and when you have a working patch I'll take a look at it.

My offer to help still stands, so let me know if you'd like to see
some of my code (unfinished as it is now or if you'd like me to show
you something that works in a few days.)

Cheers,
Filipe
