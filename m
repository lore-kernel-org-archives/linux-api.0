From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [patch v23 1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 29 May 2018 15:09:48 +0200
Message-ID: <20180529130948.GC30119@kroah.com>
References: <1527594545-19870-1-git-send-email-oleksandrs@mellanox.com>
 <1527594545-19870-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527594545-19870-2-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 29, 2018 at 02:49:02PM +0300, Oleksandr Shamray wrote:
> +static int jtag_release(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}

If you do not do anything, then there is no need to have this callback
at all, right?

> +/**
> + * enum jtag_endstate:
> + *
> + * @JTAG_STATE_IDLE: JTAG state machine IDLE state
> + * @JTAG_STATE_PAUSEIR: JTAG state machine PAUSE_IR state
> + * @JTAG_STATE_PAUSEDR: JTAG state machine PAUSE_DR state
> + */
> +enum jtag_endstate {
> +	JTAG_STATE_IDLE,
> +	JTAG_STATE_PAUSEIR,
> +	JTAG_STATE_PAUSEDR,

Be specific with these enums, set them to a value so you know all is
good.  Userspace C compilers can be funny at times.

Otherwise, looks really good, nice work.

greg k-h
