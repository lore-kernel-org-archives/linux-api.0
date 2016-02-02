From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v2 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Tue, 2 Feb 2016 14:04:29 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1602021351440.25254@nanos>
References: <1454413199-26573-1-git-send-email-vladimir.murzin@arm.com> <1454413199-26573-3-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454413199-26573-3-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2 Feb 2016, Vladimir Murzin wrote:
> +static int __init mps2_clockevent_init(struct device_node *np)
> +{
> +	void __iomem *base;
> +	struct clk *clk;
> +	struct clockevent_mps2 *ce;
> +	u32 rate;
> +	int irq, ret;
> +	const char *name = "mps2-clkevt";
> +
> +	ret = of_property_read_u32(np, "clock-frequency", &rate);
> +	if (ret) {
> +		clk = of_clk_get(np, 0);
> +		if (IS_ERR(clk)) {
> +			ret = PTR_ERR(clk);
> +			pr_err("failed to get clock for clockevent: %d\n", ret);
> +			goto err_clk_get;
> +		}
> +
> +		ret = clk_prepare_enable(clk);
> +		if (ret) {
> +			pr_err("failed to enable clock for clockevent: %d\n", ret);
> +			clk_put(clk);
> +			goto err_clk_enable;
> +		}
> +
> +		rate = clk_get_rate(clk);
> +	}

So in case that "clock-frequency" is available in DT, what enables and
configures the clock?

> +err_ia_alloc:
> +	kfree(ce);
> +err_ce_alloc:
> +err_get_irq:
> +	iounmap(base);
> +err_iomap:
> +	clk_disable_unprepare(clk);

clk is not initialized when "clock-frequency" is available in DT. The compiler
should have told you ....

> +err_clk_enable:
> +	clk_put(clk);

Put without get ....

> +static int __init mps2_clocksource_init(struct device_node *np)
> +{
> +	void __iomem *base;
> +	struct clk *clk;
> +	u32 rate;
> +	int ret;
> +	const char *name = "mps2-clksrc";
> +
> +	ret = of_property_read_u32(np, "clock-frequency", &rate);
> +	if (ret) {
> +		clk = of_clk_get(np, 0);
> +		if (IS_ERR(clk)) {
> +			ret = PTR_ERR(clk);
> +			pr_err("failed to get clock for clocksource: %d\n", ret);
> +			goto err_clk_get;
> +		}
> +
> +		ret = clk_prepare_enable(clk);
> +		if (ret) {
> +			pr_err("failed to enable clock for clocksource: %d\n", ret);
> +			clk_put(clk);
> +			goto err_clk_enable;
> +		}
> +
> +		rate = clk_get_rate(clk);
> +	}

Same problem as above.

> +err_clocksource_init:
> +	iounmap(base);
> +err_iomap:
> +	clk_disable_unprepare(clk);

Ditto.

> +err_clk_enable:
> +	clk_put(clk);

Ditto.

> +err_clk_get:
> +	return ret;
> +}
> +
> +static void __init mps2_timer_init(struct device_node *np)
> +{
> +	static int has_clocksource, has_clockevent;
> +	int ret;
> +
> +	if (!has_clocksource) {
> +		ret = mps2_clocksource_init(np);
> +		if (!ret) {
> +			has_clocksource = 1;
> +			return;
> +		}
> +	}
> +
> +	if (!has_clockevent) {
> +		ret = mps2_clockevent_init(np);
> +		if (!ret) {
> +			has_clockevent = 1;
> +			return;
> +		}
> +	}

You take randomly the first timer as clocksource and the second one as
clockevent. If clocksource init fails, you try to install it as clockevent.

Sorry, but I really cannot follow the logic here.

Thanks,

	tglx
