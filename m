Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859825;
	b=mTh629mmReI3s4KZCYAhz0v+WTnO0lvtkXEwuAC6ua7Uk7ixv6ZhRtAmvV2uqnXIZspl
	 6slIuBB6Gt5RE9XurU6jlc3uDuBNFNJdHxfORcvpIB/u4VwGiBvygOdflsLO2FN9WAt+o
	 8Kq5OfIXjYmiG1cjI8ZqKuU3lWqCjsYT+2Lr6yCaer9vq1HS4DZEflQPVJPg6mLmXoN4Z
	 uyuxFuukDc4dTgt7xITl2b5fGpgBDQaWGkbmL/OZgqJBV/CvDxBbi2Prg7IdmT3B8lXQp
	 PoXWfVBBiBqWNwjuDKEdipe6OgXABjXU0R8fWEppaqecmNnQoD4am/qpkORarAnVW3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
	b=FkrbQv5X02ENBXd8d1OsFGfT+bFZ/aB5D8UrKEqoC9d78sEN3Uqed2gMtSPhtTcgfGrP
	 1foNsAU23d796LfrfV8PYYFt4PjYZJYt8OFasnfdLUTh7t6oo2yGXdE+l1nv5k/1oDmZn
	 CdTiIA98utjhha0tVk9aWM8lTtqS/H9tQMng4+kjjF38fIHes5gdnoCtVNGZyy0CjNA7w
	 nZHnqlmMyyEh3nIL5v9JjOM3/7iuefyUGzgiXLwz971ZUQ9yV3nlC5GIHgzz/27Fst1YK
	 VttNHajRtQrW/VuB3SmsXVcffbvUJ3/sHEO+X1mzNEePuDgCZnv0vwzeS7s3aPCmjGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WOxtFWMy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2163606A8A5
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 20:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2163606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WOxtFWMy
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so5953870a12.1
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 12:10:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859823; cv=none;
        d=google.com; s=arc-20260327;
        b=FUvhKfdrOpiRsWy3hLrGiuyrZKnA4eF55VEAsdcppoKda0mbKZfjrfkECkipNq/uPC
         hwFJmNR8MN5cmnZzY5Hxe2mj0DSgXwt027daHIMKencwGPjS+O/sGgSbHi09OO8McPaS
         Td3JSGgeG2ujlSRq3v3SrVQzY0vEHq2gTACKWLue2f8g/8jNlSV2qbvVUtMoquQRw065
         XoTgv8JuYXx+ij9TcrykuhbshZ6diW+XUnyCRQkZKOtnaJYj3+AoD+e7MuEDtjfYCWbh
         dCR42YTmfD50opSA/0cZfnbN1CJOelasCAZ9URrpuoHhDRBhMs0cU1QE2PiENrVxkLdM
         9HQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
        fh=niSWH1FLg+v9NWMrrWtNwdGsDOaLj1OlLqDLqbf/AL8=;
        b=k0gNR9/zItZb/dmiduDz9tAIb5DmwPrWR58KZkjy0YYFf2d6VihdsKC5H0SUYk4vYw
         4l7lGGTfCRpXNT1s3ziSovQFNLiyLOP5i6t2Q8E/E1Yx+8FDf5l/lAtqr9o3IR+SkjQm
         YKgYslEnf6ax5MP01hotZSXQpIPl6jbV2NgvAzrBZd8mkieAI1hcVjOIGBkWXF1INc1S
         Iz8VPyyOpHNCb3BHIWJezw6d8OGx3yThUxf2FhocjuUwgsjBDbqlGhMdDRN/haq2BxD5
         fLgJqGUTBwbhXXySb9faSB5WTH98D8Ru0nhjfWiFYkogg8URBaVOo2Jk9UvMSnEyxg8Q
         6tkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859823; x=1795464623; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
        b=WOxtFWMyKSPKodrqO+mGvFaJ85nCUDAL1UbckpoCKdZZSDr6KLP1X3+k/+dUDOnHsz
         Liv0XREDYRmthCicNGPv20LYm7ELc2RuwqA4Qa7jKGzmBys8KG0igoBS5BLir3B/I5Oi
         /bgRuIn+89jEfgoRFFsF4kxmgi+DuU8n5fJ3Rg4LrQkfy2rePKI3IipY7ZyCU5oGLJVq
         PSha1QRCep6BbWSr4yXUqyOX3gDVTapQFi10/X2ht30305k3ESrBvJ7NkpVVSXa6XAsH
         nbsd+tFu6FNI6TlqkTQduwEBjohtbx6EC8CpwweOUWlftKpCXtgRzKyhkQ87oy+TaMVf
         TxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859823; x=1795464623;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
        b=iQ2oRT7NOLbfW0xjBh+hvhhKlhfuimkGJCRNH/ayN8SE/JVHRcbOwmkp9UFTVeAP4y
         2M0Y8LIlNdxcOhjVKgJf0P+a7HFCnG55c3rUYzN8u6zO/+WWzXZQhm88lq7DcctRpmdt
         QP3LYOEfuco0ULXyRZso83kznXY/NoWjUIPY2X2auUBHnVK1vBN80vPMIzPr6iYxrsZ8
         ZtxnPYFYYEXTORmed5ypJbJbl6Ve8mZ2ivABeAC8QDkTJUOdEIDR7E+mFjhG2eDc0PRb
         IsnFbTxXgdd6/YtlZSLwkE7AJaNxuc8SnBCm1meZKzWbRvMJ5wyc7pKsmnMyoUhXCLpq
         I0tg==
X-Forwarded-Encrypted: i=1; AL+hErHuJrJ9NliyH+dO0LXVLdsKrV99geKmElk321JXnakkqAQfGGiYSl1gTTUCfxEOo6SbUR2f/Um/q8U=@vger.kernel.org
X-Gm-Message-State: APuU4Z/xO5r0xKrQoa0cwbdDgLqbwxIrNNS0CVY5XuTE32MKsvo9P1Co
	gp7FQHNrLdTFQu7mrku8ja1t0sWEibcs+Mq7XjLVX6NsnNqMwQs6SUyNg0e3osBwO3++BbKfpmy
	gbLdNRQ02Kche983Yz3AsaV6n7xB+5ro=
X-Gm-Gg: AYBFou0yu5VzGzvdv4xbAN+kL8uAfApAIe7mFvGs9n9cvBEnxzsPluLM7jHLeVAtVxT
	WD5EVVGGTZvLvwy340C8pFbQpM4D3ZuEXLmRkd15H0/DYUwUbs3vBOal/1x1QWzPJOVzBDpoEGn
	K9ZGSopnBh4G2fG3gI3X9WsY+nH6XjndcnmxeX+EnXQRH7Pc33AG3Cun73Kcrukt+4avxUYy1pl
	AsdQ/EX4pbg0a44K7HCQfQVrH4SaRq4CT7ETTMk3lSrrcmzjAWf+uyk+FNXtUJoQBrzO5UM6tZs
	zbQXVsDAWLJvhom/TpPdxXnfOCKmBy4JNvdRj6d+wwlMUD8qZzQ7U9ib5OmocZ3Ao2YBxhGSPP1
	bquvWULQ8To/MB7s2YBvdA9sZoMvLDDB+FDYlZm0ppopb6NB8oMbwCHyklnzYSuNVVJUPgw==
X-Received: by 2002:a17:907:802:b0:c29:5172:6151 with SMTP id
 a640c23a62f3a-c5096415a37mr947928266b.45.1794859823120; Mon, 16 Nov 2026
 12:10:23 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-2-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-2-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 21:10:11 +0100
X-Gm-Features: AclHuK8HNkwAKAuOh7lYPiqcrySU8WxcW1gHG_-7Ti6IFMhOniGdmSp4CPwzuwg
Message-ID: <CAOQ4uxi+50NU8qzg+Owvr8gFZ4vYF5FqWg4Hr9vB6ONUpPsFwg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/10] vfs: add provenance time (ptime)
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
> Also add fa_xflags_mask to struct file_attr (and equivalent

That is a very big "Also" part
This is a significant UAPI change that needs to be delivered and
explained with a patch on its own.

> fsx_xflags_mask to struct file_kattr) to let the filesystems advertise
> their support for specific xflags and users advertise what they want to
> change, behaving like statx.stx_attributes_mask:
> - on GET (file_getattr): each filesystem fills the mask according to
>   their supported xflags, e.g. FS_XFLAG_PTIME or FS_XFLAG_COWEXTSIZE,
>   and provides the values in the corresponding struct fields;
> - on SET (file_setattr): userspace fills the mask according to which
>   xflags it wants to change, VFS validates this and preserves xflags
>   that were not specified in the mask;
> - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
>   compatibility with older programs.
>
> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> xflags and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> validate that the xflags passed in xflags and xflags_mask fields are
> valid.
>
> Finally, add the missing FS_XFLAG_PROJID flag, to allow userspace to set
> the projid using file_[sg]etattr().

This part also belongs with the xflags_mask patch

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
>  fs/file_attr.c            | 75 +++++++++++++++++++++++++++++++++++++--
>  fs/stat.c                 |  2 ++
>  include/linux/fileattr.h  |  6 ++++
>  include/linux/stat.h      |  1 +
>  include/uapi/linux/fs.h   |  9 ++++-
>  include/uapi/linux/stat.h |  7 +++-
>  6 files changed, 95 insertions(+), 5 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..12610fb6a751 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,14 +102,23 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       /*
> +        * fsx_xflags_mask contains only flags added after the
> +        * file_[gs]etattr() API, so we need to tell userspace the filesy=
stem
> +        * actually supports all legacy and new advertised flags
> +        */
> +       __u32 mask =3D (FS_XFLAGS_MASK | fa->fsx_xflags_mask) &
> +                    FS_FILE_ATTR_XFLAGS_MASK;
>
>         memset(fattr, 0, sizeof(struct file_attr));
>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> +       fattr->fa_xflags_mask =3D mask;
>         fattr->fa_extsize =3D fa->fsx_extsize;
>         fattr->fa_nextents =3D fa->fsx_nextents;
>         fattr->fa_projid =3D fa->fsx_projid;
>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>  }
>
>  /**
> @@ -141,15 +150,23 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>                                  struct file_kattr *fa)
>  {
> -       __u64 mask =3D FS_XFLAGS_MASK;
> +       __u64 mask =3D fattr->fa_xflags_mask ?: FS_XFLAGS_MASK;
> +
> +       if (fattr->fa_xflags_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
> +               return -EINVAL;
>
>         if (fattr->fa_xflags & ~mask)
>                 return -EINVAL;
>
>         fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK=
);
> +       fa->fsx_xflags_mask =3D fattr->fa_xflags_mask;
>         fa->fsx_extsize =3D fattr->fa_extsize;
>         fa->fsx_projid =3D fattr->fa_projid;
>         fa->fsx_cowextsize =3D fattr->fa_cowextsize;
> +       if (fattr->fa_xflags_mask & FS_XFLAG_PTIME) {
> +               fa->fsx_ptime.tv_sec =3D fattr->fa_ptime_sec;
> +               fa->fsx_ptime.tv_nsec =3D fattr->fa_ptime_nsec;
> +       }
>
>         return 0;
>  }
> @@ -232,6 +249,23 @@ static int fileattr_set_prepare(struct inode *inode,
>             !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>                 return -EINVAL;
>
> +       if (fa->fsx_xflags_mask & FS_XFLAG_PTIME) {
> +               if (!(old_ma->fsx_xflags_mask & FS_XFLAG_PTIME))
> +                       return -EOPNOTSUPP;
> +
> +               if (!(fa->fsx_xflags & FS_XFLAG_PTIME))
> +                       return -EINVAL;
> +
> +               if ((unsigned long)fa->fsx_ptime.tv_nsec >=3D NSEC_PER_SE=
C)
> +                       return -EINVAL;
> +
> +               fa->fsx_ptime =3D timestamp_truncate(fa->fsx_ptime, inode=
);
> +
> +               if (!timespec64_equal(&old_ma->fsx_ptime, &fa->fsx_ptime)=
 &&
> +                   (fa->flags & old_ma->flags) & (FS_APPEND_FL | FS_IMMU=
TABLE_FL))
> +                       return -EPERM;

I don't know what this is but it looks strange.


> +       }
> +
>         /*
>          * It is only valid to set the DAX flag on regular files and
>          * directories on filesystems.
> @@ -288,13 +322,41 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap,=
 struct dentry *dentry,
>         if (!err) {
>                 /* initialize missing bits from old_ma */
>                 if (fa->flags_valid) {
> -                       fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLAG=
_COMMON;
> +                       /* FS_IOC_SETFLAGS */
> +                       fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLAG=
S_MASK) &
> +                                         ~FS_XFLAG_COMMON;
>                         fa->fsx_extsize =3D old_ma.fsx_extsize;
>                         fa->fsx_nextents =3D old_ma.fsx_nextents;
>                         fa->fsx_projid =3D old_ma.fsx_projid;
>                         fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
> +                       fa->fsx_ptime =3D old_ma.fsx_ptime;
>                 } else {
> +                       /*
> +                        * Preserve unmasked xflags when running file_set=
attr()
> +                        * with a mask, which doesn't need a read-modify-=
write
> +                        * so these attributes would be set to 0.
> +                        *
> +                        * With FS_IOC_FSSETXATTR or mask =3D=3D 0 (legac=
y mode)
> +                        * this is not needed as userspace does
> +                        * read-modify-write already.
> +                        */
> +                       if (fa->fsx_xflags_mask) {
> +                               fa->fsx_xflags |=3D old_ma.fsx_xflags &
> +                                                 ~fa->fsx_xflags_mask;
> +                               fileattr_fill_xflags(fa, fa->fsx_xflags &
> +                                                    ~FS_XFLAG_RDONLY_MAS=
K);
> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_EXTS=
IZE))
> +                                       fa->fsx_extsize =3D old_ma.fsx_ex=
tsize;
> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJ=
ID))
> +                                       fa->fsx_projid =3D old_ma.fsx_pro=
jid;
> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_COWE=
XTSIZE))
> +                                       fa->fsx_cowextsize =3D old_ma.fsx=
_cowextsize;
> +                       }
>                         fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
> +
> +                       /* xflags not present in fsxattr */
> +                       if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
> +                               fa->fsx_ptime =3D old_ma.fsx_ptime;
>                 }
>

This whole flags/xflags duality needs a closer look
This looks a bit too complicated right now.

I don't have time to do the full review so wanted to give you the
main feedback first.

I'll try to get to it this week.

Thanks,
Amir.
