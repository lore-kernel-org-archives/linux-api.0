From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Wed, 9 Jan 2019 11:02:10 -0500
Message-ID: <20190109160210.GB23599@brightrain.aerifal.cx>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <6577ac4f-524c-37f4-a4d0-6eb94ec7d9a5@schoebel-theuer.de>
 <871s5muhp1.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871s5muhp1.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Thomas =?utf-8?Q?Sch=C3=B6bel-Theuer?= <thomas@schoebel-theuer.de>, Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 09, 2019 at 01:41:14PM +0100, Florian Weimer wrote:
> * Thomas Schöbel-Theuer:
> 
> > 2) please _announce_ _now_ that after the _next_ LTS kernel (whichever
> > you want to declare as such), you will _afterwards_ drop the legacy
> > 32bit support for 64 kernels (I am deliberately using "management
> > speak" here).
> >
> > => result: the industry should have to fair chance to deal with such a
> > roadmap. Yes, it will hurt some people, but they will have enough time
> > for their migration projects.
> >
> > Example: I know that out of several millions of customers of
> > webhosting, a very low number of them have some very old legacy 32bit
> > software installed in their webspace. This cannot be supported
> > forever. But the number of such cases is very small, and there just
> > needs to be enough time for finding a solution for those few
> > customers.
> >
> > 3) the next development kernel _after_ that LTS release can then
> > immediately drop the 32bit support. Enterprise users should have
> > enough time for planning, and for lots of internal projects
> > modernizing their infrastructure. Usually, they will need to do this
> > anyway in the long term.
> 
> We've already phased out support for all 32-bit architectures except
> i386 in our products, and i386 is obviously next.  (We never supported
> x32 in the first place.)
> 
> It becomes increasingly difficult to build a 32-bit userspace that meets
> backwards-compatibility needs.  We want to use SSE2 (to avoid excess
> precision for double) and avoid relying on stack realignment (for
> compatibility with applications that use the old i386 ABI which did not
> require stack realignment).  We also have to build the distribution with
> a full complement of hardening flags.  This results in a combination of
> flags that is poorly tested in upstream GCC.  The i386 register file
> isn't large enough to support all these features at the same time and
> combine them with function arguments passed in registers (which some
> programs enable manually via function attributes).
> 
> So even if we keep the kernel interface, in the forseeable future, I
> expect that it will be difficult to build a full, contemporary 32-bit
> userspace on i386.

I guess that's informative of how one company's distro process works,
but it's not representative. Your customers are enterprise and
big-server (probably mostly the former) oriented which is exactly the
domain where 32-bit is of course irrelevant except for running legacy
applications. Where it matters are embedded and other systems striving
for resource efficiency.

For what it's worth, 32-bit archs including i386 and many others are
well-supported in Debian with no forseeable EOL I'm aware of, and most
if not all of the musl-libc-based distros I'm familiar with support
32-bit archs including i386.

I don't think waning relevance of 32-bit is a reasonable argument
against x32 since x32's relevance is in exactly the places where
32-bit is already relevant and preferred for important reasons.

Rich
