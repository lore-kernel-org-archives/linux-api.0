Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022645;
	b=S7OC/CneQzDoTVDE5Jbxi9lDAOGwWUZRu+pStUNzzqMHjp6za5/jOmf4n9Qnw5+YWXay
	 d3ntoKfre8DBGFLDZIbo5q4B9EfGQdrXJYGHC7iNJKAmFwpMmMstdviX7AMjPxyQJntQL
	 yZ65xaWy8yaMBFC9oE+46fbl3taMML2dpmn9+NYIrawkttVmXOgWI22yIOCIiK3iFHMEH
	 vnqwt/b3aMmd0INN0LcknoXFalpmDNeG5gGlpIQWLv6z1X4hnfEKNZEZQY/duDyhovvds
	 phzoWgOOkIJqtf47GBBVfTkElbuucSlPf0U6PGCTCJid325/n5SHAZIQKFWXy2Bhdxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022645;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=8VmZcMVpc16J1nBk01fE3vMPgjnZWh0+ezLB75Qyp4E=;
	b=pIRpXEMJEYxk6EYpDoZtZKrA6aLIjFDU6Vc8U9XIxfpW3crXL7UjrtCyGgFxbPpnRfW/
	 vKAJ7JNGzHrWAxf68wiYYFEXiMe+S3heL6ygIOhcafmMvmAHOvwupt8gC4bfbHDmDzzSB
	 7i8u4WYwSz+pVZbUH0DkkuaAwjGHHj/YD8cCQXs9PT1wX4qryfCx22QaH7vyD2h4pXsiC
	 +4K5C+9tXhE1jls7AwUPY2OurEvrbEFA0qcPZJKZkKptmab7UZemT0ZDH+F24nZUVRkur
	 4j/DBm+bnmykNYexHRlia36JSC/9w7GHxVy0/DcJnGkWjHnvNEm36LHmXzUgsLPl6dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=frxjgyoP;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615FA60A2610
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 17:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 615FA60A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=frxjgyoP
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a5506f09f5so825285f8f.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 09:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022644; x=1795627444; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8VmZcMVpc16J1nBk01fE3vMPgjnZWh0+ezLB75Qyp4E=;
        b=frxjgyoPID206coABVjIrRRPPTBt+tQ+/VNebzaUry3GUDaWPMUIraO24xHbSZ6w43
         FSVLkzLzJfmcTixBsJcCgynHtXCBuzfs8xMatGIDHzkK2swn0oWBSGVkpd8Bd1T8hess
         b1xU0fKcwNeWwfuAqjpsgSkH0Ehjgf+eM7sfSVRmmmm3AkeixIOXG/CA/4COjw6UHtc4
         SfH4Fy94bsSScMothl0uZsKS3Fvm9J37a0B6A1iU53P8qT8ov7P2yZRZaMIYUGChU/jj
         H3WdzjBnbqI+Db2OXLHmhvNX8yA2ivtf7AimDe0uQFfHZEk1MQuJ5uS4YUc4UncZZog8
         wr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022644; x=1795627444;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8VmZcMVpc16J1nBk01fE3vMPgjnZWh0+ezLB75Qyp4E=;
        b=0L82f8SZQDMZSq0pBKMfWQqXtetqrOaEjaT0ToBCR2WYj8Qo/QnZDfyZjrdx2Pf9e2
         57Zj3PLQQ5yzbeQRWyByWJ7Q45U2n0PQwDFWzOVAjKFY9DDOM4C4Sk5esQ9EixYC6Qtr
         pYiaoH/KqJNxpeiaNE+6dyOLQnlQ7GEiRSN5pcgixB7102rIBpO1iQ7GyPHoOSTBFmzZ
         1pw4YEUB5OvETue4iYCFWmERi1j1+dIVNBJ7gK6tsxAaaasC9hymi98nysGL2e8Lts/S
         CSHsee6vZAzFmcfTO+MpBfrTChKvFOOuex0IOZ0uJxuiM+E/11Xdf3lgaSpAiXIyP3gg
         8olA==
X-Forwarded-Encrypted: i=1; AL+hErGQVwfgycNveRVEijzhHwIyWVuuEmN3C297bw8Do+IKyVCxOV5PVTi6NmagOLX5XkxHYqLUVR3geT4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ubX5XFLWyv8flmcLEaBOVJLZjUIFwkxX2+fCRl9k6oYrf7+xu
	ctGBvvehukle2Yf6nn4wA1cbCYSeJg9P0/z1cmNCHzIL7lMEVzWJGAF8
X-Gm-Gg: AZFdTZfh1C+NstTDlLfXx+EWClyqP1EmUpsnFbMFYwI+7//WsV6Yjd7AG01EK2SQHiT
	1K5BUlgmlAO1CW74znkBF8VISx1/31YnDuwshARO6s87pI0al6cvXksAY6luk9PxKW0X3wVlu4V
	k4j2s9q9xZXMjnlvhCBSbdFSat9p2VqM7ZdST0Xv+A6INhCKDc4Oh8U7179P3arOxzR+AImS+HB
	PjvQEVmHAfZGtVMgw9Hwgu3MofT9nds+ydx6sCbhltzCCsTesANazL0THEKm0iQccTxZ2LRCS8j
	QTglEh+yAh6E37nMG75K7lWJJYbTHOFmnxE4xidUC39Ys07QEKcz/F/leq/sGC+9QIj+3lCYWYA
	Z7bBYegZ31+kv2/JLi0KjFvP7YW6T8USfaXaJERJCLZBlHicNLLGimflCtrfzn6V2yyV1yWYXXg
	DIHGep6m0Eo/M2qTrUa1r+JPfgEtAQWaGgrnHBAPrRl61l5rsFWBe0sS9k+X7wdrAfOG7+WHLLz
	3aXflFy8IZfb8jRyENDAjoEtL9W31JDxIgiS4Q0s+QvwNJPquwZmB+YQY5zZcFnldoHcLJBb+PD
	hepcScB89A8W/8YkfTBZ3+IQP2at
X-Received: by 2002:a5d:5888:0:b0:48f:f26d:c5c with SMTP id ffacd0b85a97d-4a638058303mr6313854f8f.9.1795022643534;
        Wed, 18 Nov 2026 09:24:03 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:de3b:51f3:e461:c0df])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65560b2a1sm5678801f8f.32.2026.11.18.09.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 09:24:02 -0800 (PST)
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
 boundary=bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 18:23:48 +0100
Message-Id: <DMYIEZKEQXY6.EARVA8D4G55W@gmail.com>
Cc: "koraynilay" <koray.fra@gmail.com>, "David Sterba" <dsterba@suse.com>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Trond Myklebust"
 <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J. Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via
 FATTR4_TIME_CREATE
From: "koraynilay" <koray.fra@gmail.com>
To: "Chuck Lever" <cel@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
 <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
 <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
 <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
In-Reply-To: <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>

--bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Nov 18, 2026 at 6:14 PM CET, Chuck Lever wrote:
>
>
> On Wed, Nov 18, 2026, at 11:36 AM, Amir Goldstein wrote:
>> Can't an NFS client be connected to another NFS server
>> implementation which does allow this?
>>
>> I can't wrap my head around the problem.
>
> You already named the problem in a previous email: What happens
> when the NFS server's kernel is upgraded from an NFSD that exposes
> only btime to one that picks either ptime or btime?
>
> Clients will see a file's btime before the server restart, and
> afterwards, they will see a changed TIME_CREATE but the file's
> NFSv4 change attribute will be unchanged.

Not really though, newly created files will have btime =3D=3D ptime, and fo=
r
older files ptime won't be set until someone sets it.
If the underlying filesystem changes it, then it's the same situation as
if someone on the server manually changed a/c/mtime on the underlying
filesystem without informing the NFS server.

Although, I'm not sure if my current code in this patch updates iversion
on ptime change, if that's the case I'll fix it for v5 since it'd be a
bug.

Thanks,
koraynilay

--bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCav3fJAAKCRA0bnTtJTDo
OGpSAP9c3bOzD+a1N5jl1ZhnFHHQAamxFgzhMndzKRwdMl1YGAEA6Y2M7vsijmj3
bnNJpnj8gPwfPO+5AFboA6admpWVWwY=
=xhrE
-----END PGP SIGNATURE-----

--bbdccfc2c1d2aebcf158821f40e232b6fbc6627f296287ed966c4171fde4--
