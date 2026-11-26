Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795733915;
	b=idpVeyV3AEfPlhRkMFjxV4oGTsmbmSs3vwa0rysX255Oe04KHh9ST+tvEkskg+p4RFO3
	 7bIh1/QPjnWMelpzw+ct2qwoWIsFCAR9cQz4Tw0vIgX1oKBInhxrss3pEk2TK9RBt8zh1
	 KWUxtOr6ikrU8RlRSXH+PGQ9mkShuYlpk3wwyorRBWxabG4TVhNE6KIZ3Oe2IX0vQsx1M
	 yuKIeIWL5ZgTAyerCwtQRj9xHkuiFRIHiT1vMUnHquR02lnqOrO5Nt/sAZX88AWITTnaH
	 7VfJZq/zY2nayM+Nzd48BZit2rpLi/y5KS7fL0zbVulqFhLjXufUpdEfW2FRnQGR4hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795733915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
	b=4r6I+MXEiOokW9NOQgDUZhqbkndJmnia/GDkS1+XaGSZFzxe6xkeC76gcMAt9G5kOxDB
	 RWv2hvYrmAFkcCBMyTCOOs7lcmIDdOfbmTg4hr4owt8HbodxxVuDkNZGjGQKEKcnltGFB
	 4EgovYf+CvvEWjxtxsok2srS60XS6kyMfKAqxKemEtau+X1WSPDuEf1GXEUDVRSAT8AwO
	 xLnNK5PZmVwbUYJj3XwTQnJW8ULbCQrvne1OY9sYWS+mz3fxp+cZfbDqCvvuc7ZWquLFb
	 bFW3bnDweItGNvaKUfjzJv33AInzZL7Dkg8VNrQFRAWWvHf/+NxMwrpu3m5lmar0kcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Slgjv2rC;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271D5606A324
	for <linux-api@vger.kernel.org>; Thu, 26 Nov 2026 22:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 271D5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Slgjv2rC
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so72157655e9.3
        for <linux-api@vger.kernel.org>; Thu, 26 Nov 2026 14:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795733913; x=1796338713; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
        b=Slgjv2rCfiamg+O9GJlFWAOQ9tg1YUbYxrZ9VVQK1e3h5ZRy4TxckJc3EvLoHkPBcp
         6JFfOqwouWJHw9vFwDGw5BKLK/q4FoMI7a/1JQPvJVVt92csAcY0NU1qXo/KRh5S9t3I
         8s5YGzWbAkRGZqQ5yBUMWlQmj1gSwN/6uNKcvQbVoSKqbpgTXmaqjewhAp0RZtZkwIVp
         N07Kpy7P09kbXO7OWl47yKEzBcSb0PEkzk3p0gJ90757PLddYD3e7pKI2zllVzgTjXak
         Rs+BXgOS+tT2mG06wnEKBDGNAQQXcRnPnBLeg0r8YS8lC083UKyytdUQ5+LaBSlDVwfq
         fo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795733913; x=1796338713;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
        b=sDInzfuF/LZdTqaBdJCUuIfnSXZxuWnW4rO93NJJr8yVzvgf+CZGexD8JiFYsXycOX
         a+rRgK3MKuv8xtiXZCI2DcjMUCd4kam6biGBs1TtAh72pisRnasmGgTKzS5eogZhP2Li
         2yFVucpuFMHGObn7i7IaVovcXxCtvqWSOyKyn99TIxiT66ijVJt6yHgOEWVkH8c4cq7Y
         HfYL7iWfGwIoSysnrk5IEh9WWw64/bxTPxY6teoNe8RbjKLmdiTZhFUXKrGt3NIga6Gs
         1Y0YKJe8O6fs5IyfkDIryXJBDUmNj+Hfu2Yjw41Nxl/g1we13yHt2+11WfRffbnS5giH
         WSCw==
X-Forwarded-Encrypted: i=1; AL+hErHXj7il0zRAxD78IQi8DiQ56tPMqoEIWCVtPTI7k1Jn5slwEC0EG4E1v4XeWA6OzT8UkOO3et25NVo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9C1rCbb9DlUWLDfj6zY1HGSfrK0Xx4XaZk6NsizpWRmyapn/Id
	2mjufZZT1NO+kyeH6+TIhTtB6hvIADNQpFjWqYut8R8CMq7V56lne2U0
X-Gm-Gg: AZFdTZfAQqPj16mHiRLTHvcKdC/szZs3S0drfBwhN2wrHp+/1KVlwh+fw34auIhNHmx
	gHaNmhAm1rdFxR+ZxOEIsL6jy5jgjr22riE1Nke4W3vcpZkBJOZ36w7foM3StNuUy7ED7Re6jfs
	/gEp2CkJTvmTzlfOmkmTO1XlqT5KWXfwne0hdYkBNxU7X54m8pfWpomw/S1x5oXWHwBXmY+2hMi
	siWwf7nWjovPDzisq9Pykgo5QalMKNHHQvwjwUJF5+jZ5jfCLi8+8MoGK3dYdTXl9Vx3lJ9EM3R
	AWi8ZfjVn82g70zDccXTltB9HGPv0zOkpT31sWiyXfWq1r7rlvWqEFUg+bAJ2po6lZUfGayoUwf
	IvM1kNRW12g1dGuzC5ppFhhCHQg/hMuG4azmLQlgMg5DWsidZCZNV4Aiz2cYIxY9ermflCHn+31
	VMZTzKBL0dDnYcs9l3mPFExFvdBcmmGNuo4BF5MIUDka/cEYId7YoV9yfJx2IapP7DpagjVua5Y
	Cvyx2em2JR6qyRDadKdzY0bQky1Tk3IEYV1Za8bPEonSKSRiDx2DbnGjet7IPATC58PP7xb3Ob6
	rK/DCYRgkWV7H3Ary3+fjGqh4w==
X-Received: by 2002:a05:600c:4e87:b0:4a7:6bc7:f778 with SMTP id 5b1f17b1804b1-4bb88938d38mr467930345e9.30.1795733913027;
        Thu, 26 Nov 2026 14:58:33 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110c3csm41489064f8f.36.2026.11.26.14.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 14:58:31 -0800 (PST)
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
 boundary=05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 26 Nov 2026 23:58:25 +0100
Message-Id: <DN5IJJMT5L0L.QV32G91MJ6D7@gmail.com>
Subject: Re: [PATCH v2 0/4] Add f*_xflags_{rw,ro}_mask flags to the fileattr
 API
From: "koraynilay" <koray.fra@gmail.com>
To: "koraynilay" <koray.fra@gmail.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, "Jaegeuk Kim"
 <jaegeuk@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J
 . Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>

--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 5:31 PM CET, koraynilay wrote:
> This is a follow up patch series stemmed from [1] and [2], splitting the
> _mask change for the fileattr API into its own separate patch.
>
> The first patch is a preparatory cleanup so that the code in the later
> patches can be formatted better.
>
> The second patch updates fscrypt_prepare_setflags() to take FS_XFLAG_*
> xflags instead of legacy FS_*_FL flags.
>
> The third patch is the actual implementation, which introduces:
> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_ka=
ttr
> - AT_FILE_ATTR_MASKS at_flag for file_[gs]etattr()
>
> These masks have the following semantics:
> - rw_mask:
>   * for filesystems: advertise which xflags they support changing
>   * for userspace: specify which xflags it wants to modify
> - ro_mask:
>   * for filesystems: advertise which xflags they support only reading
>   * for userspace: ignored

...and I forgot to include the improved explanation.

I'll write it and send it tomorrow (hopefully).

> This allows userspace to not have to do a RMW cycle when using the
> file_[gs]etattr() syscalls, avoiding possible race conditions and
> simplifying their usage.
>
> Patch 3/4 also introduces the missing FS_XFLAG_PROJID flag so that
> programs like chattr can leverage the new mask API.
> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAGS_MASK and so it's
> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
> will be used moving forward for any new xflag (like the one proposed in [=
2]).
>
> Patch 4/4 converts fs/ntfs to this new API, to show how it can benefit
> filesystem drivers too, and for this purpose adds FS_XFLAG_COMPR and
> FS_XFLAG_ENCRYPT from their FS_COMPR_FL and FS_ENCRYPT_FL counterparts.
>
> The series has been tested with custom xfstests [3] (generic/816-835,
> xfs/611, xfs/673) across NTFS, ext4 (project quotas), XFS (project
> quotas and extent size hints), Btrfs, and F2FS.
> Note: these tests were written by gemini and not manually checked,
> before sending them upstream (if needed) I'll have to review/rewrite
> them manually.
>
> Note 2: there are apparently quite a few bugs with overlayfs and a few
> other issues, but I wanted to get the final API design out first.
>
> v2 changes:
> - make fa_xflags_{rw,ro}_mask in struct file_attr __u64;
> - add AT_FILE_ATTR_MASKS to opt in to mask semantics instead of needing
>   unreliable heuristics on usize and mask values;
> - reject intermediate sizes between VER0 and VER1;
> - reject non-zero masks on SET without AT_FILE_ATTR_MASKS;
> - add patch 2/4 for fscrypt_prepare_setflags;
> - add xflags_to_flags() / flags_to_xflags() and
>   fileattr_set_{legacy_to_mask,mask_to_legacy}() to translate between
>   legacy RMW callers/filesystems and _mask callers/filesystems;
> - clamp fa->fsx_xflags to rw_user_mask in file_attr_to_fileattr();
> - update fileattr_set_prepare() to validate capabilities and projid
>   changes against rw_user_mask / xflags;
> - move the rw_mask =3D=3D 0 early-return no-op from file_setattr() into
>   vfs_fileattr_set();
> - put FS_XFLAG_COMPR in FS_XFLAG_RDONLY_MASK only (keep FS_XFLAG_ENCRYPT
>   in both FS_XFLAG_COMMON and FS_XFLAG_RDONLY_MASK);
> - update ntfs_fileattr_set() to apply only bits selected in
>   fsx_xflags_rw_mask;
>
> Thanks,
> koraynilay
>
> [1]: https://lore.kernel.org/CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFs=
bcGp1ew@mail.gmail.com/
> [2]: https://lore.kernel.org/CAOQ4uxjVQ9cjV=3D_jBjQtNg9zCuWUEJT9KNYMKV+1j=
wBkHen5OA@mail.gmail.com/
> [3]: https://github.com/koraynilay/xfstests/tree/patches-in-queue
>
> koraynilay (4):
>   vfs: use goto out on error in vfs_fileattr_set()
>   fscrypt: update fscrypt_prepare_setflags() to use xflags
>   vfs: add xflags mask to fileattr API
>   ntfs: switch to the new xflags fileattr API
>
>  fs/crypto/hooks.c          |  10 +-
>  fs/file_attr.c             | 357 +++++++++++++++++++++++++++++++++----
>  fs/ntfs/file.c             | 109 +++++------
>  include/linux/fileattr.h   |  14 +-
>  include/linux/fscrypt.h    |   6 +-
>  include/uapi/linux/fcntl.h |   6 +
>  include/uapi/linux/fs.h    |   9 +-
>  7 files changed, 409 insertions(+), 102 deletions(-)
>
>
> base-commit: 3857587d9d6fa44d40d1c73bde6a39f6f7a5216c



--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawi5kQAKCRDmj22qf5IG
XG6WAPwJQXkvnYM2T6CI+OL3CbCXJcdyvNtTqqpqmtzkWtEBdQD8CWhtnTm8Mn20
vvyMXHnKEDWD/QMw27jw1T31axApsQ0=
=Trt/
-----END PGP SIGNATURE-----

--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b--
