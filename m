From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 1/8] Introduce dynamic clock devices
Date: Sat, 4 Dec 2010 15:55:22 +0100
Message-ID: <20101204145343.GA8390@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
 <201011080738.41871.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201011080738.41871.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 08, 2010 at 07:38:41AM +0100, Arnd Bergmann wrote:
> On Thursday 04 November 2010, Richard Cochran wrote:
> > +struct clock_device {
> > +	struct file_operations fops;
> > +	struct file_operations *driver_fops;
> > +	struct clock_device_operations *ops;
> > +	struct cdev cdev;
> > +	struct kref kref;
> > +	struct mutex mux;
> > +	void *priv;
> > +	int index;
> > +	bool zombie;
> > +};
> 
> You should really not need the file_operations here, neither the
> struct nor the pointer. Just define a static file_operations
> structure containing clock_device_open and clock_device_release,
> and whatever else you might need, then add the driver's operations
> to clock_device_operations, and pass the clock_device pointer
> directly to them, instead of passing the file/inode pointers.

Arnd, I'm working a revision of this series, and I am not sure I
understand your comment.

The intent here was to allow clock drivers to register a character
device through the clock_device API, since some clocks (hpet, rtc)
already offer a chardev interface.

The same FD from the open character device will also be usable as a
clockid for the generic posix clock_get/settime calls. Thus, the
clock_device layer needs to hook into the file open/release functions.

Are you suggesting that I simply offer all of the functions from a
'struct file_operations' (sans file/inode) in the 'struct
clock_device_operations' too?

I wanted to avoid duplicating the file_operations functions, so that
future changes in those functions would automatically trickle down to
the clock drivers.

Thanks,
Richard
