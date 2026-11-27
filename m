Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795785179;
	b=G7gZLKlsP/LMBZLC00le6YDlayGV9wOgGoorEOFqJL3Rv7l43YsqL/RIZgy4uYvFRAjK
	 lk1lf8TgwqBikz5uWeJ1Zs8N/T3HP9eQ3obX87kSFDcxC+23oL+1NClFl5AboIHlNmSjZ
	 H0GsqTejGN2uq/PaAEx7dUFUEkRXwMYZu+R+sI9IzNLfTRwuueoZ7Hpb3GSMAcwKZkMoH
	 kvTOk8617O0huYT+RCz8Hvrr0QQ6i9x2fn3v/Aa4LaBK8ipC2mt604GdCRsJJ/qixdMyD
	 7kXaPDmcGC3pehfjtI3QdgjfW8J4bSQ+HJ4YGeriIFB0dHBkSt+jTqImpIMgt/DiN7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795785179;
	h=Received:DKIM-Signature:Resent-From:Resent-Date:Resent-Message-ID:
	 Resent-To:Date:From:To:Cc:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1n7aGqslJizq3A0w/V38NH8BqsVPS3xR6m9MYJQhWag=;
	b=5P+AJctsfGTgQVaWKGLtpQasYsgcsLUBGXu8op+4h1XDROJgRhYu7IzYKawf52O7w8Hy
	 YzOm/+ydXCC/TSJeMi9Zp+iSEMATIzmHFuWR9NDJIHjQG5Pn8oWc/+11RWFU6NIe3SQ6c
	 S+SsIWqRUG/5+SUbC8hbkHndFyJvZuA4f5oVipbbqHgY+Ds+8AJK+ihhbjQYQQ2hP0s8u
	 4eN1AkDVbXoNrAtV1UAA3+9hfxFSs/FkFGm1ibfpNBkBA42gm4FzwJ2w0ZIM03cMj4kDy
	 iGQQVT/BEdQd/zZIfbqFNNlf9OEvAiSGoWdZaoeDH8eBdtsvCZAqvKA0UX5bM+A8PlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6fKVmOH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF36606A31F
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 13:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6fKVmOH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040B91F00899
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795785179;
	bh=1n7aGqslJizq3A0w/V38NH8BqsVPS3xR6m9MYJQhWag=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Cc:Subject:
	 References:In-Reply-To;
	b=Q6fKVmOH1OWprEWAl5S9FHaX7sfONUOr6bPcByYylppPnRP9izo9GR6E6ZRw2lWdY
	 DqaU5yc7TRQwBo8NhdHQFyPXNbnsbd7gxlXE9aoyN7CnQykkeUxfcaFREoUb3qnGal
	 o7W61ufA6u71RZRcHio4++oZsw4dc/nHrgCqn2U3yidVbK2OwrTICiJWJNKYbz8VMf
	 GuiFSu5aSdSB61fpqBcArEkp+Ki6s0fwX7WmfnqEuUBFItFRm1KPEqFvdPleHJ3rUL
	 2RGYa2kg2J8Tf2QQKvpCajnHOJbu6r9bt+QFo6yOqMkAfSdVumf+7pdJyF6VwOayZL
	 GpQNIre7yeGfQ==
Resent-From: Alejandro Colomar <alx+linux-man@kernel.org>
Resent-Date: Fri, 27 Nov 2026 14:12:57 +0100
Resent-Message-ID: <awmB2cOJTOB1jvfz@devuan>
Resent-To: linux-api@vger.kernel.org
Date: Fri, 27 Nov 2026 14:08:04 +0100
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Niklas =?utf-8?Q?Hamb=C3=BCchen?= <mail@nh2.me>, 
	linux-man@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: man 2 unshare: UNSHARE_EMPTY_MNTNS
Message-ID: <awl-h1Kdc61JccWC@devuan>
References: <64fb02fd-0ffa-4311-bf21-a3211e9d599e@nh2.me>
 <av-DinDzrAeN_1mU@devuan>
 <20261127-rundlich-geldkassette-farbaufnahme-62856c08c80b@brauner>
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
	protocol="application/pgp-signature"; boundary="bshabd5tnbamc7jq"
Content-Disposition: inline
In-Reply-To: <20261127-rundlich-geldkassette-farbaufnahme-62856c08c80b@brauner>
Message-ID: <20261127130804.V62-5e4QD-ZWpRika0sYfg2KjDTkNWRuxHKDw3E4OLQ@z>


--bshabd5tnbamc7jq
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Niklas =?utf-8?Q?Hamb=C3=BCchen?= <mail@nh2.me>, 
	linux-man@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: man 2 unshare: UNSHARE_EMPTY_MNTNS
Message-ID: <awl-h1Kdc61JccWC@devuan>
References: <64fb02fd-0ffa-4311-bf21-a3211e9d599e@nh2.me>
 <av-DinDzrAeN_1mU@devuan>
 <20261127-rundlich-geldkassette-farbaufnahme-62856c08c80b@brauner>
MIME-Version: 1.0
In-Reply-To: <20261127-rundlich-geldkassette-farbaufnahme-62856c08c80b@brauner>

[CC +=3D linux-api@]

Hi Christian,

> Date: 2026-11-27 13:51:03+0100
> From: Christian Brauner <brauner@kernel.org>
>
> On Fri, Nov 20, 2026 at 12:22:52AM +0100, Alejandro Colomar wrote:
> > That same commit also adds CLONE_EMPTY_MNTNS (according to the commit
> > message, for clone3(2)).  Could you explain why there are two separate
> > flags?
>=20
> unshare() only takes 32 bits. All of them are taken by legacy CLONE_*
> flags. New clone3() flags live above bit 31 so CLONE_EMPTY_MNTNS (1ULL
> << 37) can't be passed to unshare(). UNSHARE_EMPTY_MNTNS reuses the
> CLONE_PARENT_SETTID bit which has no meaning for unshare(). Both imply
> CLONE_NEWNS.

Hmmm, thanks!

$ git grep -hP -f <(grepc_c -tm CLONE_EMPTY_MNTNS) include/
#define CLONE_EMPTY_MNTNS       (1ULL << 37) /* Create an empty mount names=
pace. */
$ git grep -hP -f <(grepc_c -tm UNSHARE_EMPTY_MNTNS) include/
#define UNSHARE_EMPTY_MNTNS 0x00100000 /* Unshare an empty mount namespace.=
 */
$ git grep -hP -f <(grepc_c -tm CLONE_PARENT_SETTID) include/
#define CLONE_PARENT_SETTID     0x00100000      /* set the TID in the paren=
t */

Would it make sense to create new UNSHARE_* flags for all the existing
CLONE_* flags that make sense in unshare(2)?  That would avoid some
possible confusion.

That is:

$ man 2 unshare | grep -o '^.....CLONE_\w*' | sed s/CLONE/UNSHARE/;
     UNSHARE_FILES
     UNSHARE_FS
     UNSHARE_NEWCGROUP
     UNSHARE_NEWIPC
     UNSHARE_NEWNET
     UNSHARE_NEWNS
     UNSHARE_NEWPID
     UNSHARE_NEWTIME
     UNSHARE_NEWUSER
     UNSHARE_NEWUTS
     UNSHARE_SYSVSEM


Have a lovely day!
Alex


--=20
<https://www.alejandro-colomar.es>

--bshabd5tnbamc7jq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmsJgK4ACgkQ64mZXMKQ
wqk8ihAAl9OzcXygX9Lg1yhuFEo0Y1Ky0RCoadSTrpjteYRSQncD2eJxH8e33BD/
WPjsSIUKuXez0gQPW9hKAkK5hX+CH9zuLbzqLkvPB3HJyLFMZbERusbNk5x8wBjw
e0qqP42NnWJzBNfP/mC8tzXXMYm23QbvCn4AedTniHpVIz048/gXX/f5aGxZD9Mr
Z/xwUK+8l1f/lGlGXS3YClV8/MfYk+WqjUn0c7lngGbUP/5OBZOj9/cpc36P0aJ6
f6Dkz0kG+VcMsweJ59BUSCjNe0q5w7hGurVekkn2o9woTtUH7WL2WWKmyJX4C1uD
gUkN6FnnKGCgaG7Y1coCaYyYWeG3LXBWkCxJ/nHTGIy2QB/l0+Iw1fWposgRU7pv
0HJHXUeV5SfQ4RctNHmhXR+xsAqh5D9MUrsRFFFWslwdMooF28QiJIKe1ZzBylaI
VViePknbtiO8VxKpi1DqoGiuywIuYCAUMjjU7QxeUek/udMXAIc92PiBX/4aw59n
4PrmIenTxN8oU8aC9kUnnQJdJ9ALw+yGsPUuA90OiXk/Pj7cs9v0sbM9Bw+VusdR
CXUKRwv75U0kO2yQLlyjBdrAOqOXVgDFkEhxVniXbrioBjEHGfb/X2AyY8zcLBq3
zZ2v44kqIrqIVEaDpH4EQaQIckqiHtGFV1mXh/y0ZwWuwrHAI3I=
=HQXy
-----END PGP SIGNATURE-----

--bshabd5tnbamc7jq--
