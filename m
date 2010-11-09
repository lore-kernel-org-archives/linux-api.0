From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Tue, 9 Nov 2010 11:26:41 +0100
Message-ID: <20101109102641.GB2690@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
 <201011080756.50930.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201011080756.50930.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 08, 2010 at 07:56:50AM +0100, Arnd Bergmann wrote:
> On Thursday 04 November 2010, Richard Cochran wrote:
> >  #define CPUCLOCK_PERTHREAD_MASK	4
> >  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
> >  #define CPUCLOCK_CLOCK_MASK	3
> > @@ -28,12 +40,17 @@ struct cpu_timer_list {
> >  #define CPUCLOCK_VIRT		1
> >  #define CPUCLOCK_SCHED		2
> >  #define CPUCLOCK_MAX		3
> > +#define CLOCKFD			CPUCLOCK_MAX
> > +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
> 
> It looks like you are turning a kernel internal interface into a user ABI,
> which I think is highly questionable. Using the bits like this internally is
> ok, but making it part of the syscall ABI means that we can never change this
> in the future.

This set of defines is already part of the ABI and has been copied
into glibc.  I am extending the (mis)use of the clock id by adding one
more case.

Richard
