Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792671540;
	b=iIPcj9ShnNsFcjfVC3j6CkWflQ2ikKoh7PHdMZPgMjuEUTYcDoM5J60fR9EanhPOGX4y
	 PHxAnYIwcA9DaifbxR9DDqdmJx7/NXKA+qiaYpzbLV2lTWWmg7m+aGDrBIEBmiPUxpYAc
	 8zLUD/cmxgDvRIokPf4HrqMk/x7UmqSmwSubCDeJ1aBA35vfo8flOQgV5JUmfzuyfmHEZ
	 TB9/vkYMsW3ZP4SIE5MSSRQ3dKkmUfG/8thmniQKvD2TA2uXKc8lYDOexQ9BfWVk+8NMH
	 oVqm3lHBkGp6z2vmm02C8sRAuIKccGRNbZX0FnZ+BDr4djC6O4uk6aIeTxP8x83up0g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792671540;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=O7MzFnbIsObJkz1l1H1RrtjwBzWrndW2u4bvc7jCYf8=;
	b=LoJoIrobHYvcXKgXcksEqlmOf2RdZtztwP+36Wj9VA4ISDGS3xdhvMidspmIht9rcP8G
	 OQvn+gAHxxzPX9DR6JCcaTCmy5bISfNYTqR3NIB8VzOikLVZDN0YKInVIC0J9G8pk1jAd
	 UoEvP2ZfsTva/XIUa9PXc0W1KcU6KkNxdgaIoRRU7iRpjTuH1RzVtI8SW7bUBdNuQwQqP
	 XaIkuhJpv84oMmQSJdvq2vdGsrNNvNxj0M3BDCEcSpJ4K7bTZ3RiwpTyX88CuedSpKg1P
	 f/xVkHZ/91/AkiQB/vPyJ9JZsz8kvi+L+2s7oS7pJ1+7OyjJcTEG26B7eLP1pLDy9DQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20251104.gappssmtp.com header.i=@armoriq-io.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=YLUPMQVJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.45
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB3606A31A
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 12:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1BB3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20251104.gappssmtp.com header.i=@armoriq-io.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=YLUPMQVJ
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-843a4ca671eso948982a34.2
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 05:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792671539; cv=none;
        d=google.com; s=arc-20260327;
        b=bWjZbR04avGdyEPQ28XLuY6y+iWhkphwU7G8RPnQh9YrTdNHGicAtn0SHDQFfMSEwx
         mHvAyG/wgg6E898GesJcBZG4EOGpQi9IY/Ac8ILOMhHcq6OGZtQP1cTolPIPN97sO3cA
         +yhRx3nhtrY4nTtYxsvL8q7XwntIwde+ayCrGR5sz7UDuqGcElowBA0tBrNEJC6uXUa8
         7Celi9RkRFQ70O0HCI+gxzna99A46yPBhL272NwwGYDJBrWkSzjTeZr/Hvy29o3ObVLP
         otpAIiJCXwfqsvjtET7ayTi3QliyiCm5ZtfbDiHjNNWE06PA0R6KnqtFEvrwD35g+Pu9
         kR/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O7MzFnbIsObJkz1l1H1RrtjwBzWrndW2u4bvc7jCYf8=;
        fh=uIE/VHcgt9wRZTJiqVKz9xc3SSqCe6BeLKu4eKueCtY=;
        b=l6lSMF4bxYVeg4drQVqvxXmS+UIJrrdn4rgkYYrHsORhy9hlP0a3XJrUiPST/mLQxr
         j8EBROGLiVii0b152ga97Tw3kCayCvYhbZa9JKbz5V5hjvV4Tld+aDmH2Wi0qppzVAGb
         njbgj+BgyTStLxeyFlaPt2W3SL7Wma8/hqIsjIvqXzLcokETKxGiezpl7Ghk9+xbr5YY
         RC0hXtj2PrsnZxXAXAC11115+b5mCxlVM2axeAqIBwIlsTyGO8EJmqB3qEIl4BUGrOPW
         pzutVFb/F/ZVbrR8x9FLOukIBID8/JMzbxE7YXUydZF9PETvRq0wkFom1Zlo4di/uDtj
         ZtZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20251104.gappssmtp.com; s=20251104; t=1792671539; x=1793276339; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O7MzFnbIsObJkz1l1H1RrtjwBzWrndW2u4bvc7jCYf8=;
        b=YLUPMQVJF8HRVC8z0/+XrEs6ev066K/XYVa52+Bkail+lf49nY6jJTtmqI88eqqqsS
         JyqLtxXkZBgpqap7OKLLgfKTDdkw7sXaj2F0wki4fj815GI8j0FU3WPvBZrpoPt010jG
         a2eKGzf31l4WZyISy7N2Q9j+tM9WRaZCyHibHUXQ7x2AV10lfY5j4oXlH6Lm0KDXNPTg
         u4ey+rSbQxYeOt+0Z8HBA+BXKpNpfApwmejs/QWWkARyoKd/k0ifAy3jIR5OPv85JDDu
         3sVPwOid7UjGYaFQBECFXSA4rQLg1L8OKtRadkaLUwkT+FuuEXmEPh3CQJ3uW1kN25Et
         daYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792671539; x=1793276339;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O7MzFnbIsObJkz1l1H1RrtjwBzWrndW2u4bvc7jCYf8=;
        b=Y4HuPLYoFd20IWT6btQtyDl2160ZQFXc33eoJeB+AxB+9wwbMxknsWNEdtaaWjcWVQ
         gD9vsf93KdyyTouuau93bQ0QZSXRIHsaTRwOebQPd31vK1FnhAQ76GScdz98rGtH+R0e
         Gjx2bAl394aq+x0Xrwr3+soAcbVdZT1ngA9N8dH7Lfbi+1qNVL2R5DfH/BanFmXWjiTH
         DwerCYlqYLeDpv4JZnKeYvIcerkf/gD7g2jqaSiCwyKPTTiFwMODbzaD0e6skt/fpDGo
         y/EVbtG2TbZQZnllrzX6TRBkcSQgdOcVyozEWq2v0AImMnLmOOddh7Oufgjz1qp768HP
         FzCA==
X-Forwarded-Encrypted: i=1; AKwUvBzsgLlixvVFMtTBj+OsPDZNtwSbj066FGq+HZnb4cufcdLKCuMzDLVVVQKKH7r3ylU0yjRPyrEE+dg=@vger.kernel.org
X-Gm-Message-State: AFq9FYKxb4C60zboZ8AJYt1OZyOsr3VaENI8Xlh6dtlI8wpKPUq2YhjS
	3q1HCn6uo25mOxhTVWVqj3+zrDe+iYik7njYhAdfV9u92gWpCYg9TE0to5tvcAMDWMMqTC0nsJM
	rJTU5PrqFYCd3dHbneeOApbpDauYtQgQHIqEpyDU0dKQ=
X-Gm-Gg: AYBFou0Sei/AQY9wLI4XKbudkPrDB+G0J5mGbTGOJ0yKB6COsEkkacovSaICpvwSK3W
	ddM9fSSqqO0JW9klueDLFG64g27X4IZb9ZxW0gc8H2bcf8EkU2XO1FgZeebtbbIiSOHr1jta775
	VCaKlZtam6WSViyw+oAUUMeazpkdtHwXv5a6oPhd1FKjl/lGmJ+9uyxwEZa27xC6yOxmZpg27mj
	ncWqBKxKVXc01+dyGO39Ldc01Ag32V5Fp88is78TChJfyWPAdhtgqlsGCjXSZjCmtEYUcIdkZ4Z
	7cDVLLQQZs7IEW90qbsQh4IUeQfY/wqJdJ2UeP/UoV5Jjc6V7vfWIvtKeyU/VOq5no9XuTclFS7
	b7mVlQViv731kvBQCbyEmlYdHQkxhZCGwzq0ScNnkVWz2X2+x0Mv9OybbXShEqQ9FEjXWUn+l0V
	0HYVY51ei23+M0ZhHE4B+X75envOchl2PVl42NLGpO5/Dx8RWCfipa3ZQ=
X-Received: by 2002:a05:6830:6f85:b0:81c:ebf4:9ff8 with SMTP id
 46e09a7af769-84d09218548mr4176798a34.30.1792671538755; Thu, 22 Oct 2026
 05:18:58 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021165748.19304-1-ketan@armoriq.io> <db4e46a6-1788-44a3-a3ab-4fded03591d7@infradead.org>
In-Reply-To: <db4e46a6-1788-44a3-a3ab-4fded03591d7@infradead.org>
From: Harihara Sudhan <harisudhan@armoriq.io>
Date: Thu, 22 Oct 2026 17:48:48 +0530
X-Gm-Features: AclHuK9VMJQ9vVvn-lB4Iuv5LF_25cVG0XxJiOkPXcZoQJDfSKiJzf7VWJduKT4
Message-ID: <CAGhg=-NJjXPqeAFMnYVRnbZWQwoGiPqhyhxH_c7zhL-=Jc+qzw@mail.gmail.com>
Subject: Re: [RFC PATCH] docs: security: Describe the Kernel Assurance Plane design
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ketan Bhardwaj <ketan@armoriq.io>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 5:11=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org=
> wrote:
> I wondered what this index entry was for and then running
> 'make htmldocs' complained:
>
> Documentation/admin-guide/LSM/index.rst:48: WARNING: toctree contains ref=
erence to nonexisting document 'admin-guide/LSM/kap' [toc.not_readable]

Thanks Randy. That entry should not be there: the document lives only
under Documentation/security and there is no admin-guide page for KAP.
We'll drop the admin-guide/LSM/index.rst hunk in v2.

Thanks,
Hari
