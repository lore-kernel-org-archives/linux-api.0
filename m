Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBDA3AEB4E
	for <linux-api@vger.kernel.org>; Sun, 19 Jul 2026 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784486584; cv=pass; b=Bml29fbmbXJkFpWwmnNRuU4EDnc7ArMbYih+IuBCz49YS3FH/7lxKEWGaVJYRwA54tjuCcfet2CiOJW+5wV0j7uJnVSmSLXcfo2HhRXERWDDlxBvBt9SSYbwNSKrmkW9SvItDeut2CLzA2FVo5/i0CH1DNgUYFtVkd5XUbytDPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784486584; c=relaxed/simple;
	bh=mFFppR+tgzYK6/5HpSQcE1hem+w1X/QeYlu4aLPPxXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRuoyCDO3iUalKwXEDD8My8Wbs2Qi72iVU6B+oPZOXYacAMZB84OOxLbRXdw/R5u2AWe1uHo7RMOWKGxfKVvf8kXDNDnn7mvioG9pPkZtc7yMW3A9h26/cMM0I5Of8Gl6OqO174X59vcBwLe+RPRkCaLtcYg0C+g1sIxZc8izY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LLMEnHWd; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LLMEnHWd"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c149c5722so39138771cf.0
        for <linux-api@vger.kernel.org>; Sun, 19 Jul 2026 11:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784486581; cv=none;
        d=google.com; s=arc-20260327;
        b=RKU4bBSiCJmskMNEKwo3kX8jJiIsyTYT/B58yBOvlMaINsJO5w6BoZq+cPZJ1AmptN
         5lxAN6Z0hL7T2uHR9ET7ts0MsIYQ6+8BR84beiaczoa+9yy9IPFpEoTFkUqVf43aozNI
         kodBaSHdpmHwN6XQONORgVCQgQtkdNDOgD8FIp3LmZgYBQfXLe6/2TsnvcpI/Iiopi5R
         imjrrGBVfr05Pl9H1kmCHuEejXrvnFwlDJwsyFl6WAIc0ryt4ZZUGZ4Q5NWsdrxdkGCW
         a3ahKT4D83sig+mPInEUZNeFe6GjXAUYl/NUOle5/7+/PPDnwt24Cp3pl9LCokZAeQUz
         teYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        fh=jOKdmHg23Mgo4qeR2tYvlL+xXe2+PEFByU+b+yt9mWQ=;
        b=dF2+12aaz/Zsnbzr1GqMbRXaz1Aq350kgO++PnWJW2LC0M8KgR1BQ6Bx2pVh/nvHLv
         8AjACP8sFxc51fl+NglXYVQQH6M4iS/BNZHfskNDWFIIiCNQFwXQfqwggit5BldQELdO
         ZqdrO5SiYqMgGdyucA8mwi5vxTP/Tf/r34zBRjc0A0lHwiJG+aR4g4Hb8FhYgZKsMGZo
         ZVvDQ1Ue86z5R20kxZPHW1caSxIeKDElxisIy5zlhsIJcCkfES0x1oHzeE3fOZkLhVOb
         iVUtTsa5WT/9NsNR01EC3vX2OZFuDelCSX4DitZHSM8FNyc0LVFWodeNxeslFwQ5IXGC
         3mQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784486581; x=1785091381; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        b=LLMEnHWd0Fxl7f2PLtvb9/12JUtvOORfOPtaRf4g8nmg3HU91XEiQcSqS4b/qj1hus
         hzqXl1M50X1ZH1s3V0S/v1waL37a/zxRsdJsGbb9yoO+aT3WorFerOjvp9C2QgkXS82x
         jdyc2Areri+08q2M00uVesZs3htcPey6XALT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784486581; x=1785091381;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        b=otGfwNDclWj1/+AtcFv5iviCv4T1a/APJS21VupONo22QE54xbNJj01Y/juw7mfUkZ
         J4Vnu0hKv6IfupPxBhL7MnK8L8pukXseK4tm+dYWOgPPtprImN0N1OZ8rJLaF2taSofd
         dV3X699X67G0HlQNEpBSdR6TQzKfqJWuzfJO5FI+rHbWVU2E/wQ0xVfiP4w72SUA5/Qs
         XHEFCN1SNl9Hr0Fguw74PKO+DpsS1x38pWiCALd13tpiS15dBLV4cIrUmYLsVZrRIRfM
         JuQLnm3A/8O+7+6DAKwpfrmTzYQUmOFZkSJU53tEAJ88GqxGC0xmuXFPDY9XMzkolJjn
         hODg==
X-Forwarded-Encrypted: i=1; AHgh+RqWqdBwiLwofZ54IVPURg36w34BTYLTDX+Jnat6myjfRG8DChovwcTmUsApSJGzeJM7PxZW5VDZ1Fo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv15r2KM0dlpBP4X68gH0FDaESqSWymLFjGTxMH1CQ0Mkn4ZGH
	Mdc2UjSwrobkgXcGFkG4Oa8ZuE+psrdohoSOR+kjXqU80FMRSX2y8R49sqEJKXWOwfYY4ndZ7jU
	in7hIjCK80Qvn0gZo586UWzN87HoAwkw2CfD6gAVkKw==
X-Gm-Gg: AfdE7cmna0J6JrJUe0/8335X0v1ZOJLSuT0Vchssd/VU/sByTkSox5YzdveDeTT4TAF
	EUNeNRqO4menQRUkXNN8JWoeklF+0JQWEs1rwRzENueBFqKmlJzBzm8IFNaNRU0aGVemwDi5n0q
	Ht1ROlB9CI5u9gSYCvEswS/cHmcvk8OBCOsVhv6bbvlqa8E/c3aO5+TjfTR05PNnyWHWQjtZ2pC
	/Km0UVUMdjHEhpoI8DitKZD2v+jbKM9cUUSi4exMpPV8aApYvhdY9DIsq0HFbkZFq0WcEWafl2r
	VVZf7lzcmD8zyxUa0w==
X-Received: by 2002:a05:622a:1388:b0:51c:7aa7:e0ea with SMTP id
 d75a77b69052e-5212c20f0c9mr108504931cf.39.1784486580491; Sun, 19 Jul 2026
 11:43:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
In-Reply-To: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 19 Jul 2026 20:42:49 +0200
X-Gm-Features: AUfX_mxZAmDgP1C2hJYyCV36TzCfzCkpkn9ppyiNeH1CkViYcwVDmhXZWL-qKS8
Message-ID: <CAJfpegsS=aZABvwx56tfMtWzSsKWtR-N78q3YQ6JZ-nvQLUrGA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:

> This gives me the willies a bit.  It's very cool, but it has some
> potential security issues that I think we need to watch out for.  As
> sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> supported files-as-directories.
>
> Some questions that we would need to consider:
>
> 1. Can you open an fd referring to a "directory" within an O_ALT tree?

Yes.

>  What happens when an unsuspecting process gets such an fd?  Can you
> fchdir to it?  chroot to it?

Yes.   However you cannot escape from that particular base file's O_ALT tree.

>  clone its tree and possibly bind-mount
> it somewhere?

No, it's an "internal" mount, so no cloning.

> 2. Can you bind-mount *onto* something inside O_ALT?

Again, no, because it's an internal mount, not in any mount namespace.

> 3. Whose creds are used for which operations?

The creds of the process doing the operation.

> 4. Can you mmap the things in O_ALT?  Is this determined per object or
> generically?

Per object.

> 5. Would we ever allow FUSE to expose custom things inside O_ALT?
> What contents of O_ALT can a program trust come from the kernel and
> have the expected semantics?

I think adding such a plugin would be similar to adding a mount.  So
I'd suggest allowing it with the same privs (CAP_SYS_ADMIN) and
constraints (limited to the current mount namespace).

Thanks,
Miklos
