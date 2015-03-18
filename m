From: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Wed, 18 Mar 2015 19:28:54 +0100
Message-ID: <5509C3E6.8070000@posteo.de>
References: <1426694157-10866-1-git-send-email-martink@posteo.de>		 <2231139.ojeyer6qnI@ws-stein> <5509AAE5.1000503@posteo.de>	 <1426697978.6764.8.camel@hadess.net> <5509BDA0.9000806@posteo.de> <1426701934.6764.10.camel@hadess.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426701934.6764.10.camel-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>
Cc: Alexander Stein <alexander.stein-93q1YBGzJSMe9JSWTWOYM3xStJ4P+DSV@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>, Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 2015-03-18 um 19:05 schrieb Bastien Nocera:
> On Wed, 2015-03-18 at 19:02 +0100, Martin Kepplinger wrote:
>> Am 2015-03-18 um 17:59 schrieb Bastien Nocera:
>>> On Wed, 2015-03-18 at 17:42 +0100, Martin Kepplinger wrote:
>>>>
>>> <snip>
>>>> It could have gone to drivers/iio/accel if it would use an iio  
>>>> interface, which would make more sense, you are right, but I 
>>>> simply  don't have the time to merge it in to iio.
>>>>
>>>> It doesn't use an input interface either but I don't see a good  
>>>> place for an accelerometer that uses sysfs only.
>>>>
>>>> It works well, is a relatively recent chip and a clean dirver. 
>>>> But  this is all I can provide.
>>>
>>> As a person who works on the user-space interaction of those with  
>>> desktops [1]: Urgh.
>>>
>>> I already have 3 (probably 4) types of accelerometers to contend 
>>> with,  I'm not fond of adding yet another type.
>>>
>>> Is there any way to get this hardware working outside the SoCs 
>>> it's  designed for (say, a device with I2C like a Raspberry Pi), 
>>> so that a  kind soul could handle getting this using the right 
>>> interfaces?
>>>
>>
>> It works on basically any SoC and is in no way limited in this 
>> regard. Sure, userspace has to expicitely support it and I hear you. 
>> Using the iio interface would make more sense. I can only say I'd 
>> love to have the time to move this driver over. I'm very sorry.
> 
> How can we get the hardware for somebody to use on their own 
> laptops/embedded boards to implement this driver?
> 

It's connected over I2C. If the included documentation is not clear
please tell me what exacly. Thanks!
