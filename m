From: Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Mon, 14 Dec 2015 14:36:18 +0100
Message-ID: <566EC5D2.9050005@linaro.org>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
 <1449048790-25859-3-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449048790-25859-3-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Mark.Rutland-5wv7dgnIgG8@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/02/2015 10:33 AM, Vladimir Murzin wrote:
> MPS2 platform has simple 32 bits general purpose countdown timers.
>
> The driver uses the first detected timer as a clocksource and the res=
t
> of the timers as a clockevent
>
> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> ---

[ ... ]

> +static void clockevent_mps2_writel(u32 val, struct clock_event_devic=
e *c, u32 offset)
> +{
> +	writel(val, to_mps2_clkevt(c)->reg + offset);
> +}

Is it possible to use writel_relaxed here ?

[ ... ]

> +static int mps2_timer_set_periodic(struct clock_event_device *ce)
> +{
> +	u32 clock_count_per_tick =3D to_mps2_clkevt(ce)->clock_count_per_ti=
ck;
> +
> +	clockevent_mps2_writel(clock_count_per_tick, ce, TIMER_RELOAD);
> +	clockevent_mps2_writel(clock_count_per_tick, ce, TIMER_VALUE);
> +	clockevent_mps2_writel(TIMER_CTRL_IE | TIMER_CTRL_ENABLE, ce, TIMER=
_CTRL);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t mps2_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clockevent_mps2 *ce =3D dev_id;
> +	u32 status =3D readl(ce->reg + TIMER_INT);
> +
> +	if (!status) {
> +		pr_warn("spuirous interrupt\n");

typo: 'spurious'

[ ... ]

> +	ce =3D kzalloc(sizeof(struct clockevent_mps2), GFP_KERNEL);
> +	if (!ce) {
> +		ret =3D -ENOMEM;
> +		pr_err("failed to allocate clockevent: %d\n", ret);

There is already a stack trace in the kernel when an allocation fails.

With the above fixed:

Acked-by: Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>


--=20
  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software fo=
r ARM SoCs

=46ollow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
