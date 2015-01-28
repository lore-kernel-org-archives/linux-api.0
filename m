From: Baruch Siach <baruch-NswTu9S1W3P6gbPvEgmw2w@public.gmane.org>
Subject: Re: [PATCH v9 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 28 Jan 2015 08:12:50 +0200
Message-ID: <20150128061250.GQ2555@sapphire.tkos.co.il>
References: <sc9836-serial-v9>
 <1422413261-17184-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1422413261-17184-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422413261-17184-3-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Chunyan Zhang,

On Wed, Jan 28, 2015 at 10:47:41AM +0800, Chunyan Zhang wrote:
[...]
> +static inline void sprd_rx(struct uart_port *port)
> +{
> +	struct tty_port *tty = &port->state->port;
> +	unsigned int ch, flag, lsr, max_count = SPRD_TIMEOUT;
> +
> +	while ((serial_in(port, SPRD_STS1) & 0x00ff) && max_count--) {
> +		lsr = serial_in(port, SPRD_LSR);
> +		ch = serial_in(port, SPRD_RXD);
> +		flag = TTY_NORMAL;
> +		port->icount.rx++;
> +
> +		if (lsr & (SPRD_LSR_BI | SPRD_LSR_PE |
> +			SPRD_LSR_FE | SPRD_LSR_OE))
> +			if (handle_lsr_errors(port, &lsr, &flag))
> +				continue;
> +		if (uart_handle_sysrq_char(port, ch))
> +			continue;

My comment[1] on a previous version of this patch still stands. 
uart_handle_sysrq_char is a NOP when SUPPORT_SYSRQ is not defined.

> +
> +		uart_insert_char(port, lsr, SPRD_LSR_OE, ch, flag);
> +	}
> +
> +	tty_flip_buffer_push(tty);
> +}

[...]

> +static void sprd_console_write(struct console *co, const char *s,
> +				      unsigned int count)
> +{
> +	struct uart_port *port = &sprd_port[co->index]->port;
> +	int locked = 1;
> +	unsigned long flags;
> +
> +	if (port->sysrq)
> +		locked = 0;

The sysrq field of struct uart_port is only defined when 
CONFIG_SERIAL_CORE_CONSOLE or SUPPORT_SYSRQ are defined. You should #ifdef 
this part accordingly to avoid build breakage.

> +	else if (oops_in_progress)
> +		locked = spin_trylock_irqsave(&port->lock, flags);
> +	else
> +		spin_lock_irqsave(&port->lock, flags);
> +
> +	uart_console_write(port, s, count, sprd_console_putchar);
> +
> +	/* wait for transmitter to become empty */
> +	wait_for_xmitr(port);
> +
> +	if (locked)
> +		spin_unlock_irqrestore(&port->lock, flags);
> +}

[1]
	http://article.gmane.org/gmane.linux.drivers.devicetree/106483

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch-NswTu9S1W3P6gbPvEgmw2w@public.gmane.org - tel: +972.2.679.5364, http://www.tkos.co.il -
