Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055686;
	b=FXHue+moWM1YWOXYiJFdcA39nKq+yAZr54dk2PL1BE58+s4BUsQDjxbC/dA1p4VKM2Xx
	 G9+SocEngyYlkcn+xRjSL8Qu3ia7abfQoqD1shZAFa6IuW0jX/N6eykwTpNXL3YDr4qvi
	 QH97y2twM2d2SUW2XOGFd4a+7AOFJVRReK8I2QV8XIgSSwfB0UOr/LIERVjQ1E/H94xlk
	 Y9MpXE92YOxaUSn12SuGrHUzdHqd45VsuqkrNayliz7h5WpBwJArP2gPrRB3Nf6Vs2niC
	 /KnIU0G49s1rzwGTd0WJFBIIy1b/ayM0rfhK7kMTsgQrejpCpTigBPDuryQjweh/0og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055686;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=koz8IWFrXeUOBv9T1fHadWyJiyrh52XWngAo25wlMU4=;
	b=ekokwf4H8FqjnFtyhm4wd37g/GPXrPASeZTOw9+jh1zGqdZtG8/isQyeUBhJwpICCfIs
	 2c3PWDHs3OQyJ0P3qod4KdSFOWRcmx+BF2OzkGvJ7Uo+YCj31jQxNQHeCyjbncgqhLjID
	 M46M4dPFmWc5S3KaY6RPrl/QNGYyHBK1+7r63Bbo1ZypgOXwNCE1+SfjWmRbvufWJ2mny
	 08S1PIijiXbc+vxYS510Z9jCSwJCVhhXMHAXMKD/uMl8OR84iMWlm+M7cSVrAMfxa9Ess
	 0Uhzxu4ax5Y3C3H3ic9tHl3p+4/DugxCk3DEXHaq9do57iga1iCP5ZgxxlZ1XswlQGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BxoxicOc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B167C606A326;
	Sat,  7 Nov 2026 12:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BxoxicOc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BDB1F008A5;
	Sat,  7 Nov 2026 12:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055685;
	bh=koz8IWFrXeUOBv9T1fHadWyJiyrh52XWngAo25wlMU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BxoxicOch3ebYiHUb9ln6umWgLB4oM4wHmN6eKSF2D2G2e9qyny9iWgy+SX9uRqYc
	 qXSaL2UMMDN03obV7IthRyiJMM0mnTb19b2qMuNag0qRffGnxqWz8jIVMK0R5Gfhf2
	 Ilt46nZXoUko8YQpEKGdoZrvOnuOGx0DsAQqz+g4P6Tfw2SBVklCthlr3ZwozYZ68y
	 7BFelqv3bxB/AMNi54qjd2DBKBTHVutZpVHm8WNBTC4VK7w/9NpmEHXTvAHdRU3MDN
	 LzwNj3fy2amN0HRCWvBNyYu6hGY64Xq/A9fDsXl5tb0LlNPVLtUAxNqL/6jY5C4wvO
	 cTyKhjL3PBL/w==
Date: Sat, 7 Nov 2026 13:48:02 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 4/8] man/man2/mount_setattr.2: Refer to at(2)
Message-ID: <c206656df1610948d850c51caae22d61f2c3e47d.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="vj766bnwjuocf3z2"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--vj766bnwjuocf3z2
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 4/8] man/man2/mount_setattr.2: Refer to at(2)
Message-ID: <c206656df1610948d850c51caae22d61f2c3e47d.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man2/mount_setattr.2 | 66 +++++++++-------------------------------
 1 file changed, 15 insertions(+), 51 deletions(-)

diff --git a/man/man2/mount_setattr.2 b/man/man2/mount_setattr.2
index 0f4b619d8f38..809fa582e1ad 100644
--- a/man/man2/mount_setattr.2
+++ b/man/man2/mount_setattr.2
@@ -25,34 +25,16 @@ .SH DESCRIPTION
 .P
 .BR mount_setattr ()
 changes the mount properties of a mount or an entire mount tree.
-If
-.I path
-is relative,
-then it is interpreted relative to
-the directory referred to by the file descriptor
-.IR dirfd .
-If
-.I dirfd
-is the special value
-.BR AT_FDCWD ,
-then
-.I path
-is interpreted relative to
-the current working directory of the calling process.
-If
-.I path
-is the empty string and
-.B AT_EMPTY_PATH
-is specified in
-.IR flags ,
-then the mount properties of the mount identified by
-.I dirfd
-are changed.
-(See
-.BR openat (2)
-for an explanation of why the
-.I dirfd
-argument is useful.)
+.P
+.IR dirfd ,
+.IR path ,
+and
+.I flags
+are interpreted as specified in
+.BR at (2),
+but
+.I flags
+accepts some more values (see below).
 .P
 The
 .BR mount_setattr ()
@@ -96,22 +78,14 @@ .SH DESCRIPTION
 The
 .I flags
 argument can be used to alter the pathname resolution behavior.
+Apart from the values specified in
+.BR at (2),
+the following values are supported:
 The supported values are:
 .TP
-.B AT_EMPTY_PATH
-If
-.I path
-is the empty string,
-change the mount properties on
-.I dirfd
-itself.
-.TP
 .B AT_RECURSIVE
 Change the mount properties of the entire mount tree.
 .TP
-.B AT_SYMLINK_NOFOLLOW
-Don't follow trailing symbolic links.
-.TP
 .B AT_NO_AUTOMOUNT
 Don't trigger automounts.
 .P
@@ -383,14 +357,8 @@ .SH RETURN VALUE
 .I errno
 is set to indicate the error.
 .SH ERRORS
-.TP
-.B EBADF
-.I path
-is relative but
-.I dirfd
-is neither
-.B AT_FDCWD
-nor a valid file descriptor.
+See
+.BR at (2).
 .TP
 .B EBADF
 .I userns_fd
@@ -418,10 +386,6 @@ .SH ERRORS
 isn't a mount point.
 .TP
 .B EINVAL
-An unsupported value was set in
-.IR flags .
-.TP
-.B EINVAL
 An unsupported value was specified in the
 .I attr_set
 field of
--=20
2.55.0


--vj766bnwjuocf3z2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHgEACgkQ64mZXMKQ
wqnccQ/9Ed1EciyqbfOWwen/BA8QEgBhaoRWPGxkSLH9wtKBB/uIktiPx7xlCVEm
eLS/3TqNiAmihJyVvhDnTS/z9K+0hjazrdwirUpe4zUvvvMLsiShwuPraze9O+wP
VD7u4LxWwChQbkk4mU2QXYdMXzo6lawdqS42oSGFkeYEGb/7wbsNhOhkO6qPz3mI
gQmbSqGTjwDEDl6sEsHe3ZNxr4c4kUmkoKSx2fiEqsYfFjdVLwMzTF/y4js422lx
29IZaoo0ZttiCAs5Oa6Ap6UzBkyYu4bquZSPZC0vLZK8jXeOMa1VWsYPXyLZ7vvl
o288aMcXt5ZBz7larzFHWPQg5yOW2ed/aTlrcCvW1rRy3v5tjUMa+YipjbBhlil/
0VBDtjqpqVaP+M8FkcfYCTXdZZFxENllKwCeJ16WaJEDn6PgKwKSv9nJg/0yYdfb
SGTlPMxi0ymGWXYSlXolwIZJ2KSmhLa9FGK3Z9l60K46cKuhI8MjfcVd1IZW32Z6
tzG4FzyqI3lT+ik0II1q+qTMSXnihn+/jdWVD9Q+eKX274E+eJ3K/adsskYh/iLM
yyIa171iEqDUvef0NZX0iKpEoQN6O/v2MfCwjCb6fENxcmQ8I5SMTW0e2Q3u/nen
7gCcWfLTjB9im2OV6sGvULLkE3WpIiAhKFIYNbNI51IzqUzmUdc=
=xbSz
-----END PGP SIGNATURE-----

--vj766bnwjuocf3z2--
