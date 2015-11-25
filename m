From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 00/10] Support for Cortex-M Prototyping System
Date: Wed, 25 Nov 2015 14:39:44 +0000
Message-ID: <5655C830.7020501@arm.com>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com> <20614077.l46PyO8gV6@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20614077.l46PyO8gV6@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Mark.Rutland-5wv7dgnIgG8@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 25/11/15 11:22, Arnd Bergmann wrote:
>> I'd be happy to hear any feedback/comments on this series!
> Looks pretty good overall, I didn't have any specific concerns.

Thanks for your time!

> 
>> > Remain questions:
>> > 
>> >  - Application notes 399/400 have PSRAM located at address different to what
>> >    we have for AN385/AN386, so I'm wondering what is the best practice to handle
>> >    CONFIG_DRAM_BASE? Different defconfig or there is better place?
> I would not want to add more than one defconfig for a relatively simple
> platform. Most actual users would have to modify their config anyway, so
> I think it's best to just have one config file for the most common machine
> here and let users change the dram base if they have the other one.
> 

I think the same, just wanted to check that I didn't misunderstand
something.

> We can also look at using the Kconfig fragments infrastructure more here.
>  
>> >  - I'm not sure about naming of dts files: Application Notes (mps2-an*) vs Cortex-M (mps2-cm*);
>> >    any preference?
> I don't mind either way.

Ok, I'll leave things as they are till anybody has different opinion on
that.

Cheers
Vladimir

> 
> 	Arnd
> 
> 
> 
