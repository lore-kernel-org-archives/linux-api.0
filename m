From: "W. Trevor King" <wking@tremily.us>
Subject: Re: [PATCH v3 2/2] nsfs: Add an ioctl() to return owner UID of a
 userns
Date: Mon, 16 Jan 2017 17:19:48 -0800
Message-ID: <20170117011948.GC10810@odin.tremily.us>
References: <69550fe9-5347-309c-b421-79c16a6300f6@gmail.com>
 <daac6f7d-bc1e-bd61-355b-e47cf93e2535@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jcjv6D8puUawUjle"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <daac6f7d-bc1e-bd61-355b-e47cf93e2535@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org


--jcjv6D8puUawUjle
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 17, 2017 at 02:03:29PM +1300, Michael Kerrisk (man-pages) wrote:
> +	case NS_GET_OWNER_UID:
> +		if (ns->ops->type !=3D CLONE_NEWUSER)
> +			return -EINVAL;
> +		user_ns =3D container_of(ns, struct user_namespace, ns);
> +		argp =3D (unsigned int __user *) arg;
> +		uid =3D from_kuid_munged(current_user_ns(), user_ns->owner);
> +		return put_user(uid, argp);
> =E2=80=A6
> +/* Get owner UID for a user namespace */
> +#define NS_GET_OWNER_UID	_IO(NSIO, 0x4)

The comment here should probably be:

  Get owner UID (in the current user namespace) for a user namespace

or some such, to convey that current_user_ns is being passed to
=66rom_kuid_munged.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--jcjv6D8puUawUjle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJYfXEyAAoJEBBpoQVgXJg1L+sP/iVljlRTFV/sp1CmBveLp5P7
g+yTelTZso63XXbn3xt7383GsGxejzdF5iKUPfsPpOoX977Z6FFns7CqRksOUI1g
iiTLe9P/pL5kf2d7IOhIOqLsuc1WGD0SU4kPWdKJBxGASX6/9CwoXL2j3kjw6WRv
ZSzkd6+8kVKQZ7lCUXH0i/n7C5vWYti8b3zg9yEgiawCpdBo8Flh43jsSoOGEX3j
q6Epz1P/JyLgg0hS2oxmEt95A8RoMsDVyhS4IkdMiK7k2DvyFhnePD+8eegdSmrz
KtVPyAJYDkkygmXPMfvZvVvBU7yl/sfnfGJd5+sInvF37KRpqa3KqdNrzzsV8f2D
3KMyw7iv2f9SQpJF0f/BEKJd/iIBOO088WmufsyCZlauBjrQ7nRBRoDeCTQNtPN+
ca7hbOacuQcESbp7UmuBTUX/zHEAN7wEyNXtMJ1aiZybgT2jDzOcunJKywdt9JtW
SD5m6lKGJXOLdAOCTB9/3DsRBULlZL/St2frHuYT7zy4Un6duvi5PeHrPY71hxMS
MvQokeyCp/7b9MTHC1Mcm9/bfYFYdgdMg5NeS1zYTPXkw/7Wu1epcm9bBqQghaHs
Vqhgk3NGA7BRKiIMqeLokzuzZIZyjiT8PXE8p1qwFw35Z0oCmhrltmqQDdtNGRdh
//3GC2hzmU48Dxr9zP7x
=xgIy
-----END PGP SIGNATURE-----

--jcjv6D8puUawUjle--
