Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109458;
	b=qkVd25JEh57m+DOIcUdezmgeSPiUv/arWGBSApi7l+NN/gk9IahrPIT1Z6RvD5/5/Vj1
	 MDNkA7l6foo0KcTAUwU8dWRi6YYzNdkbquaXgLkqLF9kYfA7OiZEyrRFsRdSDtnRILdd8
	 XGFtchBWQOmZPWxSOXn9/RSPTiVopSU1u9+vUAKQ6KuUdITcqc1pPfYQFHNX61oeq3Aqq
	 dNwfMY1nSuHebJTcxr4JkFr0RMHcd1A+SPGMb35TcY42qA9ZvhKrwGrP7GRL/JIsy2Gyu
	 iXpHzf6hZLEnvjTKQa4w4XUwVW5iss+wH8aj4gI+U0KEFWvfx97r0Yn5inIq+DUorCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109458;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vs32yPthyobk2oEa2KkdNDnwUJjwL8zz25GmqC5+HvQ=;
	b=W787n5yPebroINyDTKUVPfwBiKAb5smiuBBN1ReDqpX9Cq32JnDEvMAHTPZexBO/aw+B
	 FOLamvxZq/IjprVMO2eKc1pjOv/gmzgvoGO/V29e7kj0u5DPZF3RLsPeycb0wjJcyvPWm
	 ZQTJpKl6tM9Az9LwKPnTYiYs8AiGi1+DH7ngyX+1oZqpBDxCT+pLphPQy08aaBX2H0YSu
	 ROAWaO8zCTHcf8d4+0qn8GAggoUNH7BLo4dD8DN6LnfhgHrWzbnM+DR07HwFLttpCHAmQ
	 hP+YH9gDCr91jMyYAzWlXsU3xIQwm3n9GpQimHmUYwPPPUS3/gkk3E4yw4zcOEFuwhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=kcyODoF4;
	arc=none smtp.remote-ip=209.85.219.53
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3239606A325
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 17:30:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3239606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=kcyODoF4
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-92130d3ee15so703056d6.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 09:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795109457; x=1795714257; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vs32yPthyobk2oEa2KkdNDnwUJjwL8zz25GmqC5+HvQ=;
        b=kcyODoF499MEItXJuafpVcnzdrYkl7/sScpUZDNuvzQ8x8TeBmZDqdks69cwQJPENI
         9iFlKy+JKSRnJ43XkhGYbKr6s8nEbIsy4qEBpMjCGf/q7zUHm+eoySF82h8iB9DE2E+6
         x6E285TcglmPmUWPzBeIw5GGsOfgrTK54KwCO0dY+Gad/9rpkfmJp+Fzuv7FM12rO3cW
         oVa7V3SRTkJyyHdCmKYhiZ0iNHkbMSf2mGIbRMegzCViN1JkHDoqRPAMPCRKMsFhAncg
         tqPk2hQGV6zgzsjM3kKOt4MztPrYgP6ISE5NoJeIoBzovYoyXvuYXpAuHCmOYhEhLB8f
         9Xsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795109457; x=1795714257;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vs32yPthyobk2oEa2KkdNDnwUJjwL8zz25GmqC5+HvQ=;
        b=vN7iK+8ZNMo0QTF7lfBlYhD/+xSoPAu4lIWdl+nBIznVWclTTGBaz48XCBm3TkwTUD
         d8rtMYQ+2dnoBSRfUzBl+0RuOTwm3WcYTxXFIQc+jxWFkD1QW8LMgAmAZ37C17aqpWM6
         1cvrX9QtkZmAwGdytJJ5wW2f5Y+tSs9vdbu/PmvVgU7U2HmIXu4er4gtfeKoYkzbaMzf
         Wc7U6WeHf8GsCw9h9w38J+EXucFpt+lijrmJvt3/b/hwFqaNnfUlvs7oXz+A9M1yg3eU
         sY/jWkIovecRbj9ht+kr57m0zsd0rroqqp33Fi6HwCVjH9F1vMGS3S8x3iwFgMFz1vzA
         cvSw==
X-Forwarded-Encrypted: i=1; AL+hErFUjtkunP9flUOif1R/PTvo+PxOfm7xKMFX0CZt9f1uRu/PwTQSignREPceSJZ0cqilO0aXZlWqoV4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/NrQXSCakrZiHT9YN4MFAIx3NkcEPC+a8J9QWWU7Wxnm1oRspT
	6XqlGP1+qE8DxI+ijZlDyKlrWBXix0ZgXJKyhayBnrleuFoMSSLGkHKaaO1PsxXymdQ=
X-Gm-Gg: AZFdTZd82gwrNifGxA16Y6R6AroPu87m3wvm0zwFZY3eHTaExthe5lxlmKdU+lXl1jF
	KvGoV5jZPOypfyshqkHOH5T3nAjo6pxtvOTNqe8bRXL4QSsaYeeOC08GoCtVpUc0sjjtAgFxE2g
	00MJYv7t+X0kuzehulfRlrjRbHUO5u58oYIkohc+3B1UpzCcdqq+BRe/Yp8UYErli9sxKcRxWNM
	GXi/f9rKcfDLx3OrEUYSdsksF4V/bpnh/a5jQiV5Plj8PtYkcGoH2CWl1D7iCv/QwiAcRzXVK+7
	cngTrWg7AGzZjrWjemQHXFYmsUaw91BE/LkJ176afhLhvUPWNGVKya4K3F+5qLjmsRhpS1/niSq
	bQWtEdr2M6to9mMjlUkEGdTBEPGxteRpPi4FfVH7fzs02qrAIJR8Xi/YPnn2mJZyf4ETxDkcQet
	Xn5YmTTRcjHW2GeTxy69Jp+29mszs1G634KBg2CHd9B5xqX3phpTUZJttWJTPOEuXGHRCwLnkp5
	8croGZ2GFBpgNeYOVaSnQDkH8JY+MvTViRxtoHL0UYRUulnhuoj9yWry0buoVKgMWaYw6AtWHTm
	Haso9Z4RfM/W3yzxzf3zyVaJyan1T8z9fs8qHSUeGLQ8Qg==
X-Received: by 2002:a05:6214:3d0f:b0:921:2f16:4714 with SMTP id 6a1803df08f44-921349cdc5cmr6310486d6.7.1795109456756;
        Thu, 19 Nov 2026 09:30:56 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349ec64csm3556376d6.28.2026.11.19.09.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 09:30:56 -0800 (PST)
Date: Thu, 19 Nov 2026 17:30:55 +0000
Message-ID: <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Howells <dhowells@redhat.com>,
 Jan Kara <jack@suse.cz>,
 Serge Hallyn <sergeh@kernel.org>,
 Kees Cook <kees@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 linux-fsdevel@vger.kernel.org,
 linux-api@vger.kernel.org,
 linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
In-Reply-To: <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 9:46 AM Andy Lutomirski <luto@amacapital.net> wrote:
> cells: The dance where I create an anonymous mountns, mount stuff into
> it, and then attach it to the cell is cute.  But I think the userns
> interaction is wrong: you are making me assemble all the mounts in
> *my* userns and then clone the entire tree into a fresh, non-anonymous
> mountns bound to the current userns.  And that clone operation is not
> free and serves no actual practical purpose.

The copy buys us nothing, agreed.  That's just what the mount API gives
me to work with today, it's not something cells wants.  If I could make
an empty mount namespace and fill it by fd I'd use that, the "root" slot
takes a mount namespace fd already.  Extending the API for that makes
sense to me on its own.

The mount namespace staying with the builder's userns is on purpose
though, that's what keeps the cell from mounting anything no matter what
capabilities it was given.  The builder sets the tree up and hands it
over, so the cell only ever has what it was given, and the mount code
isn't something it can attack from the inside.

> cells: I find it *incredibly annoying* that one generally cannot put
> new mounts into an existing container using most existing container
> managers.  I hit this on a surprisingly regular basis.  You seem to be
> baking this into the whole cells design.  Why?

By design.  Allowing changes to a running container is what causes the
problems.  If you need another mount, tear it down and build it again.

> both of you: Can we please make it possible to do the parts of this
> that oughtn't require privilege without privilege?

Agreed, we need to come up with a design for this.

Thanks,

Josef
