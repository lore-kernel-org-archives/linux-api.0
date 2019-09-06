From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Sat, 7 Sep 2019 08:18:00 +1000
Message-ID: <20190906221800.xzowcjgdeljikcyu@yavin.dot.cyphar.com>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com>
 <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
 <20190906220546.gkqxzm4y3ynevvtz@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="punotohnhmzxr25f"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190906220546.gkqxzm4y3ynevvtz@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Florian Weimer <fweimer@redhat.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe
List-Id: linux-api@vger.kernel.org


--punotohnhmzxr25f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-07, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-09-06, Jeff Layton <jlayton@kernel.org> wrote:
> > On Sat, 2019-09-07 at 03:13 +1000, Aleksa Sarai wrote:
> > > On 2019-09-06, Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Fri, 2019-09-06 at 18:06 +0200, Micka=EBl Sala=FCn wrote:
> > > > > On 06/09/2019 17:56, Florian Weimer wrote:
> > > > > > Let's assume I want to add support for this to the glibc dynami=
c loader,
> > > > > > while still being able to run on older kernels.
> > > > > >=20
> > > > > > Is it safe to try the open call first, with O_MAYEXEC, and if t=
hat fails
> > > > > > with EINVAL, try again without O_MAYEXEC?
> > > > >=20
> > > > > The kernel ignore unknown open(2) flags, so yes, it is safe even =
for
> > > > > older kernel to use O_MAYEXEC.
> > > > >=20
> > > >=20
> > > > Well...maybe. What about existing programs that are sending down bo=
gus
> > > > open flags? Once you turn this on, they may break...or provide a wa=
y to
> > > > circumvent the protections this gives.
> > >=20
> > > It should be noted that this has been a valid concern for every new O=
_*
> > > flag introduced (and yet we still introduced new flags, despite the
> > > concern) -- though to be fair, O_TMPFILE actually does have a
> > > work-around with the O_DIRECTORY mask setup.
> > >=20
> > > The openat2() set adds O_EMPTYPATH -- though in fairness it's also
> > > backwards compatible because empty path strings have always given ENO=
ENT
> > > (or EINVAL?) while O_EMPTYPATH is a no-op non-empty strings.
> > >=20
> > > > Maybe this should be a new flag that is only usable in the new open=
at2()
> > > > syscall that's still under discussion? That syscall will enforce th=
at
> > > > all flags are recognized. You presumably wouldn't need the sysctl i=
f you
> > > > went that route too.
> > >=20
> > > I'm also interested in whether we could add an UPGRADE_NOEXEC flag to
> > > how->upgrade_mask for the openat2(2) patchset (I reserved a flag bit =
for
> > > it, since I'd heard about this work through the grape-vine).
> > >=20
> >=20
> > I rather like the idea of having openat2 fds be non-executable by
> > default, and having userland request it specifically via O_MAYEXEC (or
> > some similar openat2 flag) if it's needed. Then you could add an
> > UPGRADE_EXEC flag instead?
> >=20
> > That seems like something reasonable to do with a brand new API, and
> > might be very helpful for preventing certain classes of attacks.
>=20
> In that case, maybe openat2(2) should default to not allowing any
> upgrades by default? The reason I pitched UPGRADE_NOEXEC is because
> UPGRADE_NO{READ,WRITE} are the existing @how->upgrade_mask flags.

Sorry, another issue is that there isn't a current way to really
restrict fexecve() permissions (from my [limited] understanding,
__FMODE_EXEC isn't the right thing to use) -- so we can't blanket block
exec through openat2() O_PATH descriptors and add UPGRADE_EXEC later.

We would have to implement FMODE_EXEC (and FMODE_MAP_EXEC as you
suggested) in order to implement FMODE_UPGRADE_EXEC before we could even
get a first version of openat2(2) in. Though, I do (a little
begrudgingly) agree that we should have a safe default if possible
(magical O_PATH reopening trickery is something that most people don't
know about and probably wouldn't want to happen if they did).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--punotohnhmzxr25f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXXLbFQAKCRCdlLljIbnQ
Ep08APwP1U/HfIWYfQu5c32xbumkvXiBXlVt7ZbRhD2w2qfdiQEA4cduDnL5ROTb
EPmEhurBIVJ5eX/EZj59be1o07F3JgY=
=wxD8
-----END PGP SIGNATURE-----

--punotohnhmzxr25f--
