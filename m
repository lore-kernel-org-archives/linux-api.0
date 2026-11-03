Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704423;
	b=wf6k3CapHaeuApOnHDBb2umrE1tyZW0ETdsg6+AlyhtUSo4oJ3b7NTyZfY/q/uwCxmFR
	 DndbMP2HcdGQZL6xpbAW/C0oZWjd1lAFzW71NUUvhL5wJ0B/tDBwqNyydIVWEdVfq/aaV
	 kvqPkaCbnizQgkWjg2amCUdy2d+8jp3Elf4Nf14RRgSx58qweP0SQf+GPzM8o+3fhyAGk
	 rsbvocpb3Xhb1h/YOxuF10pC5TEq7UsW8cD+5QMrNPfl1rVtcazedjAF50Dar6WKbe1Za
	 6uRQevm2CXiy01zSn/Y0fj9PhJ+DiPmtyv7xFOdhm/SOf8oGpnlwmj8FGLX089QxwuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aApL6RX54q6lZ7c3C3mWoQyOMn5uc2rO6KvHRJ9B9N4=;
	b=rxMi3iHGMkusHEnNuDW1dpFCiSnnm8gjdfXqTYJuiGP0I+0Ycj1/OJCN6iTyh4dHWt2K
	 2NQhWF/o/DruzN9X0YcsOR4eENNOCut4O6qG7hE47//oZtf7nkp3aOUokwqAdtFeUcSe9
	 96MbuJdo3JZhtiP48Gf/4dWYH9oNaXS3D62dxF3osYDoAC8T+7j4t7P7Fnf+eMxZCvLty
	 pQyFstRyrFrwQw9BNIvLc6LSKqYe7tJrSHkUsdBsX2b1gw2BNJ0i2TNlVP1i4Nsx7wq2w
	 VlnOXwiay6uVytPNQjaF/ZhwuDD4VXLrXLGvdAv7h4cCc5K1lj72moww4NRddg+s3VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpRmkYQw;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F58606A333
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 11:13:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94F58606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpRmkYQw
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48b060ec084so2375877f8f.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 03:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793704421; x=1794309221; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aApL6RX54q6lZ7c3C3mWoQyOMn5uc2rO6KvHRJ9B9N4=;
        b=tpRmkYQwFppJ27NUtYosmR6LsYnLr+Wiyh6rMF6lYNSjfpXnh5Q8jwzAgXIY4mEpFO
         PllIYdcu14Ls9Kmp+8OBaskBar+dbdSBWjtrhdkzxVAP+lCC14vkl+/CagIJ3uZFA29P
         qRvlXRbWdHcEcZNpvQncxDYc2R2Z3He37YNGQn4KrNI8JR9Q6xr/53Wvj31TZ1cEGugH
         s3b70ufLGfJHYowjGsb5w/bRKJwTQ7C4AI4YkjUDEPYIhGbphI9sIfhwe4v/kbybfojt
         yE3ClQnwVr5GeYlG3rLRUlNKeykNkNj77XFyn5sOHkJHKcNz89okRIlsMxqXCap6SGix
         KPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704421; x=1794309221;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aApL6RX54q6lZ7c3C3mWoQyOMn5uc2rO6KvHRJ9B9N4=;
        b=EXU7FwUAoNSDaIcaog0gm75oGY9JLQBPsziqoPUoy5Y9/fCiABNFdpxj2f+Eto6PYe
         rzb2UpC+8IVGeiUaTKrpr0fc/3w3UtZ9TrnD8growiXPtGjlDmg2KJWFXUbf7AiTRX2l
         tPDvDuAM7sZQ8P8cysqEIZj7QjhopF0ps0s65Y6kPqCy/ICQuTewKlthXEhA8i5wcdqS
         5N72RkFFXbxKKzUtKncgw2ZsZSH3rAp6vHDkdL2JUcmIgomb9cUFKXOgPXyp4aTDmetD
         oU3UAL+iE0xc18++5JsFnfTW6JzO7fGqhSZQoPc0SJTVcO5D1UHZvsgEVp1WpmAZAY1r
         gpDg==
X-Forwarded-Encrypted: i=1; AKwUvByBGZJ71n1yj3d+h7cf5R6JiHWz8WhgfAxazdd5eNXNIVOpjG8TYN/aOiObrNxn1lcNP9aszd/8sCA=@vger.kernel.org
X-Gm-Message-State: APuU4Z9KQ476eCkJFsnpNgO52jGJh0gkf3D4bnY4pdWVbybJNbHBZaWR
	kChaxzSNTLADdiPPSJQh0HpINaZOrSQu52sHLnwa/sfBX3dy0XWxKmMq
X-Gm-Gg: AYBFou2XASbabS8m5VtvDpcB+jXxUipr3FUCLDQ5tDeJYvaWpBOEDQPXtTuNngqoyn2
	miE3I6LCFJ1j7EJ8rX65tMG+TlG0/lVKtgW8zV/fy3Bg67JD66ZCDv9zBwpnP7lYUyPUN1MJmIJ
	Pdoq4p0wOMInpQQeeXFfvUhF7ECx1+pAZwfuD09rOKhOqJ4mrpe1cqHk+tJ2sDSEHNroJC6y2LT
	FNdNoJNCDbU8nV5QfOMhBbB9ffmvlQPO6VLB8lkAeg/Ic5ghRvid1MtFS7TT5UCJi19h845+E2Q
	mrJAoJ9xQtPVzrFhjT1um90ytkHji0TtkuX8FtBiOHftpG3oHP+5XfbTuZY8r12DDU3qxYaBUTG
	AvJQw9UXsu2fZHaesy1A98v51pCGceAjGBkveYuaS+09s7caFWlNhctZvaKtmtUVoMJtmm2GisA
	xqIQDbVryuHO1teSaX8QnbDBVqVvJTZFmrPfhaLit0Oy1CCIrsVq6E37Us9FnVL8VwYa5Q1qRV/
	uhNGZGAcBffjcIs8F+9I0xaAo0qYVt1DPIUTrZ/R/5BvzCVLNfB91DtN73W4BbnFbsBJ2eMleWe
	q13IPKikv836I7fmKFkRDJCOutJR61h7uQbs0LPD2EpC0uHg
X-Received: by 2002:a05:6000:4311:b0:48e:20ed:d5e7 with SMTP id ffacd0b85a97d-48e6e2ff167mr26601099f8f.34.1793704420858;
        Tue, 03 Nov 2026 03:13:40 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a5a7sm25639265f8f.37.2026.11.03.03.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:13:40 -0800 (PST)
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
 boundary=e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 12:13:37 +0100
Message-Id: <DMLJ5DR2A4KZ.28U8XSZ0KFJTG@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>

--e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com> w=
rote:
>>
>> Add provenance time (ptime), indicating the time when a file or
>> directory was created. This is user-settable via file_setattr() and
>> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>>
>> The semantics of when to preserve this new timestamp are the same as
>> mtime, the idea being that there is a correspondence like this:
>>
>> ctime <-> btime
>> mtime <-> ptime
>>
>> so every operation (copying, moving, ...) that currently preserves mtime
>> should also preserve ptime.
>>
>> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
>> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
>> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>> allow ptime to be used with the file_setattr()/file_getattr() syscalls.
>>
>> [ This is a re-implementation of the initial patch[1] by Sean Smith
>>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
>>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
>>   utimensat() ]
>>
>> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gma=
il.com
>> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
>>  fs/stat.c                 |  2 ++
>>  include/linux/fileattr.h  |  5 +++++
>>  include/linux/stat.h      |  1 +
>>  include/uapi/linux/fs.h   |  8 +++++++-
>>  include/uapi/linux/stat.h |  7 ++++++-
>>  6 files changed, 52 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/file_attr.c b/fs/file_attr.c
>> index 833e03810b24..c0645cb22bf3 100644
>> --- a/fs/file_attr.c
>> +++ b/fs/file_attr.c
>> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>>                                   struct file_attr *fattr)
>>  {
>> -       __u32 mask =3D FS_XFLAGS_MASK;
>> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>>
>>         memset(fattr, 0, sizeof(struct file_attr));
>>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
>> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct file_=
kattr *fa,
>>         fattr->fa_nextents =3D fa->fsx_nextents;
>>         fattr->fa_projid =3D fa->fsx_projid;
>>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
>> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
>> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>>  }
>>
>>  /**
>> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>>                                  struct file_kattr *fa)
>>  {
>> -       __u64 mask =3D FS_XFLAGS_MASK;
>> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>
> That is not the correct way to extend this API.
> This fixed mask was added as a placeholder for
> "We intend to add support for more xflags to selective filesystems":
> https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il@g=
mail.com/
>
> Please see this POC patch for filesystems to publish their supported
> xflags mask:
> https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il@g=
mail.com/

Thanks, I did not think of adding a dynamic mask like that, I will look
into it and implement it for v4.

> This will allow callers of file_getattr() to know if the filesystem
> supports ptime
> without trying to set it and failing.

So after adding fsx_xflags_mask to file_kattr, every filesystem would
populate fsx_xflags_mask with all the returned (=3D=3D supported) FS_XFLAG_=
*
in their own specific .fileattr_get, correct?

Best,
koraynilay

> Thanks,
> Amir.

--e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCaunB4QAKCRA0bnTtJTDo
OGlqAP9FN1O36Vljpv9qu+GHoMq4dpgT5l0jYNkHeq3xwaeLZQEAp8imIPg1c77f
Nx6+7PN4i6jMGvOBbnpA+XfhiQmdEgs=
=mk5d
-----END PGP SIGNATURE-----

--e80d9f52f04d877396f5736b7426fc0b9ce68638903c33e71797700113b3--
