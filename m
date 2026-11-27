Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795769326;
	b=I/G5yAEUwFozPp/6fE2XDDSXTXdYLG6c9Z0d3VFigbAVnkYIrLjzOlNxwtilVawiqXcM
	 VmSNn2D4bgV4jV/NAmaZaAmX8++GLu39B9tQgZiPjrf2DJQzbr3wHTFrFI5HIMFFD/T0Z
	 /wX2I43OVTukp1CSk08qifwazzIjRPITIvW842o2RoBiiD2YBtiDOj2uq5RyFbD0fNov1
	 iNPBswEyTY8/jDrgS3D+Wz4eHMWPKHz5hoQlkAJeJU5fbHIQZJHSFeKRjJz1QIj4Q1Zos
	 XU+LkjAN0m7IiXnjdQVVar35rBPsheqyDAh5gkymmxt+S97bOpk0Witg1dtAnSoO1jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795769326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
	b=QKMHM9w500Jt4A9hVtz++AvIg1OvQvMJXKdQ39vgc39OPxYFVPfElzGHfWJJzKihvxzg
	 96dhkM2oyHSdmkyLAEy8hLgInLDCIvTrtkbux281MfzHlmh68magRwdLeMYcLtUXLP4PK
	 wryhMECKMwr5IRT4GkQvLwNrXqUeSi8y+3bhqTBoay1iQ843o3SQ3LImp0fpH9kwF96Ls
	 v6iGN7dsl8xUeOAPO2hvBFLHOgv44rXGVzOTbZRxjQQtrI/TS71PMCrjrnb26zbVLZbOm
	 3OQjW8KOZ4sc0aXH08GLq4HpqazJwFvMS7VNjgl45kZzBBtWZrnpYmli5jHDq2dfrPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbJOZn5M;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB5B606A329
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 08:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AB5B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dbJOZn5M
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb77a462c6so63442725e9.1
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 00:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769324; x=1796374124; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
        b=dbJOZn5M3rCgRLPPOUJ++VnJKMJQm3Ohn3x6VlLjqOyC2bNT9/mOFF1yxLOyrzF1bl
         C+Kj5lfk/G5v+Ibl6kXxQpP75b5N2GOnPrygQfOpb+hL8pJdLWW2ruCSdOPWljpoOom9
         3k2U5q90CgtKcvQNVpmkgFpbHw4JRD8hnkpuKZMsHjBoE3LC1jnUEnzmSEuovDxk9r9t
         Wtqp53MEml1QkDIqwqCWvYw2/rzLoJc4/KbtnJ3GcoNMKSCSq01qjbob847q1eNmgWQu
         Cney17f61yibRSRiKAu1tIAGEODdNaIqbSZsxA3cV2i7XAT3GC/VSTY+hR3Urp47LrxJ
         8cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769324; x=1796374124;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IDez9NqT7Tj1QDvV6FYEN7zWNFn2T031QM3aseBOhj8=;
        b=Wf4/5MLdSc/ZvMyrwlirR0yHOcv4vtSvCIwkRiTOyW+7S9jE5iAOMvBdffl/Dzwi2I
         8Ut8Er7mZF3d/3lTPhxuskiQmscXyaNtmTmET+3WnNQXEIsCwtMarQdYCZTA7g2pJqLg
         7j0cSWpGMvJpQ+lX11KwGXphrUj7ehvQ9lstWhWvFRbjaT5Sugp2KnrroQYNeCRB7NGR
         S1GfEfAYNdhiH1rd926i17DM2YXGFLw86jTKmZ8b6rvGjKSyeb6IZb7XKCiJ8cJcXzV2
         1V2mrd3E9RV1IPHGQX2b5FEOTWfIOVF/oY0iUkecnL9JEniKuFlB8sIivIcov7rKSQym
         GVBw==
X-Forwarded-Encrypted: i=1; AL+hErEqxNO8HOiAICBrHmhZ0IzNQ0X0LIJ4oW3TM+zBPwR3KGfNDousxSN7jaSzlPgcoRHuCP90yY2k7YM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+XOgcMagPcLiFQouolVaPpo2Uk7ZlPsUgj/gGQdyiy3uHI2Mgp
	WYG5nqgk+aqju9rf5q3bQvddoVzGgP91ShVr1Ruud5m/C7u7rmjPmAfr
X-Gm-Gg: AZFdTZc/n2efh6OuFa6PmosjwGiWJvKZvr28qaLC/JwcqvWhCCozbELEz8qyGyK5FiV
	Do03CTU3H1TrC1KW7c6idYogXTTbx38y2DpW22GGXdUTd3qyZckFm8XxEqwF/CzMq6tUR4aX49d
	6XswFfL8rNl1+y4FhXENP751d/BmHmWO225FV1ryJ/HkEHTs7RdsQxlyqVK6uNujA9rEPzI+tDU
	O9L6iB+nAJSb0ctxbxwI/IZvaGXbf3Paa+5Q9zvObgM7ESlykv6IKB/ReTCM7vz+5UQ53ajXCjw
	BS/trpZ+cqZPpGG2ZgAaG3agkSdYuJ+ve1kH2WmnF2vIoOcoNEwW+ow+yYaZB2+rMdp3uRmJIrz
	A86tV+lH3m5U910vgRHP0bNQu3clC0ERWTydFvCRLvhd5q7teAdaPuIzJGU5882Qsa8Z8i63sWF
	tL7BAXkNG+2moCpKuwZ3FAIi94Uga5j98oEWp86eIEyAeDEYL7LrSYghc1Y93TF2+alnKRxkciT
	Grb5My30rtMvY4lLZ2t3pBaspJRNu35Ye6S2yM2XAIl73l0bET+avYhM6pr6R74LyOSmpI7lRmh
	jDjJKbbUKoIVN+zXXQjGAsdprOs5K8DXIlQfAE6C13FwwGOQYglR9AnyKkoWqrBhFm19Yw==
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr454676765e9.7.1795769323802;
        Fri, 27 Nov 2026 00:48:43 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906635c7sm426511305e9.2.2026.11.27.00.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 00:48:43 -0800 (PST)
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
 boundary=c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 09:48:36 +0100
Message-Id: <DN5V3F9BWZNC.ZIJY7Q6XMDOM@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Greg KH" <gregkh@linuxfoundation.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-2-koray.fra@gmail.com>
 <2026112647-earful-frosted-6ef3@gregkh>
In-Reply-To: <2026112647-earful-frosted-6ef3@gregkh>

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 8:05 PM CET, Greg KH wrote:
> On Thu, Nov 26, 2026 at 05:31:11PM +0100, koraynilay wrote:
>> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> in the main body of vfs_fileattr_set().
>>=20
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> Real name please.

Hello, this is the handle I use for everything online, thus my "known
identity", and even Linus himself in Commit d4563201f33a
("Documentation: simplify and clarify DCO contribution example
language") said
> And despite the language, we've always accepted nicknames and
> that language was never meant to be any kind of exclusionary wording.

Also, I already have a few accepted commits (here[1] and elsewhere[2])
with this DCO, so it shuold stay like this.

Thanks,
koraynilay

[1]: https://lore.kernel.org/linux-cifs/?q=3Dkoraynilay+%22Applied+it%22+f%=
3Ajeon
[2]: https://sourceware.org/git/?p=3Dglibc.git;a=3Dcommit;h=3D29803ed3ce

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawlD5AAKCRA0bnTtJTDo
OA8rAQDeEx1D2WxXRvyGunXEuOW+Cj+dElpy7MJchlEm/WMNBwD+JvucXkEupO3z
6yiHSY99QVuCP3aqlN/orccezZlLGQ4=
=mM8H
-----END PGP SIGNATURE-----

--c6f8ca06bd0087fb130def184d18448cb7c766d554c063c5f32d1cf88680--
