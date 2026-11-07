Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055701;
	b=X0dSA7cc0K342tG9XgVk3hgooV6xBvNlJrXKlv0/Mm1onwi9T1zs/hBAd7TAx6gQb69x
	 mRUWg1OXsOBWwnL9A0tSnttgXHrloK7IcPUjXccuZlEPezd9h9cxkTcbzQ+eOguBHtqwF
	 r6sRlU38aAafm6d0hmgQV8DvVui1YIjYSHzSoaHdfNLC3njmDHu/XIwd6qzYgd9h6kwre
	 wzbEZg4grqVtO2wikVUjJ6YQ31c8Ycva90nKp5uM1n+P2yKoI9blD2G/owLGxkCMRGogh
	 zme9z8t3TryhuoHYMK7HaxJ635NgY5FxFag7izADapG/ySlhpBeqqnUuvo/skLMLgyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055701;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=A7vPl59MU7uDiI9Gi/FnMedWQ38O3iVnRRVqMF56jR8=;
	b=lO8bJ8Riq1hf3n0KdXGoZWuAMmKqWvc+kRlUVmDQmOZAjUv9a6CTTwMdEHoAkORjfumM
	 phQwkdW0qVa2B1xhNAK88Dr6fefv6SqMtNz7ZRsvKE5w/jMNhnfMWXUQ/FUgl2f6Y5QDl
	 gUCDUrThVrysCwqXUIwfpZpoiFqX1DayyVNSvehcrakoO8oIFp2LqH8cnRjhtKrXi2Vfc
	 hheWfubDNf4rpMBuF4BzK75LaW/+SU7NSApZzM5wUgUW9tepxeqA9U8eodnyd0Jn/3Cbt
	 YHeNko+y3xea8OwrRLPJL/Nn99BJUA0/fFlJLJgtDfmhHA8gLxPwtt12kMh7wJt+Ctw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfXybrLM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C92606A326;
	Sat,  7 Nov 2026 12:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfXybrLM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37561F008A7;
	Sat,  7 Nov 2026 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055701;
	bh=A7vPl59MU7uDiI9Gi/FnMedWQ38O3iVnRRVqMF56jR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PfXybrLMd6cm10qP+MhNkc8sqHAqKYtjP1wtayKNWQgs03V+8SRoC+npTWBIE2GwC
	 T3Xs+nJAgGos31Bg3eCR+nQoR79O1aI9fVInxs5V8uyldXKSO5WtlTuZlHrQ1aADDs
	 N/IBQgf0dc+pzUUeIe4j9AUqFF4UI/uZLoYlIThH+74rr1HwrNPKg2d+BqbioL7w6f
	 fQE0yn5KmoSuhI2XkwYXGQibElNyiF8sl/Dvc3dAS+XkBeyd52tQ2oH13zPCHh0QQ8
	 E4R+1iLhObq1KdCJJq2TF323lX2Yex/j3CM9LAawFcIG216TqagG9nJduYUKb9KxC5
	 qhOeH57BNO2vg==
Date: Sat, 7 Nov 2026 13:48:18 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 8/8] man/man2/utimensat.2: Refer to at(2)
Message-ID: <3de33c76083e9d03d67e7fa70e6a30629ad1fecc.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="q7d3i3jpbjo3ywu3"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--q7d3i3jpbjo3ywu3
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 8/8] man/man2/utimensat.2: Refer to at(2)
Message-ID: <3de33c76083e9d03d67e7fa70e6a30629ad1fecc.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man2/utimensat.2 | 141 +++----------------------------------------
 1 file changed, 7 insertions(+), 134 deletions(-)

diff --git a/man/man2/utimensat.2 b/man/man2/utimensat.2
index bd512d48d938..fb6fe5d54872 100644
--- a/man/man2/utimensat.2
+++ b/man/man2/utimensat.2
@@ -11,7 +11,6 @@ .SH LIBRARY
 .RI ( libc ,\~ \-lc )
 .SH SYNOPSIS
 .nf
-.BR "#include <fcntl.h>" "            /* Definition of " AT_* " constants =
*/"
 .B #include <sys/stat.h>
 .P
 .BI "int utimensat(int " dirfd ", const char *" path ,
@@ -150,71 +149,13 @@ .SS Permissions requirements
 but other error conditions may still be detected.
 .\"
 .\"
-.SS utimensat() specifics
-If
-.I path
-is relative, then by default it is interpreted relative to the
-directory referred to by the open file descriptor,
-.I dirfd
-(rather than relative to the current working directory of
-the calling process, as is done by
-.BR utimes (2)
-for a relative pathname).
-See
-.BR openat (2)
-for an explanation of why this can be useful.
-.P
-If
-.I path
-is relative and
-.I dirfd
-is the special value
-.BR AT_FDCWD ,
-then
-.I path
-is interpreted relative to the current working
-directory of the calling process (like
-.BR utimes (2)).
-.P
-If
-.I path
-is absolute, then
-.I dirfd
-is ignored.
-.P
-The
+.SS utimensat()
+.IR dirfd ,
+.IR path ,
+and
 .I flags
-argument is a bit mask created by ORing together zero or more of
-the following values defined in
-.IR <fcntl.h> :
-.TP
-.BR AT_EMPTY_PATH " (since Linux 5.8)"
-If
-.I path
-is an empty string, operate on the file referred to by
-.I dirfd
-(which may have been obtained using the
-.BR open (2)
-.B O_PATH
-flag).
-In this case,
-.I dirfd
-can refer to any type of file, not just a directory.
-If
-.I dirfd
-is
-.BR AT_FDCWD ,
-the call operates on the current working directory.
-This flag is Linux-specific;
-define
-.B _GNU_SOURCE
-to obtain its definition.
-.TP
-.B AT_SYMLINK_NOFOLLOW
-If
-.I path
-specifies a symbolic link, then update the timestamps of the link,
-rather than the file to which it refers.
+are interpreted as specified in
+.BR at (2).
 .SH RETURN VALUE
 On success,
 .BR utimensat ()
@@ -270,29 +211,9 @@ .SH ERRORS
 .I fd
 is not a valid file descriptor.
 .TP
-.B EBADF
-.RB ( utimensat ())
-.I path
-is relative but
-.I dirfd
-is neither
-.B AT_FDCWD
-nor a valid file descriptor.
-.TP
 .B EFAULT
 .I times
-pointed to an invalid address;
-or,
-.I dirfd
-was
-.BR AT_FDCWD ,
-and
-.I path
-is NULL or an invalid address.
-.TP
-.B EINVAL
-Invalid value in
-.IR flags .
+pointed to an invalid address.
 .TP
 .B EINVAL
 Invalid value in one of the
@@ -305,49 +226,6 @@ .SH ERRORS
 .I tv_sec
 fields.
 .TP
-.B EINVAL
-.\" SUSv4 does not specify this error.
-.I path
-is NULL,
-.I dirfd
-is not
-.BR AT_FDCWD ,
-and
-.I flags
-contains
-.BR AT_SYMLINK_NOFOLLOW .
-.TP
-.B ELOOP
-.RB ( utimensat ())
-Too many symbolic links were encountered in resolving
-.IR path .
-.TP
-.B ENAMETOOLONG
-.RB ( utimensat ())
-.I path
-is too long.
-.TP
-.B ENOENT
-.RB ( utimensat ())
-A component of
-.I path
-does not refer to an existing directory or file,
-or
-.I path
-is an empty string.
-.TP
-.B ENOTDIR
-.RB ( utimensat ())
-.I path
-is relative, but
-.I dirfd
-is neither
-.B AT_FDCWD
-nor a file descriptor referring to a directory;
-or, one of the prefix components of
-.I path
-is not a directory.
-.TP
 .B EPERM
 The caller attempted to change one or both timestamps to a value
 other than the current time,
@@ -389,11 +267,6 @@ .SH ERRORS
 .TP
 .B EROFS
 The file is on a read-only filesystem.
-.TP
-.B ESRCH
-.RB ( utimensat ())
-Search permission is denied for one of the prefix components of
-.IR path .
 .SH ATTRIBUTES
 For an explanation of the terms used in this section, see
 .BR attributes (7).
--=20
2.55.0


--q7d3i3jpbjo3ywu3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHhEACgkQ64mZXMKQ
wqncwQ/+IZOgqe/OJfNN+DthoX0kPHUgZ/mA3IBUDpfSrun/J6NS6/NQaJlVGskd
CUxf8RVL107f4g5un/lQaOasgJBlqNLaItTYsp9474zE4wZD1yQ9DHnYt9HF5VN4
G5nrpgPiN4IExB2/1jj6tt8jfhgirEyCmN7uZx5LqA7A7u3oqLFlsoesRb9+XOmf
rpjHhvy7P5OiVujJzcNz2EBGcNl27APNSfLCvxd/U1entUqoIYpU+K6h9Q+S5yTE
+0qcXyeUwem/EmtYe/4VGVgDIF2yvIkCTrDqNW95W5L7XpwPWxc6/JhixLPhRaQA
IycakyR9xC8khAemByYLjlzkUnXpmbO3G8eh0ir341rj8VDoMke3d4wKkl7lHjf5
uQESam1hW7Gwx4umBlSdMF1rWUcezLPzKNHvd/BYgs1wmCxP8AzjUxA5+EXmr3/s
CEqc+C89VYY2n/Q3qoZumAstxbRqVR6PZYxXEFOvDshtE3VkIU8IoroisgpHj7Lf
QWpDzG5zS212c1p9j42eXGifhorstu1swzWpn0NUJZXn75uEVeLxBPPFvjZGPaO9
3+LLq+aBHZ631PH/DV84kA8bhbn5c7+cWkhYRHbyCxJIbLa8lOXFn4wFXJzjVFQl
dFSzmFFKwD2IlWIn9eyXSLtZevjJx+a2i8AC6TprdjZIJbT65ds=
=bTTt
-----END PGP SIGNATURE-----

--q7d3i3jpbjo3ywu3--
