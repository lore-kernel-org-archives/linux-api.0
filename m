From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: RE: [v11,1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 6 Nov 2017 14:28:08 +0000
Message-ID: <DB6PR0501MB2197286DFD9801F6C78D638DB1500@DB6PR0501MB2197.eurprd05.prod.outlook.com>
References: <1509724449-26221-2-git-send-email-oleksandrs@mellanox.com>
 <8760aoz78q.fsf@bilbrey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8760aoz78q.fsf@bilbrey.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Chip Bilbrey <chip@bilbrey.org>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>, "joel@jms.id.au" <joel@jms.id.au>, "jiri@resnulli.us" <jiri@resnulli.us>, "tklauser@distanz.ch" <tklauser@distanz.ch>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "mec@shout.net" <mec@shout.net>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level <system-sw-low-level@mellanox.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "openocd-devel-owner@lists.sourceforge.net" <openocd-devel-owne>
List-Id: linux-api@vger.kernel.org

Hi,=20
Thanks for review>

> -----Original Message-----
> From: Chip Bilbrey [mailto:chip@bilbrey.org]
> Sent: Monday, November 6, 2017 12:33 AM
> To: Oleksandr Shamray <oleksandrs@mellanox.com>
> Cc: gregkh@linuxfoundation.org; arnd@arndb.de; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; openbmc@lists.ozlabs.org; joel@jms.id.au;
> jiri@resnulli.us; tklauser@distanz.ch; linux-serial@vger.kernel.org;
> mec@shout.net; Vadim Pasternak <vadimp@mellanox.com>; system-sw-low-
> level <system-sw-low-level@mellanox.com>; robh+dt@kernel.org; openocd-
> devel-owner@lists.sourceforge.net; linux-api@vger.kernel.org;
> davem@davemloft.net; mchehab@kernel.org; Jiri Pirko <jiri@mellanox.com>
> Subject: Re: [v11,1/4] drivers: jtag: Add JTAG core driver
>=20
>=20
> Oleksandr Shamray writes:
> > diff --git a/include/uapi/linux/jtag.h b/include/uapi/linux/jtag.h new
> > file mode 100644 index 0000000..0b25a83
> > --- /dev/null
> > +++ b/include/uapi/linux/jtag.h
> > [...]
> > +/**
> > + * enum jtag_xfer_mode:
> > + *
> > + * @JTAG_XFER_HW_MODE: hardware mode transfer
> > + * @JTAG_XFER_SW_MODE: software mode transfer  */ enum
> jtag_xfer_mode
> > +{
> > +	JTAG_XFER_HW_MODE,
> > +	JTAG_XFER_SW_MODE,
> > +};
>=20
> Is this essentially selecting between bit-bang mode or not?  Is there a g=
enerally
> applicable reason to select SW mode over HW (or vice versa)?
> This sounds like it's tied to device-specific capability which shouldn't =
be exposed
> in a generic user API.

It is a mode of working some JTAG master devices. F.e Aspeed JTAG core can =
work in fully automatic mode when all StateMachine=20
transitions and pin control done by hardware and in the more simpler mode w=
hen JTAG pin control does by the user (like bit-bang).=20

It HW defined feature and can be applied not in all cases.=20

Seems it can be deleted from xfer option and controlled by separate like IO=
CTL_SET_PARAM command.
>=20
> > +/**
> > + * struct jtag_xfer - jtag xfer:
> > + *
> > + * @mode: access mode
> > + * @type: transfer type
> > + * @direction: xfer direction
> > + * @length: xfer bits len
> > + * @tdio : xfer data array
> > + * @endir: xfer end state
> > + *
> > + * Structure represents interface to Aspeed JTAG device for jtag sdr
> > +xfer
> > + * execution.
>=20
> Probably should remove the reference to Aspeed here.

Thanks, will remove it.

>=20
> > +/* ioctl interface */
> > +#define __JTAG_IOCTL_MAGIC	0xb2
> > +
> > +#define JTAG_IOCRUNTEST	_IOW(__JTAG_IOCTL_MAGIC, 0,\
> > +			     struct jtag_run_test_idle)
> > +#define JTAG_SIOCFREQ	_IOW(__JTAG_IOCTL_MAGIC, 1, unsigned int)
> > +#define JTAG_GIOCFREQ	_IOR(__JTAG_IOCTL_MAGIC, 2, unsigned int)
> > +#define JTAG_IOCXFER	_IOWR(__JTAG_IOCTL_MAGIC, 3, struct
> jtag_xfer)
> > +#define JTAG_GIOCSTATUS _IOWR(__JTAG_IOCTL_MAGIC, 4, enum
> > +jtag_endstate)
>=20
> I notice the single-open()-per-device lock was dropped by request in an e=
arlier
> revision of your patches, but multiple processes trying to drive a single=
 JTAG
> master could wreak serious havoc if transactions get interleaved. Would
> something like an added JTAG_LOCKCHAIN/UNLOCKCHAIN
> ioctl() for exclusive client access be reasonable to prevent this?

Yes, it dropped by recommendation of Greg KH <gregkh@linuxfoundation.org>.=
=20
Uer app should care about it.

>=20
> -Chip

Thanks for review.
Oleksandr.
