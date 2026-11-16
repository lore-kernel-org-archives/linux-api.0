Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794837180;
	b=S3JuxxqjHrRJEEXcpL19tpr5WE8u6TwkcftxDv53UbCX5ny56Pc6rSIGL0Y4LBvtOoYm
	 V/UDLYz2VR3aOarT5AOhFBwfpBmmfCrr3BimAx7mhNenX05+NVpWNVcnWuP4P0sea3Yzd
	 iPaMcC4cTQfnPqQZbrRcJNKnkh0EuQgU9iEoQT04GutjdD8kn9TLcHVmebk0qR+g0n0ye
	 sXUo6dJTw1vkdehLi4+LHQ0BaFM1YcPCXh4wA/aOaDSXtVIoMFnMEEAfYldkMtrWzC1Xn
	 shWZxrdP9SIoZa9+lkTn2heSw89VgF+lROjy+YKHsmSG4nFmjZ73mUMQCrPNpTevY0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837180;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yjMfJPlhmwgFldHvOAN6a+VpaF8LquFmHlpLZaL46tQ=;
	b=teyM2HP+OAMwznAVepFGTdeezXfNhFTXzaD/edWOxfwe9552fEWnrNBqwrFsDVz4UZQU
	 0h2DDnkbrJzBBA8GS5EpGS22RdtaPd3qMLpnEshNcQnm9dOjODrJ4Chb7EIsubi63iqSJ
	 hyFw2UaZ69MLB2Yko+2PPgaLjDvWVm1rQQCQhBgZcY061glbidGOsvGqNQGMoO+MIEkDT
	 b9AjZrQpxGoziGYvfIoenvoHXk4RHu3B/Lu3br/ClXaDZPk8/7pPRuEJ/ecMJ06XShOGq
	 7W22M/LixbKOIdDNXdq5rM0ZuymuA4JHCOiw60K15zWR1o+Ur7msqHed9srt7MANoHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="dK/KA/kv";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA8E606A331
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 13:53:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FA8E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dK/KA/kv
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b571979178so5421733a12.2
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 05:53:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794837179; cv=none;
        d=google.com; s=arc-20260327;
        b=E/LoXznNtvj+Y82uaQyzzgZEGJEJJjo8RbsMBSojG/SgWtfFYYhHCgo2CpUaN55N4N
         E7l4PYkKo0We/XHHnX6IbS7pvT2UEVwt2VFjnk4foKj2OJ8Dh3FiaUXKq5pyN0Km8HDQ
         HOP7un6cPOp5E0qedMRW/w/Ws5ji7ZYjC9jw4TmD5Kw2vp6TJo/dJzwTAlgJTaaS/06l
         0ca74ODJKuVFc5kSQPvKg4TXkV5HyjG/hNUuQrz0G2gx+Nf2QX+V3Ib9Rksa8fZuSpyl
         rQ3WK9xog0jtagblszxCzVOWmxEQ6ldq696K7AP2cUcqV8Rto0hxl8eCYjMK86xifFdY
         h1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yjMfJPlhmwgFldHvOAN6a+VpaF8LquFmHlpLZaL46tQ=;
        fh=M87iUYmkrWQuPHf69/DHU+VXnhxsZ0n9oKTyb/S9/Y4=;
        b=iBFEx/0F5zpiFDKXE3S8jf0ypZ974ek/dCx9ABMKeQZ14Jb6Ql6x5m8RTTh0d9q2/R
         51mXbZjFO5BW1SVVoOYLvwLqotOiold3RwfXAoJu14I5OsjcwkwrGdomwrwPa1t/xmhI
         gq1z6C5kOwucvUm9im8XTeSJx6n5ZKHDUYqSipbpthmycB841WNKLw+7tyyxEDlyc/vT
         pigK8H7Pc/x0ptibSPrl+h+cNYZpbFiEjuZtjbL+FoGYs/Ux2UoOW+wrR8wsGWH8fEcW
         6MyTf/C2kB5dzK52HFvk1whqOrXM4Gaq4bDOMUjnE7DMVigtv7MAxd80BxRirbxjRl0Y
         HN3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794837179; x=1795441979; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yjMfJPlhmwgFldHvOAN6a+VpaF8LquFmHlpLZaL46tQ=;
        b=dK/KA/kvNf02H9lgvhJ9SX+K6MYeWK9M1fnYgWdH0M9139sPFVZ2MSJBb+KvARkYDp
         +llJl5308g7eiJ577RRpidL75pEbAwYLzuKEfLU8jiwVJitm0j1keV+ZnLweDyDJqGiw
         o+h0sgYST7P6Klkrz/KNkKuiOQJ2W0H/+1nWjuTpkbE9Sa4OhHYjpGZRCW97CHyOQO/o
         d47FcrMXj6zFKTboDVyKDCq5AQh6sy/dr41qvT2En5S0oLxlZ0d6ROvg8WuKj3Sum1JE
         0/iDbhFDfPBrZWJzc9jA6TIgZkrc51YDcHlH5luO/i1DVaM1PScPohVfeo9sxhJKe6Er
         X+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794837179; x=1795441979;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yjMfJPlhmwgFldHvOAN6a+VpaF8LquFmHlpLZaL46tQ=;
        b=dQuK7cGSKf5cAxJ22MqUbz6ju7teTK52IeIEG4Nyu4dgRp0XmnLdHzXum1E7PecTb2
         Zzu9Ub3xyzEF6YW0YALBmNAyc0lJh2wGaZlCo/c1Uh96jcfUnuTQRmUHVRfAbzc6c/DI
         aZo56s+WfbSdIaPiFv71gi9YC/weOIEdaAy5V2EN8bteCuQROWIvuGFfTpszKuOCciGW
         AQOLZga1Ht9Z56MV7i+ApsnQpWAsZYu2cFXHNI/33E/kqw1jjJUD0WmlfMI18Z5UH8FD
         a7yRZQwH/TfH8ZSTI9AcCPKS+6pb/SFpl1kAIaPJzBIe3CRvKRYFgEiNv2vHa350X/tq
         da8g==
X-Forwarded-Encrypted: i=1; AL+hErGxzGSWOCxkFvTyKXS+HPgoaH9jU8UIUVhQapzMe+baiLKdKwJmYzIGad2ByMi1jCO/5JH8y892NFk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/zGMGfkx5dmUcLCc2zJyHEYyPY8aobox92SMHVoWcnkwv9k0YM
	jalWvrxVrUj2TWXU/y97tnmZbnf+lpgtxqDc8RYyWUMmMMTLlw7JSfdt7YagnaXW7LcxFc2hvq6
	ZgWJTxmY8S7x/kqtEvvoMXsgyYEsIUsE=
X-Gm-Gg: AYBFou2K9AzT1yCC5kUuS/KSNqHr7TTkP7Ziy7vYHX8xWQIxrW1KU9uX2O71wPTbSQP
	z9JdD2agukRcwf+3DqcTTK4rSqzofBDEDnuMEFBw/LEDR2bcAFGkPvv+nYBkeDZh1fClMs3dJKm
	6mJnmTruLXgPEaq3Ru58sUxuDMHGxLwcv99+iFM6R0mCrFrAivPKsoppBc6APwON3djiTGgRnVV
	L2ZVg2VMo9ajnkCRf0Bnf52lKqRf1ecPrAc5g1koL0AZYVm5NPxnexB8jl25S6RxNMFDBLp5Eya
	u9eY7qno4XJKIbQEhtciXCPTxBt/12iIDXYrUVS8QUyk9TekDGHoNdIjpn74CX17Kmc0ul6BKAF
	x3+y9JCJPUCg+egHQcWU55nxkCu/Fn/3lKrnJ6vR+rLxp66imjZu7hS2VeTqcSgdu2pMg9ixiQd
	pzi5PogPCsycH+7K8=
X-Received: by 2002:a05:6402:1948:b0:6b7:a180:61da with SMTP id
 4fb4d7f45d1cf-6b7c0c6fc36mr8419375a12.28.1794837178579; Mon, 16 Nov 2026
 05:52:58 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-7-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-7-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 14:52:46 +0100
X-Gm-Features: AclHuK-FBjjEu-Z1sMzcEnpiCJ9rezp8HfxV_QrUdctxQDdJI-5IhWzN560a-40
Message-ID: <CAOQ4uxgm+JEu2MGnqQrJ00nTJ45S2ECQ7CBOC2QrgniOfkLYAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 06/10] vfs: add __vfs_fileattr_set_locked() for
 inode_lock()'d callers
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
> Currently there is no way for a caller to invoke vfs_fileattr_set()
> while holding an inode lock without having the kernel go into deadlock.
>
> Fix this by moving the vfs_fileattr_set() logic into
> __vfs_fileattr_set_locked() and making vfs_fileattr_set() a simple
> wrapper that only handles the inode lock.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           | 139 +++++++++++++++++++++++----------------
>  include/linux/fileattr.h |   2 +
>  2 files changed, 86 insertions(+), 55 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 12610fb6a751..063c81fbfa6a 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -288,6 +288,89 @@ static int fileattr_set_prepare(struct inode *inode,
>         return 0;
>  }
>
> +/**
> + * __vfs_fileattr_set_locked - change miscellaneous file attributes whil=
e
> + * holding the inode lock
> + *
> + * @idmap:     idmap of the mount
> + * @dentry:    the object to change
> + * @fa:                fileattr pointer
> + *
> + * Same as vfs_fileattr_set(), but caller must hold the inode lock.
> + *
> + * Return: 0 on success, or a negative error on failure.
> + */
> +int __vfs_fileattr_set_locked(const struct mnt_idmap *idmap, struct dent=
ry *dentry,
> +                             struct file_kattr *fa)
> +{
> +       struct inode *inode =3D d_inode(dentry);
> +       struct file_kattr old_ma =3D {};
> +       int err;
> +
> +       if (!inode->i_op->fileattr_set)
> +               return -ENOIOCTLCMD;
> +
> +       if (!inode_owner_or_capable(idmap, inode))
> +               return -EPERM;
> +
> +       err =3D vfs_fileattr_get(dentry, &old_ma);
> +       if (err)
> +               return err;
> +
> +       /* initialize missing bits from old_ma */
> +       if (fa->flags_valid) {
> +               /* FS_IOC_SETFLAGS */
> +               fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLAGS_MASK) =
&
> +                                 ~FS_XFLAG_COMMON;
> +               fa->fsx_extsize =3D old_ma.fsx_extsize;
> +               fa->fsx_nextents =3D old_ma.fsx_nextents;
> +               fa->fsx_projid =3D old_ma.fsx_projid;
> +               fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
> +               fa->fsx_ptime =3D old_ma.fsx_ptime;
> +       } else {
> +               /*
> +                * Preserve unmasked xflags when running file_setattr()
> +                * with a mask, which doesn't need a read-modify-write
> +                * so these attributes would be set to 0.
> +                *
> +                * With FS_IOC_FSSETXATTR or mask =3D=3D 0 (legacy mode)
> +                * this is not needed as userspace does
> +                * read-modify-write already.
> +                */
> +               if (fa->fsx_xflags_mask) {
> +                       fa->fsx_xflags |=3D old_ma.fsx_xflags &
> +                                         ~fa->fsx_xflags_mask;
> +                       fileattr_fill_xflags(fa, fa->fsx_xflags &
> +                                            ~FS_XFLAG_RDONLY_MASK);
> +                       if (!(fa->fsx_xflags_mask & FS_XFLAG_EXTSIZE))
> +                               fa->fsx_extsize =3D old_ma.fsx_extsize;
> +                       if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJID))
> +                               fa->fsx_projid =3D old_ma.fsx_projid;
> +                       if (!(fa->fsx_xflags_mask & FS_XFLAG_COWEXTSIZE))
> +                               fa->fsx_cowextsize =3D old_ma.fsx_cowexts=
ize;
> +               }
> +               fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
> +
> +               /* xflags not present in fsxattr */
> +               if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
> +                       fa->fsx_ptime =3D old_ma.fsx_ptime;
> +       }
> +
> +       err =3D fileattr_set_prepare(inode, &old_ma, fa);
> +       if (err)
> +               return err;
> +       err =3D security_inode_file_setattr(dentry, fa);
> +       if (err)
> +               return err;
> +       err =3D inode->i_op->fileattr_set(idmap, dentry, fa);
> +       if (err)
> +               return err;
> +       fsnotify_xattr(dentry);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(__vfs_fileattr_set_locked);
> +
>  /**
>   * vfs_fileattr_set - change miscellaneous file attributes
>   * @idmap:     idmap of the mount
> @@ -308,7 +391,6 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, s=
truct dentry *dentry,
>                      struct file_kattr *fa)
>  {
>         struct inode *inode =3D d_inode(dentry);
> -       struct file_kattr old_ma =3D {};
>         int err;
>
>         if (!inode->i_op->fileattr_set)
> @@ -318,60 +400,7 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, =
struct dentry *dentry,
>                 return -EPERM;
>
>         inode_lock(inode);
> -       err =3D vfs_fileattr_get(dentry, &old_ma);
> -       if (!err) {
> -               /* initialize missing bits from old_ma */
> -               if (fa->flags_valid) {
> -                       /* FS_IOC_SETFLAGS */
> -                       fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLAG=
S_MASK) &
> -                                         ~FS_XFLAG_COMMON;
> -                       fa->fsx_extsize =3D old_ma.fsx_extsize;
> -                       fa->fsx_nextents =3D old_ma.fsx_nextents;
> -                       fa->fsx_projid =3D old_ma.fsx_projid;
> -                       fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
> -                       fa->fsx_ptime =3D old_ma.fsx_ptime;
> -               } else {
> -                       /*
> -                        * Preserve unmasked xflags when running file_set=
attr()
> -                        * with a mask, which doesn't need a read-modify-=
write
> -                        * so these attributes would be set to 0.
> -                        *
> -                        * With FS_IOC_FSSETXATTR or mask =3D=3D 0 (legac=
y mode)
> -                        * this is not needed as userspace does
> -                        * read-modify-write already.
> -                        */
> -                       if (fa->fsx_xflags_mask) {
> -                               fa->fsx_xflags |=3D old_ma.fsx_xflags &
> -                                                 ~fa->fsx_xflags_mask;
> -                               fileattr_fill_xflags(fa, fa->fsx_xflags &
> -                                                    ~FS_XFLAG_RDONLY_MAS=
K);
> -                               if (!(fa->fsx_xflags_mask & FS_XFLAG_EXTS=
IZE))
> -                                       fa->fsx_extsize =3D old_ma.fsx_ex=
tsize;
> -                               if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJ=
ID))
> -                                       fa->fsx_projid =3D old_ma.fsx_pro=
jid;
> -                               if (!(fa->fsx_xflags_mask & FS_XFLAG_COWE=
XTSIZE))
> -                                       fa->fsx_cowextsize =3D old_ma.fsx=
_cowextsize;
> -                       }
> -                       fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
> -
> -                       /* xflags not present in fsxattr */
> -                       if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
> -                               fa->fsx_ptime =3D old_ma.fsx_ptime;
> -               }
> -
> -               err =3D fileattr_set_prepare(inode, &old_ma, fa);
> -               if (err)
> -                       goto out;
> -               err =3D security_inode_file_setattr(dentry, fa);
> -               if (err)
> -                       goto out;
> -               err =3D inode->i_op->fileattr_set(idmap, dentry, fa);
> -               if (err)
> -                       goto out;
> -               fsnotify_xattr(dentry);
> -       }
> -
> -out:
> +       err =3D __vfs_fileattr_set_locked(idmap, dentry, fa);
>         inode_unlock(inode);
>         return err;
>  }
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index ba7ed3b387d8..7ff62ee27e58 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -97,6 +97,8 @@ static inline bool fileattr_has_fsx(const struct file_k=
attr *fa)
>  int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
>  int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentr=
y,
>                      struct file_kattr *fa);
> +int __vfs_fileattr_set_locked(const struct mnt_idmap *idmap, struct dent=
ry *dentry,
> +                             struct file_kattr *fa);

There is no reason for __ prefix here and I think it should be discouraged =
for
global scope if possible.

Thanks,
Amir.
