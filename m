From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [patch v23 4/4] Documentation: jtag: Add ABI documentation
Date: Tue, 29 May 2018 15:08:45 +0200
Message-ID: <20180529130845.GB30119@kroah.com>
References: <1527594545-19870-1-git-send-email-oleksandrs@mellanox.com>
 <1527594545-19870-5-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527594545-19870-5-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 29, 2018 at 02:49:05PM +0300, Oleksandr Shamray wrote:
> +++ b/Documentation/ABI/testing/jtag-dev
> @@ -0,0 +1,27 @@
> +What:		/dev/jtag[0-9]+
> +Date:		May 2018
> +KernelVersion:	4.18
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

Your open call tests for nothing, don't worry about it here at all :)

> +
> +		ioctl(2)
> +		Initiate various actions.
> +		See the inline documentation in [include/uapi]<linux/jtag.h>
> +		for descriptions of all ioctls.
> +
> +		close(2)
> +		Stops and free up the I/O contexts that was associated
> +		with the file descriptor.

No, your close() does not do any of that.

> +
> +Users:		TBD

No users?  They why do we have this api at all?

> +open(), close()
> +-------
> +open() opens JTAG device. Only one open operation per JTAG device
> +can be performed. Two or more open for one device will return error.

Not true :)

> +
> +Open/Close  device:
> +- jtag_fd = open("/dev/jtag0", O_RDWR);
> +- close(jtag_fd);
> +
> +ioctl()
> +-------
> +All access operations to JTAG devices are erformed through ioctl interface.
> +The IOCTL interface supports these requests:
> +	JTAG_IOCRUNTEST - Force JTAG state machine to RUN_TEST/IDLE state
> +	JTAG_SIOCFREQ - Set JTAG TCK frequency
> +	JTAG_GIOCFREQ - Get JTAG TCK frequency
> +	JTAG_IOCXFER - send JTAG data Xfer
> +	JTAG_GIOCSTATUS - get current JTAG TAP status
> +	JTAG_SIOCMODE - set JTAG mode flags.
> +
> +JTAG_SIOCFREQ, JTAG_GIOCFREQ
> +------
> +Set/Get JTAG clock speed:
> +
> +	unsigned int jtag_fd;
> +	ioctl(jtag_fd, JTAG_SIOCFREQ, &frq);
> +	ioctl(jtag_fd, JTAG_GIOCFREQ, &frq);
> +
> +JTAG_IOCRUNTEST
> +------
> +Force JTAG state machine to RUN_TEST/IDLE state
> +
> +struct jtag_run_test_idle {
> +	__u8	reset;
> +	__u8	endstate;
> +	__u8	tck;
> +};
> +
> +reset: 0 - run IDLE/PAUSE from current state
> +	   1 - go through TEST_LOGIC/RESET state before IDLE/PAUSE

Are you sure your enums are these values?  You should explicitly set
them in your .h file to be positive.

thanks,

greg k-h
