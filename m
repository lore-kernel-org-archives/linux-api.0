Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC1368296
	for <linux-api@vger.kernel.org>; Wed, 22 Jul 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737777; cv=pass; b=C3WoBK+2ZYaquUIPiSDz4bATdRU0BGKy52N3WM07qVwuSCcaJxIvGG1z3l6hySDqei7P70yZTYbsM6aVoARMussD9DNhSO7rK+xu5XzAM4hMhyZG6qOaf4lQ68HxwM+fc6OQMgiitK0Cfv+7PzvqoH9UPy/G++xaCUJa3Oi4Iqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737777; c=relaxed/simple;
	bh=U+1oSlhoto9RzC80eRCQEK7mIW4plZHyLlmXaf+c5ZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KQcMGy4BUvYY3+I2Y7VzXSuJQcX0WaYPw5gLAE19NnxlDjCDhLCTH8BHd7o0doCffrp8NHQQ+wzz+zZNUuR77IZ+JvJSh/z8XmijiUH+H+VkE4VLTaL6Ck++Uq6xux014NNwbyAiBZGSgbe4FHa2BNn2AYE6CRBE214ETVs/764=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=CGqtQ8Ar; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="CGqtQ8Ar"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b2a44a3b66so2646153e87.1
        for <linux-api@vger.kernel.org>; Wed, 22 Jul 2026 09:29:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784737774; cv=none;
        d=google.com; s=arc-20260327;
        b=sc7lfk+WwjNt6Z5KMTbWUQCVkBw41snkDqn2qBN/xbW+j4H4YhR3fTo4rjcHpkp4kZ
         2z7IaDEwY7yQVp/K6NLVWiNB33rPEPRN3ZJagngCa8iihWqXSXbyUiSjAV/3yrsrazLS
         v1AD+Tt/wnaEiteUDOhaWq31l3nYRAVI9FUuPsrtMnLcbBSLqwVtUbWDzOLG7R8M5flS
         Wul6+HzvCrgQvp7dfRYQpBPS7kTXvrS2XqrnXed9rwHvvCNXTn7ZSJ+bsolMBCH794kX
         DgpoxfG/u7tnBdhqmaCJM/iEYkepIs7HnJjQjJX71JDMj8J1yDVbkc+eH3XjMpZrtfqh
         FxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        fh=FrJ0hUvnAsN913CSr1PgekEG5SJCyBHkfxhstbIddGk=;
        b=V/p7K+6SB0FtgiPOKuMECm5dsuPX/XyXoWVzeZYT/c6IBUXwEZ9ugk1GX9sBdH6M1A
         PRDs7q13SndusPS5GQeYZyTVuzycuBkOki1UaDcMYS6rCdslGS9XXnSKwmT4mBgKrNAA
         qYGQxpFbUBhx+6mqgHjsXkcnWjkIsJwYfa2UO60JLCX4neKKeJMnZtN9YWiH/m6DsdMP
         YT3EKAR0Tsie3Ak4JW/e3ZSTVNjxB+kS/u4Vdq+P69+WPCUl5gth3i3CuoLAgVt3H9Fm
         4qd7J8C5D42/TDuNt9e+bIPUCMlgsjK3UlWiOLEo4pbsCWaBnaoIBQ0kNOTBobu9zVim
         A2Pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784737774; x=1785342574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        b=CGqtQ8Ar9zATM56qjLFdcqHMiqXEoB/rmSEZ7gVqOvBXFlL9pqCFP1YfXO4bJXVCKH
         h1t04PL3WCBYh11ZgmBZo7o98zYRUFiU5RsOhFysRGQ6iJIRjAdtEhrCb9pc7F0SVPwu
         iJAGNc9Cr1Avds7+BUX2dhUQkUGpWuR3auL+Bp4o2L0ReFhEO3BAEna2eJ4MM7pubBjK
         CNOGlOkWmm+Q+BTWYPNu8VwJnS/SkJCsWfXEcRB8q1tavuBqCDhFz34/W9ndHTe/kgql
         5MLp/y803L8iPsCXtq01aLZPPox/RU6/V0x0OtAXvvKCnYHnfc35oeKks/YVI5ebUqPP
         5Hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737774; x=1785342574;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        b=J9cbxvzXGWMrvRm5RIkTU7DG2hR0nf7TbiWe8aWGBahuCK03mx/R4iWufvwHP9ErOb
         60jqEdvuKXoYNqvJ/K9KDTus/i2m2DCmRZFgJV6QS7+AIax+U/r9IPNrZhM41ueLK8yI
         XhVi+roQYA+MtDohz4psVR285nHtSjH//dSnNmrI2CYLdj2KNYhl2y3gqPBxzg+JKmUb
         di7+2iSv578LfOvtGU5/DFcTaoMIHIyrummnNAjmNYl50OYFQwz8L51C64zN8XSVy6JH
         f9/L22MjfWcPWQTx+ObU/O73KQq3+BFQWqijIi5SvbrQn7ClViUCm+WKvOj4dHsBUWXi
         52lQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIj2iqpTV1rAEyFrviyioEsasKc6YWMbi4gypvNZTO10bX64IKWPEsDxtucDfWr6/3iM16GURp+kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF9SmWLHh+moUFII3OY6xz49OJegQcXTPhmQ3AdUNyRlWp9lrE
	W9TlQroiow8CPqWLcr2PBokB7jrYq4xDOZq+xY3Yv7aVjinmV+t3QhALzhXRBkW1pjBDjT1S+4N
	Z2YZjg+HH34GwD/8V8qNbZlbxxDnLqbroCUzhlkUV
X-Gm-Gg: AR+sD13YpSOp7Wzst6KeATcpCexruLqTrm68GYDXwDYifeccncYYCu78gTkf5mfX/Wk
	RoLW/JwhJyDHSq57JGxMncVxqAeYyIYWbJ6K1IWVwg0N8sn/7ht8hucdobQknE4hC7Pn/U7pBc1
	wdai3Pr4S04r2/jkZ58e19WAe4fLlGe5Lb53pA2yx4RtOBbIFCpFd80f7K+9nt65aeI4wugNl8n
	lPGjgFN5SbLL8px5bavzbiG4ujbwkJUKuqU/VVart1FNSOa28Iomc4kU3af0Q==
X-Received: by 2002:a05:6512:1328:b0:5b0:eda:de2a with SMTP id
 2adb3069b0e04-5b28f998d04mr4374814e87.35.1784737774129; Wed, 22 Jul 2026
 09:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
In-Reply-To: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Jul 2026 09:29:22 -0700
X-Gm-Features: AUfX_mwycQYWu9rMPFRhnxWdDLtR5J98EpUP47SKtC-4N4S0g7pVJ9n5XWZrccs
Message-ID: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 9:06=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:

> Like I said before: I'm fine with an API where we can use open_tree() to
> see through into underlying layers, and given the right permission pull
> a mount out of it. That is a narrow, checkable primitive and it needs
> none of this. No new open flag, no second ->show_options, no metafs, no
> mnt_devname surgery. That part we can potentially do.

What, exactly, do you mean as the distinction between "[seeing]
through into underlying layers" and "[pulling] a mount out of it".  I
have a guess, but I'm not convinced that my guess is right.


Other than that question, I think I generally agree with you.  The
interesting operations here (getting an fd to something that was
previously inaccessible) are different enough from normal path lookups
that I think they deserve to be explicit syscalls or syscall modes,
not magic links.

--Andy
