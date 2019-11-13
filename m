From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v15 7/9] open: introduce openat2(2) syscall
Date: Wed, 13 Nov 2019 13:35:37 +1100
Message-ID: <20191113023537.epcgw5u2fdbinnyj@yavin.dot.cyphar.com>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-8-cyphar@cyphar.com>
 <20191113022906.GD26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1806869698648339356=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20191113022906.GD26530@ZenIV.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, Andy Lutomirski <luto@kernel.org>, Shuah Khan <skha>
List-Id: linux-api@vger.kernel.org


--===============1806869698648339356==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ohhoiky5cv3wybqd"
Content-Disposition: inline


--ohhoiky5cv3wybqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-13, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Nov 05, 2019 at 08:05:51PM +1100, Aleksa Sarai wrote:
> > +/*
> > + * Arguments for how openat2(2) should open the target path. If @resol=
ve is
> > + * zero, then openat2(2) operates very similarly to openat(2).
> > + *
> > + * However, unlike openat(2), unknown bits in @flags result in -EINVAL=
 rather
> > + * than being silently ignored. @mode must be zero unless one of {O_CR=
EAT,
> > + * O_TMPFILE} are set, and @upgrade_mask must be zero unless O_PATH is=
 set.
> > + *
> > + * @flags: O_* flags.
> > + * @mode: O_CREAT/O_TMPFILE file mode.
> > + * @upgrade_mask: UPGRADE_* flags (to restrict O_PATH re-opening).
>=20
> ???

Sorry, that was left over from a previous revision (where the magic-link
re-opening restrictions were part of this series).

> > + * @resolve: RESOLVE_* flags.
> > + */
> > +struct open_how {
> > +	__aligned_u64 flags;
> > +	__u16 mode;
> > +	__u16 __padding[3]; /* must be zeroed */
> > +	__aligned_u64 resolve;
> > +};


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ohhoiky5cv3wybqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXctr9QAKCRCdlLljIbnQ
Ej91AQDSESPrMbumo+B1bVc2FthUOUuONyqVLG0aRmu7PQjnOgD7BOxMC9suhDip
ayqrtLJhXKxmKpbFt69x0a97Rx8tGQ8=
=4v0x
-----END PGP SIGNATURE-----

--ohhoiky5cv3wybqd--


--===============1806869698648339356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============1806869698648339356==--
