Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794857812;
	b=fC3te1L2qckYl0i97XyN3L9dArAqli4rdoQtUzVL1hUMoym0WpqMNwg5bQhgTugKv3zB
	 j7DvHsY4fQ/YzLLCYkoRHB8FO1atuT9U2ZE47dCBa/E911YzoOxf2AgYxAx+s8CUTpCwS
	 DbWFY7QD91ooKfau+iDXIXtMjjE117k/CL/buJbnbCz9LwxBcr6OcOc6TRmVmfTwTgFV7
	 tB659TkPBpR4uqDhf0m+37rZLzX6XqYw4pAvlHKrYmK4Vc5Uji+Le9gesSoKTY8TibH15
	 iNut7ny2bBCumPF2zBoJvxA6bnVGvADq6CeZ+d0G2uTNkSwFi2lK/q2/9XOwdiy5z1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794857812;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=nh4pWMvkRsPEst/kCwIp1wxFa2k7tAfx6b5lfGN0krQ=;
	b=kE4mIN4YgDoBOu8IKoNOWSTXpCoMfy5H/iYRyct0U4ETjwORwV2CBcfkk0y+ZnkUV9qa
	 wWBejlGAKGoEDugM2Ul8mt4C560HLuIxIBOoclfoQ/IvbYUWPZ3TvCJ64q15p/M7/Kp8C
	 oZplQYwvjTYlTb/aaXyHWbmBb++zxT4b9ncez1t++iInvfFEifokpADgIs6j2K0D9jVvA
	 YL+TMOC2IESBQMSc8laA6NjIaHEOugwME5/suHTJGzyWGDbCfs1Wo12ec97K7gjWGNK5a
	 OYSUwNA/xZ8UYt2mqsvrMuA/dhttFTnBCG+xieO0T7MghKmFVe+4rfiv8tBXTRxUjQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=JE0F9thh;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D37A606A32A
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 19:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D37A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=JE0F9thh
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50604721c8so622387966b.3
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 11:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794857810; x=1795462610; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nh4pWMvkRsPEst/kCwIp1wxFa2k7tAfx6b5lfGN0krQ=;
        b=JE0F9thh/y7UOTJSKLxzXKX12imABePPMOEs6ZIqDpMCHKNnzFR2d8+uI2rH3zTxFb
         3+zn+/+ytydiFugyyWX5j1XDjGVg1yc1fDfTMFBxntmN74IYqLR7d+xqVvxZddj565v1
         pu0IKYOb0XbsknnypjIZaGJErbXCCh3Lfw1vo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794857810; x=1795462610;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nh4pWMvkRsPEst/kCwIp1wxFa2k7tAfx6b5lfGN0krQ=;
        b=MwgLF6lHMIYNpnWHVhvVrzMof1ydFzbP0+9rvBSWTF/E3gJTBi6DxQ8bKVAIwrxYEi
         m99hpOqxxmuPWOoSQYkwaafWOee4LEd5Scm7KIVCHZARGRI9xJ4+J+Ax1jo9LhYaiBkA
         bp6VV8Z3yoKmm0v6YQ1x59b9w6kUl2N6HafkeOti7mUDY9OqyWfEPWk6W0qgEiSVVH9y
         l/hf8ntKmy3L/DzYiaK5caEloFjzWVPgV3AlJ44CShVxao2mxfEdqMmm2vvkWhVvmg5R
         CZtVy7fI+hZD72o1/qclpEd7t0kyWQp41QJ88UNv1Awu+UI0AnFr/6+ix5vdQwmJh7jz
         zMRQ==
X-Forwarded-Encrypted: i=1; AL+hErEm4F0+R1Y7l91mkFx+diKeqynJiaMIe/sBEs2f641Lkb0egXd4SyPbhZRn+bYi+0Wl07OlwrLuPBg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+qkrg9gQtP/6mcZH+k3GI1t6bJYL+/V11UB6zafo7kjY1Wypdj
	eJKFh2Nk+iqV6Yf/JBA8utgUjWZQaZiQnvNZmv7nLO+Dxft+sDIRzoXML414Tzziyn2+9UZrgdk
	W9w6EH5Z3xg==
X-Gm-Gg: AYBFou1Jw5cbUE2hLEalKxTmrW4FTnDRtQ8PyH/xXvfhPTSGBDAFL1Ev8AxyYPyU1Ey
	UCHKaIUt3U5UdCvBn1BjtOq0rDRSj9ldCINrNeJq0RAU5DB1NZ7tznFrTLuV461qzWNVrIXo7rs
	wxxXhpExJjpk9dpszLxReMCnWo88Coxg3sKMC3QfPRqzLUoRrsOhkdsPbMHWVqhMrpm5KwVDe2k
	CgxPq3fSVYryGYAEmWxamhWnQwqNBCJiNSSTnNLMfLNSAffeI5L58d36PK4SCqRySsBe3DRbND9
	Wlk8EoATqG6GapdIeuBF/DYOs9ktYQO31bwLYMvL8q3ucYqUbtWnezTZF3BmW22xIkKPTfVMBDl
	sYum9v21H91jNMlIrp6N1peFAv7MkCmnV2KKxN49gV+WOz+3N4b5+Cj1x+o6bahbDxzHplDx0OM
	oZxeru7as9j6X0Aw7VNdmn1/E/2DKVfdUg9pBbzHRF+BZt2m8YEI0WOti4LRvEKwYex6XYfTCtl
	AaUZS71tmVFcv1R4nb4oWUkhpgIwGXnglZXIRBKpbcOjvOt0srE7LBMh4UnlhEkYlyJP/0bkH+a
	T7f4Er2SeZ/U/dPaDsWDZXBXMB+g7NHCWaVdBbYKrPh+ybHF9KAXN5l2HdbbFoa4ftgh7EmCZKC
	t6u2GF7H1P8TC9Ke80e+Iu8/b
X-Received: by 2002:a17:907:d86:b0:c50:4b6e:329 with SMTP id a640c23a62f3a-c5096372173mr926082266b.15.1794857810588;
        Mon, 16 Nov 2026 11:36:50 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b60befsm445902866b.58.2026.11.16.11.36.49
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 11:36:49 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so373220166b.1
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 11:36:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGsiK+T6Rjlk2IPRPxUQIAyIsombGAhfiuU/dSxUkftt6dPCz3ZM5FMQV5iRe4dorjf8bBi0iAc0lI=@vger.kernel.org
X-Received: by 2002:a17:907:d86:b0:c50:4b6e:329 with SMTP id
 a640c23a62f3a-c5096372173mr926077766b.15.1794857808907; Mon, 16 Nov 2026
 11:36:48 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025164719.1831477-1-sashal@kernel.org> <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
In-Reply-To: <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Nov 2026 11:36:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
X-Gm-Features: AclHuK9wFvPLbk2hT2Jt-YCf9KvKeXcURMdq1CAih03odFDrPYf2QaCfvYcr5qU
Message-ID: <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Nov 2026 at 10:14, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> Ping?

So honestly, I really don't like it. I don't think *any* of this
should be inside the kernel. I don't think the in-kernel side helps at
all: the comments are too big, nobody will read them, and the whole -
and only - real use of them would be outside validation, not at
run-time.

IOW, I see only downsides to polluting the kernel source code with
comments that aren't useful to humans.

If this was a spec that is maintained in some automated format - not
in C comments in source files that aren't useful as comments anyway
purely inside something like tools/kernel-api/ (or Documentation, or
even an outside repository entirely), together with the scripts to
then validate it, that would be one thing.

But polluting source code with huge comments that aren't for humans is
right out. Particularly when it clearly is a "first step" and the
intent is to make those comments bigger and more extended in the
future.

And I see *no* upside to any /sys/kernel/debug/kapi interface. Nobody
cares, and any excuse to make it dynamic ("We might update the API in
the future") is actually the complete opposite of the whole point of a
stable API and not something I want to make easier or support in any
way what-so-ever.

So all of the in-kernel side to me looks like actively detrimental to
the whole idea.

What I think *can* work is an external spec that is written so that
tools (read: AI) can actually then verify it against kernel sources,
and that can be used to also drive automated testing. But putting any
of it inside the kernel is bad.

                  Linus
