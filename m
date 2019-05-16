From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v1 1/2] pid: add pidfd_open()
Date: Fri, 17 May 2019 00:56:07 +1000
Message-ID: <20190516145607.j43xyj26k6l5vmbd@yavin>
References: <20190516135944.7205-1-christian@brauner.io>
 <20190516142659.GB22564@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="asldj7bns6ry6jfo"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190516142659.GB22564@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, jannh@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de, akpm@linux-foundation.org, dhowells@redhat.com, ebiederm@xmission.com, elena.reshetova@intel.com, keescook@chromium.org, luto@amacapital.net, luto@kernel.org, tglx@linutronix.de, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, joel@joelfernandes.orgda
List-Id: linux-api@vger.kernel.org


--asldj7bns6ry6jfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-05-16, Oleg Nesterov <oleg@redhat.com> wrote:
> On 05/16, Christian Brauner wrote:
> >
> > With the introduction of pidfds through CLONE_PIDFD it is possible to
> > created pidfds at process creation time.
>=20
> Now I am wondering why do we need CLONE_PIDFD, you can just do
>=20
> 	pid =3D fork();
> 	pidfd_open(pid);

While the race window would be exceptionally short, there is the
possibility that the child will die and their pid will be recycled
before you do pidfd_open(). CLONE_PIDFD removes the race completely.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--asldj7bns6ry6jfo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlzdegcACgkQSnvnv3De
m59otQ//cKLIBYu0NRjFiTL/Sy05MLpjdwxWtxgO+bUeTNYJNghTPgEJw+c+25c7
tNoebC+JCGcAwO8ACNKnZDd3AuaNys1ZrFwNP7s9IcfOhPEHbcgD2OthKJUE5zZJ
bXypZRJF+JWJYvn8yBVWpV0IKZwytCnY/yDelTQgcZnKQ2fnmPLEIDtYD3zAuab+
IgkiYZ/oDsrgUIjkgiYs7gHSqU/cZEDI+dxAZawR2xuSOg7nLUlZ9mJmFWiUYwfL
55w4joeTcTAlRUDEBzsJFemknqCEo+5qrX0C2qoTmZvdiaVqMQKmGiqYbxdTRC/o
6lH2q4JQE2aYetbZ9Q9gl4fnFsbbAZBADAuAd8xV0rFWbCB+gkTdZS4G3MZ9baAm
F0o5HofG0TvkzG5K81aRWlipjvnngapLm/xnSCrfe3rIi9Kw+u1+9jMr+1/BTN/5
dsHnpAqWPt81mJdlzOSqhCfG7aLmJ/AQKvrC8h2JvtKema98vpK7hJhCbAUi+6lU
1V9iCvnERBIOlmzkE67ZGtKRPXmPSKIxKgbvOhc1f9DAYQID20S+SNtRJcBpSwhH
+YDqmefCAfqC6+JU/ZySLZrkuNOmoGuHP+T3ku0JyGn4xUayM1ZtKece3ILcafoi
hRTQy5y2ax/fJ2EPN7o5qc8Oe8DMInckJzKsOvbMe43FldNhKzA=
=SNKZ
-----END PGP SIGNATURE-----

--asldj7bns6ry6jfo--
