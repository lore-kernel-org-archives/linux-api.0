From: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [v11,1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 14 Nov 2017 10:34:49 +0000
Message-ID: <DB6PR0501MB219753AC43515148F39CC2D0B1280@DB6PR0501MB2197.eurprd05.prod.outlook.com>
References: <1509724449-26221-2-git-send-email-oleksandrs@mellanox.com>
 <8760aoz78q.fsf@bilbrey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760aoz78q.fsf-Gz1Ta9Qd61ZAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chip Bilbrey' <chip-Gz1Ta9Qd61ZAfugRpC6u6w@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org" <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, "jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org" <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, "tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org" <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org" <mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, davem@davemlo
List-Id: linux-api@vger.kernel.org

> -----Original Message-----
> From: Chip Bilbrey [mailto:chip-Gz1Ta9Qd61ZAfugRpC6u6w@public.gmane.org]
> Sent: Monday, November 6, 2017 12:33 AM
> To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org; arnd-r2nGTMty4D4@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org;
> devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org; joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org;
> jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org; tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org; linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org; Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; system-sw-low-
> level <system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; openocd-
> devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [v11,1/4] drivers: jtag: Add JTAG core driver
>=20
>=20
> Oleksandr Shamray writes:

[..]

> I notice the single-open()-per-device lock was dropped by request in an e=
arlier
> revision of your patches, but multiple processes trying to drive a single=
 JTAG
> master could wreak serious havoc if transactions get interleaved. Would
> something like an added JTAG_LOCKCHAIN/UNLOCKCHAIN
> ioctl() for exclusive client access be reasonable to prevent this?
>=20

Yes, it dropped by recommendation of Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>.=
=20

Greg, what you can suggest about it. May be better to add again single-open=
()-per-device lock with right locking way like:

>if (mutex_lock_interruptible(&jtag->open_lock)) {
>	return -ERESTARTSYS;
>}
>
>if (jtag->opened) {
>	mutex_unlock(&jtag->open_lock);
>	return -EINVAL;
>}
>
>nonseekable_open(inode, file);
>file->private_data =3D jtag;
>jtag->opened++;
>mutex_unlock(&jtag->open_lock);
>

Thaks.

> -Chip
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
