Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055689;
	b=bUndkCJR/HCBYFaBZa5ESZ7lYCcr96561mSDgvIBYErI8IKpp+b2x/mGQ1oFDiwHGaSp
	 FSwYVpvDUk/FQKca25RDFSSVE6xootPbJq8t3tmoZ9G8z2gOfG6C73anFSCAHyFm7u6RG
	 7ZLKqiiOaZeGRoAI1DE1bwRkfJ8kQujr8DyXVUd0TdaSuLpmEZT51Ulxe+qLendJZnvTy
	 5AhD5EVdWwOpLjLMDIZ+cBGB6XuHWbXpoz4KAwdgdBEDH57ULbPYYz8OY/ctYvqciNGAB
	 YwDY1U4GGQM6hnXV6hZF2WMeorW9rgNsT2yNlZYzs9r+L9jdny0v9H6yPmjR/lVtlzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055689;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Pun/VuY3YbJ3LaWu9ImgdYcUCB+ElVWwFaZHdU3fk4c=;
	b=y6/nA34Zg+C43S5WD+5Te7Ic3GEwAnO08AVBZTrKnRE1COoK9Xj/q3czJ+5B0pDNMxw5
	 YjrKunkVtgujJ+M1OtmyiR/u40Xk14qBrM8z0jjFcMc7B5WwdrP6es+BIZfUU1zjQY+Li
	 GTru7nAJymeGgbtqITDlpW6WqcBXwdY69RnKtKbi7uIoxGkTD8XyGT+h54jvX7DKO9vY7
	 PrQFyCXS60/NLiw9MF3Z17VDKduKwEo2vI3PPftCPupKW13XxLUVRfoYsauh7hpdSjIB0
	 SJrE+5K1wSdMjpxiW32vBCyhF1W0drUxYER+jWSP/4dBSsBPe3o2VH8blOK7dtkqNtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nt8zcmDu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFAF606A32C;
	Sat,  7 Nov 2026 12:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nt8zcmDu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6E91F0089F;
	Sat,  7 Nov 2026 12:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055689;
	bh=Pun/VuY3YbJ3LaWu9ImgdYcUCB+ElVWwFaZHdU3fk4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nt8zcmDuczusyqPfuqthY38zj+rzi5aj8PpmfSLv/eZXk5Vd4mR0ncs964SqySSv6
	 uDP6I1lOX4Gu2RKNYZ88FYZlOsN8Gu0P01XTOxhq8rI11ArfEKK4T03OVe0Wx5sEuN
	 O9fL1BuX1uUn0reZokxC0mo9gda1TURuV7dGIAIF9CPZHtc8KxkJzxT5DPdZtPVp9q
	 3iMyn3BwpdzjB4o2FQh5Txx2WvsF/AH2evtS5rp6wvaV1FyCedof7WAM+twZEe7UBn
	 Wl8Ijy90Z0F+QUjk1d2ommyuWLF4ZLoD2Mu3y0L4+NDwSGeSD8mh0w+6dh1sY/PkAV
	 yLqQ8TG8D/pEw==
Date: Sat, 7 Nov 2026 13:48:06 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 5/8] man/man2/open_tree.2: Refer to at(2)
Message-ID: <4e8ce7b9cf9dd32623ab15735a88b393b5e8af0a.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="ejazxmlhhc6c7nho"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--ejazxmlhhc6c7nho
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 5/8] man/man2/open_tree.2: Refer to at(2)
Message-ID: <4e8ce7b9cf9dd32623ab15735a88b393b5e8af0a.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man2/open_tree.2 | 168 +++----------------------------------------
 1 file changed, 8 insertions(+), 160 deletions(-)

diff --git a/man/man2/open_tree.2 b/man/man2/open_tree.2
index 3e587f7be14b..9afca6ef91a2 100644
--- a/man/man2/open_tree.2
+++ b/man/man2/open_tree.2
@@ -115,110 +115,17 @@ .SH DESCRIPTION
 is included in
 .IR flags .
 .P
-As with "*at()" system calls,
-.BR open_tree ()
-uses the
-.I dirfd
-argument in conjunction with the
-.I path
-argument to determine the path to operate on, as follows:
-.IP \[bu] 3
-If the pathname given in
-.I path
-is absolute, then
-.I dirfd
-is ignored.
-.IP \[bu]
-If the pathname given in
-.I path
-is relative and
-.I dirfd
-is the special value
-.BR \%AT_FDCWD ,
-then
-.I path
-is interpreted relative to
-the current working directory
-of the calling process (like
-.BR open (2)).
-.IP \[bu]
-If the pathname given in
-.I path
-is relative,
-then it is interpreted relative to
-the directory referred to by the file descriptor
-.I dirfd
-(rather than relative to
-the current working directory
-of the calling process,
-as is done by
-.BR open (2)
-for a relative pathname).
-In this case,
-.I dirfd
-must be a directory
-that was opened for reading
-.RB ( \%O_RDONLY )
-or using the
-.B O_PATH
-flag.
-.IP \[bu]
-If
-.I path
-is an empty string,
+.IR dirfd ,
+.IR path ,
 and
 .I flags
-contains
-.BR \%AT_EMPTY_PATH ,
-then the file descriptor
-.I dirfd
-is operated on directly.
-In this case,
-.I dirfd
-may refer to any type of file,
-not just a directory.
-.P
-See
-.BR openat (2)
-for an explanation of why the
-.I dirfd
-argument is useful.
-.P
+are interpreted as specified in
+.BR at (2),
+but
 .I flags
-can be used to control aspects of the path lookup
-and properties of the returned file descriptor.
-A value for
-.I flags
-is constructed by bitwise ORing
-zero or more of the following constants:
+accepts some more values:
 .RS
 .TP
-.B \%AT_EMPTY_PATH
-If
-.I path
-is an empty string, operate on the file referred to by
-.I dirfd
-(which may have been obtained from
-.BR open (2),
-.BR fsmount (2),
-or from another
-.BR open_tree ()
-call).
-In this case,
-.I dirfd
-may refer to any type of file, not just a directory.
-If
-.I dirfd
-is
-.BR \%AT_FDCWD ,
-.BR open_tree ()
-will operate on the current working directory
-of the calling process.
-This flag is Linux-specific;
-define
-.B \%_GNU_SOURCE
-to obtain its definition.
-.TP
 .B \%AT_NO_AUTOMOUNT
 Do not automount the terminal ("basename") component of
 .I path
@@ -231,18 +138,6 @@ .SH DESCRIPTION
 .B \%_GNU_SOURCE
 to obtain its definition.
 .TP
-.B \%AT_SYMLINK_NOFOLLOW
-If
-.I path
-is a symbolic link, do not dereference it;
-instead,
-create either a handle to the link itself
-or a bind-mount of it.
-The resultant file descriptor is indistinguishable from one produced by
-.BR openat (2)
-with
-.BR \%O_PATH | O_NOFOLLLOW .
-.TP
 .B \%OPEN_TREE_CLOEXEC
 Set the close-on-exec
 .RB ( FD_CLOEXEC )
@@ -404,21 +299,8 @@ .SH RETURN VALUE
 .I errno
 is set to indicate the error.
 .SH ERRORS
-.TP
-.B EACCES
-Search permission is denied for one of the directories
-in the path prefix of
-.IR path .
-(See also
-.BR path_resolution (7).)
-.TP
-.B EBADF
-.I path
-is relative but
-.I dirfd
-is neither
-.B \%AT_FDCWD
-nor a valid file descriptor.
+See
+.BR at (2).
 .TP
 .B EFAULT
 .I path
@@ -426,46 +308,12 @@ .SH ERRORS
 or a pointer to a location
 outside the calling process's accessible address space.
 .TP
-.B EINVAL
-Invalid flag specified in
-.IR flags .
-.TP
-.B ELOOP
-Too many symbolic links encountered when resolving
-.IR path .
-.TP
 .B EMFILE
 The calling process has too many open files to create more.
 .TP
-.B ENAMETOOLONG
-.I path
-is longer than
-.BR PATH_MAX .
-.TP
 .B ENFILE
 The system has too many open files to create more.
 .TP
-.B ENOENT
-A component of
-.I path
-does not exist, or is a dangling symbolic link.
-.TP
-.B ENOENT
-.I path
-is an empty string, but
-.B AT_EMPTY_PATH
-is not specified in
-.IR flags .
-.TP
-.B ENOTDIR
-A component of the path prefix of
-.I path
-is not a directory, or
-.I path
-is relative and
-.I dirfd
-is a file descriptor referring to a file other than a directory.
-.TP
 .B ENOSPC
 The "anonymous" mount namespace
 necessary to contain the
--=20
2.55.0


--ejazxmlhhc6c7nho
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHgUACgkQ64mZXMKQ
wqkH/w//YzZZH84x7M3R2IHggNtvjCZgpxo4Qf672v9gownsI3qyItBLK75v5KDP
CFc7n6H++HwoNVpvIlNXIAWK5LoKqPBEX5+RxbPIUmfZ59yYMcus5p5pbQRfVYJP
EsyrUvqKuU+zNGGPhWpwJpZUCzbKgAn4KtaAgb7itnBdqOC3RnhQ6d4N+HiRFY++
qGHpuem+980it9uFZ1aRUZfKa0dmdx4iNL+PZFBCyVgZXGIENonL4iTB7oREulCB
qW1i/DkqHMVMO7lBR0dEZ+lIXiuNLDW0R3duwgzOBxvsQsEG+8idVIyeFHyBIKZ/
R8o31l/aDyXNWH974sz2JXPCGMlLPGZ9jcG7UtY4oGstsaR9R3Qq4KremTb4Gf/v
08Ewl1vTsSoEhmzYvqqiMH5AHyhFWVSPnZi5c6FmLLUY7jrglhiNg/Y24RzdIARB
zXaGA0Bj+TYSMcarHoz4eqNDm0PXCsWamSLRG+zMaGnuCesLcmm4B83w8312kzYi
N6qPkiQ5Thm1/34WCT//Lya39Do62aJFaCD5mxoo7tgJOLEusKKWTIczbIfV419p
pd4Kp/fOxMxms1+Yz/SCvrpbRZYU+pS8xCPMR0gt3XAKfifZZtMbD1N+/LmJo2MS
eSWSsQY+JVZGBMnBdTRZazRJ6YFS/gv9MII4gXvYFSmViSrrmfA=
=rynI
-----END PGP SIGNATURE-----

--ejazxmlhhc6c7nho--
