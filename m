Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795125091;
	b=J21Xv5dctpdvPwnlu0rtIXOEOD/Hl9k96DL7xgbOAsUXNNPvG326w4C2g1c2WAEhsUW0
	 lthDFpOC8dsqI9J4uW3MO0oSRaETxbVvckX39xTV3NOVS5jxCdDpE6+4qXJHY2xZigRCX
	 1I+n9CHABNQ2mk8+QFs7OO9CnbDELYfAmSLe9DR1nJJypIahWblJPGPQsrHqHTF2IGeHD
	 5AdTsqkHEBBLMLR6aWCJ4CAQzt0R0OsYnhkOSlRt8ekwD5aRYOX1C/lN0MMULQxEDI9Y1
	 fwKIoPu+hp/SU+zsDrQZr0pIsSiOTDO7g3uRLw6aLT8CXti+lDBOdCVo1kLRcl/mM9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
	b=TszVuTWTXT527hOTkPFY4V+ESFxumEXHMnClc0S3ydmbn50uFk+tZjtgAeoFpI+Qwnr4
	 B+gmBAfJ0wWz0FHgEtxABOyvqYGkfMP1SMb7jASZh4gPXYevaG3jmRJXoGFIcEriNKeDs
	 KLMo9kGfPgiD6kzjSUV8wgj88u1Sdq/QkRrs4ZlPFOrcq385Nx782pCMSjJisA4jyzKBc
	 Xhif2weeDte+8DBdfVmdBMNilLc9E62zJajpSijH3+a4YUdDLNVGjMV5jXkTpOJBNera5
	 I0GTj1eDLJ1GeU5B4yAcwPY5N7HpCWF/IO7qz9minkCPBZDUErZgknq9R1KfJUabkTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IlZfXAdV;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7DF606A331
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 21:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B7DF606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IlZfXAdV
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so1605485e9.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 13:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795125089; x=1795729889; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
        b=IlZfXAdVqjbuXw7jCUzgBXdPvunc6N0Mgo0wFLsi18PRIXDg8h5ImWiXqqG9r5Z3nz
         mMCiHUUIjL1nanBAy+gmMMgf3P/DYPfNI/EhxL6VmuCltURwD+QgSpN5wH9Ap5okdiWa
         y1/JXPn/JLNw5xRoGTUzFUnMvRCF7c7CMfNmwx5ikxXdmn96ekaYhxXTtb8MRXhNYeaS
         5grEbe59oWK77G5W0OdmQ9pOUNCM7ixvwCJgXOuUiJiLHN4zyLRjXQj9XiUl5nqIEgCk
         mpXfVFfEyeVkldYSBLUdPMoMK3O4rNrOnb4CWeh8R4q5zrhhEuhtuEtenWRCvjHT14FL
         k9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795125089; x=1795729889;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
        b=jx75zgRgRoRl7V8kIqpiEhJkpjtRzX9gm2+U8Jk9iEPpItdcflLGUj2IIgZO6MNFQ8
         RMDekx3sFcs3oBLnRdwEI78y6cMCR/qEn2v5Uhkng8PwcmT8n2t2+SmYXb8ronvj0gf9
         /gSQs0mDh8FWiaqhw7/rFQIxXmh3A2K0JoGbHt3D7yN3mxly0kQXz643FVQtRombCQ5d
         VWzY68/PS6RoCVyn/GXjJ6DsGp0Q7RsxmnW7rqD+JTPSpmj2rE7dACSA7ehiLND6A5TN
         PYfUuImLjPMxOCf8+gYW2+J3IVyDdjcJJuIvzxn4+hwYD3SL2gppXZb4W8piTybqWiqd
         a/Kg==
X-Forwarded-Encrypted: i=1; AL+hErHXpx+SWHHpMw/LL65K66sFnsed/rI1BkKes/zQjHeJo+rPc88utZDCEaxyFWSVU01yU4ce3RbEkfk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9eXDXHm2XwOEzJAwn/aZHbluXVV826y7nqiG+atk7CV+RVeIdB
	katDJh2DeoODCn5H0O094TH00+9aSsVi16+SJ/Ky6cyQbxQlzq/COD7S
X-Gm-Gg: AYBFou3rF8CqogpypVod5kqsHthj0K3c57Jk+0BuvTp9OdqRl0fgD28UFdS5bNVqLAI
	IZXRez30r/Ry8pjcosSw6qiwJvjQ9/UZFvpIjvZXLtd8Nezqx0DqYGQV6fCk1pc1+edwiQMWl6v
	pG7ooTIPhXXU4Zz12qIaPcr1VDowAjY/SCx61Sjw7stWX5WkIJqr9QwIMla6PGNYVlNM1450Bdo
	er7zWJsfaJJozBFTJWBMahqhjvcBoq2OtfccJI1g2vE5fCRB/d1WJgEtNvIrR7S59l+6sKBW3/t
	p/L2egv4zczDvUz0wJpEi9Kxljs2TwmfVXEfcaHimPdO9O7G2hBx0V6yyuwzfVMHeTcG0ZxOo7y
	/7LBMr7wrzv6jOFQWcww58keX2QJyotvkC+tlm6HcvplCJIaXjLbDDpJbjQv4wnpN0T8OUP94kE
	kPzOQ+PQsm9WoaQLNkpx+OD51ApXa65FcQw9XCMYnWpzmRT1xjRIS/NvwTqGsQjy1kNIAJ8bf8N
	fUUwXiEQ4E1T29Y1nWh9QUNrqbQZwK7zv4my8o4kK6R873QPV46ZGdzmragq7OU/LxvpWI1NIRS
	NmR4igZHCFe6AsXJETbQ4p4gq/L98f+p+hc8+Mt+qkO/hl8=
X-Received: by 2002:a05:600c:4f48:b0:4a6:44b:2593 with SMTP id 5b1f17b1804b1-4bb8893ab9cmr20069015e9.29.1795125089289;
        Thu, 19 Nov 2026 13:51:29 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884a3a3dsm24821245e9.10.2026.11.19.13.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 13:51:28 -0800 (PST)
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
 boundary=305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 19 Nov 2026 22:51:26 +0100
Message-Id: <DMZIQG4U1NTH.2IN0S2YIWEYTG@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-10-koray.fra@gmail.com>
 <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>

--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 19, 2026 at 6:34 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Implement provenance time (ptime) in ksmbd, as introduced in a
>> previous commit ("vfs: add provenance time (ptime)").
>>
>> Map it to SMB's CreationTime, making it settable by SMB clients. When
>> reporting CreationTime to clients, prioritize ptime over da.create_time
>> memorized in the user.DOSATTRIB xattr.
>
> That doesn't sound like the right thing to do.
>
> If the server stored a CreationTime that client had set, you cannot
> override this.

Ah, yes, but how would we handle older files which get a custom
CreationTime both before (in the xattr) and after (in ptime) a kernel
upgrade?

> When the client sets CreationTime, the server can decide if it can and wa=
nts
> (may be a policy decision) to store CreationTime in PTIME and not store
> it in user.DOSATTRIB.

To fix the above problem we should probably keep storing it in both
ptime and the xattr though.

> Fun fact: the user.DOSATTRIB format also has a mask so storing the
> creation time inside it is also optional.

With my current patch series applied, when CreationTime gets set by a
client, ksmbd writes it to ptime and fixes/heals the xattr (=3D removing
the CREATE_TIME flag created by older kernels, see the other fun fact
below).

And another fun fact: until [1] ksmbd ignored the flags and just
read/wrote the attribs every time :) so that can only be honored for
files that have been written to/updated with newer kernels.
(That's why there is the ((flags & CREATE_TIME) || da.create_time > 0)
in my patch, and not just the flag check)

Thanks,
koraynilay

[1]: https://lore.kernel.org/linux-cifs/20261115155308.415734-1-koray.fra@g=
mail.com/

> Thanks,
> Amir.



--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCav9vXgAKCRDmj22qf5IG
XM7AAPsG6qghsrCfCEnMzpWg6QyG3mDtqVzO2LuI2Jbx+5MdmwEAqDTU6SUvXvP1
4H1OcrcMro3Ek7i+OVcH9ZQ2xF4lngw=
=LZNw
-----END PGP SIGNATURE-----

--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e--
