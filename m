Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795781098;
	b=3vwE8uYRucFNYFP5xi94ocRlW11ElVsktm28Qan8bpMNwqG1/0I5SZQ0L1KkFyJ/96qY
	 pIMes7lfHvzaJHZHr//8zD7ogd91BfBOEKNGWfAQ0q1lS0qxBG08JIKQunDGBV/pW3qht
	 LeHMfJCBeFTJ82zPN1wm+O5nyKsxbwAmCarV+BD2locCtNuhz0C2I5axlaVtrh00owRbe
	 jnX+Zes2pxQ4L5gbrp3y9O30QoiRUWfhRyXNaOlvP6lwExDMptTFo3qKLh7LMjdVMDrxr
	 40XJLb9Zf/a1BC0+GqXaqtK/ubmy3jTv2jrtKtMv0mkM2VNdjK8fvXSswjzN5Xx0hHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
	b=LHdoOdXkEZ9CirWRsaJbgJoBaLpu/WpRMRd+Jtkoexw4Q/j1KxjR9dtMFBZgp2zCzq/9
	 tGENYBtMffAzzfDzKG5do9T9JAQId3+6AgI5PPxm0ApTSw3gJqZZFF66tvnpgdfmOzLIv
	 CD2q9FwLZlWg7OTTnZYZWfT0CQFy1qCThr8yCb5UmyoY6tPLQ9ejk7g1o1i4YMGGOKW9J
	 GBLPALm09qH+g0vcNZk6JDXKZFlVm/qtc6BwLvuYd0u9DcSu1+pav2sWQIqOjhcFVyuJJ
	 KZgsbqArEx+Q1JVilzjofinWZQlQUX+uuF/wccMItX+ocQq76rXMoH2YBD6V4uH+SVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="a/faIOem";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCE7606A324
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 12:04:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DCE7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a/faIOem
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b8a52db5f9so9787030a12.3
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 04:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795781096; cv=none;
        d=google.com; s=arc-20260327;
        b=UJeslccUnSjef2jHYWHIqG8Ym7+qVzyJyRPGlGRKPXK9/7QWNyjU3vWMq3hCQuo2QB
         oTDQ/qbL11LBsKWKuTcPRVD+RQQaGl5EwfZun94kk1WfpsezTPtedVIbQl9YpCpHxrhS
         z9CrxUb09dSfPVRbDD0+L/PasKBKrH2lQcjqEY636S7zwndEK3XboRy00zxIKy9Haod5
         LPhH6h/DPnqUVoj1ep2n9s+5rAKvz+vc/PdISw9+fUTtv7YIdCrfusD20fmV3WX4sdij
         ikWGGVaOxUEIkI/D1Vy5HD7g5LIMd0a18KxSqXwtu2qS9Clw3PYIaXjGYZN2osBIAJGd
         yOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        fh=olNIDgda1XotS+Of2clU+Y78KiPbRAWgG34VE7SSHn0=;
        b=s6FL75y+32duSb6JC1tw04VipfIxMeLt68xpQq3lHGOOns789xOJ7+458DWAKYDQnl
         xAyJddLLF/jeHS0DDInFDxEGb7CwCYXjBspmDFMX1/7KdZfuSDB97p7YXy8hHNvmHX6p
         pXbsUYyoTwYDRP/tCQtoI38SAgXDaXu6lxQVTOT9zvlUnzZFisvmSrGMT45HoFAWFxH3
         3vWcvuKDpWyezCTBqfJR4V32DdoTsgtqg4jszsw4VMgItpvy2LFoSQZjY317P7Zal1jC
         sHLb6W29H956zCC5H5eYaEiNCi6dEB6O87YQOe8JRh448DT3iMMAIfepxbhcNFYzNr3e
         0+eg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795781096; x=1796385896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        b=a/faIOemKG9XP9oN9nHZ0RXKAJGUuULcrj5tlG5oW/VxoETGk/czdvSllhhNf3cLZ9
         QZfgoKUPAO+lxAeT39SzbkiTrobrvkwTRilpOiRfynBTw3Dq4mQQOsaPpO2q3L/eNCw6
         75tG8Way+N5Y7kNdc374kxwLxPpgXrf4M3aS8Tkoc7ZPyjzg6Rzr+n+Pscq1n8ZXh53X
         8gOnoWD+dlS10yDPmY1W05uiGKpWUmd1Zb6pGB8AYpx6o/RFlMqxj59WZhRkFmmQMlzf
         d6R5FFbL3Np6vQDGcBL5tFUkX4TUGEgF/3bqMPd6LQvhH05HX1jyMVN8C3RNkqypH2BI
         RiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795781096; x=1796385896;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ftbPRsCQ0aqf0DRrrjwD4Al8a/o+mRVmt2zUH0Y6zDA=;
        b=uox/SxwI+jgr/0yEFvxOLE4uISb1xW03cEZ0wa+jgu1UZVVw5RF1/sm7yoU3hOdUyA
         mayFZjrDRMJg3XnyEtd9ZqItbynK9gR+miTCmjyJQFqo3b9uu+waRqND7jmrpGS3sp5i
         DHYstced5JKdZYsJE50TGVV2RXrrKwoLR8QQn/Z+yWqXorfL4k9Sc+/wmruJw4Gs1FZR
         COC80ig4m9izZx7lNgxHYdTYpSPUudetkBXAHQPCiYTGt5V9vpd/TxP2Zyc65N/7YUVF
         GwDsqEh3nKYvy873icpVSl1YWhWlZmbwmJLBJHUxR/QZ+KPEw3u9A3ES3BeiH5zrvFux
         Jfiw==
X-Forwarded-Encrypted: i=1; AL+hErEbaBUenhwbrtELmMVVAAgcSkr2dLxFJNnjMKEdCPkn1I6HgzoVGn5ZoqfE/zVXI8ZYmqSkisqVfyg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+nKZzyIXGGLpxYNsR2WdCeNC2gUnsjteCFcVi5poNmjp5QrJRu
	A5BVFouMQyOyuA+1NIA2iT6MxkzFGA13/OlIMZ2sB9gGNqINU4ECdEQgdZbtbT11wf/9YQvNK6c
	91OKw90izI808IP2Q61wY0K5b/iTdiDc=
X-Gm-Gg: AZFdTZdDt+5zaEAeYFTbM8zr4UdWwCiGA4edm9+QhozoGffxkJIfd3ap0Gt4w+upFmO
	v9IloawKBe9JRuFztuWQfFCm7QWuzCencmEA+XSrvGD54ngM0+4CeXvU4Wm4JPMD1txFUx9GaT4
	mfdCJ5iBCPS5OnjBt4hsRK3QRaOpBPITGgq80KPLTcwh4FZvyWLq9mW3/NyUlLgWhDPfuqH0pgM
	vMW1BcuBb6HZNBbl1MH74h5DOX9yKncFZdsS++JV3ToJNvd4NUHQ+t7X/oCMKCDju5irGEaEqVU
	KrcTmAESXgTJ7T4q6lFCBBFL0FDror+AlttO0aalngKvoEOe5tOElbdXMIUizZbNgMyQIQgoSoi
	90AwaDAZarW/ubx8m43DksLiicKepjuIQsHvERPkLO+1vwKzDjcRSWgQ=
X-Received: by 2002:a05:6402:320f:b0:6b4:59d0:7294 with SMTP id
 4fb4d7f45d1cf-6ba37e9ec85mr20367582a12.31.1795781096175; Fri, 27 Nov 2026
 04:04:56 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-5-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-5-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 13:04:44 +0100
X-Gm-Features: Aa3M54qEfB_iTiJNZjGRc3XRinkgqc1ntuigIkhA7BS94_VSwwZ4uoMmp26Q3TQ
Message-ID: <CAOQ4uxgJjy3TaORBkMOdef-JvzX2uA5K2sbMDEcLqmpkedsESw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
>

This is where the commit ends doing what its subject is saying.

> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT to be used in this API
> upgrade.
>
> Following the FS_XFLAG_VERITY example, put FS_XFLAG_ENCRYPT in
> FS_XFLAG_RDONLY_MASK and in FS_XFLAG_COMMON, since it's read-only for
> all filesystems.
>
> Following the FS_XFLAG_CASEFOLD example, put FS_XFLAG_COMPR in
> FS_XFLAG_RDONLY_MASK but not in FS_XFLAG_COMMON, since it's read-write
> for some filesystems and read-only for others, to avoid breaking
> existing filesystems.
>
> Also update vfs fileattr_fill_* helpers to include these two flags as
> well.

All of those non trivial bits deserve a patch of their own.

Not only are they independent vfs changes, but they also have
implications outside
of ntfs which need to be spelled out.

With current patches, I think this change now advertizes COMPR|ENCRYPT
in fxs_xflags for all filesystems that have them set even with the old VER0=
 API.
That may be ok, but it needs to be spelled out.

Do we also allow to set COMPR via VER0 API? Do we want to?
These are questions to be asked on a standalone patch.

Thanks,
Amir.
