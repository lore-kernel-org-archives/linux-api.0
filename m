From: Lance Richardson <lance.richardson.net@gmail.com>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 10:46:23 -0500
Message-ID: <CAPmeqMrVqJm4sqVgSLqJnmaVC5iakjJ_OxGWo4eFbOCxKEx=GA@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com> <CAOesGMgu1i3p7XMZuCEtj63T-ST_jh+BfaHy-K6LhgqNriKHAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOesGMgu1i3p7XMZuCEtj63T-ST_jh+BfaHy-K6LhgqNriKHAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: olof@lixom.net
Cc: torvalds@linux-foundation.org, luto@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hpa@zytor.com, peterz@infradead.org, bp@alien8.de, fweimer@redhat.com, vapier@gentoo.org, hjl.tools@gmail.com, dalias@libc.org, x32@buildd.debian.org, arnd@arndb.de, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: linux-api@vger.kernel.org

On Thu, Dec 13, 2018 at 9:39 AM Olof Johansson <olof@lixom.net> wrote:
>
> On Tue, Dec 11, 2018 at 9:40 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Mon, Dec 10, 2018 at 5:23 PM Andy Lutomirski <luto@kernel.org> wrote:
> > >
> > > I'm seriously considering sending a patch to remove x32 support from
> > > upstream Linux.  Here are some problems with it:
> >
> > I talked to Arnd (I think - we were talking about all the crazy ABI's,
> > but maybe it was with somebody else) about exactly this in Edinburgh.
> >
> > Apparently the main real use case is for extreme benchmarking. It's
> > the only use-case where the complexity of maintaining a whole
> > development environment and distro is worth it, it seems. Apparently a
> > number of Spec submissions have been done with the x32 model.
> >
> > I'm not opposed to trying to sunset the support, but let's see who complains..
>
> I'm just a single user. I do rely on it though, FWIW.
>
> I hadn't finished my benchmarking in Edinburgh, but for my new machine
> that does kernel builds 24/7, I ended up going with x32 userspace (in
> a container).
>
> Main reason is that it's a free ~10% improvement in runtime over
> 64-bit. I.e. GCC-as-a-workload is quite a bit faster as x32,
> supposedly mostly due to smaller D cache footprints (I ran out of
> cycles to tinker with back and forth perf data collection and settled
> down on just running it).
>
> Running classic 32-bit (i386? i686? whatever it's called) is about
> half as good. I.e. even then I get a ~5% performance win. Less than
> x32, but still better than 64-bit userspace.
>
>
> -Olof

I'm familiar with two embedded Linux systems using x32 ABI for the
following reasons:
   - Significant performance benefits over i386 ABI.
   - Smaller memory footprint than x86_64 (pointer-heavy data structures)
   - Large legacy software base with many ILP32 assumptions, much
     smaller effort to move to x32 than x86_64.

Some examples of (relatively minor) problems encountered with x32:
   - Time-related data type mismatch in socket options (fixed)
     https://patchwork.ozlabs.org/patch/904254/

   - Userspace overrun with select() (patch proposed)
     https://patchwork.kernel.org/patch/10245677/

   - glibc get_phys_pages() doesn't work correctly with x32
     (assumes that struct sysinfo fields are not wider than "long").

So, one small vote for keeping x32 with the hope that support for it
can continue to be improved...

   - Lance
