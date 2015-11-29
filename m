From: Pingbo Wen <pingbo.wen@linaro.org>
Subject: Re: [PATCH 0/3] introduce new evdev interface type
Date: Sun, 29 Nov 2015 17:13:50 +0800
Message-ID: <DDC9234F-F89D-4112-BD68-FC6EFEC7E215@linaro.org>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <8705201.iaeQDTRocP@wuerfel>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8705201.iaeQDTRocP@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pingbo Wen <pingbo.wen@linaro.org>, y2038@lists.linaro.org, dmitry.torokhov@gmail.com, aksgarg1989@gmail.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi, Arnd

> =D4=DA 2015=C4=EA11=D4=C228=C8=D5=A3=AC00:58=A3=ACArnd Bergmann <arnd=
@arndb.de> =D0=B4=B5=C0=A3=BA
>=20
> On Friday 27 November 2015 18:00:29 WEN Pingbo wrote:
>> To solve the y2038 problem in input_event, I had some attempts befor=
e [1],
>> and this is the second one.
>>=20
>> We can force userspace to use monotonic time in event timestamp, so =
the
>> 'struct timeval' is enough to keep y2038-safe, as Arnd suggested. Bu=
t we
>> can not find a way to make kernel compatible with old binaries, whic=
h use
>> realtime, and there are still some devices, which depend on realtime=
=2E
>>=20
>> So I get a idea to add a new evdev interface, which is y2038 safe. A=
nd
>> userspace can switch between the old and new interface via ioctl.
>>=20
>> The patch series add three evdev interface type:
>>=20
>> - EV_IF_LEGACY
>>  send event by input_event. This is the default option, keep kernel
>>  backward compatible.
>=20
> The problem I see with this approach is that it still breaks any
> legacy source code that is compiled with a new libc that uses 64-bit
> time_t. If we are requiring source code changes for building users
> of input devices with a new libc, we can easily get them to handle
> the overflow (they normally only care about the microsecond portion
> anyway, so it doesn't matter in most cases), or to use monotonic time=
=2E

I don=A1=AFt think so.

Actually, from the view of userspace, EV_IF_LEGACY interface is work
exactly the same as old evdev. We didn=A1=AFt change anything in input_=
event
and input_event_compat. And the problem you said will still be there,
even without those patches.

Pingbo--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
