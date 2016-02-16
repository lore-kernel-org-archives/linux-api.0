From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 00/10] Support for Cortex-M Prototyping System
Date: Tue, 16 Feb 2016 16:14:01 +0000
Message-ID: <56C34AC9.8080509@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <22011981.Gqc7zXAZ81@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22011981.Gqc7zXAZ81@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liviu Dudau <liviu.dudau-5wv7dgnIgG8@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 16/02/16 11:05, Arnd Bergmann wrote:
> On Tuesday 16 February 2016 10:08:05 Vladimir Murzin wrote:
>> Hi,
>>
>> This patch series provide the basic support for running ucLinux on V2M-MPS2
>> platform.
>>
>> With these patches applied ucLinux can be run on both HW and FVP models
>> with Cortex-M3/M4/M7 configurations.
> 
> Looks very nice overall now. I have mentioned a few details that I noticed
> but no show-stoppers.
> 
> Most important question for me is how this is going to be maintained
> in the long run. Can you add a patch to list the added files in
> MAINTAINERS?
> 
> My preference from the arm-soc perspective would be to get pull requests for
> this together with vexpress and juno through the existing maintainers
> (Liviu, Sudeep, Lorenzo), and have you send your patches to them. Does
> that work for you all?
> 

I'm quite happy with either way. I'm not targeting for 4.6, so we have
some time to sort it out.

Thanks
Vladimir

> 	Arnd
> 
> 
> 
