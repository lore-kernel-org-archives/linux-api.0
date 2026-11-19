Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795128624;
	b=Ar87N96tA12+5G8Oba3iOtK7czhGh2LVkmEzOqQ2en8k9+gHtxBFgQpi61eGHeudpGm5
	 xwGAC7j6vG8Hk5si9CiF6xlBUVD4km5H0yL8kfTy73XwDScoxhCJq1AtA1vM+SmsGzCRG
	 YA6yfZR2mWT6zH/NJqRvdrzclLmLTwk/9ervYl+YCVKlX2NJlDSkpQFESUMRcKzUO6iqx
	 5Myg4FmdniUGYPtUNSrz7Im2w2p1lVfzN/tMSaCRR68dDyN2h4kBD0uMd0tdkR8i52j0L
	 6Eg3rYDSoA/DP/Hbnzswi00HbcH3LyVsxYf734bbVynL9n+oBZteWQi2GiXLnRIZryw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=e5/dl7hyTqZEbaIFwuAjfKmRpl1SUl3FSpNrpJ9d20Q=;
	b=Mdts1EJG22shWxjSZpW5cZ44hx3vqRFCcLQqzgnFUqIqtSzpfPg4PN6y/pWFYTNDv83g
	 cM2mfIv/qJJLzJ9f8hbwHrba4NkRixeQt75GHgoRPns4bD8/UzqEc970BxJok21VHejbu
	 cPPeUdtwQAr5xAAJ3L8L+yBxUGilQmrQtho4IDt/11biL/Iz8V/6VS1yH6uS+bx0OWYwu
	 90X19GoMSQ3UZdlfRf+0TCzz4RB+WTv8X2kVq6wbLTOOc0Ah2EXSLml+4GrxuuULQ0Py+
	 uGM5T1KhIMp7vRB9c/XI1Ki4BoC8LTzJfYt/5pmu5hlOvYvihbocM/AbpwFbpYV5T+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CnCiCFWV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.47
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB3B606A326
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 22:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCB3B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CnCiCFWV
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5bcdae234ecso230373e87.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 14:50:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795128622; cv=none;
        d=google.com; s=arc-20260327;
        b=XIxMBfH+taKCh96pYbUP9CAbTjFBZZKxYowDpziwImrj0kQdayxp0n0ICHGBCsrM2A
         a2Y7hVb1pNZZmT987TU4u59FsxJe+k97m5sjZZazZoUYH65OFwkIQaiAwK4Eu3uX67Cd
         VMQJb80ORy0X1mFGPtG9nAOyMptH4aOOSLfUxJeyDe+6g2ZuKLzp0FcAkCxeSTvfn0zB
         QPDjo0SJQDm/M1Tne9PfGDTMIPDBrDo/j/YXzxf5HBAA2urNh/yP1MDnJ0mMQHJviEOR
         6ZZDUDQOtsAsvFn4Gwr4VWC9nY/E/+t4pPcgNKNHXLiMp38WgOPnKwMKQi1HDuxPLN2R
         uMxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e5/dl7hyTqZEbaIFwuAjfKmRpl1SUl3FSpNrpJ9d20Q=;
        fh=axlIo1aV4y8JG6VeTNbBU6WVJGnrXD3WP8hUSSlgTH8=;
        b=KXe3k7OOazDUu342J4lb/9ddDfZeLm4/MC+QOyiUjlxrgGCRfiruZjNlxxsVx4+Kij
         LRC5sk+9+doNn8fFjjYsgzHy+HJmrWoPQng+KSG8vvwacn3/mTE+cQ/QAlxEcXJGo49b
         XrpTRaM4Rd9dHLrF7qMDKplPF0J7HhX2FEH2WVwR/Kg1uOosLxKc/PFKUzfDVMGpNQjR
         9Esb5TIk7lDPLdL0LAOOwPSTGWGk0SSkUegaOCudO8tg3s+/3F4yULW7Z+BYTEgU64N3
         b5AZlQglb1XCU3SfI6ix9jfXs8aAmTc7NH76dnw3qAIjQ4gm0vgshJHUPrkV557TvxQT
         samA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795128622; x=1795733422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e5/dl7hyTqZEbaIFwuAjfKmRpl1SUl3FSpNrpJ9d20Q=;
        b=CnCiCFWVdqrTol4CcpbrSlDlLA3fYAIDBwcdFh6d/8N9Al+d37Kz1pAOOAx90UY2GH
         RwYwOhoV6CXoXSA7CUTRwKZNDbbugHPiviw1ZrlJjOT9eUFGc0CH+hNOe4LM76Uo99WI
         P6DX/zlh2h7WDUsD45YZT8C+yOypQZE14pxWvAPwxvGPdkR0rsUQVWvZNIkOeDQqf1cS
         H/e2Yf2FTuVfpTJ9Pqe8/BMESdOeaRtqVNs8ZsQxV9qkxEPSGBEQoNPDU9l00ioRVU1Q
         yxzIE0LYkdOSEIRca+sVlkRgMIY4FpacTm8jEYXcDJ3wMRhmrd7u6crYQQV5v980MITl
         EpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795128622; x=1795733422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e5/dl7hyTqZEbaIFwuAjfKmRpl1SUl3FSpNrpJ9d20Q=;
        b=ssPWb9VSrENPjtnK9W/kwSgpUXLO6DGbB0CrCuC0+0c4hBXM0jLR0yjxOufVvvBQ3R
         nOkCz5CGMvQsxAUrKpZxrgOE0cvbBk3V3MGwn5rV52ewGqgAj5QUpktvbhagR6Viqw4z
         yFHKn99gY8HKZoGodeQQgjbLSAGp/kU12cvMmMLFltGczVZEiXPcF8MkcSzJ7YnLkbOV
         wOlsREGzQ2wz3wIinsinvKtQOz8zMJbWUbui+gFbAW4fTSScZ8NI6Az0SGv//Rdn/pKI
         uhfPQskFrO34zoW7IZ/AQExXJF52tbeSs3RcWSPeSrfASE85QZCCLwQuz+pAiWMEqRDv
         ER1g==
X-Forwarded-Encrypted: i=1; AL+hErFQcPcBsMB4ABNhXVWZGAfYtSkJxLuaZxvbElOtPR5VoDdK0GZcS5iVVkfE0Xo+3u8Kf6hnVlPBzdM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9QcH6mhqh5aQ2KddPHedESb7NeypI79aYYf/E+1h8Ui/NXO1ca
	wl6EAc6iwmMsMN9kHX4xKn+W9hoMSY58dU0ESniLS1GzbXo9YPLegUZ/28fjYH4zc3uIx0TTtgh
	jNYBGk0GH5CuHHyeuAhZ9yaINncLlJ2JaqLqBe45M
X-Gm-Gg: AYBFou2jnxbcBzD6njGd8v6QPk4jCOkh0rMpMbFavFiUJ35d5DMVEePQTwUZUq3LPFQ
	p0+kLdd0fs7TU0SvyimOAGifkVllj5TuSt4g86rg92ajKzm1I2Gf9pqW8Fd0EnEgD0cJ2B70/hX
	X3GwzCnKRQLWCfu0i/2g4O1zlf1JksFfDW8u0IWiRm+IRSLBEwGwLimzjov6icP3oSg0R0x1gSG
	e8ykxSQm+0PcRUSPhOQkPBR7dW6FmNpDPV758qlGqt7R+Ztmsoo1ychHDQPsbLlVylVropPUFzF
	/fN8ewUL5qZ5AwSobPB/WvxSTfgXV5pRPtz4tU1+rvvsDioSQ5RP1r5ihR8deeaPSj7eSoI7Izz
	+G2tih2BdbKfJjmIcUCdGeqoMyBjEq5vd5w==
X-Received: by 2002:a05:6512:3e13:b0:5c1:4793:bf31 with SMTP id
 2adb3069b0e04-5c1bc8495damr319148e87.58.1795128621989; Thu, 19 Nov 2026
 14:50:21 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117231352.3816603-1-jarkko@kernel.org> <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org> <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com> <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
In-Reply-To: <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 19 Nov 2026 14:50:09 -0800
X-Gm-Features: Aa3M54r1P8ngsOHB8Vhj7FvubBRj99w4Go1f1fZhV4inbefIYqqcV1gzmh9n2Fw
Message-ID: <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, 
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 9:30=E2=80=AFAM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> On Wed, Nov 18, 2026 at 9:46 AM Andy Lutomirski <luto@amacapital.net> wro=
te:
> > cells: The dance where I create an anonymous mountns, mount stuff into
> > it, and then attach it to the cell is cute.  But I think the userns
> > interaction is wrong: you are making me assemble all the mounts in
> > *my* userns and then clone the entire tree into a fresh, non-anonymous
> > mountns bound to the current userns.  And that clone operation is not
> > free and serves no actual practical purpose.
>
> The copy buys us nothing, agreed.  That's just what the mount API gives
> me to work with today, it's not something cells wants.  If I could make
> an empty mount namespace and fill it by fd I'd use that, the "root" slot
> takes a mount namespace fd already.  Extending the API for that makes
> sense to me on its own.
>
> The mount namespace staying with the builder's userns is on purpose
> though, that's what keeps the cell from mounting anything no matter what
> capabilities it was given.  The builder sets the tree up and hands it
> over, so the cell only ever has what it was given, and the mount code
> isn't something it can attack from the inside.

I don't get it.

Using the builder's user namespace means that the contained processes
can't be ns_capable on mntns->userns.  But this solves very few
problems unless you also deny the contained processes the ability to
unshare userns and make a new mountns, and if you can do that, surely
you can also deny the ability to modify the mount namespace.

As just one example, a mount namespace could have a little flag to say
that it's *in* one userns but its owner is a different userns.

>
> > cells: I find it *incredibly annoying* that one generally cannot put
> > new mounts into an existing container using most existing container
> > managers.  I hit this on a surprisingly regular basis.  You seem to be
> > baking this into the whole cells design.  Why?
>
> By design.  Allowing changes to a running container is what causes the
> problems.  If you need another mount, tear it down and build it again.

What problems?

I get that allowing a running container to modify *its own* mount tree
(or any other mount tree) is a meaningful attack surface.

But the whole ongoing discussion about cap_userns gives a clean way to
deny an entire container the ability to modify mounts (although we may
need to augment it to control mounts if that's a specific concern,
since CAP_SYS_ADMIN is a bit overloaded to say the least).  And surely
cells can find a clean way to lock down the container.

--Andy


--=20
Andy Lutomirski
AMA Capital Management, LLC
