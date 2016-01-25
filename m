From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Mon, 25 Jan 2016 10:16:37 +0100
Message-ID: <20160125091637.GA29561@c203.arch.suse.de>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
 <20160119135016.GL2742@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C618138@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C618138@MX105CL01.corp.emc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 23, 2016 at 05:33:31AM +0000, Singhal, Maneesh wrote:
> Hello Thumshirn.
> Thanks for taking out time to review the patch. I appreciate that. Pl=
ease find my comments inlined.
>=20

[...]

> >=20
> > Wouldn't it be nice to have this in the Kconfig file? No user will =
ever
> > look
> > at the README file in the driver directory.
>=20
> [MS>] Certainly, I will keep this README as it is (for someone who re=
ally reads this) and also add these details in Kconfig as well.
> >=20

OK, I can live with this.

> > > diff --git a/drivers/scsi/emcctd/emc_ctd_interface.h
> > b/drivers/scsi/emcctd/emc_ctd_interface.h
> > > new file mode 100644
> > > index 0000000..58a0276
> > > --- /dev/null
> > > +++ b/drivers/scsi/emcctd/emc_ctd_interface.h
> > > @@ -0,0 +1,386 @@

[...]

> > > +
> > > +/* a CTD v010 scatter/gather list entry: */
> > > +struct emc_ctd_v010_sgl {
> > > +
> > > +	/* the physical address of the buffer: */
> > > +	emc_ctd_uint32_t emc_ctd_v010_sgl_paddr_0_31;
> > > +	emc_ctd_uint32_t emc_ctd_v010_sgl_paddr_32_63;
> > > +
> > > +	/* the size of the buffer: */
> > > +	emc_ctd_uint32_t emc_ctd_v010_sgl_size;
> > > +};
> > > +
> > > +/* a CTD v010 header: */
> > > +struct emc_ctd_v010_header {
> > > +
> > > +	/* the other address: */
> > > +	emc_ctd_uint16_t emc_ctd_v010_header_address;
> > > +
> > > +	/* the minor version: */
> > > +	emc_ctd_uint8_t emc_ctd_v010_header_minor;
> > > +
> > > +	/* the what: */
> > > +	emc_ctd_uint8_t emc_ctd_v010_header_what;
> > > +};
> >=20
> > Well this is a matter of taste but you have (and not only in this s=
truct,
> > just
> > an example)
> >=20
> > emc_ctd_v010_header.emc_ctd_v010_header_address
> >=20
> > all the emc_ctd_v010_header_ stuff is totally redundant and you
> > suffer from extremely
> > long lines in your dirver anyways. Just a hint.
> [MS>] Well, didn't actually get what you meant here, header_stuff is =
getting used in the code, and is extremely useful as well.
> Also, I tried reducing long lines ... I don't think the left overs co=
uld be reduced in a better way.


I'd suggest the following:

/* a CTD v010 header: */
struct emc_ctd_v010_header {

	/* the other address: */
	u16 header_address;

	/* the minor version: */
	u8 header_minor;

	/* the what: */
	u8 what;
};

and then use it like:

static void
ctd_handle_response(union emc_ctd_v010_message *io_message,
				struct ctd_pci_private *ctd_private)
{
	struct emc_ctd_v010_header *msg_header;

	msg_header =3D &io_message->emc_ctd_v010_message_header;

	switch (msg_header->what) {

	case EMC_CTD_V010_WHAT_DETECT:
		ctd_handle_detect((struct emc_ctd_v010_detect *)io_message,
						ctd_private);

All the "emc_ctd_v010_header_" is unneeded redundant information, that =
doesn't
really solve a purpose in my opinion.

> >=20
> > > +
> > > +/* a CTD v010 name: */
> > > +struct emc_ctd_v010_name {
> > > +
> > > +	/* the name: */
> > > +	emc_ctd_uint8_t emc_ctd_v010_name_bytes[8];
> > > +};
> > > +
> > > +/* a CTD v010 detect message: */
> > > +struct emc_ctd_v010_detect {
> > > +
> > > +	/* the header: */
> > > +	struct emc_ctd_v010_header emc_ctd_v010_detect_header;
> > > +
> > > +	/* the flags: */
> > > +	emc_ctd_uint32_t emc_ctd_v010_detect_flags;
> > > +
> > > +	/* the name: */
> > > +	struct emc_ctd_v010_name emc_ctd_v010_detect_name;
> > > +
> > > +	/* the key: */
> > > +	emc_ctd_uint64_t emc_ctd_v010_detect_key;
> > > +};
> > > +

[...]

> > > +
> > > +/* nomenclature for versioning
> > > + * MAJOR:MINOR:SUBVERSION:PATCH
> > > + */
> > > +
> > > +#define EMCCTD_MODULE_VERSION "2.0.0.24"
> > > +
> > > +MODULE_LICENSE("GPL");
> > > +MODULE_AUTHOR("EMC");
> > > +MODULE_DESCRIPTION("EMC CTD V1 - Build 18-Jan-2016");
> >=20
> > This is very misleading. If I was a user I'd think the kernel was b=
uild on
> > 18-Jan-2016. Anyways The version should be enough.
> [MS>] I actually wanted to understand when this driver was last touch=
ed, and hence this description was added.
> >=20

If you insist.

> > > +MODULE_VERSION(EMCCTD_MODULE_VERSION);
> > > +

[...]

> > > +#define ctd_dprintk(__m_fmt, ...)		\
> > > +do {				\
> > > +	if (ctd_debug)		\
> > > +		pr_info("%s:%d:"__m_fmt, __func__, __LINE__,
> > ##__VA_ARGS__); \
> > > +} while (0)
> >=20
> > Please use pr_debug() here.
> [MS>] Sure.
> >=20
> > > +
> > > +#define ctd_dprintk_crit(__m_fmt, ...)		\
> > > +		pr_crit("%s:%d:"__m_fmt, __func__, __LINE__,
> > ##__VA_ARGS__)
> >=20
> > File and line information is probably not of any interest for the u=
sers
> > and
> > serves a debugging purpose only.
> [MS>] That's precisely why it is there...

Then please use the kernel's dynamic debug facility.

Thanks,
	Johannes
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
