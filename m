From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Mon, 16 Jun 2014 10:58:37 -0400
Message-ID: <20140616145837.GA179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
 <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
 <20140616143801.GJ5714@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140616143801.GJ5714@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Ian Lance Taylor <iant@golang.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 16, 2014 at 04:38:01PM +0200, Andi Kleen wrote:
> > I think this issue started when some of the Go developers questioned
> > why the kernel needed to provide a very complex interface--parsing an
> > ELF shared shared library--for very simple functionality--looking up
> > the address of a magic function.  This approach has required special
> > support not just in Go, but also in the dynamic linker and gdb, and
> > does not work well for statically linked binaries.  The support in gdb
> > is perhaps a good idea, but elsewhere it does not make sense.
> > 
> > So why not provide a simple interface?
> 
> What good would it do now that everyone already supports it?
> 
> The proposal is 10+ years too late.

I addressed that in one of my first emails to this thread. I don't
think adding it now is immediately useful, but it will be very nice to
have in a few years when optimizing for kernels from 2014 and earlier
is no longer a priority. I would expect new users of vdso at that time
not to bother with the ELF parsing ugliness and simply to use the
lookup interface. It's not like they'd be losing any functionality on
old kernels, just some performance due to falling back to the syscall.

Rich
