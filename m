From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Thu, 14 May 2015 12:38:35 -0700
Message-ID: <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
References: <20150513083441.GA17336@gmail.com>
	<20150513085636.GA11030@gmail.com>
	<20150513092421.GB11030@gmail.com>
	<20150513094622.GC11030@gmail.com>
	<20150513094756.GD11030@gmail.com>
	<20150513131835.GJ1517@pd.tnic>
	<20150513134842.GA1657@gmail.com>
	<20150513162757.GA21894@x>
	<20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
	<20150514101518.GA27550@gmail.com>
	<20150514103544.GA7027@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150514103544.GA7027@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> Add arch support matrices for more than 40 generic kernel features
> that need per architecture support.
> 
> Each feature has its own directory under Documentation/features/feature_name/,
> and the arch-support.txt file shows its current arch porting status.
> 
> For example, lockdep support is shown the following way:
> 
>     triton:~/tip> cat Documentation/features/lockdep/arch-support.txt
>     #
>     # Feature name:          lockdep
>     #         Kconfig:       LOCKDEP_SUPPORT
>     #         description:   arch supports the runtime locking correctness debug facility
>     #
>         -----------------------
>         |         arch |status|
>         -----------------------
> ...
>         |      xtensa: |  ok  |
>         -----------------------
> 
> For generic kernel features that need architecture support, the
> arch-support.txt file in each feature directory shows the arch
> support matrix, for all upstream Linux architectures.
> 
> The meaning of entries in the tables is:
> 
>     | ok |  # feature supported by the architecture
>     |TODO|  # feature not yet supported by the architecture
>     | .. |  # feature cannot be supported by the hardware

Presumably there will be instances where the maintainer decides "we
shall not implement that".

> This directory structure can be used in the future to add other
> files - such as porting guides, testing description, etc.

I suppose so.  Having a great bunch of directories, each containing a
single file is a bit odd.

It would be nice to provide people with commit IDs to look at, but the
IDs won't be known at the time the documentation file is created.  We
could provide patch titles.

But still, let's not overdo it - get something in there, see how well
it works, evolve it over time.

I don't think we've heard from any (non-x86) arch maintainers?  Do they
consider this useful at all?  Poke.
