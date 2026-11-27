Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795784884;
	b=bDOLXlN6Sk6N4KCr7cmQoAOKA6Jg1Sp+Iy6NmHZhUqFWLJAkS+qAAi3STGig2zKaGCvr
	 3uHW8+d6ZRJkb+AnmbqpDEVX07qSYR5jnCOdaWaC03gpnirb3MhVXpOPFV+xBnAZh0epF
	 dji0k7H4RBaYe427Oe1uSKCakdRTqGeah8S+Cd7cI0VsSeD5mrN/Zehb142AJH0aIfuhu
	 PPoYM7aIaPW5DUW1NsGrjMCwNKo3fLXO/FEjWd0wq3B3TwGtnipNvNBqKvzjOTNeaQj7O
	 q0Kpr5gXmr0MzpTssQflB75nZbGilwb7QDmaJVzRvNvD7a8EGEIGCHYFLwgH8pB4jqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795784884;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1n7aGqslJizq3A0w/V38NH8BqsVPS3xR6m9MYJQhWag=;
	b=wkMFRG6nkUyimfmzDH77BDtC/f5zRcBIt4Na351i9YtHKYvi4Bo2qGQKP4y3y4o/rAfP
	 TRLncKKRt/XKURwoQnhML6vb+pPqajYFafhOROO7m4cZolr/JPWd37Kg2Un2EgweLBpcX
	 3/0dCR4Iiifxkbb8ovw58QNm/ZK2foHwTlum5msnb7zCojQ7C9cawjgWAtswPBZUS38lG
	 Lo2QKBgCnLgSejudq4DgUQsheXKDX5oSImH+peW2zMjWep+AZ3hvnDHEECdJG/5qHHCRB
	 k9ePB2p/fxlM2r6JMHlrk6IZgeq4+L/VaGKkARDV9Yq88mon1eS5qElEfCIrZd5y1Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESHsicbg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE50606A31C;
	Fri, 27 Nov 2026 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESHsicbg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD7E1F00927;
	Fri, 27 Nov 2026 13:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795784883;
	bh=1n7aGqslJizq3A0w/V38NH8BqsVPS3xR6m9MYJQhWag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ESHsicbg+xlaaWdWHm8FmEtru8Bc26u7wFzrtu2iZakf0+Ip0+WKL6YDDVD7rPfsj
	 1tRSb65YNxjped8mNLqj/S25whel7s1sVWZQ1bT0b9DUSsywS+Mm5HyZfwcS4k5vrq
	 VMCU/CMqmWYNjFdav83hOmxGCQijxqnqAJmx622/fQM4Q5jUQebEOuUl/vqZRd6ti+
	 ouUXSMV+iaDO89S4/LTIhLCgtqqn2K9rg0sXOURHWc0QsJcHxOI48QCY+WraMksA9/
	 Ai7+HvjKSuRzX1VUzvwkBRk9Tq3V8Jb4JBUx3jNsGkvRiiS4oC0FuzWba9m6STTFEy
	 IPbFf4PIth2cw==
Date: Fri, 27 Nov 2026 14:07:58 +0100
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Niklas =?utf-8?Q?Hamb=C3=BCchen?= <mail@nh2.me>, 
	linux-man@vger.kernel.org, linux-api@vger.kernel.org
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
