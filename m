From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v4 2/4] namei: O_BENEATH-style path resolution flags
Date: Sat, 24 Nov 2018 03:58:43 +1100
Message-ID: <20181123165843.xtkh3jpfz7k6xa5b@mikami>
References: <20181112142654.341-1-cyphar@cyphar.com>
 <20181112142654.341-3-cyphar@cyphar.com>
 <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7r4daumaby7eak7j"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ce83cdf6e3168350b69f98f08aaa202bbaa682d.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SsO8cmc=?= Billeter <j@bitron.ch>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--7r4daumaby7eak7j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-11-23, J=FCrg Billeter <j@bitron.ch> wrote:
> On Tue, 2018-11-13 at 01:26 +1100, Aleksa Sarai wrote:
> > * O_BENEATH: Disallow "escapes" from the starting point of the
> >   filesystem tree during resolution (you must stay "beneath" the
> >   starting point at all times). Currently this is done by disallowing
> >   ".." and absolute paths (either in the given path or found during
> >   symlink resolution) entirely, as well as all "magic link" jumping.
>=20
> With open_tree(2) and OPEN_TREE_CLONE, will O_BENEATH still be
> necessary? As I understand it, O_BENEATH could be replaced by a much
> simpler flag that only disallows absolute paths (incl. absolute
> symlinks). And it would have the benefit that you can actually pass the
> tree/directory fd to another process and escaping would not be possible
> even if that other process doesn't use O_BENEATH (after calling
> mount_setattr(2) to make sure it's locked down).
>=20
> This approach would also make it easy to restrict writes via a cloned
> tree/directory fd by marking it read-only via mount_setattr(2) (and
> locking down the read-only flag). This would again be especially useful
> when passing tree/directory fds across processes, or for voluntary
> self-lockdown within a process for robustness against security bugs.
>=20
> This wouldn't affect any of the other flags in this patch. And for full
> equivalence to O_BENEATH you'd have to use O_NOMAGICLINKS in addition
> to O_NOABSOLUTE, or whatever that new flag would be called.
>=20
> Or is OPEN_TREE_CLONE too expensive for this use case? Or is there
> anything else I'm missing?

OPEN_TREE_CLONE currently requires CAP_SYS_ADMIN in mnt_ns->user_ns,
which requires a fork and unshare -- or at least a vfork and some other
magic -- at which point we're back to just doing a pivot_root(2) for
most operations.

I think open_tree(2) -- which I really should sit down and play around
with -- would be an interesting way of doing O_BENEATH, but I think
you'd still need to have the same race protections we have in the
current O_BENEATH proposal to handle "..".

So really you'd be using open_tree(OPEN_TREE_CLONE) just so that you can
use the "path.mnt" setting code, which I'm not sure is the best way of
doing it (plus the other interesting ideas which you get with the other
mount API changes).

But I am quite hopeful for what cool things we'll be able to make using
the new mount API.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--7r4daumaby7eak7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlv4McMACgkQnhiqJn3b
jbShVA//eL066b61N+4EViLKYRHvgNZYsP88NJzUgT8MksvPPJ3iuOtM6TTI2B2E
LY/fVfxNOTuRrw7Vx4I0YfNKUU3dyoDhtxL46GUEJ2h0btgiKmXWMCV8VgdPHIRR
/XLkkiJddJBtZJ6KJogz8PfOY9cewtL2Ir/byZbgYlTBDTLzcCsY/iFi8fuenDRK
l7mNsKKQge8rsMnOQoZSNV/Ln+7dNwuuuo5wqfaI6vLIud87gbWiwR50DLG465EZ
3Hz4/4/PzqW00VsG62w0wlWJrugyOfxegwW1HeH7UuaH3NWn5TPnGVA89vtIuO11
LaX03GVW4MIi+FXdWbYB8W6+9K8m/2/VvA4ArYGBTVNSKoA0ONUclMZdNv+fbElW
lcOKpORXfeocIq3WUOgtWnWmBfNLV5hCA7qImd1/nPurpA7OMJ8SL153GQAZpukF
6Q6Gr5Wc/F5uz/m+348+60REslSxTt971m8PRjC1Q0wtUcNKEpVrsv90EW1tHBnq
k3J0uQ1Vwm6fVl2SWpQkz1MDO2NMk2LDITxJguTIi9oMDjrQpCUMEjEeRtxvdNPm
5PI2j7jOJ9G5Q9E0SWO823JWsEVSVv1TRB403CNOxoum7PKXHHYYO7AYvR7gfFs0
H3wWSdKxDavXxm0k+uUuJvWj2UXmFIXLxxcPua97TKZytcq8Tgk=
=ETTZ
-----END PGP SIGNATURE-----

--7r4daumaby7eak7j--
