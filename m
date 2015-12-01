From: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] introduce new evdev interface type
Date: Tue, 1 Dec 2015 16:34:00 +0800
Message-ID: <CB4E5A6F-D514-4D3B-9C95-13A52C509EC9@linaro.org>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <8705201.iaeQDTRocP@wuerfel> <DDC9234F-F89D-4112-BD68-FC6EFEC7E215@linaro.org> <3322044.DFSNLmiFGl@wuerfel>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3322044.DFSNLmiFGl@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi, Arnd

>>>>=20
>>>> The patch series add three evdev interface type:
>>>>=20
>>>> - EV_IF_LEGACY
>>>> send event by input_event. This is the default option, keep kernel
>>>> backward compatible.
>>>=20
>>> The problem I see with this approach is that it still breaks any
>>> legacy source code that is compiled with a new libc that uses 64-bi=
t
>>> time_t. If we are requiring source code changes for building users
>>> of input devices with a new libc, we can easily get them to handle
>>> the overflow (they normally only care about the microsecond portion
>>> anyway, so it doesn't matter in most cases), or to use monotonic ti=
me.
>>=20
>> I don=A1=AFt think so.
>>=20
>> Actually, from the view of userspace, EV_IF_LEGACY interface is work
>> exactly the same as old evdev. We didn=A1=AFt change anything in inp=
ut_event
>> and input_event_compat. And the problem you said will still be there=
,
>> even without those patches.
>=20
> I think we're still talking past one another. I thought we had establ=
ished
> that
>=20
> 1. the current interface is broken when time_t changes in user space

What kinds of changes in time_t? Extending it to 64-bits in both kernel
and userspace? Ok, I get confused here, if there are some sample codes
or use-cases here, it will help me a lot.

> 2. we can fix it by redefining struct input_event in a way that
>   is independent of time_t
> 3. once both user space and kernel are using the same ABI independent
>   of time_t, we can look improving the timestamps so they don't
>   overflow
> 4. the monotonic timestamp interface already avoids the overflow, so
>   it would be sufficient as a solution for 3.
>=20
> Where did I lose you here? Did you find any other facts that I
> was missing? I don't know whether the two new event structures make
> the interface better in some other way, but it seems mostly unrelated
> to either of the two problems we already have with time_t (the
> ABI mismatch, and the use of non-monotonic timestamps).

It seems we are mismatch here.

Actually input_composite_event has the similar structure with input_eve=
nt,
but with a nicer definition, which can take both monotonic and non-mono=
tonic
timestamps safely.

What I assumed here, is that leaving EV_IF_LEGACY as a untouched, depre=
cated
interface. If userspace try to adapt to new libc and kernel, it should =
move
to new interface. The userspace can do a lazy update, keep the code unt=
ouched,
but suffer the y2038 problem by itself.

We can force kernel using monotonic time in EV_IF_LEGACY interface, and
making input_event independent from time_t(after evdev has converted to
input_value, it=A1=AFs easy to do that), but that also imply userspace
must change their code to fit this change. If changing userspace code i=
s
a mandatory option, why not to force them do a complete conversion?

Pingbo--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
