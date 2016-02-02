From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Tue, 02 Feb 2016 14:06:59 +0000
Message-ID: <56B0B803.8010003@arm.com>
References: <1454413199-26573-1-git-send-email-vladimir.murzin@arm.com>
 <1454413199-26573-3-git-send-email-vladimir.murzin@arm.com>
 <alpine.DEB.2.11.1602021351440.25254@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <alpine.DEB.2.11.1602021351440.25254@nanos>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, andy.shevchenko@gmail.com, galak@codeaurora.org, linux-serial@vger.kernel.org, u.kleine-koenig@pengutronix.de, linux-api@vger.kernel.org, jslaby@suse.cz, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 02/02/16 13:04, Thomas Gleixner wrote:
> On Tue, 2 Feb 2016, Vladimir Murzin wrote:
>> +static int __init mps2_clockevent_init(struct device_node *np)
>> +{
>> +	void __iomem *base;
>> +	struct clk *clk;
>> +	struct clockevent_mps2 *ce;
>> +	u32 rate;
>> +	int irq, ret;
>> +	const char *name = "mps2-clkevt";
>> +
>> +	ret = of_property_read_u32(np, "clock-frequency", &rate);
>> +	if (ret) {
>> +		clk = of_clk_get(np, 0);
>> +		if (IS_ERR(clk)) {
>> +			ret = PTR_ERR(clk);
>> +			pr_err("failed to get clock for clockevent: %d\n", ret);
>> +			goto err_clk_get;
>> +		}
>> +
>> +		ret = clk_prepare_enable(clk);
>> +		if (ret) {
>> +			pr_err("failed to enable clock for clockevent: %d\n", ret);
>> +			clk_put(clk);
>> +			goto err_clk_enable;
>> +		}
>> +
>> +		rate = clk_get_rate(clk);
>> +	}
> 
> So in case that "clock-frequency" is available in DT, what enables and
> configures the clock?

They are fixed-clock, so I ended up this *cough* mess *cough* shortcut.
I'd be glad if you share your thoughts what is preferred way to cope
with it (is it worth to do at all?)

> 
>> +err_ia_alloc:
>> +	kfree(ce);
>> +err_ce_alloc:
>> +err_get_irq:
>> +	iounmap(base);
>> +err_iomap:
>> +	clk_disable_unprepare(clk);
> 
> clk is not initialized when "clock-frequency" is available in DT. The compiler
> should have told you ....

Shame on me, I've completely messed it up :( Thanks for pointing at it,
I'll fix this an other places you pointed at...

> 
>> +err_clk_enable:
>> +	clk_put(clk);
> 
> Put without get ....

or double clk_put() if clk_prepare_enable() failed... shame, shame, shame

> 
>> +static int __init mps2_clocksource_init(struct device_node *np)
>> +{
>> +	void __iomem *base;
>> +	struct clk *clk;
>> +	u32 rate;
>> +	int ret;
>> +	const char *name = "mps2-clksrc";
>> +
>> +	ret = of_property_read_u32(np, "clock-frequency", &rate);
>> +	if (ret) {
>> +		clk = of_clk_get(np, 0);
>> +		if (IS_ERR(clk)) {
>> +			ret = PTR_ERR(clk);
>> +			pr_err("failed to get clock for clocksource: %d\n", ret);
>> +			goto err_clk_get;
>> +		}
>> +
>> +		ret = clk_prepare_enable(clk);
>> +		if (ret) {
>> +			pr_err("failed to enable clock for clocksource: %d\n", ret);
>> +			clk_put(clk);
>> +			goto err_clk_enable;
>> +		}
>> +
>> +		rate = clk_get_rate(clk);
>> +	}
> 
> Same problem as above.
> 
>> +err_clocksource_init:
>> +	iounmap(base);
>> +err_iomap:
>> +	clk_disable_unprepare(clk);
> 
> Ditto.
> 
>> +err_clk_enable:
>> +	clk_put(clk);
> 
> Ditto.
> 
>> +err_clk_get:
>> +	return ret;
>> +}
>> +
>> +static void __init mps2_timer_init(struct device_node *np)
>> +{
>> +	static int has_clocksource, has_clockevent;
>> +	int ret;
>> +
>> +	if (!has_clocksource) {
>> +		ret = mps2_clocksource_init(np);
>> +		if (!ret) {
>> +			has_clocksource = 1;
>> +			return;
>> +		}
>> +	}
>> +
>> +	if (!has_clockevent) {
>> +		ret = mps2_clockevent_init(np);
>> +		if (!ret) {
>> +			has_clockevent = 1;
>> +			return;
>> +		}
>> +	}
> 
> You take randomly the first timer as clocksource and the second one as
> clockevent. If clocksource init fails, you try to install it as clockevent.
> 
> Sorry, but I really cannot follow the logic here.
> 

It has been done as a response on Daniel's comment [1]. I'm quite happy
to get known what init sequence is expected here.

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2015-November/388223.html

Thanks for your time, Thomas!

Vladimir

> Thanks,
> 
> 	tglx
> 
> 
> 
