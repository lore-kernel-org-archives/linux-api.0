From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Fri, 19 Sep 2014 22:30:25 -0700
Message-ID: <CALCETrVvLwOncX1LinLPyzPSgO2U6bmeKE5M2VDi2Mo0j8ihow@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
 <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
 <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
 <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
 <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
 <54194A4A.7030104@zytor.com> <CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
 <CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com>
 <CADU+-uBMc9THr0ADntsOqwh1--ULYMcssgPBvTesvFR+KQUfRg@mail.gmail.com>
 <CALCETrXOeD=zBPvYV+-j0Ok6MXNZwdjRaz73rjuLGShx+o6Y0w@mail.gmail.com>
 <CADU+-uBmQdKSX==5NrYfSEWLg-X4cvJYXj=N8UdMdN_rHnWk4w@mail.gmail.com>
 <CALCETrV7thL-0mST4O6YZgDNm1LyLqB=_bQ3vwwrAPYZCB=W+A@mail.gmail.com>
 <CADU+-uBoMrF=vbOM4TW7YzD5cdHSn8BJdfs5nnPM6uS9-6n_Ag@mail.gmail.com>
 <CALCETrUgtveB-ddeL2t0cK18r_VeP5T7LrWCzszfFo+8GcdmEg@mail.gmail.com> <CADU+-uAw8wLbY6E0msuwZFgW9hDXz8a6oeDJBTSURUfS3aO1gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADU+-uAw8wLbY6E0msuwZFgW9hDXz8a6oeDJBTSURUfS3aO1gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sep 19, 2014 8:46 PM, "Filipe Brandenburger" <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, Sep 19, 2014 at 8:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> >> I thought of doing that from the prctl but AFAICT remap_pfn_range
> >> requires that it's unmapped before the call (remap_pte_range has
> >> BUG_ON(!pte_none(*pte));) and doing a zap_page_range followed by
> >> remap_pfn_range might incur a race condition if another thread of the
> >> same process is accessing the vvar page at that time... Am I wrong
> >> about that race?
> >
> > No, you're right.  Ugh.
> >
> > It might pay to add an explicit .fault callback to vm_special_mapping,
> > but your approach will work, too.  The main downside is more memory
> > overhead per mm.
>
> One way to limit that overhead was to keep only two static
> vm_special_mapping structs (one for the real vvar page and one for the
> zero page) and then change the vma->vm_private_data to point to one or
> the other when the prctl is called. I just thought of that recently
> and haven't tried it yet so not sure if it will cause other
> problems...

Sneaky :)

This might have interesting effects if someone races with you.
mmap_sem could be enough.

On the other hand, holding mmap_sem for write could be enough to let
you zap the pte and remap it.

>
> >>> Changing out the text is a whole can of worms involving self-modifying
> >>> code, although it may be completely safe if done through the page
> >>> tables.  But I don't think you can't use remap_pfn_range for that.
> >>
> >> No, I'm not planning to change the text, just replacing the vvar page
> >> swapping the one where the vsyscall_gtod_data lives with a zero page
> >> (and back depending on the parameter of the prctl.)
> >
> > Hmm.  This will break the _COARSE timing functions as well as
> > __vdso_time.  That'll need fixing, either by swapping out the code
> > (yuck!) or by adding a branch to all of those code paths.
> >
> > Maybe there's a non-branchy way, though.  Let me think.
>
> So this is what I was thinking of extending the vvar region to include
> one extra page (right now it's two pages, the one with the
> vsyscall_gtod_data and the one with the hrtimer I/O mapping, so this
> would be a third page.) This third page would be initially mapped to
> the zero page, so it wouldn't cost an extra page of memory per process
> or even globally.
>
> The prctl would swap that page with another page allocated as the
> prctl is called. That one page that's allocated with the prctl would
> be inherited over forks and execs, so if you have a bunch of processes
> that need the same offset then they'd all share that one single page.
>
> The vdso clock routines would get the base clock information from
> vsyscall_gtod_data, hpet, tsc, etc. and would simply add the offsets
> from the task_vvar page (not too branch-y, just a few extra adds.) In
> the regular case, that would be a zero page so it would be simply
> adding zero. If we need to apply offsets, then we replace that page
> with one that has a struct with the right offsets for each clock type.
>
> When running in kernel mode, the clock code (and timer code, etc.)
> would find that page through the mm_struct and find the clock offsets
> that way.

This seems like a lot of complexity and non-negligible overhead (extra
adds, cacheline misses, and even TLB misses) in the common case just
to have fast timing under very unusual circumstances.

I'd much rather do something to the vvar page that causes all the
timing calls to turn into normal syscalls and then handle the offset
in the timing syscalls.  Are you really doing something that's
performance-sensitive enough to justify all of the complexity of
making this work without syscalls?

To do that, the only real tricky part is handling the coarse timing
calls.  The could be done with extra branches, text patches, or
trickery involving setting up an alternate vvar page that always fails
the seqcount retry check.

>
> I was working on this approach before you suggested swapping the
> actual vvar page (and not sure if you were actually looking at
> hot-swapping the vdso itself.) I can go back to working on it and send
> you a few commits since I still have some of that code around.
>
> Cheers,
> Filipe
