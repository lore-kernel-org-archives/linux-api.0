From: =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: [PATCH v3] usb: devio: Add ioctl to disallow detaching kernel USB
 drivers.
Date: Sun, 7 Feb 2016 22:56:35 -0300
Message-ID: <56B7F5D3.6050009@collabora.co.uk>
References: <Pine.LNX.4.44L0.1602041122340.1515-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1602041122340.1515-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bjorn-yOkvZcmFvRU@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Alan,

El 04/02/16 a las 13:27, Alan Stern escribi=C3=B3:
> On Thu, 4 Feb 2016, Emilio L=C3=B3pez wrote:
>
>> From: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>
>> The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntari=
ly
>> relinquish the ability to issue other ioctls that may interfere with
>> other processes and drivers that have claimed an interface on the
>> device.
>>
>> Signed-off-by: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Signed-off-by: Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
>>
>> ---
>>
>> Changes in v3:
>> - Switch ioctl to use a __u32 given the iface qty is capped at 32
>> - Reword comments as requested by Alan
>> - Allow callers to shrink the allowed interfaces mask
>
>> @@ -624,6 +626,10 @@ static int claimintf(struct usb_dev_state *ps, =
unsigned int ifnum)
>>   	if (test_bit(ifnum, &ps->ifclaimed))
>>   		return 0;
>>
>> +	if (ps->privileges_dropped
>> +	 && !test_bit(ifnum, &ps->interface_allowed_mask))
>
> Continuation lines in this file are indented by 2 tab stops, not 1
> space.

Ok, I'll change it.

>> @@ -1198,6 +1202,27 @@ static int proc_connectinfo(struct usb_dev_st=
ate *ps, void __user *arg)
>>
>>   static int proc_resetdevice(struct usb_dev_state *ps)
>>   {
>> +	struct usb_host_config *actconfig =3D ps->dev->actconfig;
>> +	struct usb_interface *interface;
>> +	int i, number;
>> +
>> +	/* Don't allow a device reset if the process has dropped the
>> +	 * privilege to do such things and any of the interfaces are
>> +	 * currently claimed.
>> +	 */
>> +	if (ps->privileges_dropped && actconfig) {
>> +		for (i =3D 0; i < actconfig->desc.bNumInterfaces; ++i) {
>> +			interface =3D actconfig->interface[i];
>> +			number =3D interface->cur_altsetting->desc.bInterfaceNumber;
>> +			if (usb_interface_claimed(interface)) {
>
> The test should be:
>
> 			if (usb_interface_claimed(interface) &&
> 					!test_bit(number, &ps->ifclaimed)) {
>
> We don't want to prevent people from resetting a device merely becaus=
e
> they have claimed an interface.  Only if someone else has claimed one=
=2E

Sounds sensible, now changed as well.

>> +				dev_warn(&ps->dev->dev,
>> +					"usbfs: interface %d claimed by %s while '%s' resets device\n"=
,
>> +					number,	interface->dev.driver->name, current->comm);
>> +				return -EACCES;
>> +			}
>> +		}
>> +	}
>> +
>>   	return usb_reset_device(ps->dev);
>>   }
>
> Also, it wouldn't hurt to change proc_get_capabilities() and
> include/uapi/linux/usbdevicefs.h to add a USBDEVFS_CAP_DROP_PRIVILEGE=
S
> bit.

Good idea, I've added a bit now. I'm writing some docs and polishing a=20
program to test this as Greg requested and I'll submit v4 then.

Thanks!
Emilio
