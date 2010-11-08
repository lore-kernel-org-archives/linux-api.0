From: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RFC 0/8] Dynamic clock devices
Date: Mon, 08 Nov 2010 15:01:04 -0800
Message-ID: <1289257264.2798.98.camel@localhost.localdomain>
References: <cover.1288897198.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Thu, 2010-11-04 at 20:26 +0100, Richard Cochran wrote:
> The clock_ syscalls are moved into a new file and they call the older
> posix functions when needed. The timer_ syscalls stay where they are,
> in posix-timers.c, since I did not want to change the fairly involved
> timer management code. Eventually, we could remove the posix clock_*
> functions for the CLOCK_* ids from posix-timers.c and rework them
> using the new dynamic clock api. That would leave just the timer code
> in posix-timers.c, as the file name suggests.
> 
> I dropped the idea of having user space open a sysfs file in order to
> get a reference to a clock, since there are no open/release hooks
> within sysfs for drivers (coincidentally, there has been some talk
> about this on the lkml recently, but previously Greg KH object to
> abusing sysfs as a "clockfs").
> 
> Instead, since many clocks (hpet, rtc, ptp, ...) will want to offer a
> custom chardev for special advanced functionality, the dynamic clock
> layer registers a cdev for the driver, placing its own hooks into the
> open/release methods. The driver thus needs to access its private data
> via a standard access method (not just by using fp->private_data). If
> a driver doesn't want any chardev functions, that is okay, too.
> 
> Well, please take a look and let me know what you think.

Hey Richard!
	Thanks for sending this patchset out for review! This is definitely a
larger redesign from your earlier patch, and I see now how the
per-thread cputime clockids throws a wrench in my argument just using
the incremental clockids that hash into a smaller array to avoid id
reuse.

That said, given how different this is from the last implementation, I'm
not fully clear I see how to integrate this into my patch set. It might
be useful to see a trivial example of how you see a clockdevice being
registered and used.

Overall it looks interesting, but there may be a few catches that we may
have to watch out for.

I have a few other comments I'll make in context of the patches to
follow shortly.

thanks again!
-john
