From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Tue, 12 Jul 2016 09:32:11 -0700
Message-ID: <CALCETrUZeZ00sFrTEqWSB-OxkCzGQxknmPTvFe4bv5mKc3hE+Q@mail.gmail.com>
References: <20160707124719.3F04C882@viggo.jf.intel.com> <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net> <577E924C.6010406@sr71.net>
 <20160708071810.GA27457@gmail.com> <577FD587.6050101@sr71.net>
 <20160709083715.GA29939@gmail.com> <CALCETrXJhVz6Za4=oidiM2Vfbb+XdggFBYiVyvOCcia+w064aQ@mail.gmail.com>
 <5783AE8F.3@sr71.net> <CALCETrW1qLZE_cq1CvmLkdnFyKRWVZuah29xERTC7o0eZ8DbwQ@mail.gmail.com>
 <5783BFB0.70203@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <5783BFB0.70203@intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, X86 ML <x86@kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-api@vger.kernel.org

On Jul 11, 2016 8:48 AM, "Dave Hansen" <dave.hansen@intel.com> wrote:
>
> On 07/11/2016 07:45 AM, Andy Lutomirski wrote:
> > On Mon, Jul 11, 2016 at 7:34 AM, Dave Hansen <dave@sr71.net> wrote:
> >> Should we instead just recommend to userspace that they lock down access
> >> to keys by default in all threads as a best practice?
> >
> > Is that really better than doing it in-kernel?  My concern is that
> > we'll find library code that creates a thread, and that code could run
> > before the pkey-aware part of the program even starts running.
>
> Yeah, so let's assume we have some pkey-unaware thread.  The upside of a
> scheme where the kernel preemptively (and transparently to the thread)
> locks down PKRU is that the thread can't go corrupting any non-zero-pkey
> structures that came from other threads.
>
> But, the downside is that the thread can not access any non-zero-pkey
> structures without taking some kind of action with PKRU.  That obviously
> won't happen since the thread is pkeys-unaware to begin with.  Would
> that break these libraries unless everything using pkeys knows to only
> share pkey=0 data with those threads?
>

Yes, but at least for the cases I can think of, that's probably a good
thing.  OTOH, I can see cases where you want everyone to be able to
read but only specific code paths to be able to write.

I think it's more or less impossible to get sensible behavior passing
pkey != 0 data to legacy functions.  If you call:

void frob(struct foo *p);

If frob in turn passes p to a thread, what PKRU is it supposed to use?

> > So how is user code supposed lock down all of its threads?
> >
> > seccomp has TSYNC for this, but I don't think that PKRU allows
> > something like that.
>
> I'm not sure this is possible for PKRU.  Think of a simple PKRU
> manipulation in userspace:
>
>         pkru = rdpkru();
>         pkru |= PKEY_DENY_ACCESS<<key*2;
>         wrpkru(pkru);
>
> If we push a PKRU value into a thread between the rdpkru() and wrpkru(),
> we'll lose the content of that "push".  I'm not sure there's any way to
> guarantee this with a user-controlled register.

We could try to insist that user code uses some vsyscall helper that
tracks which bits are as-yet-unassigned.  That's quite messy, though.

We could also arbitrarily partition the key space into
initially-wide-open, initially-read-only, and initially-no-access and
let pkey_alloc say which kind it wants.

--Andy
