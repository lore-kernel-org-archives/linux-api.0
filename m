From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn-yOkvZcmFvRU@public.gmane.org>
Subject: Re: [PATCH v2] usb: devio: Add ioctl to disallow detaching kernel USB drivers.
Date: Fri, 22 Jan 2016 10:41:11 +0100
Message-ID: <8760ymdk94.fsf@nemi.mork.no>
References: <20160119180752.GA10487@kroah.com>
	<1453420476-26125-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453420476-26125-1-git-send-email-emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
	("Emilio =?utf-8?Q?L=C3=B3pez=22's?= message of "Thu, 21 Jan 2016 20:54:36
 -0300")
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emilio =?utf-8?Q?L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org> writes:

> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 38ae877c..bf40aa6 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -77,6 +77,8 @@ struct usb_dev_state {
>  	unsigned long ifclaimed;
>  	u32 secid;
>  	u32 disabled_bulk_eps;
> +	bool privileges_dropped;
> +	unsigned long interface_allowed_mask;
>  };
> =20
>  struct async {
> @@ -641,6 +643,14 @@ static int claimintf(struct usb_dev_state *ps, u=
nsigned int ifnum)
>  	if (test_bit(ifnum, &ps->ifclaimed))
>  		return 0;
> =20
> +	if (ps->privileges_dropped) {
> +		if (ifnum >=3D 8*sizeof(ps->interface_allowed_mask))
> +			return -EINVAL;


I don't think you need this runtime test. You can just make sure that
sizeof(ps->interface_allowed_mask) =3D=3D sizeof(ps->ifclaimed) at buil=
d
time.

I do find this variable and arbitrary limit a bit confusing, but that's
not your fault - I guess it is an indication that ifnums > 31 are rare
:)


> diff --git a/include/uapi/linux/usbdevice_fs.h b/include/uapi/linux/u=
sbdevice_fs.h
> index 019ba1e..9abcb34 100644
> --- a/include/uapi/linux/usbdevice_fs.h
> +++ b/include/uapi/linux/usbdevice_fs.h
> @@ -154,6 +154,10 @@ struct usbdevfs_streams {
>  	unsigned char eps[0];
>  };
> =20
> +struct usbdevfs_drop_privs {
> +	unsigned long interface_allowed_mask;
> +};
> +

"unsigned long" isn't a very good choice here, is it?



Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
