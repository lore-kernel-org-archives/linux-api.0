From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [RFC PATCH 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Wed, 25 Nov 2015 16:10:16 +0100
Message-ID: <5655CF58.6030507@linaro.org>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
 <1448447621-17900-3-git-send-email-vladimir.murzin@arm.com>
 <5655BA34.9040207@linaro.org> <5655CADA.1010803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5655CADA.1010803@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>, arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/25/2015 03:51 PM, Vladimir Murzin wrote:
> Hi Daniel,
>
> Thanks for you review, I agree on all concerns raised and address the=
m
> in the next version. Just some points to confirm below (I left only
> relevant parts).
>
>>> +static irqreturn_t mps2_timer_interrupt(int irq, void *dev_id)
>>> +{
>>> +    struct clockevent_mps2 *ce =3D dev_id;
>>> +    u32 status =3D readl(ce->reg + TIMER_INT);
>>> +
>>> +    if (!status)
>>> +        return IRQ_NONE;
>>
>> Why that could happen ? Add a comment.
>>
>
> Sort of defensive programming, I never seen it happens, but just in c=
ase
> of spurious interrupts... Do you prefer to get rid of this check or
>
>      /* spurious interrupt? */
>      if (!status)
>          return IRQ_NONE;
>
> would be fine to you?

Yes, that would be fine, but if it does never happen, we don't really=20
need this check. If you prefer to make sure there isn't a spurious=20
interrupt and considering it shouldn't happen, a pr_info trace may help=
=20
to spot this misbehavior.

>>> +}
>>> +
>>> +static void __init mps2_timer_init(struct device_node *np)
>>> +{
>>> +    static int clksrc;
>>> +
>>> +    if (!clksrc && !mps2_clocksource_init(np))
>>> +        clksrc =3D 1;
>>> +    else
>>> +        mps2_clockevents_init(np);
>>
>> That assumes the clocksource is defined before the clockevents in th=
e
>> DT. If it is not the case, the mps2_clocksource_init will fail (and =
spit
>> errors) and mps2_clockevents_init() won't be called.
>>
>
> Does following (stolen from efm32) look better to you?
>
> static void __init mps2_timer_init(struct device_node *np)
> {
> 	static int has_clocksource, has_clockevent;
> 	int ret;
>
> 	if (!has_clocksource) {
> 		ret =3D mps2_clocksource_init(np);
> 		if (!ret) {
> 			has_clocksource =3D 1;
> 			return;
> 		}
> 	}
>
> 	if (!has_clockevent) {
> 		ret =3D mps2_clockevent_init(np);
> 		if (!ret) {
> 			has_clockevent =3D 1;
> 			return;
> 		}
> 	}
> }

Yes.

I don't like to have a "CLOCKSOURCE_OF_DECLARE" to initialize a=20
clockevent but I can't blame you, this is what is done in the other dri=
vers.

>>> +}
>>> +
>>> +CLOCKSOURCE_OF_DECLARE(mps2_timer, "arm,mps2-timer", mps2_timer_in=
it);
>>>
>>
>>
>


--=20
  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software fo=
r ARM SoCs

=46ollow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
