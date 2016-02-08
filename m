From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Mon, 08 Feb 2016 17:17:57 +0000
Message-ID: <56B8CDC5.5010504@arm.com>
References: <1454413199-26573-1-git-send-email-vladimir.murzin@arm.com> <1454413199-26573-5-git-send-email-vladimir.murzin@arm.com> <20160207071154.GA32017@kroah.com> <56B87928.7020803@arm.com> <20160208165226.GA11593@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160208165226.GA11593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, andy.shevchenko@gmail.com, mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/02/16 16:52, Greg KH wrote:
> On Mon, Feb 08, 2016 at 11:16:56AM +0000, Vladimir Murzin wrote:
>> On 07/02/16 07:11, Greg KH wrote:
>>>> +
>>>> +#define SERIAL_NAME "ttyS"
>>>
>>> You can't be "ttyS", there's already a serial port named that, please
>>> use a unique name and a new major/minor number (dynamic ideally).
>>>
>>
>> Hi Greg,
>>
>> I did s/ttyMPS/ttyS per your request for v1 [1]. I'm fine to change it
>> back if you prefer that, but I'd be glad to know what I've been missing?
>>
>> [1] https://lkml.org/lkml/2015/12/13/8
> 
> Yeah, I was wrong, sorry about that, my fault.
> 

I got -EDOUBT from my parser. What should I stick with "ttyS" or "ttyMPS"?

P.S.
Any chance you could look at the rest of the patch?

Cheers
Vladimir

> greg k-h
> 
> 
> 
