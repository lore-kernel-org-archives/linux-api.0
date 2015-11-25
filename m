From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Wed, 25 Nov 2015 15:21:27 +0000
Message-ID: <5655D1F7.2030202@arm.com>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com> <1448447621-17900-3-git-send-email-vladimir.murzin@arm.com> <5655BA34.9040207@linaro.org> <5655CADA.1010803@arm.com> <5655CF58.6030507@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5655CF58.6030507-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Mark.Rutland-5wv7dgnIgG8@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 25/11/15 15:10, Daniel Lezcano wrote:
> On 11/25/2015 03:51 PM, Vladimir Murzin wrote:
>> Hi Daniel,
>>
>> Thanks for you review, I agree on all concerns raised and address them
>> in the next version. Just some points to confirm below (I left only
>> relevant parts).
>>
>>>> +static irqreturn_t mps2_timer_interrupt(int irq, void *dev_id)
>>>> +{
>>>> +    struct clockevent_mps2 *ce = dev_id;
>>>> +    u32 status = readl(ce->reg + TIMER_INT);
>>>> +
>>>> +    if (!status)
>>>> +        return IRQ_NONE;
>>>
>>> Why that could happen ? Add a comment.
>>>
>>
>> Sort of defensive programming, I never seen it happens, but just in case
>> of spurious interrupts... Do you prefer to get rid of this check or
>>
>>      /* spurious interrupt? */
>>      if (!status)
>>          return IRQ_NONE;
>>
>> would be fine to you?
> 
> Yes, that would be fine, but if it does never happen, we don't really
> need this check. If you prefer to make sure there isn't a spurious
> interrupt and considering it shouldn't happen, a pr_info trace may help
> to spot this misbehavior.
> 

Good, I'll put pr_warn("spurious interrupt\n") then.

>>>> +}
>>>> +
>>>> +static void __init mps2_timer_init(struct device_node *np)
>>>> +{
>>>> +    static int clksrc;
>>>> +
>>>> +    if (!clksrc && !mps2_clocksource_init(np))
>>>> +        clksrc = 1;
>>>> +    else
>>>> +        mps2_clockevents_init(np);
>>>
>>> That assumes the clocksource is defined before the clockevents in the
>>> DT. If it is not the case, the mps2_clocksource_init will fail (and spit
>>> errors) and mps2_clockevents_init() won't be called.
>>>
>>
>> Does following (stolen from efm32) look better to you?
>>
>> static void __init mps2_timer_init(struct device_node *np)
>> {
>>     static int has_clocksource, has_clockevent;
>>     int ret;
>>
>>     if (!has_clocksource) {
>>         ret = mps2_clocksource_init(np);
>>         if (!ret) {
>>             has_clocksource = 1;
>>             return;
>>         }
>>     }
>>
>>     if (!has_clockevent) {
>>         ret = mps2_clockevent_init(np);
>>         if (!ret) {
>>             has_clockevent = 1;
>>             return;
>>         }
>>     }
>> }
> 
> Yes.
> 
> I don't like to have a "CLOCKSOURCE_OF_DECLARE" to initialize a
> clockevent but I can't blame you, this is what is done in the other
> drivers.

Thanks for your time!

Vladimir

> 
>>>> +}
>>>> +
>>>> +CLOCKSOURCE_OF_DECLARE(mps2_timer, "arm,mps2-timer", mps2_timer_init);
>>>>
>>>
>>>
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
