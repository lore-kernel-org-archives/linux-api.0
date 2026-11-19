Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795109669;
	b=oApvJTvUKGbZ7asOouN6HY1OF4nNsUKAIWNO8tmzec3K+g1S4dNTC0jD8VZSHhFqJDke
	 4QSJlVh2H/TWMoRN+esD3RqihmeeWvvVs7t5I8fQOxid+85dElS8x0hX/oSPoQdCei74N
	 0QLYudBdXi78WuCRAshhWU265zvSt/ePW8iU6pNtfngG4f+QZEitA46GywKX+tmqdyL4S
	 kWsLZK2MNRfGcUx6Xm3AZCEA95W1kbShZ4E2T8t9Pq3WE13Dvld1KHtTnwyRDZVhcgMSu
	 ASjxglVk+XIQCeWmmvS9wf1JHV/q/YKJo74c7Cq7dqR8KTz/qQ9O3Up5R+wrjWqraCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
	b=xJE1SBNKd87RVCsmQxHQXcpHprQU8AQRTCTTBxoM9ON4hkXU2+oCBenoUA6r0a2l5zmz
	 LFJZmvRUhFQF1EQXjIXsq50KeZWmyfP4MKx6RtD8M0sbD6LeLMd3f27q8aX4L4HbOaN3d
	 Aexd5LlURK5zHgcDGD/kf0pBHT4aELqHOLydI3WnLWHOrlzSHzex1+kGAKBgZ9zP8jY2O
	 gWE9WUTWraxOtCbVOerodqkIWVnDpBHfAIFmJdMiqixthYm0FgN5I28eLPwocf6haD0xE
	 SxlBoA9UXDSvkuDpSFhlS0zbNN4EvG4QiLdxF+a0hwjFczVrtBh8DxrfY7wnMFUfeag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nGC6aRIF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDCA606A336
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADDCA606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nGC6aRIF
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b8815693e2so1786a12.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 09:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795109667; cv=none;
        d=google.com; s=arc-20260327;
        b=qX5lMeJ+sZbaalwiu4adXhhFRuE/Z0Lbc00Mbqr/7iAsJ1hpQQb2SUPgC0Il1d/egL
         bW8t2liYoEnYYjZxA9FG1YT8bqAtdrIiXk2FARp5UN50eoq1R0RJpXAszHtBgwbwVhwF
         8a8BLvJNm/6ujPgpe1jOB/wv4bfQ+JAebiAyQek96sBWeWRvZAX7vT4zpbi/ySeGPkb0
         bdSsp0RImWeWi4NvXRJzdQUgh1KWvIPXl8xYXy9XjJa10npYciwpF8bMwVKAJ7K+WxlN
         SZhVI9QHyroWa76oJ5wJFuYgExbA7XyFXFXM0LcRot8fNeJLGwdSqiqXfxQJY8TtdigR
         cEzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        fh=61ZMP805mj8ESvCHRQ71AC71Xj63ggvk+5QKocXpEI4=;
        b=p5NtBgBpH3XCOZs47NSNY91mBKAJsLtGS0Bm328kJLbrhwC9btz6GWjTDYFHQ3BtA1
         /JY4/2CoLmYmdFmN2IF0xMUVNbEENd6tjIqvhu7fCpcE/04dKnWS8LradOJ5vteLd2tN
         NPr6rgSVGSGKw/OXDjZQ31WS9vt8aZzP9EnrAKLSxE5SLicTW0ArRXyKBevWUIn2Rt6Z
         MM1G2nWXCP6qHHRq5f1zbfSN1adiluKW+n1EYiw5OqBBIVsEKRUQPMehItyZ4C1r9NDP
         gdu5QMvjCSwO4BQEs3ntkoVTwh2D03jcFwxY9aDIkhDN8wM+BrjtJTjV6wZDqlSCqZlD
         oshg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795109667; x=1795714467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        b=nGC6aRIFchP5t8lwJ/zVTOI/bLa8AV4FvgJg6w8MF9wmm1yRU1tUTokZFa/paaDJ8e
         5PUOtHahetL7iiRPD9uRZGlho38PnlwqF01pD+GRX36RYtqopRY+6tUdIUx/3qzL/D90
         5amQJu0ziL+hdep3ub8xpqOFUa0Nq+K1582CqDJ7KCIXsfa6geIe36gqovNyjbgAUMjf
         2HpGIgyOw12DPpv97GDYb45yfSyQVjodaas6oDy6hcvHkFleTSnYO0ogudCUxCFaFMOW
         LleZntAPokivShBafvD/8UUAi5Gk0sYRA3rFd7SRoFsU1qI4IwU8icU0s6XL5OAjoNTc
         ilJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795109667; x=1795714467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m1EYDKjHcJ1IGh49gGW/JeuREp9e8GQDYfzpAeI0szc=;
        b=GCuNHHfk8t9Thr39h3vn2RSKo3Xqx8Qtw4RaywrVorQloAKo9JiPzp1NAGOHX+e9r6
         Q+Gkwumav802hWr6ASoyJBtphpvxR6V7/3OKj8hTxFIqlZhAEg1/q3+wdzY1erPA6oN2
         JOU/MzvzHWRhcDUlYZ2ckgkLddVQO+a1PHzXWk97A70sMjf5xas2vmsH4VFeULU339xx
         mdLP9wEsqLQKVrAQDMhq1FuTb6YrS1cN0wgCSCww1K+HHE1Wi6kEa6sXj3qxus+Nsy5E
         4unrPGrPT5/Z1zXi9hwQn+tLtDKM/H4DjUnc51cx0Yze7ZtrfhnQ7j8CUNZ3VRV3twqv
         dMwQ==
X-Forwarded-Encrypted: i=1; AL+hErEgJZUvHOg38FRLPSNX9uer66Iejyv86DRa8UCByNtUmMflKiyy96vX9R5NDLhW9Pycb+4EJ2Wsgps=@vger.kernel.org
X-Gm-Message-State: APuU4Z/z3p+AF0t3Z30EX0qIA5YrsafpRVPbB/85R8BQE91S2fUXlOS2
	J4TBK4nAvbTUiPDkymBEg31IFXB2Y0JfVBCZ+jCunlin44tziGQfreh9n5q9b+1xeLE6v/H1GxA
	p6rwUvCBAMALk38Z7LXnRS74EcNFu2vQ=
X-Gm-Gg: AYBFou0xfBqsZXkC6JwGRzbAWVJrD8uAEe0Q4dxZfF74SKGycx9olOww5MmaQyWhRdb
	ykND5qwsgMCssk5n56wm/iOTKS0uAqGuEQBNiKIIDZ+Ig8BBHmwjJeMHKFFz+ZCicvuJT8Bmfse
	RcQnVsF211n2JpJhos47MmdJO3Ygft7il9z7luCNL4uKetNNpcq+8IjWlPdClDawPpPnHZJjCcb
	Fr3BEwlEow+uKlDysyzaJ/OGgJPhM72M47ic44sSOBTAwUjSkg2BylOllqWLwuyFLySivKImaAO
	00OI3umEEWjTVBiKfgPof/QgtG9dcHj14hjk3E2/Zdwu7IaKGkzPSRmBhiIHYX30msVjkzQMhdS
	6df+14W2er1/+XNmBtcD66t9UcxN+zYFB1OehvvmhLvVbbt5h5zltLy0H+9kSMyFX4IkqDQ==
X-Received: by 2002:a05:6402:70c:b0:6b8:7d98:4826 with SMTP id
 4fb4d7f45d1cf-6ba37d5bf0amr50117a12.11.1795109666761; Thu, 19 Nov 2026
 09:34:26 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-10-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-10-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 18:34:14 +0100
X-Gm-Features: Aa3M54rix9St5Car4447U2IPLFR0HdY95bNJiBlGTi0-FAZstJdvxSGCP5IQDxw
Message-ID: <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Implement provenance time (ptime) in ksmbd, as introduced in a
> previous commit ("vfs: add provenance time (ptime)").
>
> Map it to SMB's CreationTime, making it settable by SMB clients. When
> reporting CreationTime to clients, prioritize ptime over da.create_time
> memorized in the user.DOSATTRIB xattr.

That doesn't sound like the right thing to do.

If the server stored a CreationTime that client had set, you cannot
override this.

When the client sets CreationTime, the server can decide if it can and want=
s
(may be a policy decision) to store CreationTime in PTIME and not store
it in user.DOSATTRIB.

Fun fact: the user.DOSATTRIB format also has a mask so storing the
creation time inside it is also optional.

Thanks,
Amir.
