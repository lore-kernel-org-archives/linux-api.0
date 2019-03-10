From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH RESEND v5 2/5] namei: O_BENEATH-style path resolution
 flags
Date: Sun, 10 Mar 2019 23:12:22 +1100
Message-ID: <20190310121222.p5x5gxi3t3sy7p23@yavin>
References: <20190306191244.8691-1-cyphar@cyphar.com>
 <20190306191244.8691-3-cyphar@cyphar.com>
 <CAHk-=wgGKWRTgSYKkgMEf1QOg0PZSpmBha+2LCHCBOar0e8cug@mail.gmail.com>
 <20190309172631.ygfdhrn4rcwkgfmk@brauner.io>
 <CAHk-=whMuk-b6rzhbF2=vVNOuEZk8-opRJ1fD07a9ztQ+V97Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qidgb2d5gkyjstpk"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whMuk-b6rzhbF2=vVNOuEZk8-opRJ1fD07a9ztQ+V97Aw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--qidgb2d5gkyjstpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-03-09, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Mar 9, 2019 at 9:26 AM Christian Brauner <christian@brauner.io> w=
rote:
> > Aside from that I want to point out that it is non-trivial to do this in
> > user space.
>=20
> Oh, absolutely agreed. It's easy to do it in the kernel, and doing it
> anywhere else ends up having horrible races that the kernel has to
> deal with and has long solved anyway.

We've seen in the past few years, there are also plenty of CVEs from the
container runtime side of things which show that some of these races are
also exploitable. Even with some of the most convoluted O_PATH "fd
re-opening" trickery, it's incredibly difficult to both scope symlinks
inside a container and safely detect cases where you've been tricked by
a malicious actor.

> I've only seen this (2/5) patch, so I won't comment on the other ones,
> but this still makes sense to me.

I'll make sure to add you to the series Cc if/when there's a v6.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--qidgb2d5gkyjstpk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlyE/yEACgkQSnvnv3De
m5/PhQ//VnslIB/uTSS+k6C/M/G8DH5OUhDYC0DJNwIEFBKgXKY9COO28DKVpoWO
iLYAqhbYXgTKqpjOi5bYJvX7kCuz4zHpMhMXgpWwbXg8dJ748D/qZTmdr/N8I75M
eQwqxh5Io/2/8EjXXyhDdkq4lSPDT+iPjbrmeaZlKLpqVwFufJb2pAkrJNjWkkgE
CKKYl6rqaXBy9QFcVrSbCqCsnE+HdNfhRxfO/VfcyjAfEDHQxMKzO/+X2JBBh34B
+vxBHyZ5vlwNCUXEg4qfkeeRN8EZYcvh+aq95cwxlWbNw8FKVyAIb+tCF9VD25+z
ta4FfwnCd2mOumQErw57dkqAiwAIeWnVIFqzazGfkFAWEXWBVzq6/4KfKmK3U6Lq
zWxI2JnnR8XViL18EhKg2l2hQfeU0Ba1WUu46AMJM2VLBSivG65ADNktM2Vl8PZM
WqinqScExdUxa47uzrfbiUZBBzzekm77Th/a773RoaG6ap/sL0lrwSVnQS+nU5HE
TnDrnWu/hdqaJSgMYpMaftKE04q9MEyr8VAnKaHc44mnLCZziwAEGcRArngRi5PZ
1rZ6OcmQf5DkluGyJfg/gzZ47XOpu91JNAXKQFihVERUzSFocncylDvlPMw5LdEZ
qIOEX+6dPXo+g9SODVO1T4XI8qBZ9VPKEyMbORarpgIKMRGaQbQ=
=4U9I
-----END PGP SIGNATURE-----

--qidgb2d5gkyjstpk--
