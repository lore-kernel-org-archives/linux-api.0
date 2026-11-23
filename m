Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443330;
	b=avbldBLWB5D7/7V2rVPjXiyE5quXIpZ4fDac61/oAhw7hHpsqhaXF0CNqUinWzJ6kqEd
	 qoSy6iR3MJczyJpmxTfB4rtfOFZv9XjKxu31WOMAypNjqb52HdnKzye26jRfPuw5KyH8M
	 QfvOpMz7Yoev1uBEJugGafIa5+zHI75TDeesL8qmLZiAcxJWBan4mFZxo910h3mWWeowu
	 3NhsfhIHKUXAx7FMklm1z5qBuORGSN6QMzKIqzs4UxXmg57KzL8SKowptNDcOpfK8enUn
	 xTCgiT8X2n3yJ6E+yfCLC+jbjuSrXJXqHK1EIAb8yQQ9PZhmcPyEpx4yghYPWsPxDxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443330;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
	b=ytIa1nc3b8+fxIYUsPBGZROrKHGfhgxK96kxZU0R7v5fe05ztk3n+rPfkohaN2RVwsQi
	 X83m8N1TTs3xRq7G2+QHKb3Vv+0c6+K0B6j3NZZn+bWID4kTpMhqi6v6Uh19fyT5IPpjH
	 6wbiA3+IaC9I/pjeK2pwoLz8ePCe8fdl5RoWjy1yERjBgPtpUc6OGLdN5l9+JAqNjUqU5
	 hfYA9nDaICeU0Os8EoPeWQ+FCU8J2Yoo3/ZpdLzbVopA649UGlgpMWGF5aUM9vcjBVInp
	 SP+DB/b3mXVwyLj3cUgo55SepctTQMOgZ49KnpByvTm0iZUjuz6zFp+gkMxwyPkPVIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LhurUaLd;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B682606A33E
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B682606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LhurUaLd
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso1544015f8f.1
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 06:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443328; x=1796048128; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
        b=LhurUaLdrrD6el1BtOOCJ70R+8KqK05u0u89mfuXWG8+J9Bw3rVb386658OMP5zMq0
         decyq5yItprIln2niTvSLmNubbRMdoF++9VmjkmrA05HZdXvZxDurdMDYBuXSM2/ru83
         DL0zGzc4TqwjCvYZ5gt34/pSFJf4/mCtDoKXgpXPt+Sv7g1Y86AFw3XQ6uM+o5M48dZA
         fsqr7/KfuhPw2PRwDKKUwpkICKW7wj5qvnFdYfxcb8shaROlLIM069A9F1sNO6bSCk2N
         auXzk8QjTdj3SnDJjqubihTVZqQWZzgbhHEkWSyJVafh+Xk4iboolLWwWkG1XoRweIGi
         qdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443328; x=1796048128;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SVkCiAZ9hVspPzZuKZbqXCYeKQk4BcDbwlCFk9p1ut0=;
        b=TPyZFsaCxijm7+XMRW+dtjgFkmWNZmMEGsdf3zoKRkeRyKWTJSBcFMF+KADdl1vLbB
         RNt0f9KE3Em84ByXju6jQP4utvIsSiy1oK+SZTnyPd2H1HGFTDzR6qBG+dVh32+vH/U0
         cLiko7ELeKeoJihKuyLTDJfYpTXiL+0Hh5n+DD4xW8+mJ+WYGhhreWw8uMSk1K9q8MnY
         pcoWnvz3SaV0HzCCjby9z+ImgYdOJhEvfLPv+IsmNFJ9fUuvWYGNny6P45JSANRt+AZG
         34XO4G142E+lOa6nu8A8JodXVCJI0bn0JYgRpdq2/McJR5Pb1r4xO4GPWK1HaMTPPveR
         Nw+w==
X-Forwarded-Encrypted: i=1; AL+hErFelZZ0QOxaC7jOpgPffa6XPj68Nk1ezQsYacHmENKXvN8KyeoAQuQIFNdua5SZQthENes1CRC2fM8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8U8EdUikh4a5PBi7wngR/O7relE/mX7PubQU3hhF5k1/uyhW0d
	Q54xmdv8B3QYQU+QbS8RtYyJThjTIc0QZs85bL4VWosqZXvkeC5wyWw+
X-Gm-Gg: AZFdTZdFyk0dAb2gcezwVAOgSONPkiG/c8ZhAWvOAp7FNUmfNldFIQ3QirYmNcJ1Kgy
	QTYEgScq7QRJQ2VFvqVmivoviOmh1YMb+X5B1KUJkglyfWVFToTgE/VLStrWcsQgjkjSdglOiF7
	tzMVUqplptbqLqhsXk11zh2fNF4zb13nM2W9L3hZ4w0A2FP+N9PdoQE9TxehwhADmGaF/oUJqUd
	0AO1YC57ItCJVJVx+Q+TyHLyWrgLNeQMhPJkDu1ZT3QHFuFwmJuwcHZrwpVTkXfR5kanVBGk4lZ
	i/yy6QZjzMw5eYCc8Q8K5gFXE6zk4rRAfceoBHFnQmhb5HaOLToWrum7wWlAC8uiYclqJYd0HWN
	WGYstdzOIvRqYXJRc8aChp2EHtTwJuVZPV28XtWBVerqZqgMPfIpo/Ft801n4av2zmwJ2e5nYng
	WNfDrri1AbALTLxReCHj5h6FV7RQvZiYwgmjE+t30jI6k3TSq+oz/K1spTnFpDWDDwjU55VtpqZ
	/PGfEzjyXTbcqf3Yltoja9a9rQuF4wJV/ezIY8yJL8uNqSiZwmEDviEoftW+fPecAkTZMVaDs9X
	aksr7mH7JEvrT09d7QZQ/uDJ5fI=
X-Received: by 2002:a05:6000:4b0f:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-4abad6a1782mr21438558f8f.7.1795443327853;
        Mon, 23 Nov 2026 06:15:27 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad6403fdbbsm15815535f8f.15.2026.11.23.06.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:15:27 -0800 (PST)
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
 boundary=d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:15:25 +0100
Message-Id: <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Andrey Albershteyn" <aalbersh@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
In-Reply-To: <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
> On 2026-11-22 01:08:54, koraynilay wrote:
>> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> in the main body of vfs_fileattr_set().
>>=20
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> Looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thank you, can I add this tag to the v2 version of this patch (since it
won't be changed, and link to this thread in the comment section of the
patch)?

Thanks,
koraynilay

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRKfQAKCRDmj22qf5IG
XGk/AP9j2YLEmAts6UKmrX6qw0EDoHRjv0eLrfHDRJfhkjSDdQEAixfLgqqT3tMt
wDbEqGGddyloPl2sCvNgcE83htldvgM=
=8yb/
-----END PGP SIGNATURE-----

--d4d0d8ea600ad9a6a0e804d6ccca97eae7564ecdc87e5749b6027a98fdf4--
