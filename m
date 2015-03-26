From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH v3  10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Thu, 26 Mar 2015 15:46:18 +0000
Message-ID: <20150326154618.GO8656@n2100.arm.linux.org.uk>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
 <1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
 <5511ABAA.2010303@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5511ABAA.2010303-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Cc: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, stefan-XLVq0VzYD2Y@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj@k>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 02:23:38PM -0400, Peter Hurley wrote:
> Hi Maxime,
> 
> On 03/12/2015 05:55 PM, Maxime Coquelin wrote:
> > +static unsigned int stm32_get_mctrl(struct uart_port *port)
> > +{
> > +	/*
> > +	 * This routine is used for geting signals of: DTR, DCD, DSR, RI,
> > +	 * and CTS/RTS

It's also worth noting that this comment is wrong.  This is used to get
the state of DCD, DSR, RI and CTS.  DTR and RTS are *not* included
because the core tracks their state.

...

> > +	stm32port->clk = devm_clk_get(&pdev->dev, NULL);
> > +
> > +	if (WARN_ON(IS_ERR(stm32port->clk)))
> 
> Do you really need a stack trace here? Could this be dev_err() instead?
> 
> > +		return -EINVAL;

Also, propagate the error code.

> > +
> > +	/* ensure that clk rate is correct by enabling the clk */
> > +	clk_prepare_enable(stm32port->clk);

And remember to check the return value of clk_prepare_enable().

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
