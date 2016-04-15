From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 00/10] Support for Cortex-M Prototyping System
Date: Fri, 15 Apr 2016 10:30:54 +0100
Message-ID: <5710B4CE.4060405@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
 <570F593D.6040809@arm.com> <20160414192540.GD20512@kroah.com>
 <5710ABC4.5070505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5710ABC4.5070505-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, liviu.dudau-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 15/04/16 09:52, Sudeep Holla wrote:
> 
> 
> On 14/04/16 20:25, Greg KH wrote:
>> On Thu, Apr 14, 2016 at 09:47:57AM +0100, Vladimir Murzin wrote:
>>> Hi,
>>>
>>> On 01/04/16 15:02, Vladimir Murzin wrote:
>>>> Hi,
>>>>
>>>> This patch series provides the basic support for running ucLinux on
>>>> V2M-MPS2
>>>> platform.
>>>>
>>>> With these patches applied ucLinux can be run on both HW and FVP models
>>>> with Cortex-M3/M4/M7 configurations.
>>>
>>> Any objection to get it merged?
>>>
>>> Sudeep Holla noticed that there is merge conflict against linux-next
>>> with PIC32 uart (Makefile and serial_core.h), so should I provide
>>> conflict resolution or do rebase on someone's branch?
>>>
>>> Anyway, I'd be glad to know how it should be processed further?
>>
>> I have no objection to the tty/serial changes, so if this all goes
>> through the arm-soc tree, that's fine with me.
>>
> 
> Thanks Greg, can I take this as Ack ? arm-soc guys might expect to see
> that tag :)
> 
> Hi Vladimir,
> 
> I have pulled this series into
> git://git.kernel.org/pub/scm/linux/kernel/git/sudeep.holla/linux.git
> for-next/armv7-vexpress-updates
> 
> I will stick Greg's tag when it comes.
> 

Everything looks fine! Thanks everyone for making it happen!

Cheers
Vladimir
