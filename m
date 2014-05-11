From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Date: Sun, 11 May 2014 14:50:06 +0200
Message-ID: <20140511125006.GA16197@debjann.fritz.box>
References: <20140509191914.GA7286@jtriplet-mobl1>
 <20140510070742.GE6099@debjann.fritz.box>
 <20140510193246.GA12079@thin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140510193246.GA12079@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 10, 2014 at 12:32:46PM -0700, Josh Triplett wrote:
> On Sat, May 10, 2014 at 09:07:42AM +0200, Jann Horn wrote:
> > On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> > > +	if (port > 65535)
> > > +		return 0;
> > > +	switch (count) {
> > [...]
> > > +	case 4:
> > > +		if (__put_user(inl(port), buf) < 0)
> > > +			return -EFAULT;
> >=20
> > What if I attempt a four-byte read at 65535? That would access four
> > out-of-bounds bytes, right?
>=20
> No, it would do an ind instruction on port 65535.

Yes, on x86. What about other architectures?

http://lxr.free-electrons.com/source/arch/m68k/include/asm/io_mm.h#L110
110 #define inl     mcf_pci_inl

http://lxr.free-electrons.com/source/arch/m68k/platform/coldfire/pci.c#L163
163 u32 mcf_pci_inl(u32 addr)
164 {
165         return le32_to_cpu(__raw_readl(iospace + (addr & PCI_IO_MASK)));
166 }

http://lxr.free-electrons.com/source/arch/m68k/platform/coldfire/pci.c#L37
 37 #define PCI_IO_SIZE     0x00010000              /* 64k */
 38 #define PCI_IO_MASK     (PCI_IO_SIZE - 1)

http://lxr.free-electrons.com/source/arch/m68k/include/asm/raw_io.h#L54
 54 #define __raw_readl in_be32

http://lxr.free-electrons.com/source/arch/m68k/include/asm/raw_io.h#L36
 36 #define in_be32(addr) \
 37     ({ u32 __v =3D (*(__force volatile u32 *) (addr)); __v; })

As far as I can see, you'd get a slightly out-of-bounds read here. Or
is that feature only intended for x86?

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTb3H+AAoJED4KNFJOeCOoRokQAI0JrZzgC//sThV9GvPFLZuc
SkGP37/8y8B7GUl6gL5L3NhH+HIbcwB6GhudArSPSPdMaRQCQsOHC0J5xbz+Vq86
mL1S2Jt99f3K0GlGW1V8r1FeLoNI9CwXYkjbjrnV9BZzQey++Ge/NDaLn/wlqgn5
FzqOQ40thRBfvmigQ3uYYx7+xKK6qp0Ajb10Gsa9mjsMC8h08onbp72f6PGm3I1O
tpO7SmoOqe3t4zWplreeifobayCgcR1ZGNCoEVl9tlvktKiyLgboYArnUrJWsurg
/ep68wFv7wSoC32+rnCp1XPY9vuZpwrGeT31eA8hvpv5nRTpJqtqW0F1nsUnOTPj
XsZ46LVs9pZ7I+rOiKB0t7xsiBIFLTPrDSK1HkBY+ui7uFxnl6n0+Z69loidRba+
0OoQtbYaucESzH6rhwg2VZjWytpecmXcQnC9zELbmx4Mpx2Lku5KKkVZ8uxdN5Kb
9oFrqmo8U8R++oKUcMvkYUa9dpknCf3/9XXnbQMnOp8JATSvdIkN/6bimLFR5AaE
s9A/phMq1LLugcOCIohIjfc81pERs2psgonAJ1LX9R64Vf81gSP5rXgZ+EcVyQmV
hZA9KzpMl7hg72z+ei4rgdOuDfl7R6XwGY4nPsW2BQ7aCTxJQMYL13MRmrtUCfeq
4B3LSiqk334g1X+cfY2h
=RVUG
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
