From: =?UTF-8?Q?Thomas_Sch=c3=b6bel-Theuer?= <thomas@schoebel-theuer.de>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 22:16:17 +0100
Message-ID: <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 12/11/18 02:23, Andy Lutomirski wrote:
> I'm seriously considering sending a patch to remove x32 support from
> upstream Linux.

I am downstream maintainer of several self-patched kernels at 1&1 Ionos. 
The kernels are rolled out to several tenthousands of production servers 
running in several datacenters and in multiple continents.

Currently, we have a few thousands of servers relying on 32bit ABIs in 
some thousands of VMs and/or containers of various types (LXC, OpenVZ, etc).

Here is my private opinion, not speaking for 1&1: at some point the 
future, 32bit userspace support needs to be dropped anyway, somewhen in 
future. This is inevitable in the very long term.

Thus the discussion should be about _timing_ / _roadmaps_, but not about 
the fact as such.

My suggestion:

1) please release / declare a new LTS kernel, with upstream support for 
at least 5 years (as usual). Currently, only 4.4 and 4.9 are marked as 
LTS. Either mark another existing stable kernel as LTS, or a future one.

2) please _announce_ _now_ that after the _next_ LTS kernel (whichever 
you want to declare as such), you will _afterwards_ drop the legacy 
32bit support for 64 kernels (I am deliberately using "management speak" 
here).

=> result: the industry should have to fair chance to deal with such a 
roadmap. Yes, it will hurt some people, but they will have enough time 
for their migration projects.

Example: I know that out of several millions of customers of webhosting, 
a very low number of them have some very old legacy 32bit software 
installed in their webspace. This cannot be supported forever. But the 
number of such cases is very small, and there just needs to be enough 
time for finding a solution for those few customers.

3) the next development kernel _after_ that LTS release can then 
immediately drop the 32bit support. Enterprise users should have enough 
time for planning, and for lots of internal projects modernizing their 
infrastructure. Usually, they will need to do this anyway in the long term.

A roadmap should be _reliable_ for planning, and there should be no 
"unexpected surprises". That's the most important requirements.

Notice: 5 years is what I know will very likely work for 1&1 Ionos. I 
cannot speak for other large-scale enterprise users, but I think most of 
them should be able to deal with suchalike intervals in a clear roadmap.


Addendum / side note: I know of cases where _critical_ / sometimes even 
proprietary 32bit enterprise software needs to run for several 
_decades_. Please don't drop KVM/qemu support for 32bit guests using 
_old_ (unchanged) 32bit kernels, which are just happen to run on 64bit 
hypervisors. But AFAICS that was not the intention of this initiative. 
Just keep the latter in mind as another (independent) requirement.


Cheers,

Thomas
