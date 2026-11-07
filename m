Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055698;
	b=WIiQBV2chfziJTcJarQFzpbJ/zcuG2gLNVxq8FU1pTdsGLhyvxmqgpRTip7miWV7vsTn
	 e9PMfrO5PRM2el00xHZMOmk236XEi5o+S8xIh3HR3jRKKU+vckp9Nx1TijTAw+IgzBVF9
	 5/3JeP2jvv3X+1HhT5y5v5scQQkLt3n9PARsDd/3f1du4eQ6vHL4DCXeu3oqEb2Jwx5tT
	 pQhcFvIvvHTon1seTSyvUeXFfMxOdDF4VxNXFfHfFYUd8KgKdHrjLE4/AfGNPtv9vjyZA
	 v7e7LY3k/Nf44mEQfrE0SxaDwOFyauq1hYWyL9buGse++lGMl9GyhTIQI3APyvEcP5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055698;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=o6HAnh4oQhxvFHusgwH3ZHvM6R0NtoxJcuUSeSZHO9k=;
	b=wMjnTnQ4OBlLqYbgXmMe9WdOxaUYfvE34SYJbpo7Ajkx/JGXFsU0ar4b4HtWkeue+y3o
	 O0zcuQXXKJmFxOqkwHLXpUYgK/gh5aKHaBnhNmJtiupbd1Tq0C8aze1wtgzYpT1fDYjMB
	 seihN1YS13FIvq0jVqnVtypdcYNfQsA9pVHwwzk3JaUbCUOmpHDiZdEnoFIFaHU3XuUR6
	 thioP0xxzD1ps/MKykM6p/+Yu919/eCafbjd+jwHEVic0iyksw2w7Jrzaa9N//8yksrvy
	 loBaKvc2Rk7ABTGc8XMGTKUj3C2+vcLPYb41tbzJRzwj3B3tt3MYxbe3yR0HVd7AEpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6TPop28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5048606A32D;
	Sat,  7 Nov 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6TPop28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99BE1F008BE;
	Sat,  7 Nov 2026 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055697;
	bh=o6HAnh4oQhxvFHusgwH3ZHvM6R0NtoxJcuUSeSZHO9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E6TPop28opfmk+r8zFWDh3mH8jYGer2lnjEshye9Bc/33mxN43GPSpAxaDf4Qa/Mw
	 mivHHGorghCHzAUPzxgaYqEDhIToqXaGdBnsiL4Qa0MHJ+TqqXWBZSB86mAA5CgT8+
	 FWW9nqhUc5J7UQT7QmvZ57Iy/EQEmqAKjw3hByu3bXLpI+XkRymsSWBDnJou+oSexx
	 Ma1KGAmd2zyoU88BnmX3ROu3AhEw7MUvVvVRI5gJ563H2EAl6hljPetPBAGAVTkpff
	 9dK0VUWu2p3qWpVOr9N+CyMa7OaDhXR0WH1wc80h783hsN2OIeQjxyWJIFv0JJVRMY
	 j+r0PZZ8o11Ww==
Date: Sat, 7 Nov 2026 13:48:14 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 7/8] man/man3const/_ATFILE_SOURCE.3const: Some functions
 report ESRCH instead of EACCES
Message-ID: <8ae17f3f6863c93f1aab125480200ce973719272.1794055492.git.alx@kernel.org>
X-Mailer: git-send-email 2.55.0
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="v2jayviygbno353d"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--v2jayviygbno353d
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 7/8] man/man3const/_ATFILE_SOURCE.3const: Some functions
 report ESRCH instead of EACCES
Message-ID: <8ae17f3f6863c93f1aab125480200ce973719272.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

For example, utimensat(2).

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man3const/_ATFILE_SOURCE.3const | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/man/man3const/_ATFILE_SOURCE.3const b/man/man3const/_ATFILE_SO=
URCE.3const
index d88adf5892c9..183ca7cc7447 100644
--- a/man/man3const/_ATFILE_SOURCE.3const
+++ b/man/man3const/_ATFILE_SOURCE.3const
@@ -91,6 +91,8 @@ .SH ERRORS
 Some common errors for these system calls:
 .TP
 .B EACCES
+.TQ
+.B ESCRH
 Search permission is denied on a component of the path prefix.
 (See also
 .BR path_resolution (7).)
--=20
2.55.0


--v2jayviygbno353d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHg0ACgkQ64mZXMKQ
wqkDBw/+KKg5BuJlJkU/tyTSG/hlp4zOTt8jtjw+21eOgDVvDfNh75u5SMbo+NRp
+TrIYg805ldhy+8PoxKsipvV+p9i96F247QUQUVPpdGPq0eSe9fqGlZX1mCe2324
rtYFMmGlEXHntc0JfssGVNOq5VRIK6fsmbp0iNDYRHniAPnxXXzzsyC4b5PRfmNU
BuIRZFZsx6FzkQlWEAFsqwuU8u6swF4dlUs0kqLGn1t/03cvB27na5jEIIOHbpw6
Kfa+kXzcPnB2eKAD+pOsGvT25BTy/YyswxVxBRGuxW+ZfcnoZzkQc8xg5k0tmreg
GzzEMFPp0K61unB4bi+FuLdHOsOsl4aL6HGUn5gOINE7EPRkYlfNhtPrEhzyid7R
lkK3quemCjG6ai/t1UI0aKsw6LDsdqUit/KTojpnyerKYQg4F2E810fjfhiKnazy
25cP6J3DislG8Zs9ZjDxp++/XGOIn6lNYF0QxKk9nfxaqwi0V9u9g2y7tiFqBzuU
O60zOUb8loiRKp6ivZ+Ef4Dykqstn5uNFAD7lKn8WVwx/s7o6ddnOEv5Z68ZncVM
E/ArkqiA0j+F9EY357DIUPqT+np6mHc7ZJZpSI4eHvizYXJ8w/O38+yM3xFloZdj
J47pZ76nR6dy4Ft4MlKfewFFuK7cSLbZZtrpvXBwIyy//rEn+BI=
=afbX
-----END PGP SIGNATURE-----

--v2jayviygbno353d--
