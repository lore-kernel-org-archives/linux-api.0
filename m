From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 04/15] clocksource: Add ARM System timer driver
Date: Fri, 27 Mar 2015 13:33:55 +0100
Message-ID: <CALszF6AyjsYGFE+nqCHzHA3M5W3dQNSHEbt34EnVNOZLer-f7A@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-5-git-send-email-maxime.coquelin@st.com>
	<5513D64A.7060702@linaro.org>
	<CALszF6CtEf0w8AoaMwFzn34ACMjkW6obT5_MrduBdUOm7T=zNw@mail.gmail.com>
	<55151695.5050203@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <55151695.5050203@linaro.org>
Sender: linux-gpio-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.sa>
List-Id: linux-api@vger.kernel.org

2015-03-27 9:36 GMT+01:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 03/26/2015 09:19 PM, Maxime Coquelin wrote:
>>
>> Hi Daniel,
>>
>>    Thanks for the review. Please find my answers below.
>>
>> 2015-03-26 10:50 GMT+01:00 Daniel Lezcano <daniel.lezcano@linaro.org=
>:
>>>
>>> On 03/12/2015 10:55 PM, Maxime Coquelin wrote:
>>>>
>>>>
>>>> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>>>
>>>> This patch adds clocksource support for ARMv7-M's System timer,
>>>> also known as SysTick.
>>>>
>>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>>
>>>
>>>
>>> Hi Maxime,
>>>
>>> the driver looks good. Three comments below.
>>>
>>>    -- Daniel
>>>
>>>
>
> [ ... ]
>
>
>>>> +static void __init system_timer_of_register(struct device_node *n=
p)
>>>> +{
>>>> +       struct clk *clk;
>>>> +       void __iomem *base;
>>>> +       u32 rate =3D 0;
>>>> +       int ret;
>>>> +
>>>> +       base =3D of_iomap(np, 0);
>>>> +       if (!base) {
>>>> +               pr_warn("system-timer: invalid base address\n");
>>>> +               return;
>>>> +       }
>>>> +
>>>> +       clk =3D of_clk_get(np, 0);
>>>> +       if (!IS_ERR(clk)) {
>>>> +               ret =3D clk_prepare_enable(clk);
>>>> +               if (ret) {
>>>> +                       clk_put(clk);
>>>> +                       goto out_unmap;
>>>> +               }
>>>> +
>>>> +               rate =3D clk_get_rate(clk);
>>>> +       }
>>>> +
>>>> +       /* If no clock found, try to get clock-frequency property =
*/
>>>> +       if (!rate) {
>>>> +               ret =3D of_property_read_u32(np, "clock-frequency"=
,
>>>> &rate);
>>>> +               if (ret)
>>>> +                       goto out_unmap;
>>>
>>>
>>>
>>> Shouldn't be 'goto out_clk_disable' ?
>>
>>
>> No, because I assumed !rate means we failed to get the clock.
>> Actually, clk_get_rate could return 0, so relying on rate value is n=
ot
>> safe.
>>
>> I propose to get clock-frequency property if IS_ERR(clk).
>>
>> Is it fine for you?
>
>
> Why not invert the conditions ? If the 'clock-frequency' is specified=
 in the
> DT then it overrides the clk_get_rate(). So the resulting code will b=
e:
>
> ret =3D of_property_read_u32(np, "clock-frequency", &rate);
> if (ret) {
>         clk =3D of_clk_get(np, 0);
>         if (IS_ERR(clk))
>                 goto out_unmap;
>
>         ret =3D clk_prepare_enable(clk);
>         if (ret)
>                 goto out_clk_put;
>
>         rate =3D clk_get_rate(clk);
>         if (!rate)
>                 goto out_clk_unprepare;
>
> }

Ok, it looks sensible.
I will do this in next version.

>
>
>
>>>> +       }
>>>> +
>>>> +       writel_relaxed(SYSTICK_LOAD_RELOAD_MASK, base + SYST_RVR);
>>>> +       writel_relaxed(SYST_CSR_ENABLE, base + SYST_CSR);
>>>> +
>>>> +       ret =3D clocksource_mmio_init(base + SYST_CVR, "arm_system=
_timer",
>>>> rate,
>>>> +                       200, 24, clocksource_mmio_readl_down);
>>>> +       if (ret) {
>>>> +               pr_err("failed to init clocksource (%d)\n", ret);
>>>> +               goto out_clk_disable;
>>>> +       }
>>>> +
>>>> +       pr_info("ARM System timer initialized as clocksource\n");
>>>> +
>>>> +       return;
>>>> +
>>>> +out_clk_disable:
>>>> +       if (!IS_ERR(clk))
>>>
>>>
>>>
>>> Why do you need this check ?
>>
>>
>> To handle the case were no clock was found, but a clk-frequency valu=
e
>> was provided.
>>
>>>
>>> It isn't missing a clk_put ?
>>
>>
>> Right, thanks for spotting this.
>>
>> I wonder if it makes sense to implement the error path.
>> If we fail to initialize the clocksource, the system will be unusabl=
e.
>>
>> Maybe I should just perform a BUG_ON() in the error cases, as most o=
f
>> the other clocksource drivers do.
>> What is your view?
>
>
> I prefer to not BUG_ON in the init functions because it already happe=
n that
> drivers were bugging at init time and when a driver was reused on ano=
ther
> platform with several timers available, the board was not able to boo=
t
> because one timer was not used, hence not defined in the DT. I don't =
know if
> that could be the case for this platform but I prefer to keep thing g=
oing
> smoothly and return from init even if that lead to a kernel hang. Of =
course,
> the errors must be displayed (pr_warn, pr_err, pr_notice, etc ...).

Ok, let's keep the error path, that's much cleaner indeed.

>
>>>
>>>> +               clk_disable_unprepare(clk);
>>>> +out_unmap:
>>>> +       iounmap(base);
>>>> +       WARN(ret, "ARM System timer register failed (%d)\n", ret);
>
>
> pr_warn

Sure, will fix.

Thanks,
Maxime

>
> Thanks
>
>   -- Daniel
>
>
> --
>  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software f=
or ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
