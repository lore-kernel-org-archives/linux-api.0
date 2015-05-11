From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH 0/3] Allow user to request memory to be locked on page
 fault
Date: Mon, 11 May 2015 17:05:33 -0400
Message-ID: <20150511210533.GB1227@akamai.com>
References: <1431113626-19153-1-git-send-email-emunson@akamai.com>
 <20150508124203.6679b1d35ad9555425003929@linux-foundation.org>
 <20150508200610.GB29933@akamai.com>
 <20150508131523.f970d13a213bca63bd6f2619@linux-foundation.org>
 <20150511143618.GA30570@akamai.com>
 <20150511121204.2af73429ad3c29b6d67f1345@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150511121204.2af73429ad3c29b6d67f1345@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 11 May 2015, Andrew Morton wrote:

> On Mon, 11 May 2015 10:36:18 -0400 Eric B Munson <emunson@akamai.com> wro=
te:
>=20
> > On Fri, 08 May 2015, Andrew Morton wrote:
> > ...
> >
> > >=20
> > > Why can't the application mmap only those parts of the file which it
> > > wants and mlock those?
> >=20
> > There are a number of problems with this approach.  The first is it
> > presumes the program will know what portions are needed a head of time.
> > In many cases this is simply not true.  The second problem is the number
> > of syscalls required.  With my patches, a single mmap() or mlockall()
> > call is needed to setup the required locking.  Without it, a separate
> > mmap call must be made for each piece of data that is needed.  This also
> > opens up problems for data that is arranged assuming it is contiguous in
> > memory.  With the single mmap call, the user gets a contiguous VMA
> > without having to know about it.  mmap() with MAP_FIXED could address
> > the problem, but this introduces a new failure mode of your map
> > colliding with another that was placed by the kernel.
> >=20
> > Another use case for the LOCKONFAULT flag is the security use of
> > mlock().  If an application will be using data that cannot be written
> > to swap, but the exact size is unknown until run time (all we have a
> > build time is the maximum size the buffer can be).  The LOCKONFAULT flag
> > allows the developer to create the buffer and guarantee that the
> > contents are never written to swap without ever consuming more memory
> > than is actually needed.
>=20
> What application(s) or class of applications are we talking about here?
>=20
> IOW, how generally applicable is this?  It sounds rather specialized.
>=20

For the example of a large file, this is the usage pattern for a large
statical language model (probably applies to other statical or graphical
models as well).  For the security example, any application transacting
in data that cannot be swapped out (credit card data, medical records,
etc).


--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVURmdAAoJELbVsDOpoOa9a0MP/2y5c7mdKE8qXiCYEBHY1vPr
mMYr1mBF5plc21zbajP8EsFs+Ld/CdtHlmeYYS8WajfsgNYeC8/0agAzYVfJFsFP
/wCPq8eC9v1kO+bl76ysR3eHpQ1vNFPwFlRfIJmKmoeA/0QJZESjuZKXbLyWCIbh
fUft9fDVrTiKmIIPA+xU/LQBTJJG3JxM31EW0npZ5czeW82djBf1U4rqJuOJ/DFr
yRFC6Ja9JRcamqDDlwnh2sI1GAT0xzWAr2dVYFEWLuin+zUAST0ByOvirtVW+Te3
Tkd+VZ5D913uj32bJnSPFBR+XkKpXkmG2oH/bskpHi2f0IJOHq8Rwae5ONlsR3HG
9ehYZk5j6XMi8p4zc77Gz4RrzOpzJWnQCtiwP0tRsCWwYDUzUtkt89I/jEp7ng/U
vsV4QocVqk8cbmAj4kJ6lK1CSstR4vi1/kjdvnMiu0iHTMc7k/ZIguZaz4nmzq0j
WDYnr87YYuOK5rPRR1U0zFHzsdC6rdcx9o5LQaEM7JUBm5Jg1aaC0ZPgs4kbzBtv
iSPfAOjCtCetUfLF5rH+qEy06emMTxOTGXuEk1ozb+q/zm0C5cE6DrSOUabBfg8V
QGAlOxZUcFQIBKgYNbhblA+edUvEL9aglNMl+91CDzk6CkNp35K2UnEk1LM4Bqqn
mYcyYlFfiVQqWLOBBiX5
=Su4z
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
