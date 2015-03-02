From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Drivers: hv: utils: re-implement the kernel/userspace communication layer
Date: Mon, 02 Mar 2015 14:33:20 +0100
Message-ID: <87a8zvjzhb.fsf@vitty.brq.redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
	<20150227210744.GA11904@potion.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227210744.GA11904-KfRq7+sF/6zkZJWtSm8s3NvLeJWuRmrY@public.gmane.org> ("Radim
 \=\?utf-8\?B\?S3LEjW3DocWZIidz\?\=
	message of "Fri, 27 Feb 2015 22:07:44 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> 2015-02-27 17:14+0100, Vitaly Kuznetsov:
>> This series converts kvp/vss daemons to use misc char devices instea=
d of
>> netlink for userspace/kernel communication and then updates fcopy to=
 be
>> consistent with kvp/vss.
>>=20
>> Userspace/kernel communication via netlink has a number of issues:
>> - It is hard for userspace to figure out if the kernel part was load=
ed or not
>>   and this fact can change as there is a way to enable/disable the s=
ervice from
>>   host side.
>
> (Hm, this should be just a message to the userspace daemon, but netli=
nk
>  probably makes it complicated anyway.)
>
>>              Racy daemon startup is also a problem.
>
> (Is it significantly worse than what we need to protect devices?)
>
>> - When the userspace daemon restarts/dies kernel part doesn't receiv=
e a
>>   notification.
>
> (True, we could use a other-side-closed callback.)

With normal devices we can use e.g. udev/systemd machinery to start/sto=
p
service on device hotplug/hotunplug (and these devices are actually
pluggable/unpluggable from host side) without any special code in
kernel/userspace parts and I'd like to use that.

>
>> - Netlink communication is not stable under heavy load.
>
> (The message order changes?)
>

It is a disaster if it does (the whole transaction will get lost). Same
if any of these messages gets lost.

>> RFC: I'm a bit puzzled on how to split commits 1 and 2 avoiding brea=
kages.
>
> Split the userspace part -- it won't break bisects.
>

Sure if it simplifies the review.

> And then, you could refactor drivers first ... the way we communicate
> with userspace should have little impact on what the rest does (or ho=
w).
> At first sight, there are three units, apart from glue,
>  1) communication with host
>  2) communication with userspace
>  3) repacking of data between first two
>
> With an API for userspace communication, the amount of code to replac=
e
> netlink could be lower and resulting patches definitely easier to
> review.  (And with extra work, both ABIs could even live side-by-side=
 ;)

Ok, thanks!

--=20
  Vitaly
