From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v9 01/10] namei: obey trailing magic-link DAC permissions
Date: Fri, 12 Jul 2019 22:20:17 +1000
Message-ID: <20190712122017.xkowq2cjreylpotm@yavin>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-2-cyphar@cyphar.com>
 <20190712041454.GG17978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7491196064534468651=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190712041454.GG17978@ZenIV.linux.org.uk>
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


--===============7491196064534468651==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zhpexfjxcruxolbk"
Content-Disposition: inline


--zhpexfjxcruxolbk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-07-12, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jul 07, 2019 at 12:57:28AM +1000, Aleksa Sarai wrote:
> > @@ -514,7 +516,14 @@ static void set_nameidata(struct nameidata *p, int=
 dfd, struct filename *name)
> >  	p->stack =3D p->internal;
> >  	p->dfd =3D dfd;
> >  	p->name =3D name;
> > -	p->total_link_count =3D old ? old->total_link_count : 0;
> > +	p->total_link_count =3D 0;
> > +	p->acc_mode =3D 0;
> > +	p->opath_mask =3D FMODE_PATH_READ | FMODE_PATH_WRITE;
> > +	if (old) {
> > +		p->total_link_count =3D old->total_link_count;
> > +		p->acc_mode =3D old->acc_mode;
> > +		p->opath_mask =3D old->opath_mask;
> > +	}
>=20
> Huh?  Could somebody explain why traversals of NFS4 referrals should inhe=
rit
> ->acc_mode and ->opath_mask?

I'll be honest -- I don't understand what set_nameidata() did so I just
did what I thought would be an obvious change (to just copy the
contents). I thought it was related to some aspect of the symlink stack
handling.

In that case, should they both be set to 0 on set_nameidata()? This will
mean that fd re-opening (or magic-link opening) through a
set_nameidata() would always fail.

> >  static __always_inline
> > -const char *get_link(struct nameidata *nd)
> > +const char *get_link(struct nameidata *nd, bool trailing)
> >  {
> >  	struct saved *last =3D nd->stack + nd->depth - 1;
> >  	struct dentry *dentry =3D last->link.dentry;
> > @@ -1081,6 +1134,44 @@ const char *get_link(struct nameidata *nd)
> >  		} else {
> >  			res =3D get(dentry, inode, &last->done);
> >  		}
> > +		/* If we just jumped it was because of a magic-link. */
> > +		if (unlikely(nd->flags & LOOKUP_JUMPED)) {
> [...]
> In any case, this "bool trailing" is completely wrong; whether that
> check belongs in trailing_symlink() or (some of) its callers, putting
> it into get_link() is a mistake, forced by kludgy check for procfs-style
> symlinks.

The error path for LOOKUP_JUMPED comes from the old O_BENEATH patchset,
but all of the "bool trailing" logic is definitely my gaff (I was
quietly hoping you'd have a much better solution than the whole
get_link() thing -- it definitely felt very kludgey to write).

I will work on the suggestion in your follow-up email. Thanks!

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--zhpexfjxcruxolbk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXSh6/QAKCRCdlLljIbnQ
EjDMAQCLRtfrI0y8gA2T7fw18G0cU799E+TMMczEIjU79f+8jQD/UcfSgUsZT0h6
7dVpliYNzOl4Uou0Y4Kln5It6iq5aAc=
=74oH
-----END PGP SIGNATURE-----

--zhpexfjxcruxolbk--


--===============7491196064534468651==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============7491196064534468651==--
