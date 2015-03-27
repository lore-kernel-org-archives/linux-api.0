From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 04/15] clocksource: Add ARM System timer driver
Date: Fri, 27 Mar 2015 09:36:37 +0100
Message-ID: <55151695.5050203@linaro.org>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>	<1426197361-19290-5-git-send-email-maxime.coquelin@st.com>	<5513D64A.7060702@linaro.org> <CALszF6CtEf0w8AoaMwFzn34ACMjkW6obT5_MrduBdUOm7T=zNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALszF6CtEf0w8AoaMwFzn34ACMjkW6obT5_MrduBdUOm7T=zNw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.>
List-Id: linux-api@vger.kernel.org

On 03/26/2015 09:19 PM, Maxime Coquelin wrote:
> Hi Daniel,
>
>    Thanks for the review. Please find my answers below.
>
> 2015-03-26 10:50 GMT+01:00 Daniel Lezcano <daniel.lezcano@linaro.org>=
:
>> On 03/12/2015 10:55 PM, Maxime Coquelin wrote:
>>>
>>> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>>
>>> This patch adds clocksource support for ARMv7-M's System timer,
>>> also known as SysTick.
>>>
>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>
>>
>> Hi Maxime,
>>
>> the driver looks good. Three comments below.
>>
>>    -- Daniel
>>
>>

[ ... ]

>>> +static void __init system_timer_of_register(struct device_node *np=
)
>>> +{
>>> +       struct clk *clk;
>>> +       void __iomem *base;
>>> +       u32 rate =3D 0;
>>> +       int ret;
>>> +
>>> +       base =3D of_iomap(np, 0);
>>> +       if (!base) {
>>> +               pr_warn("system-timer: invalid base address\n");
>>> +               return;
>>> +       }
>>> +
>>> +       clk =3D of_clk_get(np, 0);
>>> +       if (!IS_ERR(clk)) {
>>> +               ret =3D clk_prepare_enable(clk);
>>> +               if (ret) {
>>> +                       clk_put(clk);
>>> +                       goto out_unmap;
>>> +               }
>>> +
>>> +               rate =3D clk_get_rate(clk);
>>> +       }
>>> +
>>> +       /* If no clock found, try to get clock-frequency property *=
/
>>> +       if (!rate) {
>>> +               ret =3D of_property_read_u32(np, "clock-frequency",=
 &rate);
>>> +               if (ret)
>>> +                       goto out_unmap;
>>
>>
>> Shouldn't be 'goto out_clk_disable' ?
>
> No, because I assumed !rate means we failed to get the clock.
> Actually, clk_get_rate could return 0, so relying on rate value is no=
t safe.
>
> I propose to get clock-frequency property if IS_ERR(clk).
>
> Is it fine for you?

Why not invert the conditions ? If the 'clock-frequency' is specified i=
n=20
the DT then it overrides the clk_get_rate(). So the resulting code will=
 be:

ret =3D of_property_read_u32(np, "clock-frequency", &rate);
if (ret) {
	clk =3D of_clk_get(np, 0);
	if (IS_ERR(clk))
		goto out_unmap;

	ret =3D clk_prepare_enable(clk);
	if (ret)
		goto out_clk_put;

	rate =3D clk_get_rate(clk);
	if (!rate)
		goto out_clk_unprepare;
}



>>> +       }
>>> +
>>> +       writel_relaxed(SYSTICK_LOAD_RELOAD_MASK, base + SYST_RVR);
>>> +       writel_relaxed(SYST_CSR_ENABLE, base + SYST_CSR);
>>> +
>>> +       ret =3D clocksource_mmio_init(base + SYST_CVR, "arm_system_=
timer",
>>> rate,
>>> +                       200, 24, clocksource_mmio_readl_down);
>>> +       if (ret) {
>>> +               pr_err("failed to init clocksource (%d)\n", ret);
>>> +               goto out_clk_disable;
>>> +       }
>>> +
>>> +       pr_info("ARM System timer initialized as clocksource\n");
>>> +
>>> +       return;
>>> +
>>> +out_clk_disable:
>>> +       if (!IS_ERR(clk))
>>
>>
>> Why do you need this check ?
>
> To handle the case were no clock was found, but a clk-frequency value
> was provided.
>
>>
>> It isn't missing a clk_put ?
>
> Right, thanks for spotting this.
>
> I wonder if it makes sense to implement the error path.
> If we fail to initialize the clocksource, the system will be unusable=
=2E
>
> Maybe I should just perform a BUG_ON() in the error cases, as most of
> the other clocksource drivers do.
> What is your view?

I prefer to not BUG_ON in the init functions because it already happen=20
that drivers were bugging at init time and when a driver was reused on=20
another platform with several timers available, the board was not able=20
to boot because one timer was not used, hence not defined in the DT. I=20
don't know if that could be the case for this platform but I prefer to=20
keep thing going smoothly and return from init even if that lead to a=20
kernel hang. Of course, the errors must be displayed (pr_warn, pr_err,=20
pr_notice, etc ...).

>>
>>> +               clk_disable_unprepare(clk);
>>> +out_unmap:
>>> +       iounmap(base);
>>> +       WARN(ret, "ARM System timer register failed (%d)\n", ret);

pr_warn

Thanks

   -- Daniel

--=20
  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software fo=
r ARM SoCs

=46ollow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
