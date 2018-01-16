From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [patch v16 1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 16 Jan 2018 07:04:09 +0000
Message-ID: <AM4PR0501MB2194BD3F84A1E944EF335ECAB1EA0@AM4PR0501MB2194.eurprd05.prod.outlook.com>
References: <1515776909-29894-1-git-send-email-oleksandrs@mellanox.com>
 <1515776909-29894-2-git-send-email-oleksandrs@mellanox.com>
 <20180115205142.GD2818@kryptos.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115205142.GD2818-DmwFwOShA74B9AHHLWeGtNQXobZC6xk2@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Cartwright <juliac-SPobxgzVcRdvFhSgSjN+lA@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org" <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, "jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org" <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, "tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org" <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, system-sw-low-level <system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ap
List-Id: linux-api@vger.kernel.org

Hi Julia

> -----Original Message-----
> From: Julia Cartwright [mailto:juliac-SPobxgzVcRdvFhSgSjN+lA@public.gmane.org]
> Sent: 15 =D1=CE=D7=C1=D2=D1 2018 =C7. 22:52
> To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org; arnd-r2nGTMty4D4@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org;
> devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org; joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org;
> jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org; tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org; linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Vadi=
m
> Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; system-sw-low-level <system-sw-low-
> level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; openocd-devel-
> owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Jiri Pirko
> <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [patch v16 1/4] drivers: jtag: Add JTAG core driver
>=20
> Hello Oleksandr-
>=20
> I have a few comments below.
>=20
> On Fri, Jan 12, 2018 at 07:08:26PM +0200, Oleksandr Shamray wrote:
> > Initial patch for JTAG driver
> > JTAG class driver provide infrastructure to support hardware/software
> > JTAG platform drivers. It provide user layer API interface for
> > flashing and debugging external devices which equipped with JTAG
> > interface using standard transactions.
> >

[..]
> > +		break;
> > +
> > +	case JTAG_IOCXFER:
> > +		if (!jtag->ops->xfer)
>=20
> Are all ops optional?  That seems bizarre.  I would have expected at leas=
t one
> callback to be required.

You right. But I'm preferred to check pointers before use it.

>=20
> [..]
> > +static int jtag_open(struct inode *inode, struct file *file) {
> > +	struct jtag *jtag =3D container_of(file->private_data, struct jtag,
> > +					 miscdev);
> > +
> > +	if (mutex_lock_interruptible(&jtag->open_lock))
> > +		return -ERESTARTSYS;
> > +
> > +	if (jtag->opened) {
> > +		mutex_unlock(&jtag->open_lock);
> > +		return -EBUSY;
> > +	}
> > +
> > +	nonseekable_open(inode, file);
> > +	file->private_data =3D jtag;
>=20
> These two can be moved out of the lock.

Agree.

>=20
> > +	jtag->opened =3D true;
> > +	mutex_unlock(&jtag->open_lock);
> > +	return 0;
> > +}
> > +
> > +static int jtag_release(struct inode *inode, struct file *file) {
> > +	struct jtag *jtag =3D file->private_data;
> > +
> > +	mutex_lock(&jtag->open_lock);
> > +	jtag->opened =3D false;
> > +	mutex_unlock(&jtag->open_lock);
> > +	return 0;
> > +}
> > +
> > +static const struct file_operations jtag_fops =3D {
> > +	.owner		=3D THIS_MODULE,
> > +	.open		=3D jtag_open,
> > +	.release	=3D jtag_release,
> > +	.llseek		=3D noop_llseek,
> > +	.unlocked_ioctl =3D jtag_ioctl,
> > +};
> > +
> > +struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops)
> > +{
> > +	struct jtag *jtag;
> > +
> > +	jtag =3D kzalloc(sizeof(*jtag), GFP_KERNEL);
>=20
> Did you mean to allocate: sizeof(*jtag) + priv_size?

Thank, it's a mistake.

>=20
> > +	if (!jtag)
> > +		return NULL;
> > +
> > +	jtag->ops =3D ops;
> > +	return jtag;
> > +}
> > +EXPORT_SYMBOL_GPL(jtag_alloc);
> > +
> > +void jtag_free(struct jtag *jtag)
> > +{
> > +	kfree(jtag);
> > +}
> > +EXPORT_SYMBOL_GPL(jtag_free);
> > +
> > +int jtag_register(struct jtag *jtag)
> > +{
> > +	char *name;
> > +	int err;
> > +	int id;
> > +
> > +	id =3D ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
> > +	if (id < 0)
> > +		return id;
> > +
> > +	jtag->id =3D id;
> > +
> > +	name =3D kzalloc(MAX_JTAG_NAME_LEN, GFP_KERNEL);
> > +	if (!name) {
> > +		err =3D -ENOMEM;
> > +		goto err_jtag_alloc;
> > +	}
> > +
> > +	err =3D snprintf(name, MAX_JTAG_NAME_LEN, "jtag%d", id);
> > +	if (err < 0)
> > +		goto err_jtag_name;
> > +
> > +	mutex_init(&jtag->open_lock);
> > +	jtag->miscdev.fops =3D  &jtag_fops;
> > +	jtag->miscdev.minor =3D MISC_DYNAMIC_MINOR;
> > +	jtag->miscdev.name =3D name;
> > +
> > +	err =3D misc_register(&jtag->miscdev);
> > +	if (err)
> > +		dev_err(jtag->dev, "Unable to register device\n");
> > +	else
> > +		return 0;
> > +	jtag->opened =3D false;
>=20
> Well, this code flow is just confusing.
>=20
> I suggest a redo with:
>=20
> 	err =3D misc_register(&jtag->miscdev);
> 	if (err) {
> 		dev_err(jtag->dev, "Unable to register device\n");
> 		goto err_jtag_name;
> 	}
>=20
> If you need to initialize 'opened', do it prior to misc_register.
>=20

Thanks

> Thanks,
>    Julia

Thanks for Review.

Br,
Oleksandr

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
