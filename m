From: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: [RFC ebeam PATCH 2/2] input: misc: New USB eBeam input driver
Date: Tue, 21 Jul 2015 15:54:14 +0200
Message-ID: <55AE4F06.7000407@laposte.net>
References: <1437426199-29866-1-git-send-email-yann.cantin@laposte.net> <1437426199-29866-3-git-send-email-yann.cantin@laposte.net> <20150720215956.GA21796@kroah.com> <20150720222640.GD30252@dtor-ws> <20150720224033.GA23884@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720224033.GA23884-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le 21/07/2015 00:40, Greg KH a =E9crit :
> On Mon, Jul 20, 2015 at 03:26:40PM -0700, Dmitry Torokhov wrote:
>> On Mon, Jul 20, 2015 at 02:59:56PM -0700, Greg KH wrote:
>>> On Mon, Jul 20, 2015 at 11:03:19PM +0200, Yann Cantin wrote:
>>>> Signed-off-by: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
>>>
>>>> +
>>>> +	/* sysfs setup */
>>>> +	err =3D sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
>>>
>>> Ick, you just added the sysfs files to the USB device, not your inp=
ut
>>> device, are you sure you tested this?
>>>
>>> And there should be a race-free way to add an attribute group to an
>>> input device, as this is, you are adding them to the device _after_=
 it
>>> is created, so userspace will not see them at creation time, causin=
g a
>>> race.
>>
>> No, there are no driver-specific attributed on input devices themsel=
ves,
>> they belong to the actual hardware devices. The input devices only
>> export standard attributes applicable to every and all input devices
>> in the system.
>
> Then the Documentation in this patch better be fixed up, as it points=
 to
> the input device as having these sysfs files :)
>
> But as these are input device attributes, and not USB device interfac=
e
> attributes, putting them on the USB interface doesn't make much sense=
,

To sum up : these attributes are USB device's not input's, only indirec=
tly
accessed via inputXX/device/, and they only modify the driver's behavio=
r.
So, it make sense to correct the documentation to point at
/sys/bus/usb/drivers/ebeam/X-X:1.0/. Right ?

thanks,

--=20
Yann Cantin
A4FEB47F
--
