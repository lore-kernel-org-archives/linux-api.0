Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7F33D9DDC
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798470; cv=pass; b=hvY2ObLP52ppze+qnz4WjdihUuIIZZDu9vRXrIe5E6XTPIzDjxj/3UORbA8Eih4wkH66UAeJlFQuL1TznlxB5+Wk4XerqMGZ8qM8/SMIVCWvlD/iL6yvVRH52C8hUZJH+/DUWjvol7dM/pzTAgvtMYl+y1LsSHub+Cuitq1Ev1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798470; c=relaxed/simple;
	bh=sGg6RHbGOFfY3wrPJw9iaoWvo2EuJQxmnM6MAF2FK6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p/X2KBtZWv6tpjmEHjClBGxsRWYmV0ntowJTfdPaTNQG2WVNQ+tO0JeIcj6uBxjNGi5zB7XF3EGF03fGY5Ekb+IMXrlPdmqFE42XYETtzKlPHV+YF05so0Pxn/1yGHREBLL2LO8Ey91AeOl9INTCzXx/Z3+1dMD8gK+7s4Tk5Jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/chcEIJ; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/chcEIJ"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-698e5859a3cso609173a12.0
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 02:21:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784798465; cv=none;
        d=google.com; s=arc-20260327;
        b=NciVVWb1fImnRtxrV8P7C6yvi4Sk/hyODLkvFLYM2Uvu27QxndYyWZ7cKChpeDwgph
         E95eZwtf/UG7c3yY8bW5W1Bki54uU2oh9M1OGwtdtFT0YL2NakAFF4RouOvPJNJQgh03
         HzLlaIH/fo1AAuyC4xMgH7Ln3N9IKe5jYBXMNtTt0tTcJi7fahLdBX/o7Sv9KcCqtvG8
         /yGDsXFKr/GGxmak2vKsSsGkypet0N/FsgmV0DmLHQAAjArTLTfBPXiSctC8QgIOaOb5
         MZHFqFYXBI3LHsdaQUJvUwJBYpO4owKPsOLx+zXGU7fm5tF67wfjRPOvnrmmT7m9a0DU
         XLtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        fh=bpigCxnhTgZ1t2Uh1AS4mtH2XOXqo2KPaMTH4g97wyo=;
        b=mpNH/EPz2TdEamIAEH/irnciN61Cn96Et4IQXLCaMEKf6YsM6AF7h/6/PEml9Lni3d
         aoRFP2mEzS2/tiGwE8Da5Rl7ZQ9r2OGDbLYVE55ztc0BenzLlRGOrU+rpIVWSWhTPxIz
         WzPWKzxEJq/o4cYzkmnVSFiFU0/D+tefmweifStMNHhdZl2wf8yI4AiuZSv4Bys4mMny
         Nd9Mk7uqcbipyjzxTw9o2HdDbOT/clF+eFzNm3Y5heOJd8Bv4QiPx+QB3OwQJSrfx8fq
         LDQpZ5QbjJl6cg0XuMdXtwGiAk9kPRI/iQ2H3MsGQwlxZsgDe+t104XlpH655mkjZdB1
         Vx9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798465; x=1785403265; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        b=g/chcEIJ6/GuA081rNIAaKAaWX/CudeYHOxgArtcCJwkdcODlvQWpmc6AToa0FezFB
         c4Ww/SsHx2f7aIzZogx9iA46Il/dSKyEsoiMbglDvkb3erWvpix3+UIpa1fMsca9ACql
         8p02kztGDe3G5binL/egF7FcyOgO/RD2+PD8ueffzRXu6Bs8TETxxj2+TFVw7SUwGd9M
         bAY5PByaDoUgs3y84vKm9xSkd4DdfBimj60ERjE63BZ8fbDQSUgqtMxRXKIMNdoPU388
         nblSvNNqfdXi2OLmCzSOdhqT2uQwclp1bncG4vKEUJuV321S5AFRWGZK+KuZ1RGGTy7M
         fbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798465; x=1785403265;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QUS1duImiuxRUZ48Ef5krHiYH/CmsP1C8hfnRFBWu6E=;
        b=ADtUqzaUv+2F1frWSMYp3VOWCD8zGU6p32mmZ1PplHhGhgnDEt1qgLAIFWpBWtpkMe
         2xBo154VeYBaMl24SS2EaXEeOPzpaQo9sR97ztVkjLzDnnliKE6Y9+rOeCmIJ7oPeOk0
         BUSY65SOZPUx8Xm1kvh4p7S/T2J1eN8xfiL/wl7Ng9AUfm/mjB65FJdEc36toKgqhIBI
         pnDjmQbpTixpq/BhZue4Jmtwkq/S9BLwOOtApdyGDOQrFobO0O05c9/mqviLfMt43cRD
         95UhUQy8sugpXCZktc/kunW2BbReIT0d2TvR6/854VrumKl2fvkJmfUZXPUrvKE/V27J
         gcSg==
X-Forwarded-Encrypted: i=1; AHgh+RpO0r5OH7EvYiFM0xwplzRXqFP6ujt6r6K0RquHm8JGOjQwzlBlvKOmh/qLRQtcgxuFQ3O04ZTnBsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jdzJaXOyFkmcqtiFdPL0GaBCdt5KX2MbJXD5YF4kJrUzlFdL
	/oUs83L/uatEJmCv3MKt3NWHwsH5Z2SgvKG0ry8F8udqj0lpB1+3tIc/1sEZjLHJ6dz0USfqGwV
	WL5wkTaDH9bopc8pJ1hxr2BAHxY1k2EY=
X-Gm-Gg: AR+sD10W241KjaJTbq8aeLF4ID3m8W3W87FCUANXpy+JaLSK3bZeSaxpHKre9YL9xqK
	Pfx7u13hGsiST4escpaYNENLN3Yhi+ioAExGqDmiM2/pYOG5xgCQM3rpqP675km/J6uC+g2aSpd
	/NPw+CrFmsNMfWb47P57U9KnfAILoCAthNV33J38ys539YNhHY483rL6LXrUlD+iVCRJaUBjxXe
	J0UzImk0+c1ojFYvVe+Tfdj5B5JFkgmqy1R6Waej9yPCLHM+XY2drFZvqkxnik=
X-Received: by 2002:a05:6402:2c5:b0:698:a9fe:2eb3 with SMTP id
 4fb4d7f45d1cf-69f7473bb1emr481810a12.9.1784798464605; Thu, 23 Jul 2026
 02:21:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
 <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
In-Reply-To: <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Jul 2026 11:20:51 +0200
X-Gm-Features: AUfX_mzGhC5ulgDl4H2_S8AB0-LW8RqyX4r61JB4nfZ8oT5YdWhv684RFp1OggQ
Message-ID: <CAOQ4uxhqmh47w46x0zhOzqJ54iiL0KDpuuAqr2oPyjm4AOgDYQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

> > And the smaller details really show how inelegant this model is and why
> > Al and I have opposed it multiple times before. Scalar options are
> > modeled as symlinks and non-path options are dangling links whose
> > readlink still returns the value while for path options readlink returns
> > the option string but following the link jumps somewhere else entirely.
>
> Hey, this is was a prototype to show that this can do what Giuseppe
> needs.  Not with nicely polished interfaces.
>

I want to do a sidebar regarding "what Giuseppe needs".

As I wrote I am all for introspection of overlayfs layers, but I was never
fully convinced that getting an open fd was the correct API.

The starting point of the use case is a userspace daemon that wants
to reuse mounted erofs images, which are used as lower layers.

When considering a single daemon (e.g. composefs) this reuse
would be better done completely in userspace without kernel involvement.

The reason for a need for kernel UAPI for introspection of layers was
to allow cross daemon optimizations, so that containerd could reuse
erofs images mounted by composefs.

This optimization works under the assumption that the image file
or the image file hash is a unique identifier of the desired lower layer.

But what if composefs mounted the image with idmapping or some other
property?

And how many container runtimes are there out there?
Is it really worth the elaborate effort to provide introspection
to this level?

My intuition is that introspection should provide static information
like uuid/fsid/fhandle rather than an open fd.

I am willing to be convinced otherwise with the proper arguments.

Thanks,
Amir.
