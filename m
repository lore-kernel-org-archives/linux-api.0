From: Christian Gmeiner <christian.gmeiner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] drm: etnaviv: add further minor features and varyings count
Date: Wed, 20 Jan 2016 19:01:36 +0100
Message-ID: <CAH9NwWdcxEofKYcsSc6SvEW0ag=OHhqH=AYOBOPcsbGSk_DoXw@mail.gmail.com>
References: <E1aLSQq-0006sU-Ou@rmk-PC.arm.linux.org.uk> <CAH9NwWdr+=hLKiJGM=m_dDWppEX=D+Qu5yhfjE6B3+2T1nE3BA@mail.gmail.com>
 <20160119102103.GK19062@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119102103.GK19062-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Lucas Stach <l.stach-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, DRI mailing list <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Russell

2016-01-19 11:21 GMT+01:00 Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>:
> On Tue, Jan 19, 2016 at 11:09:57AM +0100, Christian Gmeiner wrote:
>> Hi Russell,
>>
>> 2016-01-19 10:18 GMT+01:00 Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>:
>> > +       /*
>> > +        * For some cores, two varyings are consumed for position, so the
>> > +        * maximum varying count needs to be reduced by one.
>> > +        */
>> > +       if ((gpu->identity.model == chipModel_GC2000 &&
>> > +            gpu->identity.revision == 0x5108) ||
>> > +           (gpu->identity.model == chipModel_GC880 &&
>> > +            gpu->identity.revision == 0x5106))
>> > +               gpu->identity.varyings_count -= 1;
>>
>> Should we not include the whole list of GPU cores with that special handling?
>> See: https://github.com/Freescale/kernel-module-imx-gpu-viv/blob/master/kernel-module-imx-gpu-viv-src/hal/kernel/arch/gc_hal_kernel_hardware.c#L592
>
> I was debating about that - but I think we need to come up with a better
> way to do this sort of thing.  At the very least, I've been wondering
> whether a macro such as:
>
> #define etnaviv_model_rev(gpu, mod, rev) \
>         ((gpu)->identity.model == chipModel_##mod && \
>          (gpu)->identity.revision == rev))
>
> would help make some of this code more readable.
>

Yep that makes the code more readable.

> The other thing I've been wondering is whether a table looked up by GPU
> model ID and/or revision ID quirks would simplify this.  However, the
> downside with the tabular approach is that it becomes harder to compare
> what we have against the galcore sources.
>

The table driven approach could be a little heavy for the number of
quirks we have
currently. Maybe Lucas has an opinion about that?

greets
--
Christian Gmeiner, MSc

https://soundcloud.com/christian-gmeiner
