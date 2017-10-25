From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [patch v9 1/4] drivers: jtag: Add JTAG core driver
Date: Wed, 25 Oct 2017 15:58:42 +0000
Message-ID: <AM4PR0501MB21942F65C3F28F8AE9B22504B1440@AM4PR0501MB2194.eurprd05.prod.outlook.com>
References: <1505985932-27568-1-git-send-email-oleksandrs@mellanox.com>
 <1505985932-27568-2-git-send-email-oleksandrs@mellanox.com>
 <20171020115512.GA2073@kroah.com>
 <AM4PR0501MB21940531802FC14EDE8C3F75B1430@AM4PR0501MB2194.eurprd05.prod.outlook.com>
 <20171020145417.GD8965@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020145417.GD8965-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org" <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, "jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org" <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, "tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org" <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org" <mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org>, Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, system-sw-low-level <system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>"linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linu>
List-Id: linux-api@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Friday, October 20, 2017 5:54 PM
> To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: arnd-r2nGTMty4D4@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-
> kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org; joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org; jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org;
> tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org; linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org; Vadim
> Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; system-sw-low-level <system-sw-low-
> level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; openocd-devel-
> owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [patch v9 1/4] drivers: jtag: Add JTAG core driver
>=20
> On Fri, Oct 20, 2017 at 02:34:00PM +0000, Oleksandr Shamray wrote:
> > Hi Greg.
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > > Sent: Friday, October 20, 2017 2:55 PM
> > > To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: arnd-r2nGTMty4D4@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-
> > > kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org; joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org; jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org;
> > > tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org; linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org;
> > > Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; system-sw-low-level
> > > <system-sw-low- level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > > openocd-devel- owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org;
> > > linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > > Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Subject: Re: [patch v9 1/4] drivers: jtag: Add JTAG core driver
> > >
> > > On Thu, Sep 21, 2017 at 12:25:29PM +0300, Oleksandr Shamray wrote:
> > > > +struct jtag {
> > > > +	struct device *dev;
> > > > +	struct cdev cdev;
> > >
> > > Why are you using a cdev here and not just a normal misc device?
> >
> > What the benefits to use misc instead of cdev?
>=20
> Less code, simpler logic, easier to review and understand, etc.
>=20
> Let me ask you, why use a cdev instead of a misc?

As I know misc device more applicable if we want to create one device f.e. =
 /dev/jtag.=20
But in current case we can have more than one jtag device /dev/jtag0 ... /d=
ev/jtagN. =20
So I decided to use cdev.

>=20
> > > I forgot if this is what you were doing before, sorry...
> > >
> > > > +	int id;
> > > > +	atomic_t open;
> > >
> > > Why do you need this?
> >
> > This counter used to avoid open at the same time by 2 or more users.
>=20
> But it isn't working :)
>=20
> And why do you care?
>=20
> > > > +	const struct jtag_ops *ops;
> > > > +	unsigned long priv[0] __aligned(ARCH_DMA_MINALIGN);
> > >
> > > Huh?  Why is this needed to be dma aligned?  Why not just use the
> > > private pointer in struct device?
> > >
> >
> > It is critical?
>=20
> You are saying it is, so you have to justify it.  There is a pointer for =
you to use,
> don't make new ones for no reason, right?
>=20

You are right. Will remove.

> > > > +};
> > > > +
> > > > +static dev_t jtag_devt;
> > > > +static DEFINE_IDA(jtag_ida);
> > > > +
> > > > +void *jtag_priv(struct jtag *jtag) {
> > > > +	return jtag->priv;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(jtag_priv);
> > > > +
> > > > +static u8 *jtag_copy_from_user(__u64 udata, unsigned long bit_size=
) {
> > > > +	unsigned long size;
> > > > +	void *kdata;
> > > > +
> > > > +	size =3D DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> > > > +	kdata =3D memdup_user(u64_to_user_ptr(udata), size);
> > >
> > > You only use this once, why not just open-code it?
> >
> > I think it makes code more understandable.
>=20
> As a reviewer, I don't :)

Ok, I will fix :)

>=20
> > > > +
> > > > +	return kdata;
> > > > +}
> > > > +
> > > > +static unsigned long jtag_copy_to_user(__u64 udata, u8 *kdata,
> > > > +				       unsigned long bit_size) {
> > > > +	unsigned long size;
> > > > +
> > > > +	size =3D DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> > > > +
> > > > +	return copy_to_user(u64_to_user_ptr(udata), (void *)(kdata),
> > > > +size);
> > >
> > > Same here, making this a separate function seems odd.
> >
> > Same, I think it makes code more understandable.
>=20
> But it doesn't.
>=20

Ok, I will fix :)

> > > > +
> > > > +		if (jtag->ops->freq_set)
> > > > +			err =3D jtag->ops->freq_set(jtag, value);
> > > > +		else
> > > > +			err =3D -EOPNOTSUPP;
> > > > +		break;
> > > > +
> > > > +	case JTAG_IOCRUNTEST:
> > > > +		if (copy_from_user(&idle, (void *)arg,
> > > > +				   sizeof(struct jtag_run_test_idle)))
> > > > +			return -ENOMEM;
> > > > +		err =3D jtag_run_test_idle_op(jtag, &idle);
> > >
> > > Who validates the structure fields?  Is that up to the individual
> > > jtag driver?  Why not do it in the core correctly so that it only
> > > has to be done in one place and you do not have to audit every indivi=
dual
> driver?
> >
> > Input parameters validated by jtag  platform driver. I think it not cri=
tical.
>=20
> Not true at all.  It is very critical.  Remmeber, "All Input Is Evil!"
>=20
> You have to validate this.  I as a reviewer have to find where you are va=
lidating
> this data to ensure bad things do not happen.  I can't review that here, =
now I
> have to go and review all of the individual drivers, which is a major pai=
n, don't
> you agree?

Agree.  I will add input parameter checking here before call device driver.

>=20
> > > > +		break;
> > > > +
> > > > +	case JTAG_IOCXFER:
> > > > +		if (copy_from_user(&xfer, (void *)arg,
> > > > +				   sizeof(struct jtag_xfer)))
> > > > +			return -EFAULT;
> > > > +
> > > > +		if (xfer.length >=3D JTAG_MAX_XFER_DATA_LEN)
> > > > +			return -EFAULT;
> > > > +
> > > > +		xfer_data =3D jtag_copy_from_user(xfer.tdio, xfer.length);
> > > > +		if (!xfer_data)
> > > > +			return -ENOMEM;
> > >
> > > Are you sure that's the correct error value?
> >
> > I think yes, but what you suggest?
>=20
> A fault happened, so -EFAULT, right?
>=20

Right.


> > [..]
> > > +       .unlocked_ioctl =3D jtag_ioctl,
> > > +       .open           =3D jtag_open,
> > > +       .release        =3D jtag_release,
> > > +};
> >
> > add a compat_ioctl pointer here, after ensuring that all ioctl
> > commands are compatible between 32-bit and 64-bit user space.
> > [..]
>=20
> And if you do not, what happens?  You shouldn't need it as there is no fi=
xups
> necessary, or am I mistaken about that?

Yes, you are right. In code compat_ioctl called same function as in unlocke=
d_ioctl.=20
So I can remove compat and system will always call unlocked_ioctl.

>=20
> > > > +static int jtag_open(struct inode *inode, struct file *file) {
> > > > +	struct jtag *jtag =3D container_of(inode->i_cdev, struct jtag,
> > > > +cdev);
> > > > +
> > > > +	if (atomic_read(&jtag->open)) {
> > > > +		dev_info(NULL, "jtag already opened\n");
> > > > +		return -EBUSY;
> > >
> > > Why do you care if multiple opens can happen?
> >
> > Jtag HW not support to using with multiple requests from different user=
s. So
> we prohibit this.
>=20
> Why does the kernel care?
>=20
> And again, your implementation is broken, it's not actually doing this
> protection.  I recommend just not doing it at all, but if you really are =
insisting
> on it, you have to get it correct :)

I will follow your recommendations and remove it.=20

>=20
> thanks,
>=20
> greg k-h

Thanks.=20
Oleksandr S
