From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v9 04/10] namei: split out nd->dfd handling to
 dirfd_path_init
Date: Fri, 12 Jul 2019 22:12:01 +1000
Message-ID: <20190712121201.ouhwqgeszfq44t33@yavin>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-5-cyphar@cyphar.com>
 <20190712042050.GH17978@ZenIV.linux.org.uk>
 <20190712120743.mka3vl5t4zndc5wj@yavin>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7696513246986689604=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190712120743.mka3vl5t4zndc5wj@yavin>
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
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, Andy Lutomirski <luto@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, David Drysdale <drysdale@google.com>, Christian Brauner <christian@brauner.io>, "J. Bruce Fields" <bfields@fieldses.org>, linux-parisc@vger.kernel.org, linux-api@vger.kernel.orgCh
List-Id: linux-api@vger.kernel.org


--===============7696513246986689604==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="37fzaqczvbcmjfqh"
Content-Disposition: inline


--37fzaqczvbcmjfqh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-07-12, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-07-12, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sun, Jul 07, 2019 at 12:57:31AM +1000, Aleksa Sarai wrote:
> > > Previously, path_init's handling of *at(dfd, ...) was only done once,
> > > but with LOOKUP_BENEATH (and LOOKUP_IN_ROOT) we have to parse the
> > > initial nd->path at different times (before or after absolute path
> > > handling) depending on whether we have been asked to scope resolution
> > > within a root.
> >=20
> > >  	if (*s =3D=3D '/') {
> > > -		set_root(nd);
> > > -		if (likely(!nd_jump_root(nd)))
> > > -			return s;
> > > -		return ERR_PTR(-ECHILD);
> >=20
> > > +		if (likely(!nd->root.mnt))
> > > +			set_root(nd);
> >=20
> > How can we get there with non-NULL nd->root.mnt, when LOOKUP_ROOT case
> > has been already handled by that point?
>=20
> Yup, you're completely right. I will remove the
>   if (!nd->root.mnt)
> in the next version.

Ah sorry, there is a reason for it -- later in the series the
LOOKUP_BENEATH case means that you might end up with a non-NULL
nd->root.mnt. If you want, I can move the addition of the conditional to
later in the series (it was easier to split the patch by-hunk back when
you originally asked me to split out dirfd_path_init()).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--37fzaqczvbcmjfqh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXSh5DgAKCRCdlLljIbnQ
EktsAQC+xy1gwgzkK07JhvJgn8Q1pT79AOQ14p3p2Zp9thYafQD9FEgBMo7bE+TU
IjLN9tnpuJF+ybsPFaA/VNK4FHH0igw=
=ZC2p
-----END PGP SIGNATURE-----

--37fzaqczvbcmjfqh--


--===============7696513246986689604==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============7696513246986689604==--
