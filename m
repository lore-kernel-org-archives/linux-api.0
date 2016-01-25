From: =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio.lopez@collabora.co.uk>
Subject: Re: [PATCH v2] usb: devio: Add ioctl to disallow detaching kernel USB
 drivers.
Date: Sun, 24 Jan 2016 23:01:29 -0300
Message-ID: <56A581F9.5070707@collabora.co.uk>
References: <Pine.LNX.4.44L0.1601221101490.1626-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1601221101490.1626-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@linuxfoundation.org, kborer@gmail.com, k.opasiak@samsung.com, reillyg@chromium.org, keescook@chromium.org, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jorgelo@chromium.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

Hi Alan,

El 22/01/16 a las 13:10, Alan Stern escribi=C3=B3:
> On Thu, 21 Jan 2016, Emilio L=C3=B3pez wrote:
>
>> From: Reilly Grant <reillyg@chromium.org>
>>
>> The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntari=
ly
>> relinquish the ability to issue other ioctls that may interfere with
>> other processes and drivers that have claimed an interface on the
>> device.
>>
>> Signed-off-by: Reilly Grant <reillyg@chromium.org>
>> Signed-off-by: Emilio L=C3=B3pez <emilio.lopez@collabora.co.uk>
>
>
>>   static int proc_resetdevice(struct usb_dev_state *ps)
>>   {
>> +	struct usb_host_config *actconfig =3D ps->dev->actconfig;
>> +	struct usb_interface *interface;
>> +	int i, number;
>> +
>> +	/* Don't touch the device if any interfaces are claimed. It
>> +	 * could interfere with other drivers' operations and this
>> +	 * process has dropped its privileges to do such things.
>> +	 */
>
> This comment should be rephrased.  It should say something like:
> "Don't allow if the process has dropped its privilege to do such
> things and any of the interfaces are claimed."

I have replaced it with the following now

         /* Don't allow a device reset if the process has dropped the
          * privilege to do such things and any of the interfaces are
          * currently claimed.
          */

> You also might consider allowing the reset if the interfaces are
> claimed only by the current process (or more precisely, by ps).
>
>> +static int proc_drop_privileges(struct usb_dev_state *ps, void __us=
er *arg)
>> +{
>> +	struct usbdevfs_drop_privs data;
>> +
>> +	if (copy_from_user(&data, arg, sizeof(data)))
>> +		return -EFAULT;
>> +
>> +	/* This is a one way operation. Once privileges were dropped,
>> +	 * you cannot do it again (Otherwise unprivileged processes
>> +	 * would be able to change their allowed interfaces mask)
>> +	 */
>
> If you're going to keep a mask of claimable interfaces then there's n=
o
> reason this has to be a one-time operation.  Processes should always =
be
> allowed to shrink the mask, just not to grow it.

Good point, I've changed this to look like the following

         /* This is an one way operation. Once privileges are
          * dropped, you cannot regain them. You may however reissue
          * this ioctl to shrink the allowed interfaces mask.
          */
         if (ps->privileges_dropped)
                 ps->interface_allowed_mask &=3D data.interface_allowed=
_mask;
         else
                 ps->interface_allowed_mask =3D data.interface_allowed_=
mask;

         ps->privileges_dropped =3D true;

Or maybe I could change the default mask to ~0 and simplify this a bit,=
 hm.

Thank you for the review!

Emilio
