Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718890;
	b=u4nVT/nMkH9R5urOnKa7o29C5Upu5azqltiuj1uwO/A7+ZBSKgXLu/EHVRuWHbcs7Ix1
	 96h+ZqpYxmM/0OgZyFiBzQJBfgXaBOkGAUoo3VVFIiOdXTaPz1ElM5nY2vPZmP/ENhavu
	 tDLwDjuj9GzZfyHyMpEuZ1g3G3bXsTI/1GW+lavMmDFDBbobyFp8NiMtJI/jjnSoubuWp
	 +K22+ESEoh2STnn6tFMJ9fgWu/eDGUHk+zmD2V/n6edzRM31gE2Kl4jhRoTSrt2sKkEXW
	 38NabzJs2aImd/i2TyXDqPaM/W+qz7W55krjteRb4h9XuT+0y453XcSOHwEpHwLo8Cg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718890;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
	b=b6gVuLlV5pgAXg5y//oOrV5CMz+x5CHSG7oCY4Dmc4mPQQg6aRc5OxSoElYUnhtuFhBB
	 OXVIwEBOsHDPZhTPMxGHDbG5oQKmzhqefnzX466L4KPaVNy2vKC+vzwAxK5bxMHOloEap
	 CmihIHxfsYlfgrF9kpMeOBph2tp1Jo0EqRrjxkBBdQUDPC1nhrJmn06a0Op7Oiky1pZsu
	 vQw94zcHRxr4viuDNYfvmIG1zdOnXTm2LuyeeNk9UpbB1BXCF13o07GTneWRRiK98VelT
	 Ha9PNr+Xoy03vfk5rMY4XEMfzCPlw791RYzumwcnCNyVtLaTwLzrF7Xm/jcrFE0qHRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iAw1L019;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866AC606EE8F
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 15:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 866AC606EE8F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iAw1L019
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so6198459a12.1
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 07:14:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793718888; cv=none;
        d=google.com; s=arc-20260327;
        b=UERpfWZKFAiK7RFlQCmGnAj86O/9krr5Gcd2zBqMMBnwCjjbsjFjg5MFHVkvCkKrHx
         jCGFLavp5UC/0wx5CiNFNPpZOGOr+B9t3ret6tHEqw/JabY3WVu3/ygTixjlEboe9yIK
         Puen7TlUTBbqFvilKm1V3C7t08GwgYdAS8EBTsvFl+TOea7bkNFiU8J1gM+3DWPhFZvO
         GuU9uQFjJD+QE18LF2wJtW1Dzj1ioJtxZlL4kh5xvpHnR5vBeh9UVOXtn1iB7tvKRmM8
         yNMViAxW3g03VfmvZIQkE64pI4H3T7KOaj/sLgRSGB856Di56M4emUmI7A9fLap35qXX
         Ox0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
        fh=2j2kVG1w5f/Ep/39cxFoS2CTywCTNkNv3vNbFDWBhCc=;
        b=h3yC82dS9K/mP5mqMMY3Fx8hvSeVLf0c9yCSzpftCl+8YUn7SRGm723aOpkTKVRf1f
         6xauk211jc7UytL9wnMDA5UJAVIaLtxuK6B0D5e6LuG40kJhmZ64esexnTimJW9HSMgM
         tdkNQZrudIvC4zzLGek8z8c2hX6BWcD/2z2WwqVESFy1pN8CNVBGRicckf9g3t0RrFWY
         LIH9O/Cs5POBxSbL67PELDYCEmnqwxj/nrdMKVtlCnHI6a1MTLzpC24FatX5IOFVUD/J
         TSLT1T9ZMOlSwPxswerAW9K82G2Q6MXcDpi8ca1TgsFFzS+t/Oj0V5mh8sU9rpFPt6Eb
         Nveg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718888; x=1794323688; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
        b=iAw1L019pbEECqKdWoucVoYt8cFM0CJimSPA3rGm9rZtMZpD0LGCCG5hkH3c1GOMpf
         IspJYDJNQRBAf5O6qxCrg24PZgTtDkgCcJNc+Te/FaLgF/P2D2ygdPGcLtFbCUaY0gnX
         nmK4XIqfh/wBKe13PTQ3kpyVHbCepAgmJlXpEqP8L3+CnEReQhrjzuddQkWkPc8aT2Ew
         WXWATOtMwvJL4pflCNbceNHwqDeFvIKJFx0h/Vg6B5F579r0iqYdPkfD5EDX+IkmrfUS
         8lO3wA9EaUVodg+Hln22pbunmgEx1YJidGyr6Qo2rLI9Snk3VNHTBqzw5kVIPPr31SEA
         cHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718888; x=1794323688;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
        b=rv2pUw68IpqELRFmjvDhbgT2KYQozkTQQJy3XMOTFs0ROE2KmhJRQOW29l8RBiNB11
         EdXxehtTHGXijFdE/qbXwKBpjaVZRUey8Ev8iQ7VZCvsFMO7eM2khuV/ri2qjwjG3VfT
         CQEc/sUS8CNnc0oG9nfRyr9/FIq2TbhnFnHGX98wpYBMY0aCUOmEv4wDYbMlYkc3P9Hy
         AbajlsFWFV9su+pQEdNcghSIfeH2kevnRfgiG9zLnOCc9Np2yEpm9qabao9iEpkX4hS4
         M2U8z23S6dzgt2BFUT/RjzQNVRwNHe3Ix07tvQXatYMMYxWCTG+kbKwoJycuqX86ZoZc
         pdug==
X-Forwarded-Encrypted: i=1; AKwUvByaAxLv7kBoeMN7bGK52jrAvjB0oz4Io2taEtrQ/AQLS3Ri+ZtOFSZU1ttKgQykw4Li1QQobKxTrlk=@vger.kernel.org
X-Gm-Message-State: APuU4Z93X3NVq1Oduw5+tAlNtl3TUA2OSDqcPqVIQi08SIY9OR5HeQJG
	BcETUBLEUD0m4A3COGpbKBW0qhsEeVjDErctxjwl4sPEK5F5+e9XeglF65NV3SH+kNwUlXXvQzS
	lJv/rwteyHB+lSA1AqameD3IT/DUJAz0=
X-Gm-Gg: AYBFou3Rn/vGTkKI5Qcu+pHMr1na1KAE7TMGGpUAozaPhjVVXZ5ti0z9imE43jPnXwK
	TbwVOVDURubKdcjpJG5/rMtPCRjkM5Guz/ylZi/PSJs936QyN28MAcfXb+zR12Jqn6WH7z9hXq7
	m55hCWN5BOD5oUvzfNEeBcuSWThlCiEcLffvkOmBq8y1Z60GG0tvVXVi8oiZyN4xPuINnmUrPwt
	TtBI3Hqh3nKU8SS6FL903kD8wALgXHr9S98o4qVmFhhyz6dyuDVTQxqpb1n1KwM+ZiKiQhyh3dP
	vW6ZR9RhB/PC8cqHqX4IHSkPHzyRnj2wGwo7RFA+kIynhZSHnHWZkLCSc/GNCzlXP5eNnmzFiv6
	rKWbPer3AUqhFNb4wOK5onlO4Ds7yHCS/tnWSgdX8S/szHSdUOl7rBKuXW6q6ezfvQlx20Ik=
X-Received: by 2002:aa7:d309:0:b0:6b3:f094:8ced with SMTP id
 4fb4d7f45d1cf-6b4d4683a29mr7344511a12.21.1793718887787; Tue, 03 Nov 2026
 07:14:47 -0800 (PST)
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
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com> <DMLJ5DR2A4KZ.28U8XSZ0KFJTG@gmail.com>
In-Reply-To: <DMLJ5DR2A4KZ.28U8XSZ0KFJTG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 16:14:35 +0100
X-Gm-Features: AclHuK-EjP75rU69csZK2uVzxHspULIwEcPYYUtLw5t3M157ApaMB9lhTx9MQvw
Message-ID: <CAOQ4uxiTS-QT7y1avNSasJSffkt2uRNkdrb2_GrK7kJ82-MoXw@mail.gmail.com>
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

On Tue, Nov 3, 2026 at 12:13=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> Add provenance time (ptime), indicating the time when a file or
> >> directory was created. This is user-settable via file_setattr() and
> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> >>
> >> The semantics of when to preserve this new timestamp are the same as
> >> mtime, the idea being that there is a correspondence like this:
> >>
> >> ctime <-> btime
> >> mtime <-> ptime
> >>
> >> so every operation (copying, moving, ...) that currently preserves mti=
me
> >> should also preserve ptime.
> >>
> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() =
to
> >> allow ptime to be used with the file_setattr()/file_getattr() syscalls=
.
> >>
> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick =
J.
> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
> >>   utimensat() ]
> >>
> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@g=
mail.com
> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
> >>  fs/stat.c                 |  2 ++
> >>  include/linux/fileattr.h  |  5 +++++
> >>  include/linux/stat.h      |  1 +
> >>  include/uapi/linux/fs.h   |  8 +++++++-
> >>  include/uapi/linux/stat.h |  7 ++++++-
> >>  6 files changed, 52 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> index 833e03810b24..c0645cb22bf3 100644
> >> --- a/fs/file_attr.c
> >> +++ b/fs/file_attr.c
> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >>                                   struct file_attr *fattr)
> >>  {
> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >>
> >>         memset(fattr, 0, sizeof(struct file_attr));
> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct fil=
e_kattr *fa,
> >>         fattr->fa_nextents =3D fa->fsx_nextents;
> >>         fattr->fa_projid =3D fa->fsx_projid;
> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
> >>  }
> >>
> >>  /**
> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
> >>                                  struct file_kattr *fa)
> >>  {
> >> -       __u64 mask =3D FS_XFLAGS_MASK;
> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >
> > That is not the correct way to extend this API.
> > This fixed mask was added as a placeholder for
> > "We intend to add support for more xflags to selective filesystems":
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il=
@gmail.com/
> >
> > Please see this POC patch for filesystems to publish their supported
> > xflags mask:
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il=
@gmail.com/
>
> Thanks, I did not think of adding a dynamic mask like that, I will look
> into it and implement it for v4.
>
> > This will allow callers of file_getattr() to know if the filesystem
> > supports ptime
> > without trying to set it and failing.
>
> So after adding fsx_xflags_mask to file_kattr, every filesystem would
> populate fsx_xflags_mask with all the returned (=3D=3D supported) FS_XFLA=
G_*
> in their own specific .fileattr_get, correct?

Not all filesystems. Just the ones that wish to extend the constant
legacy FS_XFLAGS_MASK.
So just the ones that you change to support XFLAGS_PTIME

Thanks,
Amir.
