From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Tue, 9 Nov 2010 13:47:00 +0100
Message-ID: <201011091347.00310.arnd@arndb.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <201011080756.50930.arnd@arndb.de> <20101109102641.GB2690@riccoc20.at.omicron.at>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109102641.GB2690-7KxsofuKt4IfAd9E5cN8NEzG7cXyKsk/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tuesday 09 November 2010, Richard Cochran wrote:
> On Mon, Nov 08, 2010 at 07:56:50AM +0100, Arnd Bergmann wrote:
> > On Thursday 04 November 2010, Richard Cochran wrote:
> > >  #define CPUCLOCK_PERTHREAD_MASK	4
> > >  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
> > >  #define CPUCLOCK_CLOCK_MASK	3
> > > @@ -28,12 +40,17 @@ struct cpu_timer_list {
> > >  #define CPUCLOCK_VIRT		1
> > >  #define CPUCLOCK_SCHED		2
> > >  #define CPUCLOCK_MAX		3
> > > +#define CLOCKFD			CPUCLOCK_MAX
> > > +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
> > 
> > It looks like you are turning a kernel internal interface into a user ABI,
> > which I think is highly questionable. Using the bits like this internally is
> > ok, but making it part of the syscall ABI means that we can never change this
> > in the future.
> 
> This set of defines is already part of the ABI and has been copied
> into glibc.  I am extending the (mis)use of the clock id by adding one
> more case.

Ok, that is very different then. I wonder why posix-timers.h is not an exported
header file, it might be good to change that to make it explicit which parts of
it define the ABI and which parts are kernel internal.

	Arnd
