From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 26 Nov 2014 12:33:13 +0000
Message-ID: <20141126123313.520ac83f@lxorguk.ukuu.org.uk>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: mark.rutland@arm.com, andrew@lunn.ch, heiko@sntech.de, broonie@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-api@vger.kernel.org, jslaby@suse.cz, artagnon@gmail.com, lanqing.liu@spreadtrum.com, arnd@arndb.de, corbet@lwn.net, zhang.lyra@gmail.com, zhizhou.zhang@spreadtrum.com, geng.ren@spreadtrum.com, m-karicheri2@ti.com, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, grant.likely@linaro.org, orsonzhai@gmail.com, florian.vaussard@epfl.ch, devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, hytszk@gmail.com, rrichter@cavium.com, broonie@kernel.org, wei.qiao@spreadtrum.com, sprdlinux@freelists.org, shawn.guo@freescale.com, gregkh@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, galak@codeaurora.org
List-Id: linux-api@vger.kernel.org

> +		 213 = /dev/ttySPX0		SPRD serial port 0
> +		    ...
> +		 216 = /dev/ttySPX3		SPRD serial port 3

Please use dynamic allocation or give a very very good reason why you
can't

> +config SERIAL_SPRD_NR
> +        int "Maximum number of sprd serial ports"
> +        depends on SERIAL_SPRD
> +        default "4"

If you are doing dynamic allocation this should pretty much go away


> +static int sprd_startup(struct uart_port *port)
> +{
> +	int ret = 0;
> +	unsigned int ien, ctrl1;
> +	struct sprd_uart_port *sp;
> +
> +	serial_out(port, SPRD_CTL2, ((THLD_TX_EMPTY << 8) | THLD_RX_FULL));
> +
> +	/* clear rx fifo */
> +	while (serial_in(port, SPRD_STS1) & 0x00ff)
> +		serial_in(port, SPRD_RXD);
> +
> +	/* clear tx fifo */
> +	while (serial_in(port, SPRD_STS1) & 0xff00)
> +		;

Missing a cpu_relax and I would have thought a timeout on both of these.


> +static void sprd_set_termios(struct uart_port *port,
> +				    struct ktermios *termios,
> +				    struct ktermios *old)
> +{
> +	unsigned int baud, quot;

> +	/* calculate parity */
> +	lcr &= ~SPRD_LCR_PARITY;
> +	if (termios->c_cflag & PARENB) {
> +		lcr |= SPRD_LCR_PARITY_EN;
> +		if (termios->c_cflag & PARODD)
> +			lcr |= SPRD_LCR_ODD_PAR;
> +		else
> +			lcr |= SPRD_LCR_EVEN_PAR;
> +	}

If you don't support mark/space parity then also clear CMSPAR in
termios->c_cflag. If you do then it ought to be handled above.

> +
> +	/* clock divider bit16~bit20 */
> +	serial_out(port, SPRD_CLKD1, (quot & 0x1f0000) >> 16);
> +	serial_out(port, SPRD_LCR, lcr);
> +	fc |= 0x3e00 | THLD_RX_FULL;
> +	serial_out(port, SPRD_CTL1, fc);

Also set the resulting baud back into the termios (see the 8250 termios
for an example)


> +static int __init sprd_console_setup(struct console *co, char *options)
> +{
> +	struct uart_port *port;
> +	int baud = 115200;
> +	int bits = 8;
> +	int parity = 'n';
> +	int flow = 'n';
> +
> +	if (unlikely(co->index >= UART_NR_MAX || co->index < 0))
> +		co->index = 0;
> +
> +	port = (struct uart_port *)sprd_port[co->index];
> +	if (port == NULL) {
> +		pr_info("srial port %d not yet initialized\n", co->index);

Typo

Looks basically sound to me

Alan
