Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055693;
	b=mNn+0c/Zmet9ohpLErSUbdWpuEUA3sPhiC8Qv8axK9mTVJTFUonbe4WQZMb1zl7Bl/MZ
	 W7qefyqeXHjPd+s7Wv8tTIBtYIJOlMQm0mUEMajIsm9YgZUeAZR3kPiP8JZ1KWDs7+r09
	 OiIj8uSEqz1W9sManypspkiQTT6GZwiUFSgBheYKOjbgc/Odz7UpOIpSTWKjvtNmUbB9Z
	 MuMwNZR+yHemQ6mBFnta3yfzoGm1UwzJOovfwa3Mix+qy39XbcgbJ5CYKcNwWjGi4JfyI
	 eOABWOGPRiBMa66Zi5higr8eqolH6e78sQBLCFq9oa/eAtJkaldJBtljyAQzhCjpH0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055693;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UHRNEo+MufxeruDRrXBT7cWXvWTfIDovfED8u3ael6Q=;
	b=nCuguwxfEGKFB4R3qgMBceeUhcBJMxu8vGbL1sJ/t6k90/iEXCSCDGDIXsLz53Q7of2+
	 Px6EsNYHtsWCHEKd1ofxK+C0coHWuMjBqMAqszhW+/NG+u41P7zjRIjMEILq/TyJz6cHa
	 9M2l5QAwPt2D48U1A+0LvST3Gocie6XHVOGr88bdPnduoedJOX2iIwLGwWFYsCfoZrjAV
	 BUrnJi8m6m/fc3+rd5dUfrZ7rXjEhwE/hFpnbJN6Xkx6TpNBrCShj/qtDiHHQ18mx0GuD
	 HO2IJhLi/CyE/4hZBrEl4hq2A79RcgMFG9jBbfQV+cs391wZXUtcRIBOYkdYBx63A3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XcyIk7bC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735DD606A326;
	Sat,  7 Nov 2026 12:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XcyIk7bC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D561F0089F;
	Sat,  7 Nov 2026 12:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055693;
	bh=UHRNEo+MufxeruDRrXBT7cWXvWTfIDovfED8u3ael6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XcyIk7bC2YKu6AULlp9Tr2M7CZ2JQuAjKylq4lMxi2UuDJm8tuNmH0tIu48fW5INb
	 dpK8llJXxPsofpDojPrdd7hAxqDOWuWNO5xndGMbEOvDkN2C6wcBlE97aM7zQmj8yY
	 IpFakfG4FFyNAVm+L0R0oc1Mf/1SRpAf28owj4J1PsSFiQfKG2PcIa+ZVxUG5hZjGT
	 Mpfq5AvjFMLpQIPvG7xvmzR9ZeuoY7ZN9mcIggLA2DC9KiSFisZGwBRb+mC163ioL0
	 LfkMyyq0ufFqiPfAhuFHRGYH8Qn4TH+RGLtaX71TKpxmvhcYJJyC3z4buZWIo4NRIH
	 Z95yCTcYfxsnA==
Date: Sat, 7 Nov 2026 13:48:10 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 6/8] man/man2/rename.2: Refer to at(2)
Message-ID: <8a5ac3f93ba5d2e70cb6fe94c6f5efb9ae44d4fc.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="b6vw45tq6ds5xc6v"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--b6vw45tq6ds5xc6v
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 6/8] man/man2/rename.2: Refer to at(2)
Message-ID: <8a5ac3f93ba5d2e70cb6fe94c6f5efb9ae44d4fc.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man2/rename.2 | 84 +++--------------------------------------------
 1 file changed, 5 insertions(+), 79 deletions(-)

diff --git a/man/man2/rename.2 b/man/man2/rename.2
index 7e5c02797230..87f49ba851d7 100644
--- a/man/man2/rename.2
+++ b/man/man2/rename.2
@@ -16,10 +16,6 @@ .SH SYNOPSIS
 .B #include <stdio.h>
 .P
 .BI "int rename(const char *" oldpath ", const char *" newpath );
-.P
-.BR "#include <fcntl.h>           " "/* Definition of " AT_* " constants *=
/"
-.B #include <stdio.h>
-.P
 .BI "int renameat(int " olddirfd ", const char *" oldpath ,
 .BI "             int " newdirfd ", const char *" newpath );
 .BI "int renameat2(int " olddirfd ", const char *" oldpath ,
@@ -96,52 +92,10 @@ .SH DESCRIPTION
 .I newpath
 refers to a symbolic link, the link will be overwritten.
 .SS renameat()
-The
+The file descriptor and path arguments of
 .BR renameat ()
-system call operates in exactly the same way as
-.BR rename (),
-except for the differences described here.
-.P
-If the pathname given in
-.I oldpath
-is relative, then it is interpreted relative to the directory
-referred to by the file descriptor
-.I olddirfd
-(rather than relative to the current working directory of
-the calling process, as is done by
-.BR rename ()
-for a relative pathname).
-.P
-If
-.I oldpath
-is relative and
-.I olddirfd
-is the special value
-.BR AT_FDCWD ,
-then
-.I oldpath
-is interpreted relative to the current working
-directory of the calling process (like
-.BR rename ()).
-.P
-If
-.I oldpath
-is absolute, then
-.I olddirfd
-is ignored.
-.P
-The interpretation of
-.I newpath
-is as for
-.IR oldpath ,
-except that a relative pathname is interpreted relative
-to the directory referred to by the file descriptor
-.IR newdirfd .
-.P
-See
-.BR openat (2)
-for an explanation of the need for
-.BR renameat ().
+are interpreted as specified in
+.BR at (2).
 .SS renameat2()
 .BR renameat2 ()
 has an additional
@@ -274,25 +228,20 @@ .SH RETURN VALUE
 .I errno
 is set to indicate the error.
 .SH ERRORS
+See
+.BR at (2).
 .TP
 .B EACCES
 Write permission is denied for the directory containing
 .I oldpath
 or
 .IR newpath ,
-or, search permission is denied for one of the directories
-in the path prefix of
-.I oldpath
-or
-.IR newpath ,
 or
 .I oldpath
 is a directory and does not allow write permission (needed to update
 the
 .I ..
 entry).
-(See also
-.BR path_resolution (7).)
 .TP
 .B EBUSY
 The rename fails because
@@ -411,29 +360,6 @@ .SH ERRORS
 even if the same filesystem is mounted on both.)
 .P
 The following additional errors can occur for
-.BR renameat ()
-and
-.BR renameat2 ():
-.TP
-.B EBADF
-.I oldpath
-.RI ( newpath )
-is relative but
-.I olddirfd
-.RI ( newdirfd )
-is not a valid file descriptor.
-.TP
-.B ENOTDIR
-.I oldpath
-is relative and
-.I olddirfd
-is a file descriptor referring to a file other than a directory;
-or similar for
-.I newpath
-and
-.I newdirfd
-.P
-The following additional errors can occur for
 .BR renameat2 ():
 .TP
 .B EEXIST
--=20
2.55.0


--b6vw45tq6ds5xc6v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHgkACgkQ64mZXMKQ
wqnUCw/+J+n2h4IfQ7dZMCRY/8KylU4GqUF5GqgvP/ncFe/3BDWNSC3aUT+/bj7B
KVeeFwuGGtqxls4MWhRozxdX1KpcVShXbrKjb5r/PpScITemArrcBzLlZw+aCx+M
k0vpQ89ek+gXUJwy3mXfRICPP+kXGxYah56/a4aBApaiLGXhJoGcbPvpreVDfsIZ
1NFWr8c1NpqFSaGGX/M8l3P9UTrpwDadanWVdx9iwCfmlBtjHqB+vsv8n05Jn2DK
0kHPwPirCQoZ1oLOeBgdm97PZwsTymfPIG8fGBN2oJlJwZWYatcfSMG625S5lUmc
ppn9IJ6xfhK/6gYwJXEd6HK9WGwAsyWzvyHlI/6C6qYv0tWhAUHzINGyED5IwuNa
+QSwJ139QYoTbqkVd42NxRAAC1xVt+ioNfc5WRd8yuUkRNaFy7E9zbgXEeyiD1xJ
n/pGm0+6ZesvubUdJ892r3ZDS8ZW9dFN5uiEWp6ju0A0va4zfTwGTRFm2O2B/+fC
S7TjMsL8TsqH1IK0QkYU8o9JqdXcGofckJ2tNRKAyY8PRdKKzB2lHpbdeE6Hf72x
wK3MFXe6gkLFZTMEykaQv1dCznJU7gQvvOJc/0avZ9Pq+k8FMJF42c9AGX2BQ246
S1CMfIr5j/rUhCYlVPdDvk4FMFVEvrneYMnxIiZKDbnW2qjUwyc=
=RY/q
-----END PGP SIGNATURE-----

--b6vw45tq6ds5xc6v--
