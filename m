From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 09 Jan 2019 13:41:14 +0100
Message-ID: <871s5muhp1.fsf@oldenburg2.str.redhat.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
        <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
        ("Thomas \=\?utf-8\?Q\?Sch\=C3\=B6bel-Theuer\=22's\?\= message of "Fri, 14 Dec 2018
 22:16:17
        +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas =?utf-8?Q?Sch=C3=B6bel-Theuer?= <thomas@schoebel-theuer.de>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

* Thomas Schöbel-Theuer:

> 2) please _announce_ _now_ that after the _next_ LTS kernel (whichever
> you want to declare as such), you will _afterwards_ drop the legacy
> 32bit support for 64 kernels (I am deliberately using "management
> speak" here).
>
> => result: the industry should have to fair chance to deal with such a
> roadmap. Yes, it will hurt some people, but they will have enough time
> for their migration projects.
>
> Example: I know that out of several millions of customers of
> webhosting, a very low number of them have some very old legacy 32bit
> software installed in their webspace. This cannot be supported
> forever. But the number of such cases is very small, and there just
> needs to be enough time for finding a solution for those few
> customers.
>
> 3) the next development kernel _after_ that LTS release can then
> immediately drop the 32bit support. Enterprise users should have
> enough time for planning, and for lots of internal projects
> modernizing their infrastructure. Usually, they will need to do this
> anyway in the long term.

We've already phased out support for all 32-bit architectures except
i386 in our products, and i386 is obviously next.  (We never supported
x32 in the first place.)

It becomes increasingly difficult to build a 32-bit userspace that meets
backwards-compatibility needs.  We want to use SSE2 (to avoid excess
precision for double) and avoid relying on stack realignment (for
compatibility with applications that use the old i386 ABI which did not
require stack realignment).  We also have to build the distribution with
a full complement of hardening flags.  This results in a combination of
flags that is poorly tested in upstream GCC.  The i386 register file
isn't large enough to support all these features at the same time and
combine them with function arguments passed in registers (which some
programs enable manually via function attributes).

So even if we keep the kernel interface, in the forseeable future, I
expect that it will be difficult to build a full, contemporary 32-bit
userspace on i386.

Thanks,
Florian
