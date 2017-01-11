From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Wed, 11 Jan 2017 11:20:38 -0800
Message-ID: <CALCETrXDbkotCZ1WEbhNeYGt0zyKT42agzsFxT2SZJ4wadEnQA@mail.gmail.com>
References: <20161227015413.187403-1-kirill.shutemov@linux.intel.com>
 <20161227015413.187403-30-kirill.shutemov@linux.intel.com>
 <5a3dcc25-b264-37c7-c090-09981b23940d@intel.com> <20170105192910.q26ozg4ci4i3j2ai@black.fi.intel.com>
 <161ece66-fbf4-cb89-3da6-91b4851af69f@intel.com> <CALCETrUQ2+P424d9MW-Dy2yQ0+EnMfBuY80wd8NkNmc8is0AUw@mail.gmail.com>
 <978d5f1a-ec4d-f747-93fd-27ecfe10cb88@intel.com> <20170111142904.GD4895@node.shutemov.name>
 <CALCETrUn=KNdOnoRYd8GcnXPNDHAhGkaMaHRTAri4o92FSC1qg@mail.gmail.com>
 <20170111183750.GE4895@node.shutemov.name> <0a6f1ee4-e260-ae7b-3d39-c53f6bed8102@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a6f1ee4-e260-ae7b-3d39-c53f6bed8102@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 11, 2017 at 10:49 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 01/11/2017 10:37 AM, Kirill A. Shutemov wrote:
>>> How about preventing the max addr from being changed to too high a
>>> value while MPX is on instead of overriding the set value?  This would
>>> have the added benefit that it would prevent silent failures where you
>>> think you've enabled large addresses but MPX is also on and mmap
>>> refuses to return large addresses.
>> Setting rlimit high doesn't mean that you necessary will get access to
>> full address space, even without MPX in picture. TASK_SIZE limits the
>> available address space too.
>
> OK, sure...  If you want to take another mechanism into account with
> respect to MPX, we can do that.  We'd just need to change every
> mechanism we want to support to ensure that it can't transition in ways
> that break MPX.
>
> What are you arguing here, though?  Since we *might* be limited by
> something else that we should not care about controlling the rlimit?
>
>> I think it's consistent with other resources in rlimit: setting RLIMIT_RSS
>> to unlimited doesn't really means you are not subject to other resource
>> management.
>
> The farther we get into this, the more and more I think using an rlimit
> is a horrible idea.  Its semantics aren't a great match, and you seem to
> be resistant to making *this* rlimit differ from the others when there's
> an entirely need to do so.  We're already being bitten by "legacy"
> rlimit.  IOW, being consistent with *other* rlimit behavior buys us
> nothing, only complexity.

Taking a step back, I think it would be fantastic if we could find a
way to make this work without any inheritable settings at all.
Perhaps we could have a per-mm value that is initialized to 2^47-1 on
execve() and can be raised by ELF note or by prctl()?  Getting it
right for 32-bit would require a bit of thought.  The ELF note would
make a high stack possible and, without the ELF note, we'd get a low
stack but high mmap().  Then the messy bits can be glibc's problem and
a toolchain problem as it should be, given that the only reason we
need a limit at all is because of messy userspace code.

Sure, the low stack prevents the *whole* address space from being used
in one big block for databases, but 2^57 - 2^47 ought to be good
enough.

I'm not 100% sure this is workable but, if it is, it makes everyone's
life easier.  There's no need to muck around with setarch(1) or
similar hacks.
