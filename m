From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Mon, 15 Nov 2010 10:41:56 +0100
Message-ID: <20101115094156.GB15936@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
 <1289259423.21487.7.camel@localhost.localdomain>
 <20101109082353.GA2690@riccoc20.at.omicron.at>
 <1289337058.9434.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1289337058.9434.39.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 09, 2010 at 01:10:58PM -0800, john stultz wrote:
> On Tue, 2010-11-09 at 09:23 +0100, Richard Cochran wrote:
> > On Mon, Nov 08, 2010 at 03:37:03PM -0800, john stultz wrote:
> > > So sort of minor nit here, but is there a reason the clockfd
> > > implementation is primary here and the standard posix implementation
> > > gets pushed off into its own function rather then doing something like:
> > > 
> > > clk = clockid_to_clock_device(id)
> > > if(clk)
> > > 	return clockdev_clock_gettime(clk, user_ts);
> > > [existing sys_clock_gettime()] 
> > > 
> > > As you implemented it, it seems to expect the clockdevice method to be
> > > the most frequent use case, where as its likely to be the inverse. So
> > > folks looking into the more common CLOCK_REALTIME calls have to traverse
> > > more code then the likely more rare clockfd cases.
> > 
> > Actually, what I would like to do is refactor the exisiting posix
> > clock code to use the new framework. The idea is to have a set of
> > static global clock_device*, one per fixed clock. The function
> > clockid_to_clock_device() will include a lookup table, like this:
> > 
> > static clock_device *realtime_clock, *monotinic_clock;
> > 
> > switch (id) {
> > case CLOCK_REALTIME:
> > 	return realtime_clock;
> > case CLOCK_MONOTONIC:
> > 	return monotinic_clock;
> > /* and so on ... */
> > }
> 
> This seems a little over-reaching. I'm not sure I see what benefit would
> come from having clock_devices for the static clock_ids? The extra mutex
> locking and status/null checking for the clock_device would would just
> add unnecessary overhead to the performance critical clock_gettime call.

Okay, next time I'll leave the syscall in posix-timers.c and call out
to the clock_device in the unlikely dynamic case.

Thanks,
Richard
