From: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 1/5] fs: configfs: Fix typo in comment
Date: Thu, 9 Apr 2015 08:46:37 -0500
Message-ID: <20150409134637.GB4393@saruman.tx.rr.com>
References: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
 <1428492528-11993-2-git-send-email-k.opasiak@samsung.com>
Reply-To: <balbi-l0cyMroinI0@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1428492528-11993-2-git-send-email-k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 08, 2015 at 01:28:44PM +0200, Krzysztof Opasiak wrote:
> Signed-off-by: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/configfs/dir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index cf0db00..dee1cb5 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -325,7 +325,7 @@ static void configfs_dir_set_ready(struct configfs_di=
rent *sd)
>   * attached and not validated yet.
>   * @sd		configfs_dirent of the directory to check
>   *
> - * @return	non-zero iff the directory was validated
> + * @return	non-zero if the directory was validated

iff is not a typo, it's short-hand for "if, and only if"

>   *
>   * Note: takes configfs_dirent_lock, so the result may change from false=
 to true
>   * in two consecutive calls, but never from true to false.
> --=20
> 1.7.9.5
>=20

--=20
balbi

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVJoK8AAoJEIaOsuA1yqREyEoP/1g1pIQLlxWVJvu2rBjNZh5G
m5hTV2hRhlmgeDPB3ouTJVg5f0pD1DuzS9Y5qFCfq9qzdSF6nPkUd4gREDOcXYkz
/nXgRDeQ1bmKunxEUC9ZjZ0klZ5ywMb4mYQeHxhOXedu4KqdFqrhgqVUnzhaqoo3
r6zDSpIWP8U0cMNfkAJlF6p2U3HLMij7qIpAYoehTnIlVJ7TFRBQ7q+z3uZziF/3
IGzhHdvLYYG8mL/xeWrHO+ykP9TIjHhGp4va+NEI3X8PLfnA02TvnHVI2TuiQfTY
BcrlBPM6FolEcfUBGBgQXKmmMSevf7uKcP9BpIcvYFTbIge3sf0kOvZZ36vS189K
3E+kiEJ6sHcOMZpF+XWDWxGq/sY5E/Rxf50zeY7Ao20mr3P3TKwbArzJKlExsonB
AUdJ0ILrVSnW5g466iiYOzoNDa6zoaaf/3bj3F6hBas4HkUT7urnj2lSn7jmQBFV
5FBRkfRd97NEmrv2tcS+hXZaCNMdL/iIuILS4qaSkqpSDQLtIbLoKb7/BH8MQ1dJ
/F51AoZrfsP8rQqZVo5lVWks9XgE9haA4V0AbXmVPb8P2lZbRJYn/XeuvocXJI1G
1DSGUDpBqdXMmMOYA+9kHZeRz1r2iYiUiTXkpspa2sGj+Tk8ztTfP9PGOz/19Uv3
N6NJAHGsOYM+yYvn/i6G
=sFul
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
