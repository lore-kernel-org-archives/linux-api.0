From: Benjamin Tissoires <benjamin.tissoires-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Fri, 20 Mar 2015 08:27:32 -0400
Message-ID: <CAN+gG=GGFptRo=FXLp7S_Y1+mwerzYNN+Sf+6ZCwSpmTU-w9ag@mail.gmail.com>
References: <1426694157-10866-1-git-send-email-martink@posteo.de>
	<2231139.ojeyer6qnI@ws-stein>
	<5509AAE5.1000503@posteo.de>
	<1426697978.6764.8.camel@hadess.net>
	<5509BDA0.9000806@posteo.de>
	<1426701934.6764.10.camel@hadess.net>
	<5509C3E6.8070000@posteo.de>
	<1426760577.6764.14.camel@hadess.net>
	<550C03FC.1020303@theobroma-systems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550C03FC.1020303-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
Cc: Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>, Alexander Stein <alexander.stein-93q1YBGzJSMe9JSWTWOYM3xStJ4P+DSV@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 20, 2015 at 7:26 AM, Martin Kepplinger
<martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org> wrote:
> Am 2015-03-19 um 11:22 schrieb Bastien Nocera:
>> On Wed, 2015-03-18 at 19:28 +0100, Martin Kepplinger wrote:
>>> Am 2015-03-18 um 19:05 schrieb Bastien Nocera:
>>>> On Wed, 2015-03-18 at 19:02 +0100, Martin Kepplinger wrote:
>>>>> Am 2015-03-18 um 17:59 schrieb Bastien Nocera:
>>>>>> On Wed, 2015-03-18 at 17:42 +0100, Martin Kepplinger wrote:
>>>>>>>
>>>>>> <snip>
>>>>>>> It could have gone to drivers/iio/accel if it would use an
>>>>>>> iio   interface, which would make more sense, you are right,
>>>>>>> but I
>>>>>>> simply  don't have the time to merge it in to iio.
>>>>>>>
>>>>>>> It doesn't use an input interface either but I don't see a
>>>>>>> good   place for an accelerometer that uses sysfs only.
>>>>>>>
>>>>>>> It works well, is a relatively recent chip and a clean
>>>>>>> dirver.  But  this is all I can provide.
>>>>>>
>>>>>> As a person who works on the user-space interaction of those
>>>>>> with   desktops [1]: Urgh.
>>>>>>
>>>>>> I already have 3 (probably 4) types of accelerometers to
>>>>>> contend  with,  I'm not fond of adding yet another type.
>>>>>>
>>>>>> Is there any way to get this hardware working outside the SoCs
>>>>>> it's  designed for (say, a device with I2C like a Raspberry
>>>>>> Pi),  so that a  kind soul could handle getting this using the
>>>>>> right  interfaces?
>>>>>>
>>>>>
>>>>> It works on basically any SoC and is in no way limited in this
>>>>> regard. Sure, userspace has to expicitely support it and I hear
>>>>> you.  Using the iio interface would make more sense. I can only
>>>>> say I'd  love to have the time to move this driver over. I'm
>>>>> very sorry.
>>>>
>>>> How can we get the hardware for somebody to use on their own
>>>> laptops/embedded boards to implement this driver?
>>>>
>>>
>>> It's connected over I2C. If the included documentation is not clear
>>> please tell me what exacly. Thanks!
>>
>>
>> I'll ask the question a different way: can you please give the address
>> of a shop where that hardware is available?
>>
>
> there is
> http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=RDMMA865x&lang_cd=
> and http://linux-sunxi.org/Inet_K970 for example. I think I saw Android
> devices with it too, and I would guess it would be used more often if it
> were in linux.

I am going to say again (in a different way) what Bastien said. In its
current form, even in drivers/misc, this is a NACK for me (v1, v2, v3
& v4).

Putting a driver in Linux means we have to support it forever, and
definitively, nobody will use an accelerometer in Android if it is in
drivers/misc.
Android requires drivers to follow the IIO protocol. Period.
So having your own will not help android, it will just be a burden.

The sysfs you are proposing seems simple enough, but we can not afford
having a 3rd custom way of relying the accelerometer information in
the Linux tree (they were first handled in input, then IIO, then a
custom sysfs).

If you really want to have the driver in the tree, I won't be opposed
if you put in under staging. This way, you can break it whenever you
want and people won't rely on it. And then, we can use your driver as
a base to port it to IIO.

Sorry for being rude, but I am starting to get tired of people saying
that they don't have the time to follow what the reviewers said. You
obviously spent some time polishing this driver, why not making it
right from its first inclusion in the tree?

Cheers,
Benjamin

>
> Please refer to v4 of the patch for different questions. thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
