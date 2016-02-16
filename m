From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Tue, 16 Feb 2016 11:02:17 +0000
Message-ID: <20160216110217.3de7c007@lxorguk.ukuu.org.uk>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
	<1455617295-23736-5-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455617295-23736-5-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> +static void mps2_uart_set_termios(struct uart_port *port,
> +	struct ktermios *new, struct ktermios *old)

Not that I care much but you might not want to call it "new". People get
upset when their syntax aware editors get confused by C++ keywords 8)

> +{
> +	unsigned long flags;
> +	unsigned int baud, bauddiv;
> +
> +	new->c_cflag &= ~(CRTSCTS | CMSPAR);
> +	new->c_cflag &= ~CSIZE;
> +	new->c_cflag |= CS8;
> +	new->c_cflag &= ~PARENB;
> +	new->c_cflag &= ~CSTOPB;
> +
> +	baud = uart_get_baud_rate(port, new, old,
> +			DIV_ROUND_CLOSEST(port->uartclk, UARTn_BAUDDIV_MASK),
> +			DIV_ROUND_CLOSEST(port->uartclk, 16));
> +
> +	bauddiv = DIV_ROUND_CLOSEST(port->uartclk, baud);
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	uart_update_timeout(port, new->c_cflag, baud);
> +	mps2_uart_write32(port, bauddiv, UARTn_BAUDDIV);

This should also set the baud bits back in the termios struct
accordingly. 

	if (tty_termios_baud_rate(new))
		tty_termios_encode_baud_rate(new, baud, baud);


Not a big deal and could certainly be a follow up patch after it's merged.

Alan
