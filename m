From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Fri, 15 May 2015 08:57:28 +1000
Message-ID: <1431644248.2981.1.camel@ellerman.id.au>
References: <20150513083441.GA17336@gmail.com>
	 <20150513085636.GA11030@gmail.com> <20150513092421.GB11030@gmail.com>
	 <20150513094622.GC11030@gmail.com> <20150513094756.GD11030@gmail.com>
	 <20150513131835.GJ1517@pd.tnic> <20150513134842.GA1657@gmail.com>
	 <20150513162757.GA21894@x>
	 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
	 <20150514101518.GA27550@gmail.com> <20150514103544.GA7027@gmail.com>
	 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150514123835.1bf436bc35d711f8dbf9bc0f-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-05-14 at 12:38 -0700, Andrew Morton wrote:
> > Add arch support matrices for more than 40 generic kernel features
> > that need per architecture support.
> > 
> > Each feature has its own directory under Documentation/features/feature_name/,
> > and the arch-support.txt file shows its current arch porting status.
> 
> It would be nice to provide people with commit IDs to look at, but the
> IDs won't be known at the time the documentation file is created.  We
> could provide patch titles.

+1 on patch titles.

> But still, let's not overdo it - get something in there, see how well
> it works, evolve it over time.
> 
> I don't think we've heard from any (non-x86) arch maintainers?  Do they
> consider this useful at all?  Poke.

Yes it is. I have my own version I've cobbled together for powerpc, but this is
much better.

I'd like to see more description in the individual files of what the feature
is, and preferably some pointers to what's needed to implement it.

The kconfig for HAVE_ARCH_SECCOMP_FILTER is a good example of what I mean.

I realise retrofitting that for all these existing features is quite time
consuming, but for new features hopefully the bar can be raised a little in
terms of that description.

cheers
