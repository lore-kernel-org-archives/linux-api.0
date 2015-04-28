From: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v3 1/4] fs: configfs: Add unlocked version of
 configfs_depend_item()
Date: Tue, 28 Apr 2015 11:52:49 -0500
Message-ID: <20150428165249.GJ18263@saruman.tx.rr.com>
References: <1428596290-23637-1-git-send-email-k.opasiak@samsung.com>
 <1428596290-23637-2-git-send-email-k.opasiak@samsung.com>
Reply-To: <balbi-l0cyMroinI0@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2feizKym29CxAecD"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1428596290-23637-2-git-send-email-k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--2feizKym29CxAecD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 09, 2015 at 06:18:07PM +0200, Krzysztof Opasiak wrote:
> Sometimes it might be desirable to prohibit removing a directory
> in configfs. One example is USB gadget (mass_storage function):
> when gadget is already bound, if lun directory is removed,
> the gadget must be thrown away, too. A better solution would be
> to fail with e.g. -EBUSY.
>=20
> Currently configfs has configfs_depend/undepend_item() methods
> but they cannot be used in configfs callbacks. This commit
> adds unlocked version of this methods which can be used
> only in configfs callbacks.
>=20
> Signed-off-by: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Joel, any comments to this patch ?

> ---
>  fs/configfs/dir.c        |   29 +++++++++++++++++++++++++++++
>  include/linux/configfs.h |    9 +++++++++
>  2 files changed, 38 insertions(+)
>=20
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index cf0db00..7875a5e 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -1152,6 +1152,35 @@ void configfs_undepend_item(struct configfs_subsys=
tem *subsys,
>  }
>  EXPORT_SYMBOL(configfs_undepend_item);
> =20
> +int configfs_depend_item_unlocked(struct config_item *target)
> +{
> +	struct configfs_dirent *sd;
> +	int ret =3D -ENOENT;
> +
> +	spin_lock(&configfs_dirent_lock);
> +	BUG_ON(!target->ci_dentry);
> +
> +	sd =3D target->ci_dentry->d_fsdata;
> +	if ((sd->s_type & CONFIGFS_DIR) &&
> +	    ((sd->s_type & CONFIGFS_USET_DROPPING) ||
> +	     (sd->s_type & CONFIGFS_USET_CREATING)))
> +		goto out_unlock_dirent_lock;
> +
> +	sd->s_dependent_count +=3D 1;
> +	ret =3D 0;
> +
> +out_unlock_dirent_lock:
> +	spin_unlock(&configfs_dirent_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(configfs_depend_item_unlocked);
> +
> +void configfs_undepend_item_unlocked(struct config_item *target)
> +{
> +	configfs_undepend_item(NULL, target);
> +}
> +EXPORT_SYMBOL(configfs_undepend_item_unlocked);
> +
>  static int configfs_mkdir(struct inode *dir, struct dentry *dentry, umod=
e_t mode)
>  {
>  	int ret =3D 0;
> diff --git a/include/linux/configfs.h b/include/linux/configfs.h
> index 34025df..e9dbf01 100644
> --- a/include/linux/configfs.h
> +++ b/include/linux/configfs.h
> @@ -257,4 +257,13 @@ void configfs_unregister_subsystem(struct configfs_s=
ubsystem *subsys);
>  int configfs_depend_item(struct configfs_subsystem *subsys, struct confi=
g_item *target);
>  void configfs_undepend_item(struct configfs_subsystem *subsys, struct co=
nfig_item *target);
> =20
> +/*
> + * These functions can sleep and can alloc with GFP_KERNEL
> + * NOTE: These should be called only underneath configfs callbacks.
> + * WARNING: These cannot be called on newly created item
> + *        (in make_group()/make_item callback)
> + */
> +int configfs_depend_item_unlocked(struct config_item *target);
> +void configfs_undepend_item_unlocked(struct config_item *target);
> +
>  #endif /* _CONFIGFS_H_ */
> --=20
> 1.7.9.5
>=20

--=20
balbi

--2feizKym29CxAecD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVP7rhAAoJEIaOsuA1yqRELFEQAJuv7Vzv96VH0/U7om0Vgi8M
k+7F1KZ0STy+MBXDRaP+b9fjvJ6fdjhmgGhZ98BAWuf5+WeEJCnxyxSyvXpwDWqL
NHSNltBZHGKkWLbsKIOX8JNr6vPQ0zsGX+I9mmPvBo8UJWt7nwbyJQp4wpzAsiFC
aHMXvhz5WxTyMsLyQ9P+7LBW5Iyeyc4MFf3Hv1F6V9VkIkFv5MtOhIedx75e2t0H
1556Ao4YFWUOeOPXlgxZinFPjLLUPrdA8ifU2eslupaNZoYNG0FFW31g66MNh7Be
zZRUlwD7ouj3nxyPAS9BH1SsTikGQwOKuKoJ7SxkMCo7nVA3CRPsA5uogDypDoWK
TFAs4X6FPmnKq9tV6m7jrVcx3+SGTCi7K2GVghOl54KLoZ0y52eyLxyluWO0k0bJ
1mXS+h6nap6GjfrPEMHTzLEyBIZdnt6iRkcXEWoTIrFYsC7DhTRklIFkjkP1Cw/j
V1VRNzTUMahx8V4fQxd3XBHLlv6eqbiuM9NpQJkaJ89QIlLISpgbxnDMMUnI1hAp
+/Qd755LNkmtr/9Lpcy7zQJMsRHUOtSaHNtFR/SxQt8qX5W84lTm0lM64Q/Nc5fh
ZYKVl0KaMGsiVGS2Kab9eEPKrwQZLCjZKKXlOv48Dd1vzhtTMnwLaC04axIH6JWd
nC44dZligk2YACq481lS
=sMnv
-----END PGP SIGNATURE-----

--2feizKym29CxAecD--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
