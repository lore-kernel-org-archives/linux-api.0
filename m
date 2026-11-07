Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055664;
	b=SlRtsiBlCWgKbt/FqCqDKgSWSO7h1RgyADlqzX/COvVXhavWa+3yMoFUml+Xlt7ZH8y6
	 dqxOaHMMUtP3yYi+uF9n0kTvAHQ5C4/2SLUzYd48i+PyQEHerm3PkOa/VMosZoCDH9ZQS
	 uEUdIH/EEod73pAPIzegE5OyCb5SV/nWHeYJtkBHTciiCLZESRfeLJ0e8JXlEC98BKo48
	 DmF+TofQuvWg/iRryh1FD6sec/EIxm4JB5pFrxdwFRKEV8tpOv8Eb0p4RYrASHBns/7+m
	 QzJOrqu/XDC8lmJCbByFYVMWriSZMq+nePmKlrBsVjN1zneT68R6YkwpdctYuMq+FBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055664;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OrAMJFfKZ1Qm4VG2pMI1kLTUY9ImBI614Jwwvu8bmAU=;
	b=RgV2+e5GiiJ7/DQERmBBJ2NLQZI9Gts6ZjNF1TgGENQp4C1pBmm5zlszr2YAMYLsVXxg
	 KFGuXhk/n0TJZ3ZrvRRirhGNCKeJEm1BhFTQFN5nVeTZ3LOctwLeap0GgtZEqLIBrhEDI
	 Qd7bjfqt4ZZ+IlRj+9VLipg8QYx2PvLlMFZjHMT4OGZ/aP9iQ9Q/e3FBkLlFctpjtP/Hq
	 359zUO33Bqg7QwangJlMaBTvQVf8ixAattZQx7UxeEBVh7WOaykpS9w4ZcZeyhqet+Mgz
	 e+u0F3cH4czDs6Nsv9/0ppRkjpzavkEvH9MkjSQyTyaLw8PXHQiDvye74R4sFlm9bpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZX2bluSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52CA606A326;
	Sat,  7 Nov 2026 12:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZX2bluSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC291F0089F;
	Sat,  7 Nov 2026 12:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055664;
	bh=OrAMJFfKZ1Qm4VG2pMI1kLTUY9ImBI614Jwwvu8bmAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZX2bluSe0zEAhEEjZ5zzzRFnhMwDxm+tnoLW286eRyHKJ+EEbfK/mYI2JAM5uMUOx
	 4UWfo404QQHFsdvLI+7PaTf6PbuHGIbEXhc/qZuw7ehbDQknnn/TZ9tG45mwVwvUB5
	 PA6ICV7NxllvxHzcdClDXsQiQfYpqVfjumoL4zoR5YRb4uq6aPHOWLeLK6HnbLyMu0
	 Oc5Wxp9Dk5UM/eqIUEsYzp+SUbvwxfbypJHx20ES2Hje2M/5kzL5EI0CxJ6SaGaGoS
	 LUyXeM2xImC0b8U4+Y5rD2D+SSkHHLL0NjY39e0mAOtRvOdoIBadzsubQcY18X+Frd
	 i+XrOP9/CIvbA==
Date: Sat, 7 Nov 2026 13:47:39 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 0/8] Add at(2) manual page, and refer to it
Message-ID: <cover.1794055492.git.alx@kernel.org>
X-Mailer: git-send-email 2.55.0
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
	protocol="application/pgp-signature"; boundary="x2dv5v5o3mxdnujt"
Content-Disposition: inline
In-Reply-To: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>


--x2dv5v5o3mxdnujt
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 0/8] Add at(2) manual page, and refer to it
Message-ID: <cover.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>

Hi!

Here's a draft of a patch set for adding a centralized at(2) manual page
and using it elsewhere to:

-  De-duplicate documentation about *at() system calls.
-  Make the slight differences more obvious.
-  Have a central specification of how new *at() system calls should
   look like, so that differences don't grow unnecessarily.
-  Try to remove the unnecessary differences, if we can.


Have a lovely day!
Alex

Alejandro Colomar (8):
  man/man3const/_ATFILE_SOURCE.3const: Add page
  man/man2/at.2: Add link page
  man/man2/chown.2: Refer to at(2)
  man/man2/mount_setattr.2: Refer to at(2)
  man/man2/open_tree.2: Refer to at(2)
  man/man2/rename.2: Refer to at(2)
  man/man3const/_ATFILE_SOURCE.3const: Some functions report ESRCH
    instead of EACCES
  man/man2/utimensat.2: Refer to at(2)

 man/man2/at.2                       |   1 +
 man/man2/chown.2                    | 114 ++-----------------
 man/man2/mount_setattr.2            |  66 +++--------
 man/man2/open_tree.2                | 168 ++-------------------------
 man/man2/rename.2                   |  84 +-------------
 man/man2/utimensat.2                | 141 ++---------------------
 man/man3const/_ATFILE_SOURCE.3const | 170 ++++++++++++++++++++++++++++
 7 files changed, 214 insertions(+), 530 deletions(-)
 create mode 100644 man/man2/at.2
 create mode 100644 man/man3const/_ATFILE_SOURCE.3const

Range-diff against v1:
-:  ------------ > 1:  39bf4d24176a man/man3const/_ATFILE_SOURCE.3const: Ad=
d page
-:  ------------ > 2:  56086d43dbe4 man/man2/at.2: Add link page
-:  ------------ > 3:  7fdc286a682a man/man2/chown.2: Refer to at(2)
-:  ------------ > 4:  c206656df161 man/man2/mount_setattr.2: Refer to at(2)
-:  ------------ > 5:  4e8ce7b9cf9d man/man2/open_tree.2: Refer to at(2)
-:  ------------ > 6:  8a5ac3f93ba5 man/man2/rename.2: Refer to at(2)
-:  ------------ > 7:  8ae17f3f6863 man/man3const/_ATFILE_SOURCE.3const: So=
me functions report ESRCH instead of EACCES
-:  ------------ > 8:  3de33c76083e man/man2/utimensat.2: Refer to at(2)
--=20
2.55.0


--x2dv5v5o3mxdnujt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHeoACgkQ64mZXMKQ
wqnX2hAAt6d1OuqbPlDXskt4StJ3AgRLlsx8evMqsigYV9tkUrcYk8U7Buw4abTC
cHz+w/8K/JZct2AcFDTr0/0ZJ06236N4w/lG2jXDXi37H8D8Gm2iVR1wSmC80GQp
3ZXUHzFR0vz5fZM145OtPp/D2gMo/k3XXRVr3YO2ugAlyFCaIdI+YY+rcK9n98py
jyar1hJFwQyy1OaX30QSZvkWRTn1O/O+J2WA3AfVUN1Jl/XGoCqD2pisIK2VIMuV
VV3CnTBIhfMAVCuAWTS1mQv4Z6wZnQ3SDjliGu+6nzvFGcQ0/1B0QikfyMM9fjlP
EsZb4mzo/iMigDbL2RzcmA8kF5k5dpLpWvvsUN+vEJ+uBOwga6TdNSv3bDJRijzb
0Ll1tAlQZ+tFrh5j8DEXEEASql7h34Nj7kFoL5lajZMOpsprC0XwmP+AhYoicjO3
RnvB6sUjzkXbCh6+Jr4lNT7Wnf3sNh618u+ZQchoDj3iCVnUt/Qou8sxNR5dppaU
UZymlDkt4nOnyOsO6Cy6gJ+Jn+9OclyxqD33mi1zb8Z1+JAvlyLRtuNpE4yy5l1D
henyaYOqeKOGkZ9kojWM1COYkUClyndC2hUcl7Z9HQXMXUVGMSeTBQviCKnqcafB
UZQ7uNPm1QXYKc8TyiTFWOVm0bExHg64bv0m4wtn+DXaptU8TLs=
=RiVX
-----END PGP SIGNATURE-----

--x2dv5v5o3mxdnujt--
