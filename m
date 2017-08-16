From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v2] KEYS: make keyctl_invalidate() also require Setattr
 permission
Date: Wed, 16 Aug 2017 17:01:55 -0500
Message-ID: <3908fb9c-a616-0f07-00df-47e2f763b869@canonical.com>
References: <20170816211403.121920-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="5ID6dThotqoJKhTb0uE6JW6t52lVtV0c7"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816211403.121920-1-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul Crowley <paulcrowley-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Ryo Hashimoto <hashimoto-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5ID6dThotqoJKhTb0uE6JW6t52lVtV0c7
Content-Type: multipart/mixed; boundary="ueLk7Ho1xFX7QG7A3dJt00abaowov4cc0";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul Crowley <paulcrowley-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Ryo Hashimoto <hashimoto-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <3908fb9c-a616-0f07-00df-47e2f763b869-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v2] KEYS: make keyctl_invalidate() also require Setattr
 permission
References: <20170816211403.121920-1-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20170816211403.121920-1-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--ueLk7Ho1xFX7QG7A3dJt00abaowov4cc0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/16/2017 04:14 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>=20
> Currently, a process only needs Search permission on a key to invalidat=
e
> it with keyctl_invalidate(), which has an effect similar to unlinking i=
t
> from all keyrings.  Unfortunately, this significantly compromises the
> keys permission system because as a result, there is no way to grant
> read-only access to keys without also granting de-facto "delete" access=
=2E
> Even worse, processes may invalidate entire _keyrings_, given only
> permission to "search" them.  It is not even possible to block this
> using SELinux, because SELinux is likewise only asked for Search
> permission, which needs to be allowed for read-only access.
>=20
> Key invalidation seems to have intended for cases where keyrings are
> used as caches, and keys can be re-requested at any time by an upcall t=
o
> /sbin/request-key.  However, keyrings are not always used in this way.
> For example, users of filesystem-level encryption (EXT4, F2FS, and/or
> UBIFS encryption) usually wish to grant many differently-privileged
> processes access to the same keys, set up in a shared keyring ahead of
> time.  Permitting everyone to invalidate keys in this scenario enables =
a
> trivial denial-of-service.  And even users of keyrings as "just caches"=

> may wish to restrict invalidation because it may require significant
> work or user interaction to regenerate keys.
>=20
> This patch fixes the flaw by requiring both Search and Setattr
> permission to invalidate a key rather than just Search permission.
> Requiring Setattr permission is appropriate because Setattr permission
> also allows revoking (via keyctl_revoke()) or expiring (via
> keyctl_set_timeout()) the key, which also make the key inaccessible
> regardless of how many keyrings it is in.  Continuing to require Search=

> permission ensures we do not decrease the level of permissions required=
=2E
>=20
> Alternatively, the problem could be solved by requiring Write
> permission.  However, that would be less appropriate because Write
> permission is ostensibly meant to deal with the key payload, not the ke=
y
> itself.  A new "Invalidate" permission would also work, but that would
> require keyctl_setperm() users to start including a new permission whic=
h
> never existed before, which would be much more likely to break users of=

> keyctl_invalidate().  Finally, we could only allow invalidating keys
> which the kernel has explicitly marked as invalidatible, e.g. the
> "id_resolver" keys created for NFSv4 ID mapping.  However, that likewis=
e
> would be much more likely to break users.
>=20
> This is a user-visible API change.  But we don't seem to have much
> choice, and any breakage will be limited to users who override the
> default key permissions using keyctl_setperm() to remove Setattr
> permission, then later call keyctl_invalidate().  There are probably no=
t
> many such users, possibly even none at all.  In fact, the only users of=

> keyctl_invalidate() I could find are nfsidmap and the Chromium OS
> cryptohome daemon.  nfsidmap will be unaffected because it runs as root=

> and actually relies on the "root is permitted to invalidate certain
> special keys" exception (KEY_FLAG_ROOT_CAN_INVAL) rather than the actua=
l
> key permissions.  cryptohomed will be unaffected because it already own=
s
> the keys and sets KEY_USR_SETATTR permission on them.

It makes sense to me to require something more than SEARCH permission to
invalidate a key and SETATTR does seem to be a good fit. Since you
mentioned WRITE as another possibility, I'll point out this blurb from
the original KEYCTL_INVALIDATE commit message (fd75815):

  To invalidate a key the caller must be granted SEARCH permission by
  the key. This may be too strict. It may be better to also permit
  invalidation if the caller has any of READ, WRITE or SETATTR
  permission.

So, (SEARCH | SETATTR) || (SEARCH | WRITE) could also be a possibility
to reduce the chance of breaking existing code. READ doesn't seem
appropriate to me.

I searched for KEYCTL_INVALIDATE in https://codesearch.debian.net/ and
didn't see anything outside of nfsidmap in Debian, which you already
investigated. I can confirm that ecryptfs-utils definitely isn't
affected by this change.

Tyler

>=20
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Paul Crowley <paulcrowley-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> Cc: Ryo Hashimoto <hashimoto-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v3.5+
> Signed-off-by: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/security/keys/core.rst | 4 ++--
>  security/keys/keyctl.c               | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/security/keys/core.rst b/Documentation/secur=
ity/keys/core.rst
> index 1648fa80b3bf..c8030f628810 100644
> --- a/Documentation/security/keys/core.rst
> +++ b/Documentation/security/keys/core.rst
> @@ -815,8 +815,8 @@ The keyctl syscall functions are:
>       immediately, though they are still visible in /proc/keys until de=
leted
>       (they're marked with an 'i' flag).
> =20
> -     A process must have search permission on the key for this functio=
n to be
> -     successful.
> +     A process must have Search and Setattr permission on the key for =
this
> +     function to be successful.
> =20
>    *  Compute a Diffie-Hellman shared secret or public key::
> =20
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index ab0b337c84b4..0739e7934e74 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -400,7 +400,7 @@ long keyctl_revoke_key(key_serial_t id)
>  /*
>   * Invalidate a key.
>   *
> - * The key must be grant the caller Invalidate permission for this to =
work.
> + * The key must grant the caller Search and Setattr permission for thi=
s to work.
>   * The key and any links to the key will be automatically garbage coll=
ected
>   * immediately.
>   *
> @@ -416,7 +416,7 @@ long keyctl_invalidate_key(key_serial_t id)
> =20
>  	kenter("%d", id);
> =20
> -	key_ref =3D lookup_user_key(id, 0, KEY_NEED_SEARCH);
> +	key_ref =3D lookup_user_key(id, 0, KEY_NEED_SEARCH | KEY_NEED_SETATTR=
);
>  	if (IS_ERR(key_ref)) {
>  		ret =3D PTR_ERR(key_ref);
> =20
>=20



--ueLk7Ho1xFX7QG7A3dJt00abaowov4cc0--

--5ID6dThotqoJKhTb0uE6JW6t52lVtV0c7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZlMDTAAoJENaSAD2qAscK8+YQAJWrS0bXRsLlfXxifcRbci4a
Ro7oa3cnptzOdurD97R1Nn/Lg9ydPs92UjWSazK1YiYWk33eDso18WH+pcyz8xeC
M+lOBEbTNyztPYQZbSntmNOdY4QIFaW/RBvNiH+xKf3qFUwLz699Ao8M1B7DAzM4
C3QqBWw+YOl6p6hnGq4EGKk0c8T0KEeXHuVRWArwYJfrNaKxPxOqK6PIIbpob7HE
fsTjgYSXYhAslIEeLeykgH2GbBCUrQCE7ivlEtYAR+RwY5lAMgTLWWdnI7ZGfMzX
dZ++jSweiQBmyiWaMflIh45NEDli0E6uuULU1RrBoONm+nmKPgY1WNrQCH/FXbjF
veI1NQEiHg9dj5RBWxhBOwm0LoKMoDvHDUpET4Jic/KdUHWgPvu6kAIKp/LI0X2S
8OkY6A1Vbq/q4jBRjNGndPrFyfdoT3KftAuNmV1CAhMHVMcwTkWQR9MPOlgCuE+i
VFeFrr6PGAPzKiUMmrvS8E4YgmnL9fz3Lb0Sa5/IZ8QydojsRBkDLli1sKa7sRHh
LIXrP/PwpvG1Fv9Tm1zg8xUA/lpBQHFXVNG7jX6EtXe6EJTXLA0JDPiipsnhW5Dl
KWdFyHQIVCmr/GnywrP8B3jOwOdqKYeZKW/Vys36uESmr2GYiwBOELmmexIxu732
WTlBShcTiuWbh6VgANkB
=QUrM
-----END PGP SIGNATURE-----

--5ID6dThotqoJKhTb0uE6JW6t52lVtV0c7--
