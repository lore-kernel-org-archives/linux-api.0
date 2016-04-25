From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 00/10] Support for Cortex-M Prototyping System
Date: Mon, 25 Apr 2016 09:58:41 +0100
Message-ID: <571DDC41.5020302@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
 <201604240143.04330.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201604240143.04330.arnd-r2nGTMty4D4@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, liviu.dudau-5wv7dgnIgG8@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 24/04/16 00:43, Arnd Bergmann wrote:
> On Friday 01 April 2016, Vladimir Murzin wrote:
>> Hi,
>>
>> This patch series provides the basic support for running ucLinux on V2M-MPS2
>> platform.
>>
>> With these patches applied ucLinux can be run on both HW and FVP models
>> with Cortex-M3/M4/M7 configurations.
>>
>> Board description:
>>
>> http://infocenter.arm.com/help/topic/com.arm.doc.100112_0100_03_en/arm_versatile_express_cortex_m_prototyping_system_(v2m_mps2)_technical_reference_manual_100112_0100_03_en.pdf
>>
>> Application notes (cover Cortex-M3/M4/M7):
>>
>> http://infocenter.arm.com/help/topic/com.arm.doc.dai0385a/DAI0385A_cortex_m3_on_v2m_mps2.pdf
>> http://infocenter.arm.com/help/topic/com.arm.doc.dai0386a/DAI0386A_cortex_m4_on_v2m_mps2.pdf
>> http://infocenter.arm.com/help/topic/com.arm.doc.dai0399a/DAI0399A_cortex_m7_on_v2m_mps2.pdf
>> http://infocenter.arm.com/help/topic/com.arm.doc.dai0400a/DAI0400A_cortex_m7_on_v2m_mps2.pdf
>>
>> Cortex-M System Design Kit (referenced as CMDK from documents above):
>>
>> http://infocenter.arm.com/help/topic/com.arm.doc.ddi0479c/DDI0479C_cortex_m_system_design_kit_r1p0_trm.pdf
>>
>> I'd be happy to hear any feedback/comments on this series!
>>
> 
> The whole series looks good to me, please submit the patches to the
> appropriate maintainers for inclusion separately:
> 
> * patches 1-2 to the clocksource maintainers
> * patches 3-5 to the serial driver maintainers
> * patches 6-10 to the vexpress maintainers
> 
> I think everyone is already on Cc here, but they don't want to pick the
> patches out of the series separately. I expect to get the patches for
> arm-soc as part of the vexpress pull requests (dt, defconfig, and core).

Thanks Arnd!

I've just split patches per your request and sent them to appropriate
maintainers.

Cheers
Vladimir

> 
> 	Arnd
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
