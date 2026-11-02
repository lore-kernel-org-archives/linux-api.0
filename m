Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793628043;
	b=Bpw7UtO60w5KG9HEwNvyrQi302V/0qXxgw/LQnRK7DfeWrmLlXb9cIG/OAfy5qzzuJOi
	 JgC/O5CYA5lIpY+bmJCi94nh7PNvH50y1+KIoagPLa5OwnGvgr6HFa9i8JZtMATWAX8Ws
	 diYRzMY8XcKdv5wChhkd/5cvSKa3BaAKan2kM1YgiKPnwnFRDYHc+d7bu8/g5KQ48Zhss
	 fvC1sHEZAGOAuneRqT4AQWT+/6J1kJwosW/Jg4CXw2LVsNbCaZbQCwjo+ESUPvw0/C/r4
	 r2auefx/H0forMJQbIi5K4tAGOj26GJHZ0Zg8/Hx7Lve1lM4LkJl5PDrIA9iTgi3QUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628043;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
	b=g9rWizxPVp/cU9l2pWbWlZDri+BUiYleUx/uQeehBCSMgWEBoNzFd7rcDq4HT5/X1tkT
	 4y8YLyDkanOHZwrjvzxZufG8CVJqimbrQmHWmPSjm9S8NScyp9JE2suBdFPQdxuNgkZ0v
	 U7lhv2X7r4JjYGSvm9AovJaGA9PPPW65vFeIVz/+wx3nh3Giq8ltLDOfSZvhNrrdkMYZW
	 4lqnkKFI8xwFzrhpfRZcLYKPKSUmfyrmOU/P8pT9f5SkQ2FyapoLTjBQvVdiIA5mo33Yl
	 Y1uW+7HSiXC88FFIjng8lGB0vf/aw7Wbx1q0PcmF/RfPG9EUf1GriHzK49i2baP9qKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sqAIi+u2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6489A60A3821
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 14:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6489A60A3821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sqAIi+u2
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so488624366b.3
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 06:00:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793628042; cv=none;
        d=google.com; s=arc-20260327;
        b=QAHeu9RddiMg3uCJzrxLz8Dn1CSaErmXju1l3/YYAmcpujwq0e0DbO5ytNk/lTxBxB
         X2K900ZwjXzGZPwO9DzylPepPcvkZz5lUbvrOZf52abBmgSYpAeELOdx2QuRudtEbsaV
         GbCUUS5GoClfCD6cZbGSiCtCZJnNq+aHc+GYgWF7E8Kx8t4fTI+EXDFr6QsX2H8KyzSN
         yTOilxBFY2pwW2LZegGbgTSG5aBb5sAU65pkUEOxl7Q6zMMbSfkVifgpXPj80mCyjW37
         PFEU0mdETsVVGORH1zpkr5QCiPTtrCDKa6rgwt6NdAA3HZWmJa3f9P0ifUMVWgGnqyMP
         PfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
        fh=X3DvrAeaaL6eRXmBSlmmhr2uRFcWPEVW272ONwSjZ/Q=;
        b=J9Nee4Vl70S2tFTMC8QM3jZzrYlJcXf/IjBR/ve1FasYIfDljsc/NyjoWOiSo+sIgg
         cW1+ApLlTYpoGKnbfUJx6gY4td4ZmuxU+WaQ+mR2OLVLBKSa95Io+BP3Y4F/TmCk/T47
         WgNIXq9adro3HfbD8SLIgO7GOrMukYC4ugrGmANKtDcwzrsgWCyVZl2LQ7HTjKkvDkoP
         Nqmtf4ZqtD4l7ktxsibR0eT9pp0Z8LeJ7OHHWj6wjxTOUMG/YGcmrn0MPvLU3lwuwl/c
         xNjpGH3pU5WZJiAjnvolZ5A2uxkTmin/vvoAU137YfI6+XIBDHv9AQCjjt3Q+hT7IKGf
         JgnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793628042; x=1794232842; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
        b=sqAIi+u2ogK6jCFX9j76dArnOThd5X0GCkPk+9VoPxB/STC2ao3yNQSapJ/76uyvZF
         UQeJMLj3OjZQ6jYb3yKYpQYBgapfOVjbaeH6XWMUdukR6YyyOJiZarpmEibYav80QQel
         ARzb1zBdJX680p6g7SYIcqKej0UMKNcuV/AzvXi9sTPGi/DS+5e8TNR91gHolVHyQs08
         0pb9QRYTbtnS9lHSmz2/j9UIRd0UCpD0n6qnEqh4x5brTozZCvk/gpLraes7Ilzx05Qt
         g2ZPufDM/NVNfGkokXFUysAeDG9pH92EnlHodWhDjFX58izRV8iTvo18CdxRQeNzpMZ6
         WV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793628042; x=1794232842;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
        b=ERba0bCo7y9lAPF10hEF5zRmk9Jo93wu0XMyE09qnX0EPT2WvvjajGhYPED3Mxs9ui
         Acbwqg1w5E2e6/9j+2Pc8kexMhuz17/Regj6hNdBNG0g+YC0xLn5RMmVMynvxyElX80T
         49YhzDcyNtqfWK2htvTnHliEkWN1rHQvbPFIYQjnJ6AAZtXAFYl4lOSv8uObFR6vtZWf
         FfsCdu7Giv6C44bKjxJYYCnwmtMoSWeKRm0zXAq1H34/5Nt0+OeNX5lmr8Zq57VmK4Kp
         25xJM2WBwlD2lmu45ELnUzFCRHnniFfEHgz5T3OxTiUWEJdhxf1su4d/T5esqSdaDF9i
         dWtA==
X-Forwarded-Encrypted: i=1; AKwUvByJMo7K+M1+pXM3V8PILbZULcXcS2CwDdptxDFgTXgDGfgGX+emoM+cnQAC5dK2CN91QuQJbCBLovQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+737dHYQQ+8gNZayh0/24OdR8aHhprO/DrV8TUcdbCdsSAcdTd
	weTDYdaLVUhL0gyQy4+SrrPKPXH5TcBEXOx0hAyOwLfsZlCqNzTCEfuTiixe9KOlq8wy2f5weBl
	Z/8yo0HDLahPWLQWVPA16dMPtAABKdK8=
X-Gm-Gg: AYBFou2+BB2gnFNgdmla5tyrFp9WEBX3kpUFzmVhmdP09IeJz3VEunb9S2Bn7XFj1K5
	HbTzVh8rCsnPVhT9lxqtJFjGlmUjWpRfT4Dxuq9CEHayfSzte85NFP0Q0JqVWKs3G4WNE2UvUpe
	wqWtOajB2HaLYYk0mEI8UG5IGsTFqT2u18VRMns7n7a5Tny9WtnEvIOVVcJi8V3UFsmjT4Ko8Ne
	dAxbrxnv5hS4YU9++L2AqqwmuZ6ulIO9g8gzwn50ZetfL9f3dhuEVuWOMycpoF+DZkwaxE7NKj4
	TrMppbju37SRLRABdj3WvGlcz0pkBdPR7t4XTTSpoa39uA4hKlulUl8+pMEXOsV9OadQgIfxCrQ
	W9/GNB7nCJ85/UVSjGFM1Q77jhdspKbGONSWgSkiPtnyl5jurJesSvFbSSwS7h0u85/xZ9g==
X-Received: by 2002:a17:906:9f87:b0:c33:9fab:5f61 with SMTP id
 a640c23a62f3a-c4ca7a80dfcmr888696766b.29.1793628041476; Mon, 02 Nov 2026
 06:00:41 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-2-koray.fra@gmail.com>
In-Reply-To: <20261101015551.786044-2-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Nov 2026 15:00:29 +0100
X-Gm-Features: AclHuK8C6KXo0yGTK4G9AdpXOF6ch7dlD0GPHOdparCBMVqSIwGLvVGFGi1BG64
Message-ID: <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com> wro=
te:
>
> Add provenance time (ptime), indicating the time when a file or
> directory was created. This is user-settable via file_setattr() and
> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>
> The semantics of when to preserve this new timestamp are the same as
> mtime, the idea being that there is a correspondence like this:
>
> ctime <-> btime
> mtime <-> ptime
>
> so every operation (copying, moving, ...) that currently preserves mtime
> should also preserve ptime.
>
> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> allow ptime to be used with the file_setattr()/file_getattr() syscalls.
>
> [ This is a re-implementation of the initial patch[1] by Sean Smith
>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
>   utimensat() ]
>
> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmai=
l.com
> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
>  fs/stat.c                 |  2 ++
>  include/linux/fileattr.h  |  5 +++++
>  include/linux/stat.h      |  1 +
>  include/uapi/linux/fs.h   |  8 +++++++-
>  include/uapi/linux/stat.h |  7 ++++++-
>  6 files changed, 52 insertions(+), 4 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..c0645cb22bf3 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>
>         memset(fattr, 0, sizeof(struct file_attr));
>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct file_k=
attr *fa,
>         fattr->fa_nextents =3D fa->fsx_nextents;
>         fattr->fa_projid =3D fa->fsx_projid;
>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>  }
>
>  /**
> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>                                  struct file_kattr *fa)
>  {
> -       __u64 mask =3D FS_XFLAGS_MASK;
> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;

That is not the correct way to extend this API.
This fixed mask was added as a placeholder for
"We intend to add support for more xflags to selective filesystems":
https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il@gma=
il.com/

Please see this POC patch for filesystems to publish their supported
xflags mask:
https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il@gma=
il.com/

This will allow callers of file_getattr() to know if the filesystem
supports ptime
without trying to set it and failing.

Thanks,
Amir.
