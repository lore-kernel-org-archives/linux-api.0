Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795779355;
	b=RDvnMLf8hkMc1DT7CTDIDawAebZQspqyRWveDlDAqSc8Hs+orA8N4HMqJnmgLBIuZ6sW
	 WFauZWnSIb6mHeR57wwKqGORXoEWuxoOVLaF6OMUMt4Gkmxu8SxycTAoFWv8xMugv+aN+
	 d1eLRpLITGzwPWsDmbqeCCf8hMOi+rhtnHhcaNLAI+poXoQiIdVVstwGrxnFIoZ/teHl9
	 ylJdMA8jCyPhDrv2aqdg4Z5j7N3SYQMv18EbTDHu/CQ9eT+RLFB5Fv12EFs3tQE8zj5n0
	 l0rAj2w6vqnfNVcARnUmMKpvWG9dMdg3xr2as8lhOJ3jMLm+HYW7vYFhoLbH/Moz9sA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
	b=qn8KK7cZEJjH0XNZyQ8HJZ8Nh+oYGWViELGNoE5i3/VBuuXuWHzpklu5eS+4WhRNOb/T
	 Yz/ZcWXSFExznadNmX7VaamRs0tKO4U4cdDgtmbx5/AvQ96MHtUcKGoGpCWrB2kppdkdr
	 3BmA15iKQIJafA9TKYiWKNkxBTjyw40+phvntAs1C4JF6csk8z236ma+m7EWRMQXY0+64
	 gO5apYi5bDY0JXetfNFnK36StRMWc42pqUm9jDBIShhRGKlNl6kxbldGFwlYrLlFBwCnT
	 7DxKKCZaCH0ETYRTrPprSl1ZIDBaLJfc39FrVa85jq6SGs3tPcWQTcwFKnGYACexqAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vfl6nsas;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B349606A324
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 11:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B349606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vfl6nsas
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b88b74e54eso9764428a12.0
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 03:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795779353; cv=none;
        d=google.com; s=arc-20260327;
        b=eUWQrUUV6cGkR4MN4jb6I71lKuG/RC8e0zdaxaE7zjDKx0BrlGfYxPOLGs8SuXOmt0
         ETQ2/dfIS7Fiwm4GQEQrIM+f+fqh0huSXUVRRk/t4AL31HrTPINpy5WDVpNYHavmym1F
         HhQK6h2FEOWKd431OB4IBVIkvNA+mAPHJggOy+zgKKd/n9HcIH2xGZNlxZ3088l834F7
         VcRuGZ/j76MzOvxQeP1ejhpmGU9TrnfAGEPIl1fRvLSX0UWQWPh0HkEer8yWgVLyYsoq
         TCUvQE8Jx68PHmPaTmbRmdC3fQICAsWwlk8ChTR5Iv8y+9SHymzJNWVGT3PrdBtRTg5h
         aIWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        fh=pvXNhHcYnluEvghFHt9isRW4KBRKn/LuHpWowjS8Pqw=;
        b=d6AnvDBt8G+IbDXI6Lyi5wMJ95OckWvHdR7B7EnxJ08m/8keFhTPVPrpSNzVqoQJ77
         GMhrgyBhqFyV/6qAWGrQ2L6lT80bNTT/WB+cTiNlTh1oQkiaLe5ZOMDgo1jq4Rbh4oOA
         OHd0vq2smIYvwia8i5igJpTKDfgqiad9AoePS/wBGHk0hvaaBzrhj5RGkwEVf5M2EP9q
         zDYL2KU3ccVmEjmVk+pgp1ZFm6vBkB/VhDe9xadM7ztU3b+DEwXH5/mvFs9CIwTt09L2
         O6agwtBlPzDyuSfOzUX4BVpMUSV96ynLrEoVA+IcCujJOzKUkSVuODou4TdZWwhuK/iI
         Z9eg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795779353; x=1796384153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        b=vfl6nsasnL9MeKJC3PKlnSrIcRDT85xssIPtgR+brRFXXZVzFiEq6BssOPBNi+U1NX
         rACDgNvbgFoECMBGeOSxlv7f9ZZPlw8jbFZGiBU72Swu1vfaeCoxTTziHNw7UcLrHWJR
         AKKiFDsyO93LUbEmoG+hHJdZEh650ptJD3odyQ/w9fPYc4PvSJ0mm2Sf5PxZt3k35+Xr
         wxob5ZuRAYUg/cXXu2K92l8bOQgHSH8rodtPWHXJuG7bBF/5TfgeoeRbDB0Wy/K1sCCD
         uVtxcxA6CrL6WBmCavRtirj9U2/SaEAzfTB9jrKlSoL4xIH/1z47TjHh6YE/4ycLvzHM
         m/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795779353; x=1796384153;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        b=kBbLmLgP81GzXW35mwR94f9AQLvx2XGrAoYeiT9+7Ddr1w0ZFiUXb341cKwTgknkOU
         OuK0zs8YCvW3wFOmulIkGKPvmx8QSz29fA7hAH3wTeNoV8JbsFwLbsVRQ7OsykOdFRKt
         2dHfD/JdsMe01+ctzWHuHI+WLew6TznoPK4oXYlRFuBx0i1+KNcMX/mnZuXoQotZdjt1
         xUZHu/LyvXa//NWNL68iQNCCKzHkdBDDwuPzxmUtRXttjgtpF3VLeXhtz0Dkb5qR90yE
         Dm09K0SxpEVXQvVq+svmd1uc4JMkWmCFUKuqhZDFcA0X2hgvLIUjwrkY6aGuzvh6nxCu
         xSAw==
X-Forwarded-Encrypted: i=1; AL+hErFFxQ8HHdRVBFXZ0ZobzNjQrPdO0KB7D4SfwHnFdNlMeJdiNJoqA0QdyWcGgGQ5uD8aROynmXqYAik=@vger.kernel.org
X-Gm-Message-State: APuU4Z9YlyKEUrnl707TqMEc97eAVdwcjiLLSq2r/2SXoGAZJTW7dlnA
	d8oaCWFSHI86gbjLPbjRQEjEJeTAddbC/5x3WLthmkA5t1VUSfAvDX66vZVAUXJ2B8HDgqfICHO
	COxtA6im+Zn/S+hwtPKqrasICMyy2ca4=
X-Gm-Gg: AZFdTZcxE9ZbwckISljIn5/+Z17SRCZxsdYzeYEdmPm+yfzlwK8xHAxQ3+7UIjKRUbB
	pMZVG6yqHUUAiO1BmEf53DJem29dH4CGyleQxnHJhW9njzh9eGiYUKpQV3v+RG1GNnCDTFl9Ew1
	O/RYB60oR2kxNmtqzY6SOJqmrtV/QSyz3sZpnsPdj3OiK/36ok0JnBa2gYWZidaOhrwP/39SJTr
	I70tBNnOjd10A2lSU5mgyXRI/MzpJvizy27KZs7Tw4FWms0udoHeRbQao7V6eaUlzt2PVSCIuLs
	XehsIodgaCQOke2utzlpeWR7p5xIYf133nc5Va/uewwHEFO68ttuhjy8yKGmg43RamlwUTjU59A
	HJvRSaYeT652/ZkJBy6k7mspl6NM4Udl2KPLV6v0s0w5QU2+jdrlkQ7kRBPqs5+yvATp8Nw==
X-Received: by 2002:a05:6402:42cd:b0:6b7:b872:27c0 with SMTP id
 4fb4d7f45d1cf-6ba37ebff16mr18720566a12.44.1795779353347; Fri, 27 Nov 2026
 03:35:53 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-3-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-3-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 12:35:41 +0100
X-Gm-Features: Aa3M54oDVUmD4L041vA_Ja2kzcuIcnu49jvnV20FPfNA1gUDEEUT8nV16GU1jvk
Message-ID: <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to use xflags
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
> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
> legacy FS_*_FL flags.
>
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/crypto/hooks.c       | 10 +++++-----
>  fs/file_attr.c          |  2 +-
>  include/linux/fscrypt.h |  6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 149498bdab94..52d6a33fc9e9 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *dentry=
, struct iattr *attr)
>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>
>  /**
> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_SETF=
LAGS
> + * fscrypt_prepare_setflags() - prepare to change xflags

prepare to change the file attributes with file_setattr() or one of
the legacy ioctls

>   * @inode: the inode on which flags are being changed
> - * @oldflags: the old flags
> - * @flags: the new flags
> + * @oldxflags: the old xflags
> + * @xflags: the new xflags
>   *
>   * The caller should be holding i_rwsem for write.
>   *
> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>   *        another error occurs.
>   */
>  int fscrypt_prepare_setflags(struct inode *inode,
> -                            unsigned int oldflags, unsigned int flags)
> +                            unsigned int oldxflags, unsigned int xflags)

This here is a backporting landmine -

Changing the semantics drastically without changing the helper name
or signature.

Please rename the helper something like fscrypt_prepare_fileattr_set()
so that backporting mistakes will be caught at build time.

Thanks,
Amir.
