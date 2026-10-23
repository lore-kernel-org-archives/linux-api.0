Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792777244;
	b=Vc+iIxYz7qOSaqWph7rAX2cs4Qv6Vxamh932yuIuBAVJf40ShK1CZtiFCc+EOcdJ/kZs
	 9xuKxbMv0I+twq1I/ke9mkBN5lH1/o1uT1MjscH+asdpuexo3871gS8+r5awEF2cbPW/A
	 Q2HLWl12VOppc1jbAiVr5Xvz5sncfHx2CRpm2XU8K7H84wykNRUlcoaqFNXxkb/0nPYlY
	 akeoDN7dcd738VTXtMUpljLv+J3BvDqQGMUYg2jp6AY0uVYwxhtsnpmpXsjHJOapEWxfV
	 acwLZ52g0XAWfP4Pi4Ev0/JKiT0rvKfHK2T3sF1NPKR4e81bXV60nfUM37F6+VDTBTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777244;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=XXxeck+ZchWgLVe2LO6Nz2Gb7M6JpqsKo6THhVTlwlM=;
	b=FnSv6HUDSYLqz3I0/qRZiwd3/T+rLBt+POTgfG69RXY1XUj0NVMPlv1uCfHuryW7+fGj
	 nxd2CeREEE1aHfgNhY2/RxT+G5kV9TMPDwLoDNy9Sft7yK7CA9oArIrejUldGKgW69L9x
	 joo161s1E5Rvxwb5KkfbSM9QtfshZ8vgCwD62QFh7G+t29mwNEeb8wCWkjpvvo9TTffC7
	 x8ZnIA6H4GGGtLeG1U9yzDJ/tV18akYYP0Gj9QqX2vImrU663YFC68ZkFdSL8xrtewEsW
	 wkqVuZ59ROR74N3icEru5ZR7fo2Q26WnASh4v+j9130qKVD0TIB73q5O6AgI6u5pwFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=baoyDKlA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C5C606A31A;
	Fri, 23 Oct 2026 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=baoyDKlA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D262F1F01825;
	Fri, 23 Oct 2026 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777244;
	bh=XXxeck+ZchWgLVe2LO6Nz2Gb7M6JpqsKo6THhVTlwlM=;
	h=Date:From:To:Cc:Subject;
	b=baoyDKlAJKCKhMmqp0GMLJqdPFNf0xJBqblNYBWPtprczprOaY73toe2CBmesuZZz
	 euja9GB11JejzLU4BPaZBD6c+y97Vh3j1n0dqyhIR4OLZQF7Uhno9dMNEwvLsu5bLi
	 q6fIzA8F98G2sx99JoWwd3/i1eA+UvKCC/Iq5tNP8HHgsmDm6kjpx931QCIhG79Xbs
	 Witm5q3Sfa193NCi1USgvINyWMVA102Xw3g7QsDY5VEEe54ExBYc+iYzPDYXkmP+9P
	 DpoiF6P62CrwMvcU3Dy9I8tz/sIFkT/wx54mql21X7MToVR+Tkh5awR8upG6+SSRfz
	 oe6iO/CP+3Q0A==
Date: Fri, 23 Oct 2026 19:40:37 +0200
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, linux-api@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [RFC v1] man/man2/at.2: Add page
Message-ID: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
X-Mailer: git-send-email 2.55.0
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
	protocol="application/pgp-signature"; boundary="llh3r6rczd32itqt"
Content-Disposition: inline


--llh3r6rczd32itqt
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, linux-api@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [RFC v1] man/man2/at.2: Add page
Message-ID: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
MIME-Version: 1.0

This page documents conventions common to several system calls
(most of them conventionally named ...at()).

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---

Hi!

We have a lot of repeated documentation about these system calls, and
each one has sligght differences, and some syscalls even have actual
behavior differences (such as some accepting NULL, other not, and others
documenting that not while they most likely accept NULL).

This documentation aims to unify the behavior of as many at() syscalls
as possible, and document the odd ones explicitly so that differences
are known and justified.

If you maintain or know of system calls that don't behave as specified
in this page, I'm very interested in having a disussion about them.

If you know some mistake in this page (for example, I have not yet
documented anything about NULL, because I want to have a discussion
about it), please also let me know.

I'll reply to this email with a copy of the manual page as it looks when
formatted, so you don't need to apply the patch to be able to read it.


Have a lovely night!
Alex

 man/man2/at.2 | 166 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)
 create mode 100644 man/man2/at.2

diff --git a/man/man2/at.2 b/man/man2/at.2
new file mode 100644
index 000000000000..3d50e92420cd
--- /dev/null
+++ b/man/man2/at.2
@@ -0,0 +1,166 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH at 2 (date) "Linux man-pages (unreleased)"
+.SH NAME
+at \- identify a file at directory specified by file descriptor
+.SH SYNOPSIS
+.nf
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
+.BR path_resolution (7),
+.BR symlink (7)
--=20
2.55.0


--llh3r6rczd32itqt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrbnBUACgkQ64mZXMKQ
wqmh8w//Y6X9UOCAO00E30MQnkWJjpp6NaUDDxBDkq1ZJY5q4smZ909s907es3MY
FRIz6UHqbQNWaGcG261tSO9PGt4M2Nf00rfGGrjtwaQkuQeN/rYMQwcxGULwQiGD
uinFagDVQ7wKtsgXVD+aY0YJWDPFpQXegKvGpls36ep1pm+U+IOfpDraz6RsZfsi
o14UIwyzYBK5W8BQ2UzyRQbS+6fYzNq7PlFh4MDafIWAuRWDMw/vx8dJdabjqkMZ
mNz9019C3iDFhJpjoC/Ev/sS5AlRu42spRtpEySqIMjDDfBZm5tzuI0O2pGtbru8
vpi69pLUoEC/hkk2/TCEuPMuPgT1esoclqNY0HPFzYIoTwXwIxKI6poYdNtmVdG0
A/3Np50rUCPxhulU4S+2voNL/2rRAYqoIX9JXCH+e+1Gs3PZ8hkQqbZNsVs4mx2Z
5iMgoXWLgTi8h8rX1ZlTtVL3r9P868dgEPcMKjKOVjmXBdOA49N3eIinlPjtuRfV
kPVw0n+bEQ7yl+/P9thaQTAQS7zP42/KBB4xCVJkf0B9pk8/OZ2fssC8dIACpjCw
gpeuSwKKF+IDc2Wn18FI49ukaduaNmAFjJJfJSgsUBeRPneXoI5/ToZF+HPqvRQv
P015OMp41Zyp87DVVqbjA7ucIvkJY26tzTWV8PkUh2/cnQHU34U=
=rpME
-----END PGP SIGNATURE-----

--llh3r6rczd32itqt--
