From: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: [RFC ebeam PATCH 2/2] input: misc: New USB eBeam input driver
Date: Tue, 21 Jul 2015 14:18:39 +0200
Message-ID: <55AE389F.9060409@laposte.net>
References: <1437426199-29866-1-git-send-email-yann.cantin@laposte.net> <1437426199-29866-3-git-send-email-yann.cantin@laposte.net> <20150720215956.GA21796@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720215956.GA21796-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le 20/07/2015 23:59, Greg KH a =E9crit :
> On Mon, Jul 20, 2015 at 11:03:19PM +0200, Yann Cantin wrote:
>> diff --git a/Documentation/ABI/testing/sysfs-driver-ebeam b/Document=
ation/ABI/testing/sysfs-driver-ebeam
>> +++ b/Documentation/ABI/testing/sysfs-driver-ebeam
>> @@ -0,0 +1,53 @@
>> +What:		/sys/class/input/inputXX/device/min_x
>> +		/sys/class/input/inputXX/device/min_y
>> +		/sys/class/input/inputXX/device/max_x
>> +		/sys/class/input/inputXX/device/max_y
>> +What:		/sys/class/input/inputXX/device/h[1..9]
>> +What:		/sys/class/input/inputXX/device/calibrated
>
>
> What tool(s) use these sysfs files?  Don't we already have "normal"
> events for these types of things such that we don't have to make up n=
ew
> sysfs files for these?

The ebeam_calibrator tool is there : http://ebeam.tuxfamily.org.

I agree this can be a problem : this driver is totally useless without =
a
userspace dedicated calibration tool.

By nature these device's coordinate system can't be mapped to screen vi=
a
trivial transformations, such as scaling, flipping and rotating, hence =
the
special calibration and mapping procedures. I choose to use an homograp=
hy
transformation as it is more robust and faster than linear interpolatio=
n
in this case. And anyway, it requires 9 calibration data and xy range
parameters.

I haven't found any existing tools performing that : xinput_calibrator
(witch ebeam_calibrator is based on) and other touchscreen calibration
tools can't do much more than trivial transformations.


>> +static DEVICE_ATTR(MM, S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP,		    =
   \
>> +		   ebeam_##MM##_get,					       \
>> +		   ebeam_##MM##_set)
>
> DEVICE_ATTR_RW()?

Ok, will do.


>> +	/* sysfs setup */
>> +	err =3D sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
>
> Ick, you just added the sysfs files to the USB device, not your input
> device, are you sure you tested this?

Yes, "run fine since 3.3.6, both x86_32 and 64.".

thanks,

--=20
Yann Cantin
A4FEB47F
--
