Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795625490;
	b=A05KD6okfsxeXZIy/oW8pxdmYddSI6+3vnP/XU4wKiUjycl29XSdw54DCbNk2FgMd4Ib
	 S8JL0yy5uwdG2txUJUElUQu4wXM00wRfy37DFNn18SzEPk2kYrC35kB0lN5MXZC5kDGVo
	 AQhxOuHPKD8WmHBui079kX5UdJhVEbbu6NlP+sZNMLYk2x38DQG4rdqNAzelsaEEUP/sN
	 C/EVYlpBZraAVHmC39kAv/FSzYsL7mCQ7KtiOAcQIU+oEHPq9kImi3/Q0cBcaxdLyejhf
	 qiF+zxQqraLChqIJPu1z65JHtQS1w1H3X4oGRYgcmR99K9LWF0jVzu7TtMUeU1qzNAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RXQk5HMe2BJYtF6nqI/dEd/GRzh+7/vUyfQ0kGs8Dkc=;
	b=cGzgjReCguJw2pZN5AkOMfOhJDJoryVJdLHJGxT+1AvMSNOOpdo1Rb3mv/o6P5HWUOUH
	 yD+hmO0Kq159eD99FH6rGiJTfG74oKpRdPpbkzWiCe6VBOwG1p+PoXgTjZ2SZTu1ez9q1
	 akhosrOE679fayT828LlBq21qtjJBqc8CAjTQ7o2L0yLWNtSy3Y9ar3QPe/9iOYFKiqih
	 0TFk9c8AACrOFcgMj5ZSZaAQiwZ20Iv1J/H8H87V6i/Mrd6xPxOsVtKSIu+1GBJCYpIHn
	 NAdOYeCJWrO3VrXldX2vBm0/nOjON6ia7FK6tDklLIPkK3LLyxtlvoG99gKgyGzVHIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoPoxyMU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954EF606A32A
	for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 16:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 954EF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoPoxyMU
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6ba380cd8dbso8168840a12.3
        for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 08:51:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795625488; cv=none;
        d=google.com; s=arc-20260327;
        b=gNJQOr5kUCbE3v3jibrgL1I56sZNKqwVt9soadH+UX4okQAldSXS2J33g5Q/UreLiw
         ILbhm52Koitz9jmK9gMy6fPV/LlctuncJmNnKF1pcauMuLzgaVrpHmAHwAy3JnEdengv
         Mm54WsyDOe5TFZSJUsj3jqnDdx0SHHTFvtRixJHeBUwKRVhdzZIzOrtlX+FCwh5gRirK
         CGzDFguAeOCrL7hy3c/9IX8BWvS6kvGYANMec6K4rPh/0TRWWATckahTwu/N5jBIhuzA
         arS0bJBIh++asQ4pN8oHMWv8bWfFy7xn1ZNln7Eu73zuuVIX4Qcn6MDrw07hmZc9K6FG
         BmxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RXQk5HMe2BJYtF6nqI/dEd/GRzh+7/vUyfQ0kGs8Dkc=;
        fh=3wgnEwkQ3EiCN3ZIGZiCst//Em93XP3oMwj68kQ+Asg=;
        b=CAy1ixrh+lGlNRR+tO3ghV/Rqq+6UUlrpyS6xhjhJBdOVW+PgMc/T1VqIAEhGYDd6B
         yClBkyTYKgf3cIwjzJEB+YVcd0BFAa6EE91P+GB0LMLmJ9ITLZCKQy3cGejBS/1H+bIy
         Dez8dbc49tMNYY8mLCpkD4BZwfyhTmNCs0gM0xIU6J+DoBme4CkeTVxxLDPlW22OqTH3
         /gYhs3IT5Zyd1rUXfvaAlgcj+EPPU+iiYc9Mia081ekDXYHuJFc+Oq3UP0Vw08uZsriB
         1lcIhyhNkT51C7atRLMzM+u53Mi4dQmxr3MF2VDGZmLKjhhm54O8enuuNL2HKFoIH/yX
         avLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795625488; x=1796230288; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RXQk5HMe2BJYtF6nqI/dEd/GRzh+7/vUyfQ0kGs8Dkc=;
        b=MoPoxyMUvDW1SLt017Zbm2ElRZzGiEKE9LRDq//X7B5j3TZZdR2cJjL2ZBOsvKEAZ6
         5IMuomAixYVKXTxTSbsvvUkuYlCm6JWLTwiWhbHnmzbjD0SYKpVTGs0a8R/hyeXlTCat
         v++nacOw8wh8nQnKme7ZkOgcPVHS9U8PIZNzXPa5F/Gs2HzHICpegLzAaPhJMFiGMKnd
         zJSCrK/jjB3QqXfi00Do0OBXJ9cHaspoS4hsJqMX0lgRiT/EeRtS0YXVLWqei5vHAUbO
         Qr2NYy6jU0QsyDak7b6GcknaTsPdnQLdlnS7CLbP5ta2fpt8cldZxvRM2QK24ULz/9X2
         +t2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795625488; x=1796230288;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXQk5HMe2BJYtF6nqI/dEd/GRzh+7/vUyfQ0kGs8Dkc=;
        b=duxLhtsBSVVYTgb5Gxy56WGFNJyjMqU4lNvn33bgjCtnS6SuK5iVjdH6R+OqokH9zT
         qjXKOX7AZnt4Fq4CtcHkvN/UNGg5v2BZBSjt4PYAQ36JD238hcy9l1c/lKLl2/VZROGT
         ql55irLH+kkbvgGU8gq75j5IH8JHUHYGRSt3yfnNIDzQq6yPR8Sk/tInf7MEpBb90uvs
         +Wz1HSAVUKd+kH2A9sfwEz3wDuFnCW8fgkDIIe0dntNeXdcUVxAfFjpr93Gz68XZlJC6
         CtCdCkReFdnuHPyu3leP3IsftrK79chW1LoC9wfXSgMNglFnxIfuur6P/SzBfAQPH0RO
         ConA==
X-Forwarded-Encrypted: i=1; AL+hErF+HWkvGWKvaqYTR1EhH8/1s76Joj05g2EGpxnv3qg+NYTfXkFC3R+vumREYCW4noK7RgGBdVtR7+U=@vger.kernel.org
X-Gm-Message-State: APuU4Z+c6Zm9CUr5Q2kuILpHZ2uMs0zRwUA7/KtDZnKtFRfwaI8fwOwo
	h0HKSBQFvjiE55kfKYMrsYevgqvK3keXX85GQUgJJwpS1t6vTCGqkehDvZfk1aZo2RtMEP+BumB
	GMXlFjIzCJ0+raVNrF5mLr5AZs/kK6EA=
X-Gm-Gg: AZFdTZcLoPuzDw/Qd2EcCiLYTtObwtTq6QKejen6+A+VDOcyrcle7/eZWN/iQ7jis4j
	x3DY/F6zcqy3dzN9UbxZzlfmkm89++QsU2c9m08Zyuc9FXxPYaaiHkjgPKw/Y+xw+i26V1Bvqvq
	uAeRCBGpS11RUHR44xmWXpOtin52kZWNmJIFa6vsxpoCei0xxCQAfG9J62mvBt79nCObgCwARsu
	Z/hhNpKIW8ZxUtb45VawUu1uHNLg1gv0UmIfCyCvT8khMzYWj8Qof199fq7JYw2LlsxgFVZHWuV
	bh+6f5gVs5BoLyL2E7wPNerSDUfiGMhePzd7rtNDMHNTNqLn/wYe5V5fNNqLicrQBbQps6RKUFe
	WYMskF+BHK4+N71HEdASO8uOjs+Ijks4HrSzFiCU+LT8xllEWHfctppXkE6KKX33Co8lyGQ==
X-Received: by 2002:a05:6402:84e:b0:6b8:ac39:bb7b with SMTP id
 4fb4d7f45d1cf-6ba37f07a02mr12784419a12.45.1795625487513; Wed, 25 Nov 2026
 08:51:27 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>
 <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com> <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
 <DN4DRUYPHYMP.20U4DYV5VBN7P@gmail.com>
In-Reply-To: <DN4DRUYPHYMP.20U4DYV5VBN7P@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 25 Nov 2026 17:51:16 +0100
X-Gm-Features: Aa3M54qBSzc52sWJyl_AAZDXWvCmiaZo0RX22LaXSRo3u2ihdyPPNj6mbzgC3-4
Message-ID: <CAOQ4uxg0g+XkPb3-kQS5ez1-rp7Q=BkYDHW0CGOFhpbcf70yMg@mail.gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 4:01=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 4:29 PM CET, Amir Goldstein wrote:
> > On Mon, Nov 23, 2026 at 2:58=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> On Mon Nov 23, 2026 at 2:24 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.=
com> wrote:
> >> >>
> >> >> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
> >> >> equivalent masks to struct file_kattr.
> >> >>
> >> >> Also add has_masks selector to struct file_kattr so we can know whe=
n a
> >> >> user of this API (userspace or filesystem) supports them.
> >> >>
> >> >> This lets filesystems advertise their support for specific xflags, =
like
> >> >> statx.stx_attributes_mask does, and userspace can specify only whic=
h
> >> >> xflags it wants to change without needing a RMW cycle:
> >> >> - on GET: each filesystem that wants to support this new API fills =
the
> >> >>   masks according to its supported and read-only xflags, then:
> >> >>   * for boolean xflags: it fills fsx_xflags with the current on-dis=
k value
> >> >>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and =
the
> >> >>     xflag value in the struct field;
> >> >> - on SET: userspace fills the rw_mask with the bits of the xflags i=
t
> >> >>   wants to change, then:
> >> >>   * for boolean xflags: it provides the xflag value as a bit in fa_=
xflags
> >> >>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and t=
hen
> >> >>     provides the value in the struct field; if the xflag bit is set=
 to 0
> >> >>     instead, this informs the kernel to unset/clear that value.
> >> >>
> >> >> Since fa_xflags_rw_mask means "I want to change the xflags specifie=
d in
> >> >> here", if userspace specifies fa_xflags_rw_mask =3D 0, only check f=
or
> >> >> permissions and fileattr support without checking any xflags.
> >> >>
> >> >> Behaviour of older programs that already use file_[gs]etattr() is
> >> >> preserved by checking against FILE_ATTR_SIZE_VER*.
> >> >>
> >> >> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to s=
et
> >> >> the projid using file_[gs]etattr() by leveraging the new masks.
> >> >>
> >> >> Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from acce=
pting
> >> >> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xfla=
gs
> >> >> and use it to validate/clamp both the _xflags fields and the masks.
> >> >>
> >> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> >> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> >> ---
> > ...
> >> >>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
> >> >> @@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const =
char __user *, filename,
> >> >>                 return error;
> >> >>
> >> >>         fileattr_to_file_attr(&fa, &fattr);
> >> >> +       /*
> >> >> +        * Remove xflags added in or after VER1 so userspace progra=
ms compiled
> >> >> +        * against VER0 don't try to write xflags they don't know a=
bout (since
> >> >> +        * they do RMW).
> >> >> +        */
> >> >> +       if (usize < FILE_ATTR_SIZE_VER1)
> >> >> +               fattr.fa_xflags &=3D FS_XFLAGS_MASK;
> >> >> +
> >> >
> >> > This looks odd.
> >> > old struct size with new flags should be -EINVAL not silently drop t=
hem
> >>
> >> Right, and the GET path should strip any new flags, so old programs
> >> doing RMW will never see them, correct?
> >>
> >
> > Yes, I think so.
> >
> >> >
> >> >>         error =3D copy_struct_to_user(ufattr, usize, &fattr,
> >> >>                                     sizeof(struct file_attr), NULL)=
;
> >> >>
> >> >> @@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const =
char __user *, filename,
> >> >>         if (error)
> >> >>                 return error;
> >> >>
> >> >> -       error =3D file_attr_to_fileattr(&fattr, &fa);
> >> >> -       if (error)
> >> >> -               return error;
> >> >> -
> >> >>         CLASS(filename_maybe_null, name)(filename, at_flags);
> >> >>         if (!name && dfd >=3D 0) {
> >> >>                 CLASS(fd, f)(dfd);
> >> >> @@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const =
char __user *, filename,
> >> >>                         return error;
> >> >>         }
> >> >>
> >> >> +       /*
> >> >> +        * Userspace said "I don't want to change any flag", so be =
it I guess.
> >> >> +        * Still check for fileattr support and permissions, also i=
n case this
> >> >> +        * is just a probe.
> >> >> +        */
> >> >> +       if (usize >=3D FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_ma=
sk =3D=3D 0) {
> >> >> +               struct inode *inode =3D d_inode(filepath.dentry);
> >> >
> >> >
> >> > No No this is not what this userspace said!
> >> >
> >> > This user space is the same old chattr programs recompiled with a ne=
w
> >> > fs.h header file
> >> > installed.
> >>
> >> Oh, right, I did not think about this case, I hope it doesn't break to=
o
> >> much of the new code I changed already for v2 :(
> >>
> >> > When userspace does not set anything is masks it means "old API"
> >>
> >> And so a modern program using masks that passes rw_mask as 0 should be
> >> also interpreted as "old API", even if it kinda goes against the
> >> definition of rw_mask right?
> >
> > Yes, but it is not a problem to describe this backward compat exception=
:
> > When (rw_mask | ro_mask) =3D=3D 0, it means "no mask" "set everything"
> > but then vfs will not accept new xflags that were not supported in v0
> > syscall.
>
> Uhm, since we have no way to know on the GET path if the caller is mask
> aware or not, on mask aware filesystems and legacy programs recompiled
> against VER1, file_getattr() will return rw_mask !=3D 0, when the program
> does RMW, so calling file_setattr() with the old struct which has
> rw_mask !=3D 0, vfs will think that the caller is mask aware.
>

True. This is a requirement from the design of v1
that RMW works correctly when the program does not change the masks.

> This causes problems when that legacy program changes the projid, since
> vfs will see rw_mask =3D PROJID but fsx_xflags will not have PROJID, vfs
> will clear it even tho the program wanted to set it to some value.
>

Yes, this is a specific issue with PROJID itself, not with the
entire masks API.


> Unless I'm missing something, there is no way for us to know if a caller
> of file_getattr() is a new mask aware program or just a recompiled legacy
> program.

Right.

>
> My robot proposed 2 fixes: either don't introduce FS_XFLAG_PROJID
> (which, eh, not the best imo)

Me neither. It's inconsistent IMO.

But it is inconsistent in that we want to have a way for chattr -p to say w=
ith
the new API "set only projid", so we must have the flag, but we
mostly need it for the mask, we don't really care about its value in
fsx_flags.

> or add a new flag to be used in at_flags,
> like AT_FILEATTR_MASKS, which would resolve all our legacy vs non-legacy
> problems, but it would be in *at*_flags, so doesn't really make sense
> semantically (but it would work well since file_getattr already rejects
> unknown at_flags, so it wouldn't cause problems for old programs).

I think this is an overkill as well.

We discussed this before.

Attributes that have X_value like fsx_projid have few types:
1. 0 means disabled (all existing values incl. projid)
2. 0 is a valid value but cannot be unset (btime)
3. 0 is a valid value and NULL/unset is also a valid value

Only for type 3 does can the interpretation of
(!XFLAG_X && !fsx_X) be considered as an "unset"
and anyway, this will require support in individual fs.

fileattr_set_prepare() already treats the existing values as:
fsx_X =3D=3D 0 =3D> clear XFLAG_X

And xfs returns EINVAL for !!(fsx_X) !=3D !!(XFLAGX)

A simple solution is to fix the flag according to val in fileattr_set_prepa=
re()
if rw_mask contains this flag:

if (fa->fsx_xflags_rw_mask & FS_XFLAG_PROJID) {
    /* Possibly legacy chattr -p compiled with new headers unaware of PROJI=
D */
    if (fa->fsx_projid =3D=3D 0)
          fa->fsx_xflags &=3D ~FS_XFLAG_PROJID;
    else
          fa->fsx_xflags |=3D FS_XFLAG_PROJID;
}

Does that leave any problematic corner case?

Thanks,
Amir.
