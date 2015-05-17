From: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] iio: doc: fix typo
Date: Sun, 17 May 2015 18:16:06 +0200
Message-ID: <6D256937-6698-4D42-A786-EC798545EA8F@posteo.de>
References: <1430404582-13115-1-git-send-email-martink@posteo.de> <5546737A.9000407@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5546737A.9000407-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



Am 3. Mai 2015 21:14:02 MESZ, schrieb Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>On 30/04/15 15:36, Martin Kepplinger wrote:
>> Since we have deviceX, we don't need accelX. This has no users as of
>now, so
>> correcting this is no problem.
>> 
>> Signed-off-by: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
>The X is certainly misleading.  The interface could have a number
>there,
>(if we have a device with multiple parallel accelerometers - unusual,
>but
>not unheard of) but it would be the channel index, not the device index
>and hence should be Y not X.
>
>Or as we don't have any of these anyway, just drop the X and leave it
>as
>an un-indexed accelerometer channel.
>
>Jonathan

There actually is a user, without the index, bma180.c and if it's done correctly there I plan to use it aswell.

I think removing this index would be the right thing now and your scenario may be a bigger change.

      martin

>> ---
>> 
>> That's really just a question now. If I'm wrong, sorry for the noise.
>> 
>>  Documentation/ABI/testing/sysfs-bus-iio | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio
>b/Documentation/ABI/testing/sysfs-bus-iio
>> index 3befcb1..efd1334 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>> @@ -1119,7 +1119,7 @@ Description:
>>  		This attribute is used to read the amount of quadrature error
>>  		present in the device at a given time.
>>  
>> -What:		/sys/.../iio:deviceX/in_accelX_power_mode
>> +What:		/sys/.../iio:deviceX/in_accel_power_mode
>>  KernelVersion:	3.11
>>  Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>  Description:
>> 
