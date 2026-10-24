Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792848203;
	b=DxGskP0Pt+c16JpqK1scvOeaC0KkS2OgkNFIGFr5ZR06XhClhfgYtSAPmDv8wllav33B
	 5xTN51xqjRsF3aP6H+sc6KeF6u6eUJCxwKF3C3mnYz+p8ZjvurHiuw1qvb0yd5hWvC8Ud
	 W/+sXwNw9ZhECrNwaqpPF2qMCA0cjQgCr8hH7w423NGtDuo/e+2P0yu/NrKaFAjS6/H03
	 YRbfPRSIoKhnyGg1zvQ+DS5bxqIrqoaElphgIb2GgdDKoKep+NZt1JfRoUZqRaB/ahjoZ
	 py4Kc61HjYzeVy9nXEX9AN2JRwnGlNHMNtwLN82QlcYOA6E8Zpi5Z3EuZaz9n5tE67w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792848203;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AenfdRm90WrSjoi864BFabnLzqWgO/qqA3F0PRLFjp0=;
	b=L3u/c/TVi4fnca8dkn+MkD1lnrw/b87sNi1CYaywsZxDRcpqibg7IRDtKb2214an2kw/
	 TEvwRI/GK1NP/dVBZEwsHhteNTmJ2gYIQCy690o0Qxo4Zu9RKZ9AmBIxH1iYvZe6L1n97
	 +aXY4xFZSVUU+RHmIZZwhhwfdU5vh5QEBsa0R0Fld0IWzo9Y+VV0h44mnMiNLfC9pHzUI
	 2bD2jENDK4xQoW+13VpeV0kZhiuH3xUhZTRI1hEKPgijQIa4B7r2+9vWGUKIAx5q+Edbh
	 69HmPndCLUIvWPW45atle9oBKcEGp+IWjRBBgHiGOy12nDt2TYQ7QAto1EEqA2oSxeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=napl7AQi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332E1606A31A;
	Sat, 24 Oct 2026 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=napl7AQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4EB1F01825;
	Sat, 24 Oct 2026 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792848202;
	bh=AenfdRm90WrSjoi864BFabnLzqWgO/qqA3F0PRLFjp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=napl7AQi2UiTBpTwoXjQ8MJt+9SLLnPFu7CuUVg7W/aRolDGozszZGUlIaGY+Cq/N
	 OM471O3WWvM9+LNDFoZVYSx2OjzdA0u+FiDe6SRoEIwe9QgI2HgFtNIw0KfL8rNN1C
	 32HI0xaj8v6w0CTprcI98iFZnFQKn2n+ja77zSSYDNUIBkUxaAMMZmyL7RNCmzuvYM
	 xXu8APRXiotFV/J3gUsH3y1ycY8zXwuC6YoPteRB/kTOqpq87i/lshG/WOt9KNJ7l2
	 2y5CPcgneTBH/sgUMaPQpWYCZHPWj3xP7tQ4BRrLucpNUdwqSrf25DUssebpwne0sm
	 AqfzKMgSYqN6Q==
Date: Sat, 24 Oct 2026 15:23:11 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ipc/sem: reject negative SEMOPM values
Message-ID: <atyvbQ5xxtxcxBZE@debian>
References: <cover.1792808260.git.x-professor@outlook.com>
 <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3ypnmqpyuzbufluf"
Content-Disposition: inline
In-Reply-To: <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>


--3ypnmqpyuzbufluf
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Vasily Averin <vasily.averin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, 
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ipc/sem: reject negative SEMOPM values
Message-ID: <atyvbQ5xxtxcxBZE@debian>
References: <cover.1792808260.git.x-professor@outlook.com>
 <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>
MIME-Version: 1.0
In-Reply-To: <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>

Hi Yingjie,

> Date: 2026-10-24 12:21:42+0000
> From: Yingjie Wang <x-professor@outlook.com>
>
> The SEMOPM field has been stored as an int while semop() receives an
> unsigned operation count since the beginning of Git history. A negative
> SEMOPM accepted by proc_dointvec() is converted to a large unsigned value
> in the comparison, defeating the intended operation-count limit.
>=20
> Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc
> namespace") made kernel.sem writable by IPC namespace owners without
> capabilities in the initial user namespace.
>=20
> Parse writes against a temporary copy and validate SEMOPM and SEMMNI
> before changing the live settings. Hold a per-namespace mutex from the
> snapshot through publication so concurrent sysctl writers cannot publish
> stale values for fields they did not supply. Access the live fields with
> READ_ONCE() and WRITE_ONCE(), preserving the per-field access semantics of
> proc_dointvec(). Read requests continue to use proc_dointvec() directly.
>=20
> Failed writes leave the live settings unchanged. Successful partial writes
> change only the supplied fields relative to the latest locked snapshot.
> The writer mutex retains the existing per-field visibility for readers.
>=20
> Keep zero and positive SEMOPM values valid. Zero continues to reject every
> non-empty semop() request.
>=20
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link: https://lore.kernel.org/r/20261016155905.2a659b7bb7d61f33467a3263@l=
inux-foundation.org
> Link: https://lore.kernel.org/r/51c93c19-f1dd-455f-8698-6b1ee30eb630@colo=
rfullife.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>
> Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  include/linux/ipc_namespace.h |  3 +++
>  ipc/ipc_sysctl.c              | 35 ++++++++++++++++++++++++++---------
>  ipc/sem.c                     |  1 +
>  ipc/util.h                    |  9 ---------
>  4 files changed, 30 insertions(+), 18 deletions(-)
>=20
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 12faca29bbb9c..c06568ccfca88 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -4,6 +4,7 @@
> =20
>  #include <linux/err.h>
>  #include <linux/idr.h>
> +#include <linux/mutex.h>
>  #include <linux/rwsem.h>
>  #include <linux/notifier.h>
>  #include <linux/nsproxy.h>
> @@ -31,6 +32,8 @@ struct ipc_ids {
>  struct ipc_namespace {
>  	struct ipc_ids	ids[3];
> =20
> +	/* Serialize kernel.sem writers. */
> +	struct mutex	sem_ctls_mutex;
>  	int		sem_ctls[4];
>  	int		used_sems;
> =20
> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
> index d038d944257f6..a05e28e67c305 100644
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
> @@ -51,21 +51,38 @@ static int proc_ipc_auto_msgmni(const struct ctl_tabl=
e *table, int write,
>  static int proc_ipc_sem_dointvec(const struct ctl_table *table, int writ=
e,
>  	void *buffer, size_t *lenp, loff_t *ppos)
>  {
> +	struct ctl_table ipc_table;
>  	struct ipc_namespace *ns =3D
>  		container_of(table->data, struct ipc_namespace, sem_ctls);
> -	int ret, semmni;
> +	int sem_ctls[ARRAY_SIZE(ns->sem_ctls)];
> +	size_t i;
> +	int ret;
> +
> +	if (!write)
> +		return proc_dointvec(table, write, buffer, lenp, ppos);
> =20
> -	semmni =3D ns->sem_ctls[3];
> -	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
> +	mutex_lock(&ns->sem_ctls_mutex);
> +	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)
> +		sem_ctls[i] =3D READ_ONCE(ns->sem_ctls[i]);
> =20
> -	if (!ret)
> -		ret =3D sem_check_semmni(ns);
> +	memcpy(&ipc_table, table, sizeof(ipc_table));

Why memcpy(3)?  Being a structure, we could use simple assignment, which
is type safe.

	ipc_table =3D *table;

memcpy(3) is way too powerful for this, and that can be dangerous.
A few ways where it is easy to screw a call to memcpy(3) are:

-  Size of destination doesn't match size of input.
-  Size argument doesn't match size of destination.
-  Type of input doesn't match type of destination.
-  You may forget to copy a flexible array member.

In some cases, you really want to defeat those, and then memcpy(3) is
useful (or you're copying an array, and then you have no choice), but if
not, memccpy(3) is not the best tool.

[CC +=3D linux-hardening]


Have a lovely day!
Alex

> +	ipc_table.data =3D sem_ctls;
> =20
> -	/*
> -	 * Reset the semmni value if an error happens.
> -	 */
> +	ret =3D proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
>  	if (ret)
> -		ns->sem_ctls[3] =3D semmni;
> +		goto out_unlock;
> +
> +	if (sem_ctls[2] < 0 ||
> +	    sem_ctls[3] < 0 || sem_ctls[3] > ipc_mni) {
> +		ret =3D -ERANGE;
> +		goto out_unlock;
> +	}
> +
> +	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)
> +		WRITE_ONCE(ns->sem_ctls[i], sem_ctls[i]);
> +
> +out_unlock:
> +	mutex_unlock(&ns->sem_ctls_mutex);
>  	return ret;
>  }
> =20
> diff --git a/ipc/sem.c b/ipc/sem.c
> index a8c9807175520..0f7d32c12993f 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -249,6 +249,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, =
void *it);
> =20
>  void sem_init_ns(struct ipc_namespace *ns)
>  {
> +	mutex_init(&ns->sem_ctls_mutex);
>  	ns->sc_semmsl =3D SEMMSL;
>  	ns->sc_semmns =3D SEMMNS;
>  	ns->sc_semopm =3D SEMOPM;
> diff --git a/ipc/util.h b/ipc/util.h
> index a55d6cebe6d3b..51b4efa3d6db0 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -245,15 +245,6 @@ int ipcget(struct ipc_namespace *ns, struct ipc_ids =
*ids,
>  void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
>  		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
> =20
> -static inline int sem_check_semmni(struct ipc_namespace *ns) {
> -	/*
> -	 * Check semmni range [0, ipc_mni]
> -	 * semmni is the last element of sem_ctls[4] array
> -	 */
> -	return ((ns->sem_ctls[3] < 0) || (ns->sem_ctls[3] > ipc_mni))
> -		? -ERANGE : 0;
> -}
> -
>  #ifdef CONFIG_COMPAT
>  #include <linux/compat.h>
>  struct compat_ipc_perm {
> --=20
> 2.43.0
>=20

--=20
<https://www.alejandro-colomar.es>

--3ypnmqpyuzbufluf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrcsTcACgkQ64mZXMKQ
wqnKRRAAt8enQI5cXjKMqVjXRh1pd0f04+raK2ShM3YQhaynNwX7pqaPuQu7CNYn
XS4UU//IYiVQhRD+/a6w8QixgPRqvYbpQiVSPaOexM4TmCwbciR/XIs0PBVcyjFI
5GRV9vJBf0c3U1Lcsc2rLqtQT5X7OWK9nEjwHdrKSbYu1JOynmH43gBP+b4wyLW2
4Jhurv34jdrxGZ+oBgMBBOmSJcr3C7CIUj7kOgaJO6uA4w7d6KVcuwgHraP25Qat
+kEhFgs9G7SkzZ8QLOSzUhmY59tkAzuNuqpMRM4LfqOaNNrr8LJKEJLW5/BiZzu6
DewbIzVND0w+PwohgGESVpj+fbEjO3CMlln6tAtmneIB5rrNa5kcqLUyKdhszDIB
BeV2nVRI13zzbs7tuPa1V4/YAB53+QH+JkYadnDkwwEcKs3gGw6TA48g4Sr/L0nu
cBp7f/yslXDqiSxIyUwt1Y2AxUX/5zDzTn4/DqDyxUrWwsc6B07X0IY0rvLDSBWJ
Q68dB2r9lsFdzqdMpBb06OdBl2D/no3BEu/Xni7ROwc2RwlOK9gUS86ILuvIwpGU
jtPOTnbk7c3NRO6/xmPMPVCqGrsm5HIJEfkL2x8Gvfzp3+hnIh+37aj6/Gc9lfLn
qEEiMnILRfHuz52Lk+6KQxg4ZjFU11gtlKYtqoo0H4Gm1yGkTnM=
=dC3A
-----END PGP SIGNATURE-----

--3ypnmqpyuzbufluf--
