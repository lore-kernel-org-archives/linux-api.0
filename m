From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [RFC PATCH 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Wed, 25 Nov 2015 14:51:06 +0000
Message-ID: <5655CADA.1010803@arm.com>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com> <1448447621-17900-3-git-send-email-vladimir.murzin@arm.com> <5655BA34.9040207@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5655BA34.9040207@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>, arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Daniel,

Thanks for you review, I agree on all concerns raised and address them
in the next version. Just some points to confirm below (I left only
relevant parts).

>> +static irqreturn_t mps2_timer_interrupt(int irq, void *dev_id)
>> +{
>> +    struct clockevent_mps2 *ce = dev_id;
>> +    u32 status = readl(ce->reg + TIMER_INT);
>> +
>> +    if (!status)
>> +        return IRQ_NONE;
> 
> Why that could happen ? Add a comment.
> 

Sort of defensive programming, I never seen it happens, but just in case
of spurious interrupts... Do you prefer to get rid of this check or

    /* spurious interrupt? */
    if (!status)
        return IRQ_NONE;

would be fine to you?

>> +}
>> +
>> +static void __init mps2_timer_init(struct device_node *np)
>> +{
>> +    static int clksrc;
>> +
>> +    if (!clksrc && !mps2_clocksource_init(np))
>> +        clksrc = 1;
>> +    else
>> +        mps2_clockevents_init(np);
> 
> That assumes the clocksource is defined before the clockevents in the
> DT. If it is not the case, the mps2_clocksource_init will fail (and spit
> errors) and mps2_clockevents_init() won't be called.
> 

Does following (stolen from efm32) look better to you?

static void __init mps2_timer_init(struct device_node *np)
{
	static int has_clocksource, has_clockevent;
	int ret;

	if (!has_clocksource) {
		ret = mps2_clocksource_init(np);
		if (!ret) {
			has_clocksource = 1;
			return;
		}
	}

	if (!has_clockevent) {
		ret = mps2_clockevent_init(np);
		if (!ret) {
			has_clockevent = 1;
			return;
		}
	}
}

Thanks
Vladimir

>> +}
>> +
>> +CLOCKSOURCE_OF_DECLARE(mps2_timer, "arm,mps2-timer", mps2_timer_init);
>>
> 
> 
