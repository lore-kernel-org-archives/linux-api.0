From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Wed, 20 Jan 2016 13:14:52 +0100
Message-ID: <20160120121452.GA32379@pc.thejh.net>
References: <20151130224356.GA27972@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151130224356.GA27972@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, lxc-devel@lists.linuxcontainers.org, Richard Weinberger <richard@nod.at>, LSM <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 30, 2015 at 04:43:56PM -0600, Serge E. Hallyn wrote:
> +int get_vfs_ns_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
> +{
[...]
> +	/* find an applicable entry */
> +	/* a global entry (uid == -1) takes precedence */
> +	current_root = make_kuid(current_user_ns(), 0);
> +	if (!uid_valid(current_root)) {
> +		/* no root user in this namespace;  no capabilities */
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	for (i = 0, cap = (void *) hdr + sizeof(*hdr); i < ncaps; cap += sizeof(*cap), i++) {
> +		uid_t uid = le32_to_cpu(cap->rootid);
> +		if (uid == -1) {
> +			nscap = cap;
> +			break;
> +		}
> +
> +		caprootuid = make_kuid(&init_user_ns, uid);
> +		if (uid_eq(caprootuid, current_root))
> +			nscap = cap;
> +	}

Wouldn't it be more consistent to check against the root uids of all parent
namespaces until one matches?

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWn3o8AAoJED4KNFJOeCOo4KQQANctx02GIqZ1RgvgbP3suVMw
kbVIcfBDc7e+WIPspg8sZlrbKSOlt8rtnqbnw9znZdKpE+hxqpvNqNW/FXX8GwY7
tAIO+WeUQCl/vWnUSfjDY7ChZNuzzQ+Gz/q923xJ6oQ6p3XF9sZbsGHkGHyJtFOx
oe3+uyqU4IrDI9eqnBBcOwYf6PQsWV8zjGGrwCxWI1ftT81tzRfBhLX0Tgpu0kYQ
lTgEQUHfzlRlJN/H/rrbkELiuWOHja1HaGO10h6h2hvDSXN76lSSWNB2UKmksHWd
UfYmkLts4fMWUo/ONKzR3nKuKMfvkVZRq6yjp639iDCVeuc5QIApUAgwerIts329
NAB9hAA0/5yz6h30MHnQhfD7F+kDprk3LSv9NHlNKOaHtUCucMfawOWkFl7xHDTT
IDjqzouxH6OrnBMXfpfwsBwE/FJxRTxliCht5vuKLk7BBTf4Tn2bPmEz8tJ6QWYV
uXMeGSXPL7tCrRxdv1kRdb3aNjSWvQplqnaD8GfrWIG0hCmK7c3njJaPUqlmnBUa
AD+7RksInzFhISqqEy5KHrW7Ugg4baa/h2odl6XjRbCyP1bV0Vkggd+dtDNTPEMJ
um3LOQwfiPyqGDfsaUrC+egHsvNELf+5NJ+/OHJPBJbBoY7Tg9jFMWFBXN1NMETY
AJ5rQJ7XHAudBMw5hEsB
=LAxO
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
