From: =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: [PATCH v2] usb: devio: Add ioctl to disallow detaching kernel USB
 drivers.
Date: Sun, 24 Jan 2016 22:40:28 -0300
Message-ID: <56A57D0C.6030308@collabora.co.uk>
References: <20160119180752.GA10487@kroah.com>
 <1453420476-26125-1-git-send-email-emilio.lopez@collabora.co.uk>
 <8760ymdk94.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760ymdk94.fsf-lbf33ChDnrE/G1V5fR+Y7Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn-yOkvZcmFvRU@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Bj=C3=B8rn,

El 22/01/16 a las 06:41, Bj=C3=B8rn Mork escribi=C3=B3:
> Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org> writes:
>
>> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
>> index 38ae877c..bf40aa6 100644
>> --- a/drivers/usb/core/devio.c
>> +++ b/drivers/usb/core/devio.c
>> @@ -77,6 +77,8 @@ struct usb_dev_state {
>>   	unsigned long ifclaimed;
>>   	u32 secid;
>>   	u32 disabled_bulk_eps;
>> +	bool privileges_dropped;
>> +	unsigned long interface_allowed_mask;
>>   };
>>
>>   struct async {
>> @@ -641,6 +643,14 @@ static int claimintf(struct usb_dev_state *ps, =
unsigned int ifnum)
>>   	if (test_bit(ifnum, &ps->ifclaimed))
>>   		return 0;
>>
>> +	if (ps->privileges_dropped) {
>> +		if (ifnum >=3D 8*sizeof(ps->interface_allowed_mask))
>> +			return -EINVAL;
>
>
> I don't think you need this runtime test. You can just make sure that
> sizeof(ps->interface_allowed_mask) =3D=3D sizeof(ps->ifclaimed) at bu=
ild
> time.
>
> I do find this variable and arbitrary limit a bit confusing, but that=
's
> not your fault - I guess it is an indication that ifnums > 31 are rar=
e
> :)
>
>
>> diff --git a/include/uapi/linux/usbdevice_fs.h b/include/uapi/linux/=
usbdevice_fs.h
>> index 019ba1e..9abcb34 100644
>> --- a/include/uapi/linux/usbdevice_fs.h
>> +++ b/include/uapi/linux/usbdevice_fs.h
>> @@ -154,6 +154,10 @@ struct usbdevfs_streams {
>>   	unsigned char eps[0];
>>   };
>>
>> +struct usbdevfs_drop_privs {
>> +	unsigned long interface_allowed_mask;
>> +};
>> +
>
> "unsigned long" isn't a very good choice here, is it?

I went with a type matching ifclaimed on struct usb_dev_state to keep=20
the limit the same, but I guess it's not the best idea for an ioctl. I=20
can switch it to __u32, keeping the runtime check above as is, or use=20
__u64. Which one would you prefer?

Thanks for the review!
Emilio
