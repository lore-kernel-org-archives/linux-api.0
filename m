Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795593479;
	b=S55cmOqed0bxFwvlJjuWsbLxl9B9YMBds/60DBBR9wDfkRqo+tTWaVmfNnjIKYEqpTph
	 kgKh+IixIrMm79MkFGaiB4z7hrhURqKBkcMhqLl68+2bnQwfOQG5aW62PMvFKiKjipDSS
	 m5eddr02y8Iq+1AqGrLGFK07TnJOEt6YLI4L9IZFafLJUg1DL00JNkcEA9yKHqNfvYlmF
	 4f9lAwCCv2Qei1tg3hzBNzdODyKzns/v0o7IOFB6myWBJVoPmAyygvKmnT4SLR2a4mRV1
	 bjrx+RX99Dq3RlZIn2f0dHRjPCl0H3aNs4SGGWd4ISOXszS7OKGDcVLRxVj0pgr81VA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:From:In-Reply-To:References:X-Google-Nh-Sender:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=ul5eVM6to8I5k6j4gyfBybKY8kBadnDIJAoBs2N8ESE=;
	b=DbL63xqJ19eIf57fxO56M/esuVcYGBvyWu6PvNNvy8npDv0p69jBqMlhtmmjvrx6QIjf
	 lEKFngr20+0zZcy/RPLpxQxivXwA6WI7NHeu4XyadurhPtMoYYEGP73X/E+PYQYfQ4bbO
	 qIWhjKhVvZLkmMkGT2opPUZE23lZ3/6GOTzVTJ440sBFGuCO/rsDDjKRLmN1O0W+1ADM+
	 hIexurYgAMuChJYJ5RCNCda4vhWbLrnDeIvhveFSHkP2uG2V4b+2A7JUIe5xpeGc9t8hY
	 aNf0wi0UMHv4bZxvPZaPCJi6diSkxmXH7BSZkKTdTIaGyogfdwVWuWiaAR4OdDdxpzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="os1wA2k/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273A606A31E
	for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 07:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C273A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=os1wA2k/
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b51871c5c4so40831747b3.1
        for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 23:57:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795593478; cv=none;
        d=google.com; s=arc-20260327;
        b=h6i4XT5Qa1SrChB0pmZ9xIyTJ+l+IXkBQ56z0cDltMfb3S5iKztc3FNZCbIuWWkLQI
         gWEV9tfZJrtq2Kh3OgDnenM3nkPp71OObUjkDjlpyXj9cioeUApnMfeZ1u16GPkOBT3+
         6GALOYkmUYKcc+ZthXsSUnP+CExLUaKy19nB98emMNjVV3n3lS+WK0qfIBgbqL/VJpew
         i3simpRyW1cch6MSJ1+Im+mdNSA5/xIUPGCh5BesNqMvNe8UxqY+Ap8jA7zYNJl70hk8
         8EB1Quk7qgmSOHQ7wFquYThpf8bxIKV81MdK/O9BYRaOMLuhcuKwOMNLJBTexV19Om/F
         f9LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:references
         :in-reply-to:from:mime-version:dkim-signature;
        bh=ul5eVM6to8I5k6j4gyfBybKY8kBadnDIJAoBs2N8ESE=;
        fh=FzGyy2ZJkY0owKD2DHw12oswtXCbnvFNVdldnJ83/m0=;
        b=QlU/a1C2CoVxZVCuFcoTgbDWMMvww3IOSxhXrMJkcmmm3oIQBq//WrO4g3+4KVv67l
         wNZMSxn+kJRUZErRZz6pfGBRlVWEGlm/Qmp7NFI5KLt+wxmTT5iImm7sIXWWma+7qoTz
         DlKGyfK9CYZMx11+9x9u7/AxG2BbSAfWYd6wvprqkxkewY1MUz/adUTNxfMe1xnKlLqt
         neKH+Cqnj47x79iNz9hH/gC/fM/AJqq8f6x4NxqrnkX9BHnQb1n2xMcoYjDiDKh9PKFp
         lmWfYqcqgpAC3wdjYFKltLMdcrZ4KyI8iWsyGauL0B9tETucvOcQWxGEJdtqTDziLgUF
         CNDw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795593478; x=1796198278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:references:in-reply-to:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ul5eVM6to8I5k6j4gyfBybKY8kBadnDIJAoBs2N8ESE=;
        b=os1wA2k/HDuNvLOaitHw6lCGdTi+dEc/77bcad7q/Cu5ogAwKJHE0EweBTKXoYNZ3q
         jVXKK6GCAyaD0jVtVZdL6H8f9BvyREOelAZj4bOmo6musSrOQcm2I6qtPKZYmANkJgtf
         PAtdjK+LHTv+2YwVQSJlID2FQUl7YFH8HK9PY92IFdTQo1peOEG3/+yyU0GTEDvavyhu
         DdS4bs9nslw9cHJwgvc92uZLmExB7pc27FAXPhQU3udgT9wH37yd+CXniwBi9lGXDgeM
         ykdBgdC2bYVbCE2YR+bk9LjUvXp6KtbtEVJR8EhGZ+WOYv9aCoikhvZq1yZ6D3IgMA52
         YXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795593478; x=1796198278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:references:in-reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ul5eVM6to8I5k6j4gyfBybKY8kBadnDIJAoBs2N8ESE=;
        b=c6HYstayKhKGw8tCv94AEjm6dPur5otjtfjj56n1qm18OLHQ+BathW15N+77dikyxm
         j+kpxUbi1Bk0JOgBr7eVoRKiejnBnNZdF4anv7i8gAAA7IJkDUna1V8ZjXzcCWrDxcMS
         l6GwWGZA585QrYhnHiKrEN5lkS6bUlXk57QAFfopXprphLUq3IriTNJjjGRPJKr9SQeQ
         P+dLwyUkZ+i7zS57ENxgj4HmINB0LEqYw8SMOaquzB7nC3W/d6YxTSRDJV7F82cPjSLv
         N92PTfZzQcg5Ed/RhaBwVhkUxl5tKztNmnwo0RuunAvJYYGsK7OWOL79hmSanlCuK9zE
         bGFQ==
X-Forwarded-Encrypted: i=1; AL+hErGiwRCZs7+ddvvspu2S4y/bQ8SET0kWTeUz9xrv8OFl70qsPE7MXJifNWx6v9bx+GNBNMBIFyktn/A=@vger.kernel.org
X-Gm-Message-State: APuU4Z8y88nCFltEq5QvaK++Wn4apkKQyPWqTbsmQx0BPRQcb4VCR4O4
	riYJrqp9FHxe/QGK+b6EZRtfJntZv6Srbxjw+a8D187mzXlNBml5/8gzr03xhXri1/VKE7QBPQc
	mrSql+A76zAQWssKaCVwJf1mbQ371tOE=
X-Gm-Gg: AZFdTZfBEYY2Hax083xx04PkDK9Mswd5R5tInkdW2nlFte/rkiJruSzuHCzud9IrBuy
	2wtEX4t7voPVZuymf48vxWh4dlP+8MLOk32PUnEQa5QqG1BM5H0ncwiUH/3k8kerZKOdpJsz81S
	8D0uFm0UNV5n0xu2TnBAS7dFY1ZMDSgvGTjrNu8NUj++YtNUpHHsJ2AuxvFTcY6B+WsK+IYA26Q
	5pnGheIXBuMkcNXulGMSGTVF89BfpdINXbXs+dtHmBKxFVIVdG/v+J9bknfsUqcn9PmbCw4PN4q
	OdEvIcD7ThkeIgy5zqAh059iLYOlUi/ltkQWYlVHZOLm4ngG7KuoJX0MFiMvALA4cNupQNM37kv
	rLR0yhHHlpFiF/bX3AJjjOxzFoZ+aS14IkZ9Oe7xN2m70mGWZ5Tml12GCcCcKHDM4ErrhaNeQ8T
	8U7Zb1JmxguIvZXLImvtO67i2+2OaB/mXcoyIXtISterw0qzlKkgovvI9sluGOw3FeB8gfuzdpQ
	bGLQu0=
X-Received: by 2002:a05:690c:60c4:b0:8b3:b01:74c3 with SMTP id
 00721157ae682-8b518f19782mr69361117b3.23.1795593477817; Tue, 24 Nov 2026
 23:57:57 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 25 Nov 2026 01:57:56 -0600
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: peder.bergan@gmail.com
In-Reply-To: <20261124185427.3821700-1-aliceryhl@google.com>
References: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com> <20261124185427.3821700-1-aliceryhl@google.com>
X-Google-Nh-Sender: AW_J_UoiGWtwg6qnqUMBw-OJ-1UVFEbjy0wfv5Rh44W6JIMxd7U4y8mFVkrNI5HtQOK7ljja6JOiAjS7xwkZiGXEFdl0Ulsl2DyARbLE2OBtjbGtkeGRZSW5XZ0J_3lGWC7feWPG6jWtexTx2GjMEIk-wJteUIn1NtnDiX31bUda1vsE4L49hwYvar3comaDfsQX3th1DE1l2TZIEwwsgH3CoUYV2ANOWtkRhrYjuGo-r5eEdHFq0arOpzb1pjIEWnQXWuL9
Date: Wed, 25 Nov 2026 01:57:56 -0600
X-Gm-Features: Aa3M54p1LUGsSOwrIWll983HQ7Jb_OQJyMjmYeIZbB_tbx53ZIZvkiW3hGwAhAA
Message-ID: <nh-b28a5938-34e4-4077-822b-71fae5f4773b@google.com>
Subject: Re: [PATCH] rust: drm: enable standard fdinfo for Rust drivers
To: Danilo Krummrich <dakr@kernel.org>
Cc: Janne Grunau <j@jannau.net>, Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Asahi Lina <lina+kernel@asahilina.net>, Lyude Paul <lyude@redhat.com>, 
	dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the reviews, and thanks Janne for testing on Asahi. I agree
that the Fixes tag should go.

Danilo, I=E2=80=99ve prepared a v2 against drm-rust-next with the callback =
in
UnregisteredDevice::FOPS. Would you like me to send it?

Peder


On Tue, 24 Nov 2026 18:54:27 +0000, Alice Ryhl <aliceryhl@google.com> wrote=
:
> On Thu, Nov 19, 2026 at 10:48:47AM +0100, Peder Bergan wrote:
> > DRM monitoring tools use drm-driver and drm-client-id in procfs fdinfo
> > to identify DRM clients. The common Rust DRM file operations leave
> > show_fdinfo unset, so these entries are missing for those clients.
> >
> > Set show_fdinfo to drm_show_fdinfo. The DRM core helper emits the
> > standard client information and calls the separate driver statistics
> > hook if the driver provides one.
> >
> > Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
> > Closes: https://github.com/Rust-for-Linux/linux/issues/1266
> > Signed-off-by: Peder Bergan <peder.bergan@gmail.com>
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
> Alice
