From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Thu, 18 Feb 2016 12:47:18 +0000
Message-ID: <56C5BD56.2050603@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <7245560.jfhuhtPsB8@wuerfel> <56C5A742.8010304@arm.com> <5567140.dIBhKTnriP@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5567140.dIBhKTnriP@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 18/02/16 12:16, Arnd Bergmann wrote:
> On Thursday 18 February 2016 11:13:06 Vladimir Murzin wrote:
>> On 18/02/16 10:45, Arnd Bergmann wrote:
>>> On Thursday 18 February 2016 10:11:37 Vladimir Murzin wrote:
>>>>
>>>> Right, I thought in a wrong way, in opposite it makes more sense now.
>>>>
>>>> .dtsi
>>>>
>>>> /* below the soc/ */
>>>> smb {
>>>>         compatible = "simple-bus";
>>>>         #address-cells = <2>;
>>>>         #size-cells = <1>;
>>>>         ranges = <0 0 0x40200000 0x10000>,
>>>>                  <1 0 0xa0000000 0x10000>;
>>>> };
>>>
>>> That looks good, yes.
>>>
>>> Is 0x10000 the correct maximum addressable size of the external bus
>>> in both cases?
>>>
>>> Intuitively, I would guess that the 0xa0000000 range might
>>> be much wider.
>>
>> There is only Ethernet connected to this bus (apart from PSRAM), so it
>> might be wider, but there is no indication of this in documentation.
> 
> I see this called "ahb_to_extmem16" in the documentation, which indicates
> that it might be use 16 bits of address space, which would match
> the 64K you listed.
> 
> For SSRAM1 / SSRAM2 / SSRAM3, a 8 MB address space is mentioned
> and 16 MB for external PSRAM at 0x21000000.
> 

Right. I'll incorporate changes in the next version. Thanks for lessons
given and your time!

Cheers
Vladimir

> 	Arnd
> 
> 
> 
> 
