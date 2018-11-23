From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v4 2/4] namei: O_BENEATH-style path resolution flags
Date: Sat, 24 Nov 2018 03:48:19 +1100
Message-ID: <20181123164819.skruu23wjwzf47f5@mikami>
References: <20181112142654.341-1-cyphar@cyphar.com>
 <20181112142654.341-3-cyphar@cyphar.com>
 <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
 <CALCETrURCXjNMBR6DjujVc6HHHS=CbET81kHS+odur+Bm-z7Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bd7wx4sujq35ecq2"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrURCXjNMBR6DjujVc6HHHS=CbET81kHS+odur+Bm-z7Tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: j@bitron.ch, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--bd7wx4sujq35ecq2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-23, Andy Lutomirski <luto@kernel.org> wrote:
> > On Nov 23, 2018, at 5:10 AM, J=C3=BCrg Billeter <j@bitron.ch> wrote:
> >
> > Hi Aleksa,
> >
> >> On Tue, 2018-11-13 at 01:26 +1100, Aleksa Sarai wrote:
> >> * O_BENEATH: Disallow "escapes" from the starting point of the
> >>  filesystem tree during resolution (you must stay "beneath" the
> >>  starting point at all times). Currently this is done by disallowing
> >>  ".." and absolute paths (either in the given path or found during
> >>  symlink resolution) entirely, as well as all "magic link" jumping.
> >
> > With open_tree(2) and OPEN_TREE_CLONE, will O_BENEATH still be
> > necessary?
>=20
> This discussion reminds me of something I=E2=80=99m uncomfortable with in=
 the
> current patches: currently, most of the O_ flags determine some
> property of the returned opened file.  The new O_ flags you're adding
> don't -- instead, they affect the lookup of the file.  So O_BENEATH
> doesn't return a descriptor that can only be used to loop up files
> beneath it -- it just controls whether open(2) succeeds or fails.  It
> might be nice for the naming of the flags to reflect this.

I agree that there is something quite weird about having path resolution
flags in an *open* syscall. The main reason why it's linked to open is
because that's the only way to get O_PATH descriptors (which is what you
would use for most of the extended operations we need -- as well as
reading+writing to files which is what most users would do with this).

And I think O_PATH is another example of an open flag that is just odd
in how it changes the semantics of using open(2).

One of the ideas I pitched in an earlier mail was a hypothetical
resolveat(2) -- which would just be a new way of getting an O_PATH
descriptor. This way, we wouldn't be using up more O_* flag bits with
this feature and we'd be able to play with more radical semantic changes
in the future. I can outline these here if you like, but it's a bit of a
long discussion and I'd prefer not to derail things too much if
resolveat(2) is definitely out of the question.

> I also don't love that we have some magic AT_ flags that work with
> some syscalls and some magic O_ flags that work with others.

I also completely agree. I think that we should have a discussion about
the long-term plan of syscall flags because it's starting to get a
little bit crazy:

 * Every "get an fd" syscall has its own brand of O_CLOEXEC. Thankfully,
   many of them use the same value (except for memfd_create(2) and a few
   other examples).
 * AT_* was supposed to be generic across all *at(2) syscalls, but there
   are several cases where this isn't really true anymore.

   * renameat2(2) only supports RENAME_* flags.
   * openat(2) supports only O_* flags.
   * Most AT_* flags have O_* counterparts (or are even more of a mess
	 such as with {AT_SYMLINK_FOLLOW,AT_SYMLINK_NOFOLLOW,O_NOFOLLOW}).
   * statx(2) added AT_STATX_* flags, making AT_* no longer generic.

(Also I just want to mention something I noticed while writing this
patch -- openat(2) violates one of the kernel "golden rules" -- that you
reject unknown flags. openat(2) will silently ignore unknown flag bits.
I'm sure there's a really good reason for this, but it's another flag
oddity that I felt fit here.)

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--bd7wx4sujq35ecq2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlv4L08ACgkQnhiqJn3b
jbQNZw//cbVZ6mja1WexO3nT8oHZekLWz51OovZZ//xUM8t4WXfqf794yLdjBW/f
szkgqHpmoKEGtzJ1jrDkuNezflK8gy/2WETSTYv+hEump+c3z2RgZBbb7dmVz0pF
MsPgBIAhLtFtnTyMTT57NMgQxCURCG9NAb3vWzcujuci0QX6kzKpMmhNoTe9q8G9
MuNVv7x/NJCaoUOnLsi1QoEc7RWYQIUfVGHUX6Sw5km8NzLlOOdmYDUC8rJdEIJs
RBdBQWq+XR/wVFuzBzLfbMLFRsQPlDDOrWvxap7t9CwjKmc1Qm1Q0R/L28kwnNeq
mPxpFCBnXQ0eWlNTUMIK+gETGlqOxs91lC1rv2FdiwEAyT1SLCBLoIE0X+d1UR4x
sewI7Rs/WTlFSdPWE8QRltgIK8E0TVrfJxn/vBD/GyAX+edl9JH8Cdx8RV+MKS5x
yI1d+7YNsYto2heIZ2KrAfWxWluVutiMJ1VjW477vN4T9cVE6jDIbl9dOKFoMDCQ
MKY3J5CYj9COfhtTbwuIR6jOWeflBTy/VIvGLcPZjNbBLCe/38CfeCBvWObtmmcD
Jpe4Nkkc5ttQXiZu37A8ZpehnoHBC45YMsRLvavPowTt82P0P8Y5RsIJfaqu0KFw
xPjs0g6JHiMdUExryNZDsLEIoAeCDCE0aOi+OaHnjYaxTIUyxEk=
=aoUZ
-----END PGP SIGNATURE-----

--bd7wx4sujq35ecq2--
