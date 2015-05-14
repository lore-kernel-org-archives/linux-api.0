From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] Documentation/arch: Add kernel feature descriptions
 and arch support status under Documentation/features/
Date: Thu, 14 May 2015 21:59:25 +0200
Message-ID: <20150514195925.GA27570@gmail.com>
References: <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
 <20150514103544.GA7027@gmail.com>
 <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150514123835.1bf436bc35d711f8dbf9bc0f@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Add arch support matrices for more than 40 generic kernel features
> > that need per architecture support.
> > 
> > Each feature has its own directory under Documentation/features/feature_name/,
> > and the arch-support.txt file shows its current arch porting status.
> > 
> > For example, lockdep support is shown the following way:
> > 
> >     triton:~/tip> cat Documentation/features/lockdep/arch-support.txt
> >     #
> >     # Feature name:          lockdep
> >     #         Kconfig:       LOCKDEP_SUPPORT
> >     #         description:   arch supports the runtime locking correctness debug facility
> >     #
> >         -----------------------
> >         |         arch |status|
> >         -----------------------
> > ...
> >         |      xtensa: |  ok  |
> >         -----------------------
> > 
> > For generic kernel features that need architecture support, the
> > arch-support.txt file in each feature directory shows the arch
> > support matrix, for all upstream Linux architectures.
> > 
> > The meaning of entries in the tables is:
> > 
> >     | ok |  # feature supported by the architecture
> >     |TODO|  # feature not yet supported by the architecture
> >     | .. |  # feature cannot be supported by the hardware
> 
> Presumably there will be instances where the maintainer decides "we 
> shall not implement that".

So I tried to limit the list of features to those that represent the 
overall progress of the generic kernel and are recommended on all 
architectures that are able to support it.

There are certainly features that are opt-in. We could still list them 
here as well, because this is a convenient central index, but would 
mark them not with 'TODO' but with a low-key '..' marking?

On the other end of the spectrum we could also define 'must have' 
features for new architectures. For example modern-timekeeping and 
clockevents.

The patch that adds a new architecture to all these files would give 
us a good overview about how complete an initial port is.

> > This directory structure can be used in the future to add other 
> > files - such as porting guides, testing description, etc.
> 
> I suppose so.  Having a great bunch of directories, each containing 
> a single file is a bit odd.

It's a starting point and nicely extensible. I was thinking about one 
more intermediate level:

   Documentation/features/locking/lockdep/
   Documentation/features/locking/rwsem-optimized/
   Documentation/features/locking/queued-rwlocks/
   Documentation/features/locking/queued-spinlocks/
   ...

   Documentation/features/vm/PG_uncached/
   Documentation/features/vm/pmdp_splitting_flush/
   Documentation/features/vm/pte_special/
   ...

The advantage of this, beyond more structure, would be that I'd 
probably move most of the Documentation/locking/*.txt files into 
Documentation/features/locking/, for example lockdep-design.txt would 
go into Documentation/features/locking/lockdep/.

I'd keep the hierarchy at a predictable depth though, i.e.:

   Documentation/features/<subsystem>/<feature_name>/

> It would be nice to provide people with commit IDs to look at, but 
> the IDs won't be known at the time the documentation file is 
> created.  We could provide patch titles.

Ok.

> But still, let's not overdo it - get something in there, see how 
> well it works, evolve it over time.

Yeah.

> I don't think we've heard from any (non-x86) arch maintainers?  Do 
> they consider this useful at all?  Poke.

I think we god some feedback from the PowerPC side, but yeah, would be 
nice to get more reactions.

Thanks,

	Ingo
