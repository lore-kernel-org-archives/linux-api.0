Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795190318;
	b=l5n0RGYJTdA1sLhZAnbCLnw8Jd/+K+Aj4gpCDslja7nnlh1gXZ5GUTFW59R/wNXaCbog
	 RcMbjqsHd1S0BLTk0kvW6kz76KS3C4OPvum/0aIwj587nocxYD7S2XPYJeI2JKENbeoP0
	 LCoUBGvu0u6K3im5hYhebWa/DKY9TzMELHgc/RlprdkdcY04SL51dDR3PjuB4QGXUXYYf
	 r4fkQMuWeBni4j4CjOC+ZYJyugjC6aD2zUF7s1hN2Ss61vT6GpZXrnu7Di0goHNbRL5WR
	 pHQgzw36Upur1TkDbGyrJc4DO49YmnXA67KPKppvxqX3hQSycu8jPdCUoD/i0rfv0tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
	b=uSE2kFQMMfIyB/AWLZtG+xWTqBBHVgU6/ndX4HQCTomAzVA6+IccACD+xGycNtDLOLtC
	 51TRLYMpsq9UX/9k79O93yEUGULciusN79JL9qwd4AoQhIhl/AHHpZjnVU34G33N6gTxi
	 O6eazScf+w6+SUDxLwajRafNrNCBvFqY5dyuGMMJQR+ytBOtjutoNsta7KwgsqOHQxT8v
	 CCTXrrEANqdVkbM+JPQ6rxXSYLEKEDAunUH/dizZZOdvFBMTubzkM+BYJNLe3IXXGvbiv
	 I0Se5ac0P48o2YKd+lfsN6oqoENGJ7QQiU1N00rI2o/+3vqFd+3jFcgKkWTSH8Z4BEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTc+eMp4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C2560A2617
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 15:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6C2560A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTc+eMp4
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b894d9a075so1219469a12.2
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 07:58:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795190316; cv=none;
        d=google.com; s=arc-20260327;
        b=VNhh1LasWkhg0OoSklcqtqBIY7l0ltuePl71y8UNeduparIEPkdDBPddSEhhR83jpU
         Vw4jUlA9c4QVDDReJwMFLEF9XvS4UfAc4Vb2wbwFTqaXhHPboHeLds7WInU1gyzcMvwM
         r1lyehHCM4IUMyq7z9ga0zxO7PbBAlTbXqDS9VzxrV6v6dBUcQK9guQD3eCUIKYHBofN
         c8sHbyB9KuFoxTnoU+2AscbPD3YBKUxdLpRRojO8c7dmBr1fyJSaW286PBsY81z1kkd/
         +5nN1IfFl0/I+WWVXxVgvy0SgKh1hvcp028yZ4iAzK/V5S4v3O0T7XXZZtSVW0rIF1+q
         eUEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        fh=g2kLSUAUmqDWxm9CMJ6Pd8mtBejrJmFkSkKatMkniTc=;
        b=P57CK83D3pDX2fOHs7TTTDu17qTgZE4VSHHnDHHOYDzKXlKQNqj+EL9dYSNOBVYVCj
         F9LR5Uh6pOq+LblEXhg3CW7uYfrMFDBrrpNs+C4U25iQtjaFgTtLtQsPJfChmRNugInt
         xNpjnMWWmuVvEg8F2JK7ZNxQOxWXNqXkx6TIS8Dh9L11B88awMUHeaHd00P2oJSE6eyQ
         palCYzqqGoq8KFaCObA89rsYl0XJ1x3SK+IQ7rP1wQtyZujEFom/lU4YGnLTUbnVRMVK
         NwOQoQKOj1E8JjdazIK11Euj3lm/k8/79WuG58Uum54lUMziDXwEMtpfrxiTxcxVQ7Uk
         gpUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795190316; x=1795795116; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        b=eTc+eMp4bITMI7jgx5jM4l7NyEFh1c9lTC1VxvFXF9G+vcYBoZB53yLQdKfrQOpf6F
         Mtz8FTmSSTw6Ei7un/2M30yiLReetEhAe/lO4dm/xLE7CcivvqjbhlK/KCKhN5ARxijZ
         ChezPcoSYPSGA4dYvVLO7Yd9kb7uDyVuUiuKTqgzbCAKx1XbYJKzxg+Mx7ccVg34Vcwt
         Sq2087h5YZQNFE89KJ0Ys4A0dIfGzwnygs4zE++uxupxXjpFy9vZB08cycp+xBcweq9+
         96UTqALXMzvyeJr5t/bjHIhkmiHd4xvEUtcz6apgxXUf6gRVWrykVKb8LpEbPe+pU8hS
         b+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795190316; x=1795795116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        b=p8JGk6kMPyXcXFwovt6pGZpqdSYRT/xHQGErwWExSkVsGSycIXC7jRyEmtfeTtjodh
         UUD3RQysrYhs8c9FeE0gwepwaEXxujkPro+MWvWNI6N8nVBfyNvDrheSkR8MBuF761hw
         H5tern1Q9sIPKDHqwFyeTU5XorGZKHrp4zcfg46ML4Teu6QSEikrteabJJ1Ocg6ld40i
         gt4VKiYpu+SDyJy+2L/tR34SagFU4xHg36+ZiJdZXpcZBL7Qr9TyRox91Vm7PFdiwG+G
         6gsl3uw6g+P1kcAKhdxZrV2l+H7FLy3P3/EZm2nV/x0kSc/ro8l8rq3Sa2CFHLILprmt
         V7Wg==
X-Forwarded-Encrypted: i=1; AL+hErGlTaSXTu1o5rFV80aPmrg3mjKrHtNECxz550eWJARPCPz1HGXyLZGctdTFsHj2jJj6rxsCG82H/8w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ap2L0zs9D6ib3f7pEZTZeXC6+FE8MFIxMDSvn4VB0ofnqI2oj
	YvI9dj+6PJEo8RNvf92HmsjY5N+oq+uPn2/xPtekfA81Am9omKzgBQCd9VWH49WpKkYVgB1TAPt
	c08KcvrUavOipK0FujT52rhzuvzmKQuY=
X-Gm-Gg: AZFdTZfu/dcsSJDdXnhl42eChrm6FeRng5suRwn50ClcClFN6uxdW6fsinEUqEbvUiN
	OHTsDIlRmQgAXMQ/AadnN6uyBkM9cuJ4fE4hzgv8daauIBy5cLBvqqlzaCV6XBAtZWCwbEH/9VA
	nFxkI2qQlTN2MKJjp7+oSq1BssIjQNPwvNsnC9udWc5OjEveV67eFZtEI6tO6p2rUGe4KfFpcoL
	zm9+mwoKVb7BRudG5qkUShzcpN29gVRFoCflA7NHyzHPsieULYNHIRWR44O1LOjUGT8p3BmKDm/
	ojQFWars85ywoDZ/JkmJpUU1YEOYn+SlCG81nd8JMG3Pe3PHOWA8rdjrWxNg1fztVQ/NbPzsA2T
	EGCZoNF26r4B2C5V1/xwSZGCa7huAlTUcX6JOHrt11D7Fs/ddeYf0fTTBlmFDzd000+7yMQ==
X-Received: by 2002:a05:6402:52c8:b0:6b8:5aba:6c06 with SMTP id
 4fb4d7f45d1cf-6ba37d652f3mr2090064a12.14.1795190315774; Fri, 20 Nov 2026
 07:58:35 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-4-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-4-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 16:58:24 +0100
X-Gm-Features: Aa3M54pideZA7GJITw5PojgxjktVU6GBxKullq4dSyaJ0XYgg1VLGv1zO6-iMnU
Message-ID: <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/10] ntfs3: make crtime user-settable using ptime
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
> Since NTFS supports user-settable file creation timestamps, map
> provenance time (ptime) to NTFS file creation time (crtime) by using the
> newly introduced ptime API (in commit "vfs: add provenance time
> (ptime)").
>
> To do this, update ntfs_fileattr_[gs]et(), ntfs_getattr() and make it
> persist to disk in ni_write_inode().
>
> The timestamp is now retrievable by using file_getattr() or statx(), and
> is settable by using file_setattr() with the FS_XFLAG_PTIME flag.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/ntfs3/file.c    | 20 ++++++++++++++++++--
>  fs/ntfs3/frecord.c |  8 +++++++-
>  2 files changed, 25 insertions(+), 3 deletions(-)

Please don't change the unmaintained ntfs3 driver.

If you want to include an ntfs patch work on the new fs/ntfs driver.

Thanks,
Amir.
