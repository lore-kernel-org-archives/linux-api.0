From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Fri, 19 Sep 2014 15:09:11 -0700
Message-ID: <CALCETrXOeD=zBPvYV+-j0Ok6MXNZwdjRaz73rjuLGShx+o6Y0w@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
 <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
 <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
 <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
 <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
 <54194A4A.7030104@zytor.com> <CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
 <CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com> <CADU+-uBMc9THr0ADntsOqwh1--ULYMcssgPBvTesvFR+KQUfRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADU+-uBMc9THr0ADntsOqwh1--ULYMcssgPBvTesvFR+KQUfRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Filipe Brandenburger <filbranden@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg Thelen <gthelen@google.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Davidson <md@google.com>, Ingo Molnar <mingo@redhat.com>, Richard Larocque <rlarocque@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 19, 2014 at 3:02 PM, Filipe Brandenburger
<filbranden@google.com> wrote:
> Hi Andy,
>
> On Fri, Sep 19, 2014 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> I have this (special mapping tracking) 3/4 implemented.  I'm planning
>> on making it fully functional for 64-bit programs and almost correct
>> for 32-bit.  (You'll still crash if you have multiple threads, you use
>> sysenter, and you remap the vdso, but I think that this is essentially
>> unavoidable until someone lets mremap work on multiple vmas at once.)
>
> In case that's useful, I was looking at swapping the vvar page by
> changing the vm_special_mapping to change the pages array between the
> actual vvar page and the zero page and using zap_page_range to force
> the next access to go through a page fault that would remap it.

That will do it globally, since the vm_special_mapping is global.  I
was just thinking of using remap_pfn_range.

>
> I didn't have all the details figured out (I was closer to 1/4 of it
> implemented) but I didn't see any issues on 32-bit programs.

The 32-bit issue comes from mremap.

>
> Let me know if you'd like to see some of my patches or if you think I
> should keep working on them.

Give me another day or two to straighten out the vma stuff, although
it shouldn't impact your patches too much.  The main effect will be
that you'll be able to rely on mm->context.vdso (renamed to
vvar_vma_start, most likey) being correct.  Currently, you should
*not* rely on it, especially if CRIU is involved.

--Andy
