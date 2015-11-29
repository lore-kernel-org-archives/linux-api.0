From: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] input: evdev: add new ioctl EVIOCSIFTYPE / EVIOCGIFTYPE
Date: Sun, 29 Nov 2015 17:19:30 +0800
Message-ID: <C143A796-AFAA-4422-A60D-E462173BDC81@linaro.org>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org> <1448618432-32357-3-git-send-email-pingbo.wen@linaro.org> <2705528.qSj27KAuDS@wuerfel>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2705528.qSj27KAuDS@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Pingbo Wen <pingbo.wen-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aksgarg1989-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


> =D4=DA 2015=C4=EA11=D4=C228=C8=D5=A3=AC00:59=A3=ACArnd Bergmann <arnd=
@arndb.de> =D0=B4=B5=C0=A3=BA
>=20
> On Friday 27 November 2015 18:00:31 WEN Pingbo wrote:
>> This patch depends on 'introduce new evdev interface'.
>>=20
>> Userspace cat set / get evdev interface type via the two ioctl
>> commands. And default interface type is EV_IF_LEGACY, so the old bin=
ary
>> will work normal with new kernel. Maybe we should change this defaul=
t
>> option to encourage people to move to new interface.
>>=20
>> And since all events are stored as input_value in evdev, there are n=
o
>> need to flush evdev_client's buffer if we change clk_type and if_typ=
e.
>=20
> I would split out the change to evdev_set_clk_type into a separate pa=
tch.

Agreed.

>=20
>> +	case EVIOCSIFTYPE:
>> +		if (get_user(if_type, ip))
>> +			return -EFAULT;
>> +
>> +		return evdev_set_if_type(client, if_type);
>> +	case EVIOCGIFTYPE:
>> +		return put_user(client->if_type, ip);
>> 	}
>=20
> This look asymmetric: EVIOCSIFTYPE uses a EVDEV_* constant, while
> EVIOCGIFTYPE returns a EV_IF_* constant. Should those just
> be the same constants anyway?

Yes, thanks for pointing it out. I need add evdev_get_if_type() here.

Pingbo
