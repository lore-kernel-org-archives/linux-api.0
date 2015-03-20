From: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
Subject: Re: [PATCH v2] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Fri, 20 Mar 2015 12:26:52 +0100
Message-ID: <550C03FC.1020303@theobroma-systems.com>
References: <1426694157-10866-1-git-send-email-martink@posteo.de>			 <2231139.ojeyer6qnI@ws-stein> <5509AAE5.1000503@posteo.de>		 <1426697978.6764.8.camel@hadess.net> <5509BDA0.9000806@posteo.de>	 <1426701934.6764.10.camel@hadess.net> <5509C3E6.8070000@posteo.de> <1426760577.6764.14.camel@hadess.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <1426760577.6764.14.camel@hadess.net>
Sender: linux-input-owner@vger.kernel.org
To: Bastien Nocera <hadess@hadess.net>, Martin Kepplinger <martink@posteo.de>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, dmitry.torokhov@gmail.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-api@vger.kernel.org, devicetree@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

Am 2015-03-19 um 11:22 schrieb Bastien Nocera:
> On Wed, 2015-03-18 at 19:28 +0100, Martin Kepplinger wrote:
>> Am 2015-03-18 um 19:05 schrieb Bastien Nocera:
>>> On Wed, 2015-03-18 at 19:02 +0100, Martin Kepplinger wrote:
>>>> Am 2015-03-18 um 17:59 schrieb Bastien Nocera:
>>>>> On Wed, 2015-03-18 at 17:42 +0100, Martin Kepplinger wrote:
>>>>>>
>>>>> <snip>
>>>>>> It could have gone to drivers/iio/accel if it would use an 
>>>>>> iio   interface, which would make more sense, you are right, 
>>>>>> but I 
>>>>>> simply  don't have the time to merge it in to iio.
>>>>>>
>>>>>> It doesn't use an input interface either but I don't see a 
>>>>>> good   place for an accelerometer that uses sysfs only.
>>>>>>
>>>>>> It works well, is a relatively recent chip and a clean 
>>>>>> dirver.  But  this is all I can provide.
>>>>>
>>>>> As a person who works on the user-space interaction of those 
>>>>> with   desktops [1]: Urgh.
>>>>>
>>>>> I already have 3 (probably 4) types of accelerometers to 
>>>>> contend  with,  I'm not fond of adding yet another type.
>>>>>
>>>>> Is there any way to get this hardware working outside the SoCs 
>>>>> it's  designed for (say, a device with I2C like a Raspberry 
>>>>> Pi),  so that a  kind soul could handle getting this using the 
>>>>> right  interfaces?
>>>>>
>>>>
>>>> It works on basically any SoC and is in no way limited in this  
>>>> regard. Sure, userspace has to expicitely support it and I hear 
>>>> you.  Using the iio interface would make more sense. I can only 
>>>> say I'd  love to have the time to move this driver over. I'm 
>>>> very sorry.
>>>
>>> How can we get the hardware for somebody to use on their own  
>>> laptops/embedded boards to implement this driver?
>>>
>>
>> It's connected over I2C. If the included documentation is not clear 
>> please tell me what exacly. Thanks!
> 
> 
> I'll ask the question a different way: can you please give the address 
> of a shop where that hardware is available?
> 

there is
http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=RDMMA865x&lang_cd=
and http://linux-sunxi.org/Inet_K970 for example. I think I saw Android
devices with it too, and I would guess it would be used more often if it
were in linux.

Please refer to v4 of the patch for different questions. thanks!
