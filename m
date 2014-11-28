From: Orson Zhai <orsonzhai@gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Fri, 28 Nov 2014 18:13:50 +0800
Message-ID: <54784ADE.6010602@gmail.com>
References: <Sharkl64-v3>	<1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>	<1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com> <20141126123313.520ac83f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141126123313.520ac83f@lxorguk.ukuu.org.uk>
Sender: linux-doc-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com, gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com, arnd@arndb.de, corbet@lwn.net, jason@lakedaemon.net, broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sprdlinux@freelists.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi, Alan,

Thanks for your comments!
Some question for them below,

On 2014=E5=B9=B411=E6=9C=8826=E6=97=A5 20:33, One Thousand Gnomes wrote=
:
>> +		 213 =3D /dev/ttySPX0		SPRD serial port 0
>> +		    ...
>> +		 216 =3D /dev/ttySPX3		SPRD serial port 3
> Please use dynamic allocation or give a very very good reason why you
> can't
do we just leave the .major & .minor as NULL in struct uart_driver for=20
dynamic allocation?
>> +config SERIAL_SPRD_NR
>> +        int "Maximum number of sprd serial ports"
>> +        depends on SERIAL_SPRD
>> +        default "4"
> If you are doing dynamic allocation this should pretty much go away
I think you mean getting the number of uarts from dt and dynamically=20
allocate their port structure?
>
>> +static int sprd_startup(struct uart_port *port)
>> +{
>> +	int ret =3D 0;
>> +	unsigned int ien, ctrl1;
>> +	struct sprd_uart_port *sp;
>> +
>> +	serial_out(port, SPRD_CTL2, ((THLD_TX_EMPTY << 8) | THLD_RX_FULL))=
;
>> +
>> +	/* clear rx fifo */
>> +	while (serial_in(port, SPRD_STS1) & 0x00ff)
>> +		serial_in(port, SPRD_RXD);
>> +
>> +	/* clear tx fifo */
>> +	while (serial_in(port, SPRD_STS1) & 0xff00)
>> +		;
> Missing a cpu_relax and I would have thought a timeout on both of the=
se.
We will add in V4
>
>
>> +static void sprd_set_termios(struct uart_port *port,
>> +				    struct ktermios *termios,
>> +				    struct ktermios *old)
>> +{
>> +	unsigned int baud, quot;
>> +	/* calculate parity */
>> +	lcr &=3D ~SPRD_LCR_PARITY;
>> +	if (termios->c_cflag & PARENB) {
>> +		lcr |=3D SPRD_LCR_PARITY_EN;
>> +		if (termios->c_cflag & PARODD)
>> +			lcr |=3D SPRD_LCR_ODD_PAR;
>> +		else
>> +			lcr |=3D SPRD_LCR_EVEN_PAR;
>> +	}
> If you don't support mark/space parity then also clear CMSPAR in
> termios->c_cflag.
just simply use code like "termios->c_cflag &=3D ~CMSPAR" ?

> If you do then it ought to be handled above.
>
>> +
>> +	/* clock divider bit16~bit20 */
>> +	serial_out(port, SPRD_CLKD1, (quot & 0x1f0000) >> 16);
>> +	serial_out(port, SPRD_LCR, lcr);
>> +	fc |=3D 0x3e00 | THLD_RX_FULL;
>> +	serial_out(port, SPRD_CTL1, fc);
> Also set the resulting baud back into the termios (see the 8250 termi=
os
> for an example)
you mean something like this part ?

/* Don't rewrite B0 */
if (tty_termios_baud_rate(termios))
tty_termios_encode_baud_rate(termios, baud, baud);


>
>
>> +static int __init sprd_console_setup(struct console *co, char *opti=
ons)
>> +{
>> +	struct uart_port *port;
>> +	int baud =3D 115200;
>> +	int bits =3D 8;
>> +	int parity =3D 'n';
>> +	int flow =3D 'n';
>> +
>> +	if (unlikely(co->index >=3D UART_NR_MAX || co->index < 0))
>> +		co->index =3D 0;
>> +
>> +	port =3D (struct uart_port *)sprd_port[co->index];
>> +	if (port =3D=3D NULL) {
>> +		pr_info("srial port %d not yet initialized\n", co->index);
> Typo
it will be fixed :)

Thanks,
Orson
> Looks basically sound to me
>
> Alan

