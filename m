Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795117027;
	b=zzCuOAJAI3IYGb9qacyHNzdhfmXyuUGGPxjKGor+tz9GlSWw39na8u1RBdA0cnDrNPgC
	 +uTPnimmDKRXfPQcGVaos2Ks56zBVyAAcrqS9/oXieDjs2PT+cHvTwLzzaDGLO/f6t6me
	 ylIBJw7Yy1c04dCe+8RHW9sEqr6Sxtas/Tv322h5Ft3XPnvSMlpGQSY59f6fd7fQNKVWi
	 N5rsZfjJNljtTVHL4S03UitE3jhJ4lBjSdE6zjYhlUtTcg80czhKN6qpThlMyoSR1JVtp
	 7LOWsshHIr5h3UKKjnFvTq/mAE4nbtmIEwiYTxl0V+zp0EKL/iODp0ydnM3UM3HIlZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795117027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
	b=4z6lzwNUCxg+85OUPPukDMm5rGkjT45A+JgN6pPxxx2NtiCiRNHwHtlt+gtmFxnmWCtm
	 SiO1EikRJ1tBMoGbBZCAfDHqYMFM46KdDexv+Gi5NIYQAHRJ3ZA51yHCCkK7pIVNz7RnP
	 HksP5hZbmjX1Q/dC3S8PSeFYfeEJQXJZJCpR8bD8edr/JVt5mOZt40UFV4Ds7MjtR2eU5
	 ktTEfzrFqZhcgcufuTjwkQYSzkFzrbdGFJv8zyVMwTKEpvTbfLEnqSsPH5Yw4V/jYcgzH
	 0kf14v3AkeJuWp+3j9qx6KkRS1TzcgdGf+H0pXqD3vWjNPQ1P2qU26rxoOeTlrvvdYg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J2P1rliW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7E60A2611
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 19:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EF7E60A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J2P1rliW
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso129243a12.1
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 11:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795117026; cv=none;
        d=google.com; s=arc-20260327;
        b=O+9iSdwkVNvD/l5w2FPbcmWXWzFDcSO0vBBZcovpPr4nLm8+2Zd/4ipzWBMgjc+2N6
         73YOFEmB8yLxcbdw0C40ochpPtBZUp9CTpScVyOp1wKJmrPYmzWdelvNyd6dRtJeLiG5
         FcjFtpXlNfoAyGBkMaxzBJns64NmcQdhVb4M9zy4qlYN6ieyhstvyoiXRApDLsKTuN7e
         Nhj/2B3cShyrDQmRSJVpiefM105+u75SExDYDrRwJHgfPhQ1KSQMjXE1TX6Z+Oz5uT1v
         A5vSgyNF8AVzKbtVdn8H91yzRkLzH5x7qqD/vZJTRCI5WhS8y7ZcvEDUoV2fzkE1sXYn
         D21g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        fh=PDgIAc/AIA2aQMs1YmKqTI5ROBguvtJN+0aPPjVg9sE=;
        b=o936tAcKF3DwVHquX4BUGrdF+GgDd/ofU70sMhA48DRsv0AJ+aaHQguM83nAnirSH0
         73nwL3iaxzFUsaZkvpMnkwJyMHa+knDtgQf1SZyvAolo11Ol1f9mZ3cAeElqGmUeUg31
         4AFtpSJYrPagM4KPz8nOc3c8NK7UCbosMR5DNAb2fKzokoUcmelQPRXdE0VR2S/+GSxa
         zWjKcQFJJ4Kx1stirc6+3pJRXpqaCK85TDBwDETskJZRwbONvJHoX13Fz19EGVz3E1jC
         YH1XgfCE0ZVcTmi4VL2O5xuN1Xz0VADIzANEdFByQXWLNW947vrG7VeB9DWJyn48iF6r
         hG8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795117026; x=1795721826; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        b=J2P1rliWlWFeXXFXmXF+ohrZY4u8BY5guzLNIZE4zyZEFvv9XjVp6qSFQEuKBYS4gw
         tRHKICBYDX7EHD7dOjit9dYAF5zAZQoiMjaWziJZS+p8scKNzprADKCa9phj/1Tq5rLq
         AdLh58YB1IlCzIIphjpmi7F6IODiO1Lb028EXgDFuQRtiOTbHyBQqFgQJ2a9rTkXFmIk
         rIDw5jsAro28ug3nEE4pf9UY06m6dKeDy1GLSXALfX/FhKkPB24uxc9fzqALY5d5/0zY
         o3ELAOqepaHkRc8vyIjpo6spF9jSLJ5v2/RpEGLV7zg0pNxm6ebUphbxyHHPfV1Pvs4Y
         7KvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795117026; x=1795721826;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        b=BbbmBlh1Vxv3gzg3n2GEiMAyMX8/FyDVsfFgFlsudIt7KSztq/A/OfBlxmUvcatWd7
         MW2jAbAgvpmNkyNrHH9uelavrEPSZLxFLxxbdetSx336fqMeyfp37Wn56qV/tVBN9QA1
         pN+r6RRNb7yfqrjLL3Yhk0DTo6idQ/F36xVDRR2r4Jry8kXTqex3ipLzEoGmIxgg/sZd
         ez2f1QfVcNHEwHRsgKS5O+R3M6JzUk23qlxBhnWcJKC6IYYWNpQ5IfQQnWbGgOLTbAQB
         PSJw9ce1c22bqn0yM8cKJBFZQr3Bd6d07ieWaD7tn2LBnLsSYRi+ZCp8jErNMVAhflUp
         DQCQ==
X-Forwarded-Encrypted: i=1; AL+hErF+e+dpaI05fEiPokap8v0gTgE7A8Zx1Q6zYdhisJzuka8Fe/3tORmvscDpu5gCiWYuCBho2cd+eFc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/aU5whmBmKYzNM2ihDMKgjzploFvJpVwCMWcbJVjZbEN4Wmj/d
	h5dX/sUlZ2k3kSlvrl/LafvSps5+HJkzHJ2w9UgGhjCADb+ywCOuzXMPugBYl6KLnk81s+oXY3u
	eCEa1XSjA1GBuQRHPt9zg7JNF4ISgOcU=
X-Gm-Gg: AYBFou03zmqcBhKlB4i8Sgtt49LfssAex7LdNorw8eynVcS0duDeCA7OyNIY/udLMR6
	9uvRpI0QhPl4r7ArGXbJntqdWk2QxNINFCovIfM00P1N0BrShKeiQobIjaqOIC6BCyqXpZAep4s
	t4T89GKqEShO7FljTXKbW22RmuoA3MBOre8QsvdVj7PLv9MSdCZ8CbBiv2eS7+w12OMT0ge8W+1
	5hsZjpLl/Ay4QCOugWYtbFIxjTAJngJwQtuSINpSmWD6OWV6gVaY8PwbrXjB9VZ7trmnbeKLKpz
	aVJh1w4RPzhV51JXFSueN/fso6jDOxHc0enoioqs93xHQg3HV59vNXq7xlFr13AuUK4FF/h/t9Q
	XP4G56fEuHDLW0Onc2dPH0RnhkfRbdPWfvIhBa1869ZzweS9/ng+Fg0AUa+BpSyw8GGH8XC4=
X-Received: by 2002:a05:6402:897:b0:6b8:8328:8e66 with SMTP id
 4fb4d7f45d1cf-6ba37d62a2dmr239724a12.7.1795117025446; Thu, 19 Nov 2026
 11:37:05 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-3-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-3-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 20:36:52 +0100
X-Gm-Features: AclHuK-9kUyGBTzq0h8pZyp8mMZSXIXsu9pOi4Bu2Y5vLjqBJOsUk2EoN70jtkI
Message-ID: <CAOQ4uxiRFUqgUMvngvXc1nA7e_HMKSs+aXWVQmAEpcR7yQiQLw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/10] vfs: add fileattr_has_fsx_mask()
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
> Add fileattr_has_fsx_mask() as a helper to let filesystems check for
> unsupported xflags while allowing supported ones. Can be used in the
> same way as fileattr_has_fsx().
>
> Also make fileattr_has_fsx() a wrapper around fileattr_has_fsx_mask().
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  include/linux/fileattr.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 42b92ccdc583..ba7ed3b387d8 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -65,6 +65,23 @@ int copy_fsxattr_to_user(const struct file_kattr *fa, =
struct fsxattr __user *ufa
>  void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags);
>  void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
>
> +/**
> + * fileattr_has_fsx_mask - check for extended flags/attributes
> + * @fa:                                fileattr pointer
> + * @allowed_xflags_mask:       additional xflags permitted
> + *
> + * Return: true if any attributes are present that are not represented i=
n
> + * ->flags or @allowed_xflags_mask.
> + */
> +static inline bool fileattr_has_fsx_mask(const struct file_kattr *fa,
> +                                        u32 allowed_xflags_mask)
> +{
> +       return fa->fsx_valid &&
> +               ((fa->fsx_xflags & ~(FS_XFLAG_COMMON | allowed_xflags_mas=
k)) ||
> +                fa->fsx_extsize !=3D 0 || fa->fsx_projid !=3D 0 ||
> +                fa->fsx_cowextsize !=3D 0);
> +}
> +

Every patch in your series did:

       if (fileattr_has_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
               return -EOPNOTSUPP;

       if (fa->fsx_xflags_mask & ~EXFAT_SUPPORTED_XFLAGS)
               return -EOPNOTSUPP;

It looks like this helper is not as helpful as it could have been
and you have raised this question yourself in the cover letter.

Effectively every filesystem that supports fileattr_set() already has
a defined SUPPORTED mask, so I think it's better to do the negated
something like:

static inline bool fileattr_supported_fsx_mask(const struct file_kattr *fa,
                                               u32 supported)
{
        if (!fa->fsx_valid)
                return true;
        if ((fa->fsx_xflags | fa->fsx_xflags_mask) & ~supported)
                return false;
        if (fa->fsx_extsize &&
            !(supported & (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT)))
                return false;
        if (fa->fsx_cowextsize && !(supported & FS_XFLAG_COWEXTSIZE))
                return false;
        if (fa->fsx_projid && !(supported & FS_XFLAG_PROJID))
                return false;
        return true;
}


...

       if (!fileattr_supported_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
               return -EOPNOTSUPP;


>  /**
>   * fileattr_has_fsx - check for extended flags/attributes
>   * @fa:                fileattr pointer
> @@ -74,9 +91,7 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 fla=
gs);
>   */
>  static inline bool fileattr_has_fsx(const struct file_kattr *fa)
>  {
> -       return fa->fsx_valid &&
> -               ((fa->fsx_xflags & ~FS_XFLAG_COMMON) || fa->fsx_extsize !=
=3D 0 ||
> -                fa->fsx_projid !=3D 0 || fa->fsx_cowextsize !=3D 0);
> +       return fileattr_has_fsx_mask(fa, 0);

            return !fileattr_supported_fsx_mask(fa, FS_XFLAG_COMMON);

I hope I got this right.

Thanks,
Amir.
