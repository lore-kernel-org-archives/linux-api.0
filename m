From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch v14 4/4] Documentation: jtag: Add ABI documentation
Date: Mon, 12 Feb 2018 00:43:44 +0100
Message-ID: <20180211234344.GA3864@localhost>
References: <1513268971-13518-1-git-send-email-oleksandrs@mellanox.com>
 <1513268971-13518-5-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513268971-13518-5-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org
List-Id: linux-api@vger.kernel.org

Hi!

> @@ -0,0 +1,27 @@
> +What:		/dev/jtag[0-9]+
> +Date:		October 2017
> +KernelVersion:	4.15
> +Contact:	oleksandrs@mellanox.com
> +Description:
> +		The misc device files /dev/jtag* are the interface
> +		between JTAG master interface and userspace.
> +
> +		The ioctl(2)-based ABI is defined and documented in
> +		[include/uapi]<linux/jtag.h>.
> +
> +		The following file operations are supported:
> +
> +		open(2)
> +		The argument flag currently support only one access
> +		mode O_RDWR.
> +
> +		ioctl(2)
> +		Initiate various actions.
> +		See the inline documentation in [include/uapi]<linux/jtag.h>
> +		for descriptions of all ioctls.

I tried reading the jtag.h, and am still not sure how it works. Real docs
would be nice...

In particular, it seems to always specify read or write actiom. Sounds
like a job for read/write syscalls?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
