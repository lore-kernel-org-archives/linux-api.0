From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: How should we handle variable address space sizes (Re: [RFC 3/4]
 x86/mm: define TASK_SIZE as current->mm->task_size)
Date: Mon, 2 Jan 2017 12:49:07 +0300
Message-ID: <20170102094907.GC30735@node.shutemov.name>
References: <CALCETrXMCVOmVcQYxF_ghPdEjLuNNqbcnoRKRVpJegsQ=SPEFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXMCVOmVcQYxF_ghPdEjLuNNqbcnoRKRVpJegsQ=SPEFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 30, 2016 at 06:11:05PM -0800, Andy Lutomirski wrote:
> On Fri, Dec 30, 2016 at 7:56 AM, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> > Keep task's virtual address space size as mm_struct field which
> > exists for a long time - it's initialized in setup_new_exec()
> > depending on the new task's personality.
> > This way TASK_SIZE will always be the same as current->mm->task_size.
> > Previously, there could be an issue about different values of
> > TASK_SIZE and current->mm->task_size: e.g, a 32-bit process can unset
> > ADDR_LIMIT_3GB personality (with personality syscall) and
> > so TASK_SIZE will be 4Gb, which is larger than mm->task_size = 3Gb.
> > As TASK_SIZE *and* current->mm->task_size are used both in code
> > frequently, this difference creates a subtle situations, for example:
> > one can mmap addresses > 3Gb, but they will be hidden in
> > /proc/pid/pagemap as it checks mm->task_size.
> > I've moved initialization of mm->task_size earlier in setup_new_exec()
> > as arch_pick_mmap_layout() initializes mmap_legacy_base with
> > TASK_UNMAPPED_BASE, which depends on TASK_SIZE.
> 
> I don't like this patch so much because I think that we should figure
> out how this will all work in the long run first.  I've added some
> more people to the thread because other arches have similar issues and
> because x86 is about to get considerably more complicated (choices
> include 3GB, 4GB, 47-bit, and 56-bit (the latter IIRC)).
> 
> Here are a few of my thoughts on the matter.  This isn't all that well
> thought out:
> 
> The address space limit, especially if CRIU is in play, isn't really a
> hard limit.  For example, you could allocate high memory then lower
> the limit.  Similarly, I see no reason that an x32 program should be
> forbidden from mapping some high addresses or, similarly, that an i386
> program can't (if it really wanted to) do a 64-bit mmap() and get a
> high address.
> 
> On that note, can we just *delete* the task_size check from pagemap?
> It's been there since the very beginning:
> 
> commit 85863e475e59afb027b0113290e3796ee6020b7d
> Author: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
> Date:   Mon Feb 4 22:29:04 2008 -0800
> 
>     maps4: add /proc/pid/pagemap interface
> 
> and there's no explanation for why it's needed.
> 
> So maybe we should have a *number* (not a bit) that indicates the
> maximum address that mmap() will return unless an override is in use.
> Since common practice seems to be to stick this in the personality
> field, we may need some fancy encoding.  Executing a setuid binary
> needs to reset to the default, and personality handles that.

If we want to be able to specify arbitrary address as maximum, a fancy
encoding would need to claim 51 bits (63 VA - 12 in-page address) on x86
from the persona flag.
To me, it's stretching personality interface too far.

Maybe it's easier to reset the rlimit for suid binaries?

-- 
 Kirill A. Shutemov
