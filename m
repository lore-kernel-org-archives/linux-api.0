Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055677;
	b=l75I2nO6sn3QtFcVMlFkf64iX1JzoaZLxVIdYlu7NEYPLnlYAjG+0t7xA+n6OWbO5o9v
	 wfrwEY48pLPqxp1eZjFTI51O5XPFoeLxkMfBGdDZ1Fun5oooMfPjHNZIFz00t54TzbRZX
	 UZx+mSoCOlb/08iXa/X/WSRv0lHbRdyB9NmfcUcL1Bq5LTasBN+7gcsKN5kE+6lTHQksU
	 FR4klCZiKflUHApqFL14kvhUrO2EDm4UwznLXpKCAxmIrUqJwK0ZVrx/bNpggg6qsoKxk
	 +PBwa3ubLv87zVdAU3OaTe8ZAh/3l0giVoUZMKHeBSdONGLed+Dg1uu6nacAjQx50lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055677;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oSV566ORFc/5vSee52C2AvM+tcJ5Ti0lHrXLg1VTLfs=;
	b=SqdII3c50k5InRsuBrPbx6Ka9UE2l5wOoG6J30cdK779oAgpw/jXJ1Eo72G67ZfbvR7D
	 t2tswzKHxdvUO+v6+xmtpzrIHGla3mRYy5zr3kW+S0dQWNzqjw1jtY5BSdCXtcLZWTRsU
	 f/vGFReJnLMXXLOg81vlEL5COI9bUHIv1C0iiHxcys2kKry57nO7Nil5P/zQtTmSyWVF1
	 ZlpxeYM4uVNf22rDoyLqggLw0uEUuEiH3cxtALY5HwCzGwj28P1YtebFYY8hIm/xAPp1x
	 /S4gCkTF9sFlZoIkgbCQgFO9WOv7Db5WhX6rrDsFEiqkwwxecm3BQeUAxxAO9hTyn8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ylhv7Q4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273A8606A32C;
	Sat,  7 Nov 2026 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ylhv7Q4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54061F0089F;
	Sat,  7 Nov 2026 12:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055677;
	bh=oSV566ORFc/5vSee52C2AvM+tcJ5Ti0lHrXLg1VTLfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ylhv7Q4KPFXnj/vUeqaG66eK/4LYghpb2taJJP5F269vSnWOAYWocsfCC2UJnQOIr
	 +S+aM0+zo9EKLuDVwgm57Gem4r456RLqCkWMDS72VSdsoQvXgsiUbYQist4DXXWJoR
	 XEu8/38FoPYaGgLsO77t7JRnz+woK3Z42KyifJCeulZy/FTJQUG/rB6tDgCuYzth9/
	 d6JqLKrGMRfDPZqLvI5+h3GrFVlIHmLnqXCrgZC6PpFZJauo3cDfN2MGWWoXWRsW+Z
	 EylfuGZNAozfWAwC6VGHs/zgvFyfrwOc5kgMlQlC0piHJC130Yx4COWq1jJhZdQ+rU
	 /5dewBMkvLTFA==
Date: Sat, 7 Nov 2026 13:47:52 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 2/8] man/man2/at.2: Add link page
Message-ID: <56086d43dbe49932c2e466f7ac6846431c3814f8.1794055492.git.alx@kernel.org>
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
	protocol="application/pgp-signature"; boundary="v3avyowgr74w4p4m"
Content-Disposition: inline
In-Reply-To: <cover.1794055492.git.alx@kernel.org>


--v3avyowgr74w4p4m
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-man@vger.kernel.org
Cc: Alejandro Colomar <alx@kernel.org>, aalbersh@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC v2 2/8] man/man2/at.2: Add link page
Message-ID: <56086d43dbe49932c2e466f7ac6846431c3814f8.1794055492.git.alx@kernel.org>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1794055492.git.alx@kernel.org>

Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 man/man2/at.2 | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 man/man2/at.2

diff --git a/man/man2/at.2 b/man/man2/at.2
new file mode 100644
index 000000000000..e8ec02f7324c
--- /dev/null
+++ b/man/man2/at.2
@@ -0,0 +1 @@
+.so man3const/_ATFILE_SOURCE.3const
--=20
2.55.0


--v3avyowgr74w4p4m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrvHfcACgkQ64mZXMKQ
wqkrJg/+IZggV8aA2LBAGysfp1Wwi6L1aGZaiRK5ojpw8GEHTWQ+5vIGUJ4bw/+6
Xoy9SwyL8jBQ0w/BodDiHyubfBJsNOnWXZ2CIste3qmG4uqpEP3lkxlZe+A059Rr
NaRZcznom0683exnSHgu6w8lHkD1MDPOkcK/tPfGYoIgHK32coGo7sm3cHS7HQ18
cnU8uOwFfkBp4b6sXEvKodQBbsPhIplhEV+SnoMULLpx3anDEXshQDjiXk0J2ZHw
txgL2zli6cTIowKV1flihmXro8C6f09/hDes+KpxHkY6fENCqXzOlgxGUMo9ef8E
GZTDoprP11uYn84ZecNSkeCubbDwN4jm9eUtb+BgbvVhSoc9hSRmFaOjij4U2+vE
VshmtRahbSYb0+BJE0bCfaM6ZHZ0ZROFbR0/mGbnGsFySdEo+notCfhUYZC7yHF/
SwRFnFrUUm8fEfzO1waXJo1II3XDzovG9KandyaMifC/rwuXtbhonyEzPzxZKr/T
OWEbuGqg3tgqX0ezWj9uiWgynIVCxAbDZGe6dsJKk48m7ksJ7oE/L5hKsnQDllqw
cgniLMwJVoCjP33WIm6/+uI0NyorweDqPWSu5W1krRJa1XAHLm2Jzo6FyW9kPz9P
hiT4WAEVNXhNcFAr2/ZcrwdKxmk6eCXKkENPaDNNoLB8iqxXl6g=
=O85l
-----END PGP SIGNATURE-----

--v3avyowgr74w4p4m--
