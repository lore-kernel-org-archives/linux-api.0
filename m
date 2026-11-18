Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013893;
	b=2mRwqskrgrC8QNPwqkNU9I87Eam2U6QoQOvCpC6t/r01OzCEZ0VG6K+4QeOQCXSRzSRl
	 5h+n5CEgS8jO9kUUYPaxoC/ehR5fNDOtasmZZc6kxYB7K90Qqg0fvH5BObv0iTcdqLlJu
	 69Q3ZMvgVLgBbp4tN38izBeYyULXCb3cEgTDAlU4kL55eTPfLDDzG5CWQkobZqG7tADLg
	 a4BUKScw4Inqqss6en66s6QlC/zTa7/7w4/xCDuCAY/PrKzOChWQ6Cbn7MiqTHlLK/JFO
	 fGwFuiCfazmz+iCApNjwMyQ5jvqtlpvubrSuVwjpCEpzQ5JOkztMWvmtCgxz7sRux1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Pp/RLPMZ3GifsKTDdh8Pk/uftsOfh5azJIs0J3c6Xr8=;
	b=MU1Y1C2l57q1FsMH8sSsLZLxGjy/K9bWOkjHm25rCgEkoTKppoWHpIr/Od64B2m//eBm
	 a03ldGQOBSFEhkR4thFSAjSv5ZULvaA6lkG92ZhVdoy2G94EXvPRMa0s+ANgjM7vkZ6Rv
	 94SivF+emRVDhjqhtLCNr+Lsg2Nn0rjAqkzWWC2d8UPZtE4yM6UbdmnH6U0Lwc1EjGfiY
	 ZBstr9pXaiW1Q+CdyAmNjGKtdgn8m/IUlX4klBtMg+kTye+T1ol1LM2GIOG7E5TLk0FwW
	 iwP4OIQD9DnGacRt200yDXGYJMyjJ/uxuKN3oqrtufJq2kTq08dhm0Pf0nZIp0Ck2hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WIynCKYl;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7466B606A32F
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7466B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WIynCKYl
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4a5506f09f5so674431f8f.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 06:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795013892; x=1795618692; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Pp/RLPMZ3GifsKTDdh8Pk/uftsOfh5azJIs0J3c6Xr8=;
        b=WIynCKYls1N8nEyEmKDwpbFtK4fRYUUmPMeyj1Lc9KrBLr4DNDXRTqxqglZZe6Ifn/
         rnLkHwm2hphWg/c9Bfvobg9Xh3gOHmCC39W5EhYmE2vXc7oQ8QkoZqlQnR0DV/jsH1GX
         0zzmewpfcvfatXcXxZYAaoXNifblQeQTqV9d1MYWR9E61n5n3sGbMTxRnTnaL0nDt2oW
         nQRU8AFvYlvH+9vQ96dlbf/TUEFEwX2A0JC+XqUxCoPLcHF9R+OCRlpqai8JZglyJgPk
         qdEM9PuU3prps6Ygbz0r7hOM9uQF4f9gUmI0QuSofnln19TV9ZuOiZ8w6K8QMEHi7Fbn
         NPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795013892; x=1795618692;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Pp/RLPMZ3GifsKTDdh8Pk/uftsOfh5azJIs0J3c6Xr8=;
        b=n9lwF/LzAGTdURuhXOtPhJo01JO1MzjDLmHjO3l5vCLgDkL3JbGOK5K4YE5RUIPV12
         S6r3CvFBu/WijGFwFawhSgEioqjSkPBd0P6bF0hs6tONGDkcDa8VhAuLtTpLTchNl66F
         Z0DvERoiru9FfiLsCPGC4jMjGVuCiKCKRqzwhA/YDGjJX0GvI9tZPxg4mBIr+qO2tojz
         uqh9M8XCk77MnZNDIOHDV2y6qY0C+dFS/GVx3A4ff9ba7/ntRjPoDssyoC/3Ocf/bHP/
         Hsd+XAh2rLee3KjwkuhQVz8INZke8TcA6Ep+BCqdxlgIuIoss5IbR97NjLes+ApoPr64
         kxYQ==
X-Forwarded-Encrypted: i=1; AL+hErGJ8F96go/xXRMYY9ruZToYil/8t8mglxqT5WN1Fu06KID6ZVFN7uJDkZ7S/UBiTM72mQRFoPIBLfI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8fxt57CNKbVq8IWZ78E4ckt+N+1cfQPmlhmOkw/kWbLHUZqavl
	9Vi112Ghuer0VZD/cYFE3ZCYOlXYx6jAJ0YQ/645WQvETCJS9HdHKT+u
X-Gm-Gg: AZFdTZcyafQ3gTgZsszKvvzKkFIJ2VTd+oxUmQSPwT1q6EvSeAHLHf3lJMIKMYXt/Ls
	+xvbxyOb7EPJ8gJq9+jeGfYqeCX8seygRBEfGPpk3NW5Uln5fk+0k7BPTdlW+Ndvo09oTS9Um4Z
	lLYvjCOIZ2VBwFMMm4zwJzvmAGinqEu+7bY8f3LmuZN3eGx2gBwKKHa7rn0PuT65e9e9CkAC6VC
	0H4QRshXU8xP0mNrUcExeCR6TSPE6FPZwdFmfhgxP39BnAZ/JZE/zj3whrqvP5+dE5hHgtM9UKL
	EQU+VfkTM7RSPMhO6bUjrKJeL0eTDVDPxFEEZDs1ZXRaL2zdMIzULTC4zIkwixouxTq5es5w36w
	iCPfnokzPs6Jbjk977IPA7qkLi77rzor2eRJoklTj/jMHXgcih587Gwar3NHTRoV/T6I1JV5k6B
	xnS7Gt1yUYxpee6dYiMYW2Yh9L6HcvK/6CFs9mxbFia0+MjrpZ2CcHojlkJsjPiFJEtWEG6rAe1
	jIXt9nuzwbgkaEjqzogO6vtaNdkCIFGEKV0Pzr7Y53hQJwPXkEBEPjeeDWCGEKe6R+7vH0c4o4J
	hKHRVQplmFYruSU9NkGPMEbWAmg2tsDHwxC3PBL6fCOsPaWjd2HAj/NdqS2eIUVY+Q==
X-Received: by 2002:a05:6000:2dc5:b0:4a7:7bec:e159 with SMTP id ffacd0b85a97d-4a84976942fmr1578019f8f.15.1795013891542;
        Wed, 18 Nov 2026 06:58:11 -0800 (PST)
Received: from localhost (mob-176-246-251-118.net.vodafone.it. [176.246.251.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65541f3b3sm5373344f8f.23.2026.11.18.06.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 06:58:10 -0800 (PST)
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
 boundary=9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-Id: <DMYFBDIV4Y08.35ZKR5G86U1H7@gmail.com>
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
 "Pedro Falcato" <pfalcato@suse.de>, "Amir Goldstein" <amir73il@gmail.com>,
 <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-cifs@vger.kernel.org>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261118142613.be3r3s6kobkkxnz4@pali>
In-Reply-To: <20261118142613.be3r3s6kobkkxnz4@pali>

--9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Nov 18, 2026 at 3:26 PM CET, Pali Roh=C3=A1r wrote:
> Hello,
>
> I have just one issue with the userspace API. It does not allow me to
> figure out what is the source of statx btime field. If it is fs ptime or
> fs btime because this RFC implementation is mixing both fs ptime and
> fs btime into the statx btime field.
>
> I have feeling that this is quite a mess in API and I would like to see
> a clear distinguish between btime and ptime in the API, like there is a
> difference in the fs storage.
>
> If the btime is used for forensic analysis then somehow I would expect
> that the statx would not report / not fill changeable ptime value into
> the statx btime.

Hi, for native linux filesystems it will report ptime as PTIME and btime
as BTIME (also semnatically), for the windows-like ones that only have
ptime (semantically) I think it's reasonable to not expect btime to be
immutable, since they are meant to be used with other OSs who lack btime
semantics.

> It would be really helpful if the statx API on inode can differ between:
>
> 1. btime is present and its value is ..., ptime is not supported
> 2. btime is not supported, ptime is set to value ...
> 3. btime is present and its value is ..., ptime is set to value ...
> 4. both btime and ptime are not supported
>
> This should cover all cases of different filesystems and also allows
> userspace to do proper backup of both ptime and btime fields (if it want
> to do forensic analysis or anything else).

These should already all be covered by STATX_BTIME/PTIME and their
fields in struct statx, the only problems are windows-like filesystems,
which IMO shuold be handled as mentioned above.

Of course, as in the other discussion, I'm open to changing ptime
NTFS/exFAT/... support to remove btime altogether and only use ptime for
their own crtime if that's what wanted (I'm fairly impartial on this
specific issue).

Thanks,
koraynilay

>
> Pali

--9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCav28+gAKCRA0bnTtJTDo
OLZcAQD9pG1FmR7nRZDk2H08cDMhIho0sN3gDoVZ9UGDLNS9YgD/Z/0Ge9mFK15R
FEjSmx712gDHXRyPIeZ3A/k22EGaOQc=
=3Ms7
-----END PGP SIGNATURE-----

--9e0e009d1054760532dfbb31949a479f82968ef4509cbe81b751bd0d90dd--
