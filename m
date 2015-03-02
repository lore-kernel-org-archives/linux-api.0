From: Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH 1/9] HSI: cmt_speech: Add cmt-speech driver
Date: Mon, 2 Mar 2015 16:26:53 +0100
Message-ID: <20150302152652.GB2834@earth>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
 <1425271139-24715-2-git-send-email-sre@kernel.org>
 <1425291753.2014.5.camel@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425291753.2014.5.camel@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Joni Lapilainen <joni.lapilainen@gmail.com>
List-Id: linux-api@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Mon, Mar 02, 2015 at 11:22:33AM +0100, Oliver Neukum wrote:
> > +static ssize_t cs_char_read(struct file *file, char __user *buf, size_=
t count,
> > +								loff_t *unused)
> > +{
> > +	struct cs_char *csdata =3D file->private_data;
> > +	u32 data;
> > +	ssize_t retval;
> > +
> > +	if (count < sizeof(data))
> > +		return -EINVAL;
> > +
> > +	for ( ; ; ) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		spin_lock_bh(&csdata->lock);
> > +		if (!list_empty(&csdata->chardev_queue)) {
> > +			data =3D cs_pop_entry(&csdata->chardev_queue);
> > +		} else if (!list_empty(&csdata->dataind_queue)) {
> > +			data =3D cs_pop_entry(&csdata->dataind_queue);
> > +			--csdata->dataind_pending;
> > +
> > +		} else {
> > +			data =3D 0;
> > +		}
> > +		spin_unlock_bh(&csdata->lock);
> > +
> > +		if (data)
> > +			break;
> > +		if (file->f_flags & O_NONBLOCK) {
> > +			retval =3D -EAGAIN;
> > +			goto out;
> > +		} else if (signal_pending(current)) {
> > +			retval =3D -ERESTARTSYS;
> > +			goto out;
> > +		}
> > +		prepare_to_wait_exclusive(&csdata->wait, &wait,
> > +						TASK_INTERRUPTIBLE);
> > +		schedule();
> > +		finish_wait(&csdata->wait, &wait);
> > +	}
> > +
> > +	retval =3D put_user(data, (u32 __user *)buf);
> > +	if (!retval)
> > +		retval =3D sizeof(data);
> > +
> > +out:
> > +	return retval;
> > +}
> > +
> > +static ssize_t cs_char_write(struct file *file, const char __user *buf,
> > +						size_t count, loff_t *unused)
> > +{
> > +	struct cs_char *csdata =3D file->private_data;
> > +	u32 data;
> > +	int err;
> > +	ssize_t	retval;
> > +
> > +	if (count < sizeof(data))
> > +		return -EINVAL;
> > +
> > +	if (get_user(data, (u32 __user *)buf))
> > +		retval =3D -EFAULT;
> > +	else
> > +		retval =3D count;
>=20
> You want to execute the command even if you got -EFAULT?
> That is highly unusual.

I will change this in PATCHv2.

> > +
> > +	err =3D cs_hsi_command(csdata->hi, data);
> > +	if (err < 0)
> > +		retval =3D err;
> > +
> > +	return retval;
> > +}
> > +
> > +static long cs_char_ioctl(struct file *file, unsigned int cmd,
> > +				unsigned long arg)
> > +{
> > +	struct cs_char *csdata =3D file->private_data;
> > +	int r =3D 0;
> > +
> > +	switch (cmd) {
> > +	case CS_GET_STATE: {
> > +		unsigned int state;
> > +
> > +		state =3D cs_hsi_get_state(csdata->hi);
> > +		if (copy_to_user((void __user *)arg, &state, sizeof(state)))
> > +			r =3D -EFAULT;
> > +	}
> > +		break;
> > +	case CS_SET_WAKELINE: {
> > +		unsigned int state;
> > +
> > +		if (copy_from_user(&state, (void __user *)arg, sizeof(state)))
> > +			r =3D -EFAULT;
> > +		else
> > +			cs_hsi_set_wakeline(csdata->hi, state);
>=20
> No sanity checking for state?

Will be added in PATCHv2, so that -EINVAL is returned for values > 1.

> > +	}
> > +		break;
> > +	case CS_GET_IF_VERSION: {
> > +		unsigned int ifver =3D CS_IF_VERSION;
> > +
> > +		if (copy_to_user((void __user *)arg, &ifver, sizeof(ifver)))
> > +			r =3D -EFAULT;
> > +		break;
> > +	}
> > +	case CS_CONFIG_BUFS: {
> > +		struct cs_buffer_config buf_cfg;
> > +
> > +		if (copy_from_user(&buf_cfg, (void __user *)arg,
> > +							sizeof(buf_cfg)))
> > +			r =3D -EFAULT;
> > +		else
> > +			r =3D cs_hsi_buf_config(csdata->hi, &buf_cfg);
>=20
> Sanity checking?

cs_hsi_buf_config() calls check_buf_params().

> > +		break;
> > +	}
> > +	default:
> > +		r =3D -ENOTTY;
> > +		break;
> > +	}
> > +
> > +	return r;
> > +}
> > +
> > +static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	if (vma->vm_end < vma->vm_start)
> > +		return -EINVAL;
> > +
> > +	if (((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) !=3D 1)
> > +		return -EINVAL;
> > +
> > +	vma->vm_flags |=3D VM_RESERVED;
> > +	vma->vm_ops =3D &cs_char_vm_ops;
> > +	vma->vm_private_data =3D file->private_data;
> > +
> > +	return 0;
> > +}
> > +
> > +static int cs_char_open(struct inode *unused, struct file *file)
> > +{
> > +	int ret =3D 0;
> > +
> > +	spin_lock_bh(&cs_char_data.lock);
> > +	if (cs_char_data.opened) {
> > +		ret =3D -EBUSY;
> > +		spin_unlock_bh(&cs_char_data.lock);
> > +		goto out;
> > +	}
> > +	cs_char_data.mmap_base =3D get_zeroed_page(GFP_ATOMIC);
>=20
> This could be moved outside the locked sectionand use GFP_KERNEL.

Right, this is fixed by a follow up patch. I kept the patchset split
to keep authorship information. I guess I can squash the first three
patches, though.

> > +	if (!cs_char_data.mmap_base) {
> > +		dev_err(&cs_char_data.cl->device,
> > +					"Shared memory allocation failed.\n");
> > +		ret =3D -ENOMEM;
> > +		spin_unlock_bh(&cs_char_data.lock);
> > +		goto out;
> > +	}
> > +	cs_char_data.mmap_size =3D CS_MMAP_SIZE;
> > +	cs_char_data.dataind_pending =3D 0;
> > +	cs_char_data.opened =3D 1;
> > +	file->private_data =3D &cs_char_data;
> > +	spin_unlock_bh(&cs_char_data.lock);
> > +
> > +	BUG_ON(cs_char_data.hi);
> > +
> > +	ret =3D cs_hsi_start(&cs_char_data.hi, cs_char_data.cl,
> > +				cs_char_data.mmap_base, cs_char_data.mmap_size);
> > +	if (ret) {
> > +		dev_err(&cs_char_data.cl->device, "Unable to initialize HSI\n");
> > +		free_page(cs_char_data.mmap_base);
> > +		goto out;
> > +	}
> > +
> > +out:
> > +	return ret;
> > +}

-- Sebastian

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJU9IE5AAoJENju1/PIO/qaD7wP/3gW73rCOETtwOhVRx8NG+vZ
Chr4qAJ2uEmB+9OFq9Bm4InMuLePzXL2d5akdpCxhYCxOBHPB4YC9V+nUyCN6ATK
rd8RDV6zmp79Rry8jmv0EeOsl3VC81jl/AkedpboBDBWgEkd6sPuA/BJt/YJIHCt
7yj2RGAi2w+tqHB87iPpI+l1A4jP9Vxl5Uf59/W5JHSF3lE/TqtNABM5NxIZM2Cy
OMURi02/8nXEoVT8ngvSstk+mY/oSo5K34d3f5jSeYPXoInlxeir+2NkFZO9UIBG
hJYmrH1sdtMg4A+c//BdoH4SgDsI5t6UNBJvJ8R+rUZdz6F2r+D1hN/b5CtRVbWM
yP5UYYcndNKqJT+qPWVyDxp/UPzTPcuVSAKH2mRALl4Cu2jtSSRmEx/1atpqA1av
oC2UnQiteSxF9NyHI2caY8KM3yzF6f3JumyXxNMNs3iH+i1nuGjeFfCGsZi6vpZN
jnXe7G+74+3SwmAq1IExnow0emRkK7b4OGVsl7VfIEUciFM8+6obk3haTjhi9Udy
ar9BDAPkLJaaUAhSKzn4anf0d0jF6a2R3nEVOIZuPCwHruWO76pt4UnerpRCOiep
ESVTvNjJkHrm2uyY6o+9qKSZVAEuBaIU7bz2sRTPE5+9/nvEplnrr9WgtDpv/171
4pHpMMpcYklXaHZGQOCO
=uGX9
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
