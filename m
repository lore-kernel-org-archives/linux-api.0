From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Tue, 4 Dec 2018 17:03:54 +1100
Message-ID: <20181204060354.bozjmjn24sw3axav@yavin>
References: <20181120105124.14733-1-christian@brauner.io>
 <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
 <20181202100304.labt63mzrlr5utdl@brauner.io>
 <8736rebl9s.fsf@oldenburg.str.redhat.com>
 <20181203180224.fkvw4kajtbvru2ku@brauner.io>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n32bdtqrrttj3wgr"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181203180224.fkvw4kajtbvru2ku@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Florian Weimer <fweimer@redhat.com>, ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org


--n32bdtqrrttj3wgr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-12-03, Christian Brauner <christian@brauner.io> wrote:
> > > As I pointed out in another mail my I is to make this work by using
> > > file descriptors for /proc/<pid>/task/<tid>.  I don't want this in the
> > > initial patchset though.  I prefer to slowly add those features once
> > > we have gotten the basic functionality in.
> >=20
> > Do you want to land all this in one kernel release?  I wonder how
> > applications are supposed to discover kernel support if functionality is
> > split across several kernel releases.  If you get EINVAL or EBADF, it
> > may not be obvious what is going on.
>=20
> Sigh, I get that but I really don't want to have to land this in one big
> chunk. I want this syscall to go in in a as soon as we can to fulfill
> the most basic need: having a way that guarantees us that we signal the
> process that we intended to signal.
>=20
> The thread case is easy to implement on top of it. But I suspect we will
> quibble about the exact semantics for a long time. Even now we have been
> on multiple - justified - detrous. That's all pefectly fine and
> expected. But if we have the basic functionality in we have time to do
> all of that. We might even land it in the same kernel release still. I
> really don't want to come of as tea-party-kernel-conservative here but I
> have time-and-time again seen that making something fancy and cover ever
> interesting feature in one patchset takes a very very long time.
>=20
> If you care about userspace being able to detect that case I can return
> EOPNOTSUPP when a tid descriptor is passed.

Personally, I'm +1 on -EOPNOTSUPP so we can get an MVP merged, and add
new features in later patches.

> > What happens if you use the new interface with an O_PATH descriptor?
>=20
> You get EINVAL. When an O_PATH file descriptor is created the kernel
> will set file->f_op =3D &empty_fops at which point the check I added=20
>         if (!proc_is_tgid_procfd(f.file))
>                 goto err;
> will fail. Imho this is correct behavior since technically signaling a
> struct pid is the equivalent of writing to a file and hence doesn't
> purely operate on the file descriptor level.

Not to mention that O_PATH file descriptors are a whole kettle of fish
when it comes to permission checking semantics.


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--n32bdtqrrttj3wgr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlwGGMoACgkQSnvnv3De
m5+lDBAAxrkdEEDjq6ASZyzYu++elzkZwOs9q49a1PFaNr0i4W08Kz2ZEPOvXMiP
xz+s4dL78GZo4sSL1e6rs35+3N0dZHFUlfASXeDU8XlKdoM1MQ55/DFHMJ1WcwBH
C3xPOGW4zOBCF1hEp7mayrmc6qIcPGj5jCvamoYAC1P/1RdJ4qbqLJ6FiYynYaJr
McAWlFBjCI60Bzhxkg8cuOOkpF4PE922kCWsdqKEkwLuVztrHwXu/80NYPzuRVXI
g0QxtSz1Gu+6ZMOmdyxluy3RvricEMt4dNsIo8PuLALrGkeoklivfWJKWFT9n00Y
2uI3qYkQdLgfy5OQZ4ceY5PkeI1DX6BXTV2TkIN4Zh+gDmAGhOjO+wzwhIgeNqrq
MX+Luujx6iyKDnNrDJuFJJ12u5sQN4pW9+ilYAXcMos6hyejeG/xtIS+t7wwEcny
PMQQaLuEr8Kz+/z9FBdYr3HZAMe29Z4mB1UOag5/6Iv1NYprukY2OJOot6x3mq4w
YWtt2o2W/QOithsPfCxRZ5HpxiyZXATUe5ZVIWqxSFk+VCOIn9eIzlQ4KVzFZpjx
ngh7OqsfEWaHRquUMLNEEdrNeBs29ewdj8GbWb8yTrXJzmEz9JBVQtVJy8+sd4Bd
X8D7nD9eUq+XxZwLWXgPwIKLJbeo6WUme80euvu3PSWwUqCrlOg=
=mApV
-----END PGP SIGNATURE-----

--n32bdtqrrttj3wgr--
