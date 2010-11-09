From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Tue, 9 Nov 2010 09:23:53 +0100
Message-ID: <20101109082353.GA2690@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
 <1289259423.21487.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1289259423.21487.7.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 08, 2010 at 03:37:03PM -0800, john stultz wrote:
> On Thu, 2010-11-04 at 20:28 +0100, Richard Cochran wrote: 
> > #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
> 
> So I think we may want to add some additional comments here.
> Specifically around the limits both new and existing that are created
> around the interactions between clockid_t, pid_t and now the clock_fd.
> 
> Specifically, pid_t is already limited by futex to 29 bits (I believe,
> please correct me if I'm wrong). MAKE_PROCESS_CPUCLOCK macro below seems
> to also utilize this 29 bit pid limit assumption as well (via pid<<3),
> however it may actually require pid to be below 28 (since CLOCK_DISPATCH
> assumes cpu clockids are negative).
> 
> Anyway, this seems like it should be a bit more explicit.

Yes, you are right, of course, but I would like to point out that the
existing "overloading" of the clockid_t isn't really explained at all.
It was not clear to me whether or not 29 pid bits is enough for the
worst case, or not.

This code is older than 2005 (git/linux) and so I don't know who wrote
it and what they were thinking.  I took the first step and tried to
explain as much I understand.

> > +#define FD_TO_CLOCKID(fd)  ((clockid_t) (fd << 3) | CLOCKFD)
> > +#define CLOCKID_TO_FD(clk) (((unsigned int) clk) >> 3)
> 
> So similarly here, we need to be explicit in making sure that the max fd
> value is small enough to fit without dropping bits if we shift it up by
> three (trying to quickly review open I don't see any explicit limit,
> other then NR_OPEN_DEFAULT, but that's BIT_PER_LONG, which won't fit in
> the int returned by open on 64bit systems).

I also didn't see any limit to the number of open files, except that
it must be a non-negative (signed) integer.

For userspace, there will have to be a glibc function/macro like
FD_TO_CLOCKID() that tests the three most significant bits and returns
CLOCK_INVALID if any are set.

This will result in the limitation that if a userspace program already
has 2^29 (536 million) open files, then it will not be able to obtain
a dynamic clock id. I think we can live with that.

> So sort of minor nit here, but is there a reason the clockfd
> implementation is primary here and the standard posix implementation
> gets pushed off into its own function rather then doing something like:
> 
> clk = clockid_to_clock_device(id)
> if(clk)
> 	return clockdev_clock_gettime(clk, user_ts);
> [existing sys_clock_gettime()] 
> 
> As you implemented it, it seems to expect the clockdevice method to be
> the most frequent use case, where as its likely to be the inverse. So
> folks looking into the more common CLOCK_REALTIME calls have to traverse
> more code then the likely more rare clockfd cases.

Actually, what I would like to do is refactor the exisiting posix
clock code to use the new framework. The idea is to have a set of
static global clock_device*, one per fixed clock. The function
clockid_to_clock_device() will include a lookup table, like this:

static clock_device *realtime_clock, *monotinic_clock;

switch (id) {
case CLOCK_REALTIME:
	return realtime_clock;
case CLOCK_MONOTONIC:
	return monotinic_clock;
/* and so on ... */
}

This could be done on top of the existing patch in an incremental way.
However, I did not want to change everything all at once.

> Also, in my mind, it would seem more in-line with the existing code to
> integrate the conditional into CLOCK_DISPATCH. Not that CLOCK_DISPATCH
> is pretty, but it avoids making your changes look tacked on in front of
> everything.

Sorry to disagree, but I really don't want to be the one to extend
that macro in any way. IMHO it really should be replaced with
something more legible.

Thanks for the review,

Richard
