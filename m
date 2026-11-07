Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055672;
	b=b2Jxwx7+R98hePslgIN4N3fZpR6f3glf43glY2+niHSIs9P6iSR1b/2REfIxjt7YzCAB
	 pqr4JlBoj5jl94wMz5PZIhUie0Cowda5qBzsx9RQtkKF0bVee1H4griuy+lzIHqu5FESP
	 6YZOw0+Y7VsmmfQOhWP2ECFquCsR5bWHmpJMI7aLPdUHzWJiaNoN++Nu9wEZXk2tUQqKH
	 QXj9TgWnj5bvwUuG5aril19OJWftge8BFl72tUtKjHmZAKjknIr7u8rWK0peUshmAy7+b
	 0FJoiqgi234NA70snGy58in8iwMBpiMCX3Wgihx3LOyF+ggT7RUiaEWyRP5xNrsZ1Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055672;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=viJ6WPY2ML5NDRODIrXDFQDCbaKTa3gq00ek7dDrbxM=;
	b=iGJU6GG/9QT1AEE3Q11OR7pPulRXkzTa/kzKjMLrcZ3J8Fupbe2WwRzzgsqCLkTuwrAt
	 jqJtlbNRhLJuJu6KsMMf4MCkBfyEZA37ksZndCtZ7AFGGs+p+4kYQNAR5V+IjNmiwNlcM
	 GFXCwNBTwSOJl//J6VWRVq3byehbx423r52jBHinLchSb4Z4pBvEayTdd3jIhotznSCXW
	 OY1yVE0gfr+Viu0Bw1GuZIYv3mEhQpXu1eJ9GVLzqccuzCirQGz0fO10poTtMcYrVu9H9
	 VO9z8Z6vvpAGgTmm2Rh9fwVzKKkbDB8cO9MGi4R/sc98ppOhec/tYG+y9iz405BCfwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A1OCHnQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD942606A326;
	Sat,  7 Nov 2026 12:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A1OCHnQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7E11F0089F;
	Sat,  7 Nov 2026 12:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055671;
	bh=viJ6WPY2ML5NDRODIrXDFQDCbaKTa3gq00ek7dDrbxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A1OCHnQGucB+TRcT/wnGu6RA08fqXJCcjSX9yAx73Mxoucgkxeu1cbQWBCsfRNYg8
	 G88WInOZJF6fb56dHMIFjsIrlJvPeB7nU0zP4IxBPhEPq5iaKvOTvKrrzXLb5JFyWg
	 fwtEJCG+lbsTnvaYuPIaycUAHjmmfkn7G1zHvYyJLUqwBznBf56AZLlWIfiYPBkKI0
	 Xsk4y7OZl8RNPPFbFIm6359N/rhWcQCejM9MGEehKlUU5t0+uiHtv/u0HPm5P+OGpa
	 uN/udHOdSXy2KLsXpPta2ugc3JWAczw3fN8WgqHaRQfSAoEFsAVVwBuUB88fnTpkko
	 azVoZ2gVFNepA==
Date: Sat, 7 Nov 2026 13:47:45 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 1/8] man/man3const/_ATFILE_SOURCE.3const: Add page
Message-ID: <39bf4d24176a09a5f9b53b402df4becf1263729c.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="3zc4g3oy7ueaz47m"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--3zc4g3oy7ueaz47m
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 1/8] man/man3const/_ATFILE_SOURCE.3const: Add page
Message-ID: <39bf4d24176a09a5f9b53b402df4becf1263729c.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

This page documents conventions common to several system calls
(most of them conventionally named ...at()).

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man3const/_ATFILE_SOURCE.3const | 168 ++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)
 create mode 100644 man/man3const/_ATFILE_SOURCE.3const

diff --git a/man/man3const/_ATFILE_SOURCE.3const b/man/man3const/_ATFILE_SO=
URCE.3const
new file mode 100644
index 000000000000..d88adf5892c9
--- /dev/null
+++ b/man/man3const/_ATFILE_SOURCE.3const
@@ -0,0 +1,168 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH _ATFILE_SOURCE 3const (date) "Linux man-pages (unreleased)"
+.SH NAME
+_ATFILE_SOURCE \- act on a file at a directory
+.SH SYNOPSIS
+.nf
+.B #define _ATFILE_SOURCE
+.BR "#include <fcntl.h>" "  /* Definition of " AT_* " constants */"
+.fi
+.P
+.nf
+.BI long\~...at(int\~ dirfd ", const\~char\~*" path ", ..., int\~" flags "=
, ...);"
+.fi
+.SH DESCRIPTION
+The
+.BR \f[I]*\f[]at ()
+system calls perform an action on a file
+specified by the combination of
+.IR dirfd ,
+.IR path ,
+and
+.IR flags .
+.P
+If
+.I path
+is absolute,
+then
+.I dirfd
+is ignored.
+.P
+If
+.I path
+is relative,
+then it is interpreted relative to the directory
+referred to by the file descriptor
+.IR dirfd .
+.P
+If
+.I path
+is relative and
+.I dirfd
+is the special value
+.BR AT_FDCWD ,
+then
+.I path
+is interpreted relative to the current working directory
+of the calling process.
+.P
+The
+.I flags
+argument is a bit mask created by ORing together
+0 or more of the following values
+(some system calls may support more values).
+.TP
+.BR AT_EMPTY_PATH " (since Linux 2.6.39)"
+.\" commit 65cfc6722361570bfe255698d9cd4dccaf47570d
+If
+.I path
+is an empty string,
+operate on the file referred to by
+.I dirfd
+(which may have been obtained using the
+.BR open (2)
+.B O_PATH
+flag).
+In this case,
+.I dirfd
+can refer to any type of file,
+not just a directory.
+If
+.I dirfd
+is
+.BR AT_FDCWD ,
+the call operates on the current working directory.
+This flag is Linux-specific;
+define
+.B _GNU_SOURCE
+.\" Before glibc 2.16, defining _ATFILE_SOURCE sufficed
+to obtain its definition.
+.TP
+.B AT_SYMLINK_NOFOLLOW
+If
+.I path
+is a symbolic link,
+do not dereference it:
+instead operate on the link itself.
+.SH ERRORS
+Some common errors for these system calls:
+.TP
+.B EACCES
+Search permission is denied on a component of the path prefix.
+(See also
+.BR path_resolution (7).)
+.TP
+.B EBADF
+.I path
+is relative but
+.I dirfd
+is neither
+.B AT_FDCWD
+nor a valid file descriptor.
+.TP
+.B EFAULT
+.I path
+points outside your accessible address space.
+.TP
+.B EINVAL
+Invalid flags specified in
+.IR flags .
+.TP
+.B ELOOP
+Too many symbolic links were encountered in resolving
+.IR path .
+.TP
+.B ENAMETOOLONG
+.I path
+is longer than
+.BR PATH_MAX .
+.TP
+.B ENOENT
+The file does not exist.
+.TP
+.B ENOENT
+.I path
+is an empty string,
+but
+.B AT_EMPTY_PATH
+is not specified in
+.IR flags .
+.TP
+.B ENOENT
+A component of the path prefix is a dangling symbolic link.
+.TP
+.B ENOTDIR
+A component of the path prefix is not a directory.
+.TP
+.B ENOTDIR
+.I path
+is relative and
+.I dirfd
+is a file descriptor referring to a file other than a directory.
+.SH VERSIONS
+On older kernels where
+these system calls are unavailable,
+the glibc wrapper functions emulate them.
+When
+.I path
+is relative,
+glibc constructs a pathname based on the symbolic link in
+.I /proc/self/fd
+that corresponds to the
+.I dirfd
+argument.
+.SH STANDARDS
+TODO.
+.SH HISTORY
+TODO.
+.SH CAVEATS
+Most of these system calls are named with an 'at' suffix,
+although some new system calls don't have this suffix.
+.SH SEE ALSO
+.BR openat (2),
+.BR feature_test_macros (7),
+.BR path_resolution (7),
+.BR symlink (7)
--=20
2.55.0


--3zc4g3oy7ueaz47m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHfEACgkQ64mZXMKQ
wqmEghAArUlSP/YXbj8SuNV70kdBpvBSMo86/MSdGsTJ7opN3ynveMKy50L8hZkJ
dHhr24XfDx7o4vnf6K9ylnC2h6tef/ixWFEZg7SKzOpTwmWGibbGU3RUp0nGwi7X
fcQlnIHn2uSWJybhv9qatanpgeWM8igAGhkopjUMVAJAzOFxz6ffijOUoCxOpfLF
Bj9kZn4gQxwkcuVL5V6CQ83vTY3Z0hyEle9QltLO7Iv0puYxZHHnIo7SHTMThHZn
TXM4QhG6iSTjoaekyLObBTuCthwyLfs6cXLg4639pKOhAn4VX6n9FJgtO0XlXv2a
w43/CTF6bo/Umb7qvQfWdm3l+oO285AseZMpM/R65pXJqwZBgVO64GI/MKc9swzp
dOFbxMx6AgLaP46ZOLTnLXdsxjdtB6fi41zqJQpn2mTRntyypX1zv/s397yXs1iK
pJooCpVkIT+j719cxZp1Tb6HASBQVAv5BCf6lPeBkf3YyT7k875G8bC7jgJcL5Ao
YFGHiNXA2XVANEwTF+w6u4Cn5+LfmxRgeOLgYJiKKU/MuISHsJmXyd1HcnXDMDpx
AiegdcNT3lqm5PUzOidTZUVup/y3t+r5/KtROxi+ARpJwDhiO4VEuuO4Nl2SRXgQ
HKd/yhloMGL7GKmnhj/8w2mIK2VBkzefmY2mwhjBh8guJQCg3cM=
=b2xK
-----END PGP SIGNATURE-----

--3zc4g3oy7ueaz47m--
