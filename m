Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795805478;
	b=rrJT/fb4KsBeNLLzHHQrehM7rx1rg+HL5Dym3FxcB+rBRap38Gn4+Ux3yPgeLfF9fPXN
	 /aG33a43mvaZT60VsXE7AjWhKXkCfsKVZbe4wrOjPntjqQiWikrkEkZvHwmqC9ZyrRvck
	 N5g/AR7rWt/8fqg7AiVSwhp5EiJ95dQvGcz6Ydt/piMfZJAyI9EtcVGY4kjd0JTqbl9+t
	 w0VWsq4Y0/TtU3kspO2lbAjWJbAYEVsST6CWNW68yscojc9MKNv4yh5roZjmKlDqbOTpi
	 SrN3PV9DNaQj2kstTB//sTnV9b0eFJC6LgNTste3S5QxovHWCV8o7UMa3cwOIjALCOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795805478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
	b=lwKD6279dPtMafd5wjJoYych9OQsCC854rfZovsh5A/kK+6JxfaFiUGZRZxQ61u3C1Wb
	 bQgppe0liU9koTR/6HqFqdL9IMcX4ttWO8IxN2DFBcaGXZlB+JRTy9gKBJbmmvcJm1Mu9
	 ZY8BcXiB3oGVapHy7y9kiwap39RQgEFRDQQSp0X7TMvaXC12Ys9Odf3539fx8Tm1LhsKB
	 AV6IONM4v0xCh8Du0oXnGvdjxQZxalV2MplTutSCue/aeGiz7VQ5345tL91pW7Amincv2
	 YmbKwjesJbtZVSfPD/VQmsCsimKvNqsSO/bt9sy7R6Hkljs/sQLE31btsf8SprykmAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pNdptj;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2406606A31E
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 18:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2406606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pNdptj
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4ac109a8a12so4995027f8f.3
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 10:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795805476; x=1796410276; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
        b=m3pNdptjqW81pY9NLNr665+hJMXwfSRIqlg9cV1mmo9g7662QC2nuYP6a74k3dZ3Iv
         zvWxD2plIKeVWrLGkl0fu/pCXc3Vzo5AvT6VFc4h9ivwKjhKyhk7gIjLCx9npZwJUmyQ
         Nk4TvX4IzB2micR2Tn6o+UKGujjmbSTrorSwb1pZ/GkQGqOji8LqBS5bCMicKVrMKepu
         ioYd1kId/PYWHMgCja4C2aGhqgHUyOK5G1CCmNbKgHfRfy+Yjo4yFy+orjpyYzTB+iHt
         M9/R5HRHUsAyOqHMXuprEzV4ETE8D3x09EMM2j33PoYMAXrIBvD7VzX01Z6gcTlyJABk
         Dmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795805476; x=1796410276;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
        b=bLbmSJHCrSLaxHEY9w61lrH0vkxqCK6T8+2Y/yILYy+oNl7T0kMqFXQpI+gGDLuOP8
         S34hx1CGA28Ul6gh+itkdUuy4TiVNJsHCDnYmmLJ766BoMWHGI1VcP+qZKfXrUCsRW+e
         A1SqdwSclDAkTnXYtd6HM8jLt+x7DrjO7r6sDuNRGrJmribOxbQUuxIJGLC0/kfG746k
         AaCJO89AiUvgAuUyioYLefbZMnHKuPicUcEem0P8PUFVa2hDGUoehE0KjCB6BJCzFdXc
         BCXhQDTBLrBBNVlfUB1WAkdWELW/1p7huxkhYTA2GdJjjM2tXFk6uKZumvP9ltzN8dr6
         5NKg==
X-Forwarded-Encrypted: i=1; AL+hErE/sF9gjMwcgOcjXO2Zf4BqmqPpeyCEIPswloQ9qvFS3X1BJS3YJI8RVjMVclvo/gG64CtOvJwXviU=@vger.kernel.org
X-Gm-Message-State: APuU4Z8KGNyddWZFkWYt0PnusFpz8ZphHlaKNkk8mus4dDpnUKJ1dNwV
	dlHPaQuioUhp1hWwAFKcrDlNXWuQDVioTgdOr6CB/iu4J+HgvvMgtc+a
X-Gm-Gg: AZFdTZeAg4fkKIZgktlxvydOubv20pM7dmKlgKYvQHFKmt4D1fQwGj821yujeZ0dMNw
	NdLxZ48k2vYc/SS+buKrLKakhZ0tN4yY2myVKDmqO9ZIYdIigM1XOdRLJGWgCOAZf3L54blEfNb
	jq2n0wbvhgph0ZSg3fb4HsuyNwxfcfWnjSYsxSSfecAsH0CIk9gXnEcssRNaHwwftebQC2Q6Yfe
	W8L8WUznNz3xGNmh5xXGvhxywevzz33+6vkyUmovjFybFHYtyZrn47qJCroKSjlvK8zm2sc4gjJ
	uvvLuqYRpdxBOVNFXMhGqmYHVXyp6u35s3UmIrADnRIqIvaRlgHg0/QvQSuNx/6knD5OY5jJjsG
	3U2TFqTouun5jLdciRai33n2JhMuJ2B2XQxnn7mHl4oMi4v8KDa/rcf0eXt+eysPvOpGzQ//IsG
	eDKaUEdwIDXfx3ln2riHc1FL95r3BxCNg4FHKDnF5EDw3yf/PNwgfVbYnekUrqfe0P09mw3mEOc
	XZGLNa9uhqCIY4x7QInL7hbvfNg7uFfpBF+dMCmNG5pCYqpZyahRQvpAdNmWeraxQ5gM8XWGODN
	PdGpUP2z9aJo+1sIgJWMr7Rung==
X-Received: by 2002:a05:6000:4812:b0:48d:b650:69aa with SMTP id ffacd0b85a97d-4abb55185e4mr49465105f8f.50.1795805475952;
        Fri, 27 Nov 2026 10:51:15 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4bef07f9e0dsm4921752f8f.53.2026.11.27.10.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 10:51:15 -0800 (PST)
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
 boundary=3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 19:51:13 +0100
Message-Id: <DN67WTNVL19F.1D5GOBP57BP1L@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-4-koray.fra@gmail.com>
 <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>

--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 6:48 PM CET, Amir Goldstein wrote:
> On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr, both
>> __u64 to match fa_xflags' size, and bump FILE_ATTR_SIZE_LATEST to
>> FILE_ATTR_SIZE_VER1, which is now 40 bytes.
>>
...
>
>>  #endif /* _UAPI_LINUX_FCNTL_H */
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index a13c7b32a1bd..63d88ebe3420 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -238,10 +238,13 @@ struct file_attr {
>>         __u32 fa_nextents;      /* nextents field value (get)   */
>>         __u32 fa_projid;        /* project identifier (get/set) */
>>         __u32 fa_cowextsize;    /* CoW extsize field value (get/set) */
>> +       __u64 fa_xflags_rw_mask;/* supported writeable xflags (get) / fl=
ags to set (set) */
>> +       __u64 fa_xflags_ro_mask;/* supported read-only xflags (get) */
>>  };
>>
>>  #define FILE_ATTR_SIZE_VER0 24
>> -#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
>> +#define FILE_ATTR_SIZE_VER1 40
>> +#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
>>
>
> Man... we really need a bot to review all UAPI changes
> Please someone tell the bot to check
> NO LATEST/LAST/ALL constants in UAPI headers!!!

Forgot to add: maybe Sashiko can do it if asked nicely :D

> Your patch does not introduce this constant in UAPI but if we change
> it we risk spreading different versions in installed headers.
>
> Honestly I see no reason for FILE_ATTR_SIZE_VER* to be in UAPI
> either. For other UAPIs those constants are not in the UAPI header:
>
> ~/src/linux$ git grep SIZE_LATEST include/linux/
> include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_VER=
0
> include/linux/seccomp.h:#define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST
> SECCOMP_NOTIFY_ADDFD_SIZE_VER0
> include/linux/xattr.h:#define XATTR_ARGS_SIZE_LATEST    XATTR_ARGS_SIZE_V=
ER0
>
> So please move those contacts before adding/changing them
> (can be in the same patch IMO).
>
> This is a high level review.
> I did not look at the details of the conversions and validations
> Will do that for v3.
>
> Thanks,
> Amir.



--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawnRIQAKCRDmj22qf5IG
XJUmAP9OYQdkwBS0FIjyqP9a3I8gdrfFrp/bZms8ThGuY3SovAEA9zGXlhLiGxhC
iuYnX95tMjFyQ2w7/Y0yIwxjSTRZ7gg=
=DR0g
-----END PGP SIGNATURE-----

--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91--
