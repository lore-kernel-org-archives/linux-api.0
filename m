From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Thu, 5 Jan 2017 13:27:40 -0800
Message-ID: <CALCETrW7yxmgrR15yvxkXOF1pHy5vicwDv6Oj019ecEyBCrWBQ@mail.gmail.com>
References: <20161227015413.187403-1-kirill.shutemov@linux.intel.com>
 <20161227015413.187403-30-kirill.shutemov@linux.intel.com>
 <5a3dcc25-b264-37c7-c090-09981b23940d@intel.com> <20170105192910.q26ozg4ci4i3j2ai@black.fi.intel.com>
 <161ece66-fbf4-cb89-3da6-91b4851af69f@intel.com> <CALCETrUQ2+P424d9MW-Dy2yQ0+EnMfBuY80wd8NkNmc8is0AUw@mail.gmail.com>
 <978d5f1a-ec4d-f747-93fd-27ecfe10cb88@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <978d5f1a-ec4d-f747-93fd-27ecfe10cb88-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 5, 2017 at 12:49 PM, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On 01/05/2017 12:14 PM, Andy Lutomirski wrote:
>>> I'm not sure I'm comfortable with this.  Do other rlimit changes cause
>>> silent data corruption?  I'm pretty sure doing this to MPX would.
>>>
>> What actually goes wrong in this case?  That is, what combination of
>> MPX setup of subsequent allocations will cause a problem, and is the
>> problem worse than just a segfault?  IMO it would be really nice to
>> keep the messy case confined to MPX.
>
> The MPX bounds tables are indexed by virtual address.  They need to grow
> if the virtual address space grows.   There's an MSR that controls
> whether we use the 48-bit or 57-bit layout.  It basically decides
> whether we need a 2GB (48-bit) or 1TB (57-bit) bounds directory.
>
> The question is what we do with legacy MPX applications.  We obviously
> can't let them just allocate a 2GB table and then go let the hardware
> pretend it's 1TB in size.  We also can't hand the hardware using a 2GB
> table an address >48-bits.
>
> Ideally, I'd like to make sure that legacy MPX can't be enabled if this
> RLIMIT is set over 48-bits (really 47).  I'd also like to make sure that
> legacy MPX is active, that the RLIMIT can't be raised because all hell
> will break loose when the new addresses show up.
>
> Remember, we already have (legacy MPX) binaries in the wild that have no
> knowledge of this stuff.  So, we can implicitly have the kernel bump
> this rlimit around, but we can't expect userspace to do it, ever.

If you s/rlimit/prctl, then I think this all makes sense with one
exception.  It would be a bit sad if the personality-setting tool
didn't work if compiled with MPX.

So what if we had a second prctl field that is the value that kicks in
after execve()?

--Andy
