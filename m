Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020FA3DE44B
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794955; cv=pass; b=DAhoUK4WuDO3wz1FgbbcDrN5mqtG7aZwgffuzOLU0nqiojLvBewIb2WOgXYawsqKF4NOTpGEBo/f2bwFjy/kYvlc8OYnZ28HXPJFt9HpkVYQrzqgyNjRw0UqE2B/eMtcr1zBq+W6GrDnHe6puxSKgH+JTQxEGWfTVbGfWSGQnys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794955; c=relaxed/simple;
	bh=aLZSqJ0URF4BgPuBzwI7e5ieUH/kEHL0hZuAQkzXJZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0YQt2tFz3wlMx4OTiZFyibmQtu7d9R10RCqjyt8pDfKhtwL128D2tnU7OgUkG+Rdjpfz6oYa/G+CmFjlr9zr3LviDfsNrHH/0v35rDj7oTKARYkK5OJK9fJ1+/KpfZQyloU0KiH8Cz+0oFTpLsIY9chlZwALcfsadWh2gOurfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=gmooZBEP; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="gmooZBEP"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c0006ea8eso2800311cf.1
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 01:22:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784794953; cv=none;
        d=google.com; s=arc-20260327;
        b=ked6ygWBt90LMDqc6n9mDLaYCtedApEftbls5qpVXUOi/oMgvm8Gtey3Xo1dH5pdWZ
         G1RIyt2pJIbkN9/dIvR56Ys7A9pmwvFu5O9nf75XQ3vUxSCYRNOFlBPL4dEpgKfdBUMo
         POBd1IuJE1SjEwdRcJNmxxWJnBOnnaRIbrxJdt4hQRZEe44H5b52pJOnKgRCgpVI6dqA
         XsXNuD6M5DiF90bvYC8703PrEtnSyBXci0/KFdDMZYkfsjJ5BYuPWJzPl1fGxA5Gi9ok
         bZ2aET1O6GIXgsR4LXNYmbRHOwyTQaoA6EGMe6FVf/zL/TKQk64bQ8a6hgJOMg3lXtXV
         YEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        fh=QVBY3VWXj3cziD2ulG9jl7PvOJ1LwftTIkdzhzbtjNg=;
        b=KxB3pfE3Ii1UT9QV01dqQZToABb952HHwFqazqqxmMX5h59ao5454OA5E0KFRgfj9h
         etkn5xLSTOd8vKu531k5cdRXv7TmBKLG4KT6UZ4U/ddMCxnFT2UvmaiQgvVScSmEJib9
         ib7VSnjSltdce7ebvAWhA+Y47vX0hM3c6Rgw9unolhdEMrhFIAn9sYcbjsfHrl/pVLQA
         4rNX7XQFIJbT7hwXEcfOnu9nxDCs78Kxbvqpuw3bFMqKgxXQc/QrfzNChFQQLTGhHJwC
         L+VFTThA/PrEPDwj4Us+2igrdyctov6K569V0G1nf6ujWTR6gn+zzgNjUS2KEp2Ay4Jk
         6buw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784794953; x=1785399753; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        b=gmooZBEP6yxzO/jbE04k+td9SkYz+eKuMblMAwvIBzhrnGKY0ZIjzo2c0q/9VDXnD0
         AryreByxDRHFLHtY5UWu3edNIcPikUcl5SBiBdAUu0vVl3eSpKQtPxlL16yEyHF86qnx
         f04ZpSyS2xSBECpFvI/E+iBe52VtrMurWFjMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784794953; x=1785399753;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        b=T5gUCT1gKBg6fqr2xnnC7g8LJcjPHuEvutpvKjIndeJbSIw4bmZ4kLwBMCSkgYSLo/
         bVKHzP+0nZmbMuw45CK6s7Pd1+Rxj4nRcWKyzfgI1h/h7tqQTBM3NdV+ldn8SCosS28Q
         UpwDRX6RfpBxCOaJvoghHBIUz4lYOryQ+2UhqK2hzw29fY1nW6aUmnXs9HDd5XZL43oK
         24zyPYRgs+aD/iGY7oFqOmfmP+My43s5A09vJC8A9rWasuXQK2ABWyQdfqHk816vpATM
         fHCzBUzxKUfnn+4PfhRL8HLUq/FdHDSjVk9xOUbC+j/XF0uINvx7TmAteax0yIJFR0zw
         CkBw==
X-Forwarded-Encrypted: i=1; AHgh+RrnbFIZWry+CE5LqdA97cgYXP4WiNSZEgVFxIGnrcqVN2H4oXANTw54o1i+3q/tmyYAjPHqvWX0Llw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCNfMYdWUYH94rNyXYscrZMzimh0D97wfTs8C5Vn/ye3I8SZHB
	Jt+yI2nIYBKOxmpUJtPVg/Mmyyq94lv/M9RwI2Wgv2QfBB9G32bcczNKlS5JG0DwPYFmypc+JVp
	lzYdRyq66/DYo6euGS69eSnAF/4TlZT4Of+dm5BEkNQ==
X-Gm-Gg: AR+sD11DVHt9c7A7xw3tSMhtqTaDbtxDtAO0+A1zmiv9j6C7iFQAAQcw+1dlfU7GlzB
	JuTId41pxU9ns5AKaBaAj4q4KlWvT82F/DuzUOhaXnQsfohtbvgFrG00ieebpOZrXEsD+zpjLWA
	KlM+/PkFC73ZXJ4XmpHYpRAnf1rftsLj7V5EYcElreFqwhNbLzOOjzwe3BmKGtHH47p017tSGJk
	F2RFICpwwxbHyQ0+AgN8vroeWA9orBuHM/OsQb+tRUdZt86jo/cNaMtiEIGqwl3v5lX49zOrwPD
	kmZQz/25vh2AgY8yfw==
X-Received: by 2002:a05:622a:14c8:b0:51c:7b12:5fd4 with SMTP id
 d75a77b69052e-5283e012098mr18036511cf.80.1784794952935; Thu, 23 Jul 2026
 01:22:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
 <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
In-Reply-To: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 10:22:21 +0200
X-Gm-Features: AUfX_mw-0nrqXevHRitoGqWVZtjfkA0y47FHySyo3TiICVfrOazHUs2Vr34P9VI
Message-ID: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 18:36, Andy Lutomirski <luto@amacapital.net> wrote:

> Other than that question, I think I generally agree with you.  The
> interesting operations here (getting an fd to something that was
> previously inaccessible) are different enough from normal path lookups
> that I think they deserve to be explicit syscalls or syscall modes,
> not magic links.

This is a super specialized use case.

I sort of agree that doing statmount() as a syscall was not a bad
idea.   But new syscall for getting a backing layer, that makes sense
on just a couple of filesystems?

And that leaves us with ioctl.   And ioclt() returning an open fd has
it's own problems, besides ioctl being a generally bad interface.

And we have all these powerful concepts and interfaces for
filesystems, why the big resistance to actually using them?.

Sure, it's easy to misuse, but I don't yet see why this particular
case would be a misuse.  Enlighten me please.

Thanks,
Miklos
