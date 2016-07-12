From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Tue, 12 Jul 2016 10:12:00 -0700
Message-ID: <578524E0.6080401@intel.com>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
 <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net> <577E924C.6010406@sr71.net>
 <20160708071810.GA27457@gmail.com> <577FD587.6050101@sr71.net>
 <20160709083715.GA29939@gmail.com>
 <CALCETrXJhVz6Za4=oidiM2Vfbb+XdggFBYiVyvOCcia+w064aQ@mail.gmail.com>
 <5783AE8F.3@sr71.net>
 <CALCETrW1qLZE_cq1CvmLkdnFyKRWVZuah29xERTC7o0eZ8DbwQ@mail.gmail.com>
 <5783BFB0.70203@intel.com>
 <CALCETrUZeZ00sFrTEqWSB-OxkCzGQxknmPTvFe4bv5mKc3hE+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALCETrUZeZ00sFrTEqWSB-OxkCzGQxknmPTvFe4bv5mKc3hE+Q@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, X86 ML <x86@kernel.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-api@vger.kernel.org

On 07/12/2016 09:32 AM, Andy Lutomirski wrote:
> I think it's more or less impossible to get sensible behavior passing
> pkey != 0 data to legacy functions.  If you call:
> 
> void frob(struct foo *p);
> 
> If frob in turn passes p to a thread, what PKRU is it supposed to use?

The thread inheritance of PKRU can be nice.  It actually gives things a
good chance of working if you can control PKRU before clone().  I'd
describe the semantics like this:

	PKRU values are inherited at the time of a clone() system
	call.  Threads unaware of protection keys may work on
	protection-key-protected data as long as PKRU is set up in
	advance of the clone() and never needs to be changed inside the
	thread.

	If a thread is created before PKRU is set appropriately, the
	thread may not be able to act on protection-key-protected data.

Otherwise, the semantics are simpler, but they basically give threads no
chance of ever working:

	Threads unaware of protection keys and which can not manage
	PKRU may not operate on data where a non-zero key has been
	passed to pkey_mprotect().

It isn't clear to me that one of these is substantially better than the
other.  It's fairly easy in either case for an app that cares to get the
behavior of the other.

But, one is clearly easier to implement in the kernel. :)

>>> So how is user code supposed lock down all of its threads?
>>>
>>> seccomp has TSYNC for this, but I don't think that PKRU allows
>>> something like that.
>>
>> I'm not sure this is possible for PKRU.  Think of a simple PKRU
>> manipulation in userspace:
>>
>>         pkru = rdpkru();
>>         pkru |= PKEY_DENY_ACCESS<<key*2;
>>         wrpkru(pkru);
>>
>> If we push a PKRU value into a thread between the rdpkru() and wrpkru(),
>> we'll lose the content of that "push".  I'm not sure there's any way to
>> guarantee this with a user-controlled register.
> 
> We could try to insist that user code uses some vsyscall helper that
> tracks which bits are as-yet-unassigned.  That's quite messy, though.

Yeah, doable, but not without some new data going out to userspace, plus
the vsyscall code itself.

> We could also arbitrarily partition the key space into
> initially-wide-open, initially-read-only, and initially-no-access and
> let pkey_alloc say which kind it wants.

The point is still that wrpkru destroyed the 'push' operation.  You
always end up with a PKRU that (at least temporarily) ignored the 'push'.
