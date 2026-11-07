Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055681;
	b=oVbq1XcCIVfK+HMlschS6Nsu7uCVl7Cu8x00SQOh//lUKX0pb9LXbYpdfj34VGWCjdcx
	 /YxsgSNIP5GjRD5sKq3MCG7ffzDK4AB830lmcL+12uS+fq6apZPhUU9qJNch4din6trND
	 KmqCbOF/qGi0sl2t5M3k8SQArRFv3z0zKaqdsOunpEJudY2Eajq9yNRuGvOEw4+oPB4Dh
	 JCa5uf8qJU4R8tRWFooRP4D+fklctyBWckb6zV6xt2gUa7jOe8VkQIOyI3QtYHUyXlmhw
	 Bv6Ur3IRHdpal4LP/JgTs+Yg/REmw6NZk6XVl02AwJzVmKcrWaB571v9fvOJWH1FemA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055681;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=J15WhdM9xEcg/4ACTurm0aUs7PmVruKvUfYbtq4f+KI=;
	b=BfxSRt3o6M0rtEOAXJW/gzPiuGWWkvKSDP0IhtJz2Zz4DUq5edrpox37DCmzKVbeh9Tj
	 V9+fl8n9Ta1rSoq8I7nEbnYRe3OlC2upsoSE1Irox2XT7FlnG1RCOHw2rTfltvX17zH34
	 /IHXbNbVFNvXP5c+Jh2V70IaWn7B8xpUrbnJe5x/WWkBX/c6zXQkZYu/HPpkC1sBha/Sv
	 ryElJK3jZ0JlFXGvpMy4s4gamg1vHmwuMvmwUDiytWuyFhbc38EWUi95NvxBcY3fISatB
	 PhJBMkgfwKpvgBiEf8xXcl88LQzppSIQBsGH/DlNTvVvPpuul4MRAti/7l7fmzdzmQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQT3YdyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800C4606A339;
	Sat,  7 Nov 2026 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQT3YdyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29381F008BF;
	Sat,  7 Nov 2026 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055681;
	bh=J15WhdM9xEcg/4ACTurm0aUs7PmVruKvUfYbtq4f+KI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DQT3YdyHx09KjeOxApssp9EGSWVZNhLGA6fykE01jzJr5JiStpZA2b8nTq4j90+gf
	 1Nm33tLfOU8mlaiua/K5+3zc+wRqR4iGDET06HuPzFZ3Uv5nvOcf7/d9AsD86rP26i
	 Fpw9nDaT1fh80nN8h1NM/OWY9dHV9nf4y8KJeSw+xNtKOwhOku/wXYX8coTUZpchJP
	 RBZeY73BFRgrTE5wDRbhzd7w0uINeXTXzVBpyChVa+6v9jfD9DeFf8pCKH92TCRiZw
	 whebllFlSLpYLLeBaejaK9y1I/q7PQgOJfy9uxazJJdsA9MACKwQ5P3Tegf8qY8FUH
	 oNn5Pgz1+O8AQ==
Date: Sat, 7 Nov 2026 13:47:57 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 3/8] man/man2/chown.2: Refer to at(2)
Message-ID: <7fdc286a682a46b94fac99bfb70f581d111c2921.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="s63r2rhcib3bfhwg"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--s63r2rhcib3bfhwg
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 3/8] man/man2/chown.2: Refer to at(2)
Message-ID: <7fdc286a682a46b94fac99bfb70f581d111c2921.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man2/chown.2 | 114 ++++-------------------------------------------
 1 file changed, 8 insertions(+), 106 deletions(-)

diff --git a/man/man2/chown.2 b/man/man2/chown.2
index b346e0adb029..ce62312538b4 100644
--- a/man/man2/chown.2
+++ b/man/man2/chown.2
@@ -18,10 +18,6 @@ .SH SYNOPSIS
 .BI "int chown(const char *" path ", uid_t " owner ", gid_t " group );
 .BI "int fchown(int " fd ", uid_t " owner ", gid_t " group );
 .BI "int lchown(const char *" path ", uid_t " owner ", gid_t " group );
-.P
-.BR "#include <fcntl.h>           " "/* Definition of AT_* constants */"
-.B #include <unistd.h>
-.P
 .BI "int fchownat(int " dirfd ", const char *" path ,
 .BI "             uid_t " owner ", gid_t " group ", int " flags );
 .fi
@@ -116,73 +112,12 @@ .SS fchownat()
 .BR chown (),
 except for the differences described here.
 .P
-If
-.I path
-is relative, then it is interpreted relative to the directory
-referred to by the file descriptor
-.I dirfd
-(rather than relative to the current working directory of
-the calling process, as is done by
-.BR chown ()
-for a relative pathname).
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
-.BR chown ()).
-.P
-If
-.I path
-is absolute, then
-.I dirfd
-is ignored.
-.P
-The
+.IR path ,
+.IR dirfd ,
+and
 .I flags
-argument is a bit mask created by ORing together
-0 or more of the following values;
-.TP
-.BR AT_EMPTY_PATH " (since Linux 2.6.39)"
-.\" commit 65cfc6722361570bfe255698d9cd4dccaf47570d
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
-.\" Before glibc 2.16, defining _ATFILE_SOURCE sufficed
-to obtain its definition.
-.TP
-.B AT_SYMLINK_NOFOLLOW
-If
-.I path
-is a symbolic link, do not dereference it:
-instead operate on the link itself, like
-.BR lchown ().
-(By default,
-.BR fchownat ()
-dereferences symbolic links, like
-.BR chown ().)
+are interpreted as specified in
+.BR at (2).
 .P
 See
 .BR openat (2)
@@ -194,6 +129,9 @@ .SH RETURN VALUE
 .I errno
 is set to indicate the error.
 .SH ERRORS
+See
+.BR at (2).
+.P
 Depending on the filesystem,
 errors other than those listed below can be returned.
 .P
@@ -211,24 +149,10 @@ .SH ERRORS
 .I fd
 is not a valid open file descriptor.
 .TP
-.B EBADF
-.RB ( fchownat ())
-.I path
-is relative but
-.I dirfd
-is neither
-.B AT_FDCWD
-nor a valid file descriptor.
-.TP
 .B EFAULT
 .I path
 points outside your accessible address space.
 .TP
-.B EINVAL
-.RB ( fchownat ())
-Invalid flag specified in
-.IR flags .
-.TP
 .B EIO
 .RB ( fchown ())
 A low-level I/O error occurred while modifying the inode.
@@ -250,13 +174,6 @@ .SH ERRORS
 .B ENOTDIR
 A component of the path prefix is not a directory.
 .TP
-.B ENOTDIR
-.RB ( fchownat ())
-.I path
-is relative and
-.I dirfd
-is a file descriptor referring to a file other than a directory.
-.TP
 .B EPERM
 The calling process did not have the required permissions
 (see above) to change owner and/or group.
@@ -353,21 +270,6 @@ .SS Ownership of new files
 Filesystems that don't support these mount options follow the
 .B \-o\ nogrpid
 rules.
-.SS glibc notes
-On older kernels where
-.BR fchownat ()
-is unavailable, the glibc wrapper function falls back to the use of
-.BR chown ()
-and
-.BR lchown ().
-When
-.I path
-is relative,
-glibc constructs a pathname based on the symbolic link in
-.I /proc/self/fd
-that corresponds to the
-.I dirfd
-argument.
 .SS NFS
 The
 .BR chown ()
--=20
2.55.0


--s63r2rhcib3bfhwg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHf0ACgkQ64mZXMKQ
wqlQ0g//ReUB+eiRwuJN8837YjU8S2zMm8nIjNJfC2Ckdais6LFE3h1XVp5qBYTs
fesDDfPAem9r964woni5D2+XvIcdnrdRhQXtFDzeSNHNBO/pJGEDJUDcMILNjx3E
S2Ujfiq6ZJeGDmuL3VQeOq+dPEqOczGYxZgxDreUrOeEU8+r0k9abTNxDTN0ix6Z
7K0mcn3e+E8iCAQX3/NWhwtS6eozqH+Linn/6Q7HNEPnxYf7O6iRdbH9aH5ec32q
BjXCkZdkbpXG1ophKTcV02WNNmweAoQsTwSNmB8yUZTDZUE0USiKbBn7RQa70bSN
Au3cOUZWomFXLA5gqHlRYnaDEJ3E19WrwPSNPrnC28NfftVyd7O69fE0ZF3aZqRp
EwqRNxoey8JPzTf47Efi0jzc/Wo3f9ethI6pTlsBn12mGKosP9f0RxLqkCLu6CIP
K4hflwlD4K8UAzov1LqHKkIQBdRiI/r7fbcycOklItdwuFS94KrtLC5XU4cL4GLQ
uojpC79/wK5Jx9THlhf0buhOalFOIAJNAzizMXpq+87ljYVSBnuV9h7jbSIVJV2m
357M85Ueryk+J4qDVKyM5ot7Zxc46VOUdIkuFQ79dZg6Pov009NDJZGZde5VrT5a
f0Yfo/BNjWaXrHYdGqzG3lRL6vNLHnGJIEzdQJKp+BDkFc0MezI=
=c+gC
-----END PGP SIGNATURE-----

--s63r2rhcib3bfhwg--
