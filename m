Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792777330;
	b=1qjhLYT/eU24AGfnLCfaEGLaTFZoO/4Ld8FcRNEP/jWWUwj4HotB2hLrPYy3mDDBVC+V
	 E3ySJZ8DgMzKQiPzEkgDLRQ3xvE12EGIy1fm/uvtSklJbSEKhdGHqTXgbwPbp/Z8f5Zb4
	 wh6V26cSIdUbr/mWaPjsO3LhDpgRdgYyJZjECAUhQh60OiiqAmutGvHTL7R5JXwmgvVOO
	 jID5Ih56eCYUbiadC/oxsj01t1P1lKH5wexIZkRFS3+QGAdV5UzcT2zP57MAUeM2rvChD
	 77KaMWNEYYYSrz5hrN8hpGvn73JAvRUJ94diH8PeUrs0ZFi4svsdSyMMHyKz07zeWNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777330;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eXk5l7CEoxQFdVixmtWhhVuhMbVmh6Cu4fYEPgHaKvI=;
	b=JJxP4i/nymcS2L+PnOpdW/a2wo52b7K3XC1FnDNXH5qzPIM6gCQuY5yt2rV+hlicuZJ+
	 GqpDvdjdx2VUsvIpMBabvG5OAL+m0WJR0KuftmMQ64F2DiFi74xsOYWBqw04b6Pkeg5OI
	 DJTz8Eas4EVdKBA5PozRy9nDBhnjHXb4ovMSG0EdCWCE3fayPn/vQjlUjJNifHltuRGKH
	 sN07WL9nWnDX30a5fJI2LVbJDn0NxyT9ex0MEKtCwYuDTVndXrsRm9U3ikAbbkA9dMAuj
	 YpWxH7PNIsu/6gSdSgrHCp31dtamfKMEVPCvvpaK1JN+bpeZILQxu34sX0SpLg0AKFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dTr9Qcd2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF82B606A31A;
	Fri, 23 Oct 2026 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dTr9Qcd2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719691F01828;
	Fri, 23 Oct 2026 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777329;
	bh=eXk5l7CEoxQFdVixmtWhhVuhMbVmh6Cu4fYEPgHaKvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dTr9Qcd2OcUxg4fADEf/F3yQLEYE9KyiORXy/wxcPDMBSn//lwA6im5KANPxf/Dz5
	 V9Yl5GRV/4bcAhSW+I7lS7sbOJWsnQ6w5uPbsBSkyOoO7TATqlhX5NXdqDiFgnZ9n0
	 3Q3Y6r8mqKh5+0dm4u74duS1Esb6cwjjqkHI7+/aES/UxWQj5Wy1GAa4M0KD2K4mgS
	 7EcDhAvhl/vHSom6JyUAP/PPkG4ywdLtiUnO+RePCemTL/gwjduu11k6y+ev9Wa96w
	 xzuYPXIWBR//iwd6uUnsYW+MT6lXXHu6i/EyBgXxQidLopKoRGQAo8Tj/jMuHX+den
	 /bn8vTwUlY6Tw==
Date: Fri, 23 Oct 2026 19:42:03 +0200
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: linux-man@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <atucS0sfOWjgtk-d@debian>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="iidozeguifen472x"
Content-Disposition: inline
In-Reply-To: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>


--iidozeguifen472x
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-man@kernel.org>
To: linux-man@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <atucS0sfOWjgtk-d@debian>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>

at(2)                 System Calls Manual                 at(2)

NAME
     at  -  identify  a file at directory specified by file de=E2=80=90
     scriptor

SYNOPSIS
     #include <fcntl.h>  /* Definition of AT_* constants */

     long ...at(int dirfd, const char *path, ..., int flags, ...);

DESCRIPTION
     The *at() system calls perform an action on a file  speci=E2=80=90
     fied by the combination of dirfd, path, and flags.

     If path is absolute, then dirfd is ignored.

     If  path  is  relative, then it is interpreted relative to
     the directory referred to by the file descriptor dirfd.

     If path is relative and dirfd is the special value  AT_FD=E2=80=90
     CWD,  then  path  is  interpreted  relative to the current
     working directory of the calling process.

     The flags argument is a bit mask created by ORing together
     0 or more of the following values (some system  calls  may
     support more values).

     AT_EMPTY_PATH (since Linux 2.6.39)
            If path is an empty string, operate on the file re=E2=80=90
            ferred  to  by  dirfd (which may have been obtained
            using the open(2)  O_PATH  flag).   In  this  case,
            dirfd can refer to any type of file, not just a di=E2=80=90
            rectory.   If  dirfd is AT_FDCWD, the call operates
            on the current working  directory.   This  flag  is
            Linux-specific;  define  _GNU_SOURCE  to obtain its
            definition.

     AT_SYMLINK_NOFOLLOW
            If path is a symbolic link, do not dereference  it:
            instead operate on the link itself.

ERRORS
     Some common errors for these system calls:

     EACCES
            Search  permission  is denied on a component of the
            path prefix.  (See also path_resolution(7).)

     EBADF  path is relative but dirfd is neither AT_FDCWD  nor
            a valid file descriptor.

     EFAULT
            path points outside your accessible address space.

     EINVAL
            Invalid flags specified in flags.

     ELOOP  Too many symbolic links were encountered in resolv=E2=80=90
            ing path.

     ENAMETOOLONG
            path is longer than PATH_MAX.

     ENOENT
            The file does not exist.

     ENOENT
            path  is  an empty string, but AT_EMPTY_PATH is not
            specified in flags.

     ENOENT
            A component of the path prefix is a  dangling  sym=E2=80=90
            bolic link.

     ENOTDIR
            A component of the path prefix is not a directory.

     ENOTDIR
            path is relative and dirfd is a file descriptor re=E2=80=90
            ferring to a file other than a directory.

VERSIONS
     On older kernels where these system calls are unavailable,
     the  glibc  wrapper  functions emulate them.  When path is
     relative, glibc constructs a pathname based  on  the  sym=E2=80=90
     bolic  link in /proc/self/fd that corresponds to the dirfd
     argument.

STANDARDS
     TODO.

HISTORY
     TODO.

CAVEATS
     Most of these system calls are named with an 'at'  suffix,
     although some new system calls don't have this suffix.

SEE ALSO
     openat(2), path_resolution(7), symlink(7)

Linux man-pages (unreleased) (date)                       at(2)

--=20
<https://www.alejandro-colomar.es>

--iidozeguifen472x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrbnGsACgkQ64mZXMKQ
wqlMcxAAumTA605GdKeovY6XSzsaqa2eMXpdEkbnoXT4R+k0mrfpu532GOb3EImK
vE1sgo5BfuO6GrobGG1UCfGe/boLrV8YCsFku5UHUWZBUB+TYLh6O7LSfSskdVtR
Y9bLhYOsGfMOuMS3HbUEhDo4d19KPw43+YsZQqHq04xLE5LmVveu1aHhHn7S59up
T5+fVDsdwSsMWJ4OuwMAXsJ9RKSwoAnwRkQGaAv9xvtpx8ZIywPDgv32K3efHLbs
R+BAPrRYgI/g1orgAi0OEueBib0X3uUzTKv3xHmlqPVZs2BBXZdQBbknXgl1XSgJ
//wzWmJ30LEzSlTmAeCwssM5lD/oTvAjqQp8h7OKTc4ZE69nULzLmy5VDYB6a8Fi
bNuEs/fqsvzRBioXTDxwP50bJqtOZVd9GmaGXAvekLnn9euiNMxeIEfEgguXm9D3
rEf8AbylFzTPCnOioT7DXmLkQ9KG6C2dHcIQrEy4Zm2xBoeeA9YXkL+K9D/O79ut
sjmu7GcoymO/nSJck0b25ioLoSfsDlb89MjoWFCrh2hXswlqiL1NH1ncj14P/zes
f0/WK/rZc46oEVrlP/aw7FMQ28kbZcxiXDp46q5xXL5SyuGizk1jPjBJI8WzF9pa
mEZTJGYCpqJCeXLGbvpgjEN64ahi2hGq83j2aTEIv29j+skAqgI=
=fE2a
-----END PGP SIGNATURE-----

--iidozeguifen472x--
