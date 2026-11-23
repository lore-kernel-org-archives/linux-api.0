Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443738;
	b=iJjzZhVWAtJhY9Z76BdCr8KKSKRUS+LCfYMq+5q+ULuyWJLJ7bb24LtV1rg4SHVADwzi
	 hEcojXw3e0KqA5ED+J1LkAQuFawy1eCPklUE2gGeWcf79wvPOUPI0SGiy2zueW2H5wiEb
	 0wP2bolxU43cJ4mFlGx5F5pr1FLUgZTcp9nNz4Y19eNDaTkiD5AakJU9AsV9fHOZLOtSO
	 8stwYZe3rInrGYtPx66zEL3lR4rJI9tBYJUXVzWxXPXAtnc+JP4p1zia2cLqfEhX+v9NS
	 W4RAdLVK9GDHCBpYGwGTkxB7Mpgv0VycB3dY9461LdS4j3y9oeKOFKpoDR6BevNUedQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
	b=rbDHWmGUKwt9l3ky3UgjBsqUPRzgOvTe1XmCEEjpaBBn2ZlnqOohNBk0+WDbnNLSDqnF
	 rdRnG2Sjha+324kkZVqH0CKil20+Vz/RB7c/xkKURjqYj6Ax+gLVdcWPp7u7RSlpMjT7p
	 v+Q6SvuEveaF+BK51rlb8JomAzHAc2DplYmoRHAsKK3EfSBUqWd1ZUZ/yGk0B9jT2HrwK
	 Be0yJV9yQl1Q/FUqCBaCqOuhJ924LhOJsZwze95glWrp13/KqH8CfKcgvMbklQJn0nFjX
	 iP5rMC9UdDxzcR17fzxf082TyRv0T5qgv24lFWL4Xkgkw2X9pd2+ToBsR4/ZgW5/ntw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00fZwspv;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E056606A338
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E056606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00fZwspv
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so22722415e9.0
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 06:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443737; x=1796048537; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
        b=00fZwspvrkZHzlXeIp1sk0DPnZy6zbXYi6zIJ3d5v+w1NsTls89lOgHp7t/tKAch7D
         Hd4wIO6XRRuOp6DsoVpuy1fI1JBPDAuB4H2ar/Lx9QF9UMM3I2Bn+apTm6C02HriyEjS
         KA72OMzw0B/nPuHEn1s5VR5vbpTHGND2TpdI0u8SjlASUOf9KvX7qqbdv4pthaNSOPjC
         CBP+ouQep439U4VPJ4zVW33k/OEd+wxFLAmiROh0/cG1vbpp0ujnO+YiOIBm4UWAjdd7
         OjHijbDRGvuUxSrmtMDu3hyafB2uG4C7Vi4d2cljbIB0BPnpF3JySA7ndBemr4CxbXa8
         8Zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443737; x=1796048537;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
        b=kXvKtjF38ixCuYBSUFs8gFlqLgMEYnQPzp/JSOeoKF/LWrqyDIadGwFWEIEr9EQoNc
         +hGM4l6GKTiApoaQQT9VjJPpzR8kwnwzilQ+Q46Vm5SoFzLyAUOBuuSgRwo+ZG0hWJZz
         2sEgAIoVQ/jr4F/h1dVW8MCcQz1B/6NcDQO+9UxvAPfpgcsOWa2g6UgMc8Z0D6cYrpsn
         Sg6DLr27sfkN+Ts41Iwdt39ZR+FtjfYm3xh8dDphFtcnFtXVyMgr5QzoxxfqovsdX1dz
         FHwzLKteCL/tOmXyOArI7kYuejimlyuE4G4n6gQy4DtDdBXPOAH8sCe8eM9WdEyW2UzI
         IIGg==
X-Forwarded-Encrypted: i=1; AL+hErGiUqeSds6syBMt4J0otsg5AgsnK928lRn+PsAdaQ8bdueZSYqTu1cRFcghIBkfVF2utcrkjp/aAzU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+SnwrhwqiVJ9aQx1WAXhDIFUpeMJ9pkKc1NlwV1kXLKRwzu08I
	UIXra2pjoSDV4kxy6gFDKORt+kS2K+w9HpW6nYQktQ3iWtOM+amaKznz
X-Gm-Gg: AZFdTZdsTFrF5/vKEGMMPoVl+Eb21+4Jb/u4vnqDiqCHYAKWXlfDwt64sNT/Gw5qYFM
	zKFmDTPRv82Td/3iDhRKpqNtLthlAxpPIQX5KXfsYAA36Qx3Buip1Zky4uQfSChzIskj2qbEK1W
	LilSEBVwxkWvrtfHx1nNFKOZnBRFVGWa30UZUSoaQohhaY6NpdjwTdWNgVy4lfhyx3Mw7PTqL3W
	MAabOL7ViHuw0ZdI64xjyUgc2XWkaad6CmQzsl5f6M2z9qRHCz2pcT0QZVz6xS+gc6q+Dd7B2Y7
	J1RFM94vNzErM1hvShVNQpFM1gWF3DdOumAxX8oa9Xs698FoA/zntwaaDVFGXE2keF2/2gdsTw1
	K1mbQm/yzHV1a4Q1OxAHgRCKD4cN3gZB36N4gwQX4ll9zv5sv2tLrxag16VixpLmqy74dl4VQCH
	hIlSs+Inh1FLz4UOP1aOVzRhESRfYMW9GGprF1RG2rLMb0uqYTLJRn1QTEEWA+xmRSXYsWufOom
	EaWeQEoaiyc54aB19f5nWjnldpHkz9UI/333rvZoPfcrYRPr3entnWRbWTrg5ma6cCI0p5H804M
	cEQZylFehDFudlCnjodOsrYrjA==
X-Received: by 2002:a05:600c:64c9:b0:4bb:679a:86ee with SMTP id 5b1f17b1804b1-4bb88938dbemr253115345e9.29.1795443736768;
        Mon, 23 Nov 2026 06:22:16 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm170939525e9.2.2026.11.23.06.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:22:15 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:22:13 +0100
Message-Id: <DN2NOOG9J6HX.1L4IO84SKCYOG@gmail.com>
Cc: "Andrey Albershteyn" <aalbersh@kernel.org>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
 <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 3:18 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 3:15=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
>> > On 2026-11-22 01:08:54, koraynilay wrote:
>> >> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> >> in the main body of vfs_fileattr_set().
>> >>
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >
>> > Looks good to me
>> > Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
>>
>> Thank you, can I add this tag to the v2 version of this patch (since it
>> won't be changed, and link to this thread in the comment section of the
>> patch)?
>
> You should always keep RVB when re-posting without meaningful
(RVB =3D Reviewed-by, right?)
> changes to a patch.
>
> That's how reviewing works.

Ok perfect, thanks.

Best,
koraynilay

> Thanks,
> Amir.

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRMFQAKCRDmj22qf5IG
XCZkAQDH8wiuPEqDaB1cat+NLbwVTy9AgTGpQeVFZlTodz2juwEA00+c7xq8+RtC
rQ07nQ+3av0Gvb1S4BH2IP+66ik5awQ=
=/Ubu
-----END PGP SIGNATURE-----

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde--
