Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847388;
	b=T464fzAeILX9XPwniNtYYLdSygTOyUj4f21DCURyDO1IiaiARYfqaoZNW7/Bnmt5oUOw
	 3md/W2qGHrVK7yAVJRQDZrYlGqGEsXAIJi5CGzGRlZNVUxDeBNhoClkUvxpaN9ipKkMLz
	 kRFL/E+IvHJjRxRmVWKWXKQyiwlbNSG0iPpXIewjiP7GuNO8/ix0o4ILx2Q0n70o7F21w
	 ccgxak+hJV51bxv84FGmM/DTydJevnIwC2rkO2QmQCzeCVjJ5yMQDKDbLsSiTa59vLN5B
	 /g1EZC8wPLtAav8OxPaLMmrRtRi4kmliKSCuceY3Zy6F3HwENTzbkbb3F3tr2UG70/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847388;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=mDfU+sS9f1CGfQAVDBxxcGKeVZ+qJ/3ua+e3uJH5HXA=;
	b=xEXBnBGX20vfJIxS1Yi3rtt6t+i45DeB7hSeC+1TxCZIGA8mPftqceka8FnMmf+dzxJ/
	 lFUvQyl63Cg1UU0K0dehDcYB/p/8PMh5UsxfmYXI+XNEbTWq7VJqX3m+jXzOz4AfDiYxq
	 OkjL038IdQYzVjs+vFdLK9cGs1asgU3GuGkECFrC/sfmO2drCQ2Wo+2DFNVp1/335W0P0
	 Xl8EYN2qDInIkHCh/tuS3okjWN5Zz0uBB7j1QaQ48u5443T+wUVIe74uMahasMesuF0B3
	 4Rca+cwiX8S0EWn+xcXLcopobVRw7KXxVhoWc3TbihkPrhDLgIOegVC73jG9WdIAhIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IHD+g70C;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727C9606A334
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 16:43:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 727C9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IHD+g70C
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c508bafaddfso408482166b.1
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 08:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794847387; x=1795452187; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mDfU+sS9f1CGfQAVDBxxcGKeVZ+qJ/3ua+e3uJH5HXA=;
        b=IHD+g70CMjjDb+lNyaZS7FPrR9hKiBjI6am80yEPTtTB9qWtugwit+DSXHqY66L98K
         8EtcQ72+xPDDvax/dKjPailSRAMm2iFoAICCBJiaKhmJXvLESaGHskyifSodaT1tRs2k
         FnHt0a2P09ARVfqqIUhh4npU9nurbR746tcMFt5h0VvYTWxJ99h7V4nt5AdC5Xn+RuNw
         R+UPfCjsMpCI0kZGUr8m/0061Cxdd4HI0FJsop35cbdBWrApwuRCUgB8AqRfgWVySydR
         5NYVgGLoJ1FeSnqZ87k51s8BnWjIU7UBqdkx4H+pPBId62cZa0wxGpKqydkewL7P/Ubz
         LItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794847387; x=1795452187;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mDfU+sS9f1CGfQAVDBxxcGKeVZ+qJ/3ua+e3uJH5HXA=;
        b=nU7b5pp5K5qvRvSuarc1VTOe9y1gZMKa0z9kNbQkm0Ig79Nk6SnNbVNOVe5EroX5bm
         4ZIH5lTy8n5xCW+Y50ttj4tG6fMLq0XXca523mY2ybCQYuK7POPOdhrYFXLh0KVA3HKV
         FUuIL5l1/BvkI2Fzq+W/8W2fRlPKp3zuJ5BQYs7ESL9FuGiiMZbAL9bac/xHeBQJYeWe
         a2aN1bXxPm0rcATZbRz65IggRZqL+VA0C5tS0Ku7H6Ofn/VX2FXKHzp0r81ibH6ckK7y
         6qR0B3ekimmg83wLO37kXQ9raAQgqL1vphoihb5dZ9KRXMaGxyuEtO3uEKJ2bipWrOPN
         S0iw==
X-Forwarded-Encrypted: i=1; AL+hErHbTaJSI0y25ApG29iXzlQ5MIEqYZlR5Wy+PrN2YScjByuMP3lsPAJLDQIc2023CBVBtph5cdAUJxc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9PHBxvg2KBHIcznE4ZAVkfqODxhVLUUT/7xDnuvNC/hqWg7Dft
	bT2o2r8p5L2VgucPIVVW7+oJdlucrwMLxRlODolfDhR7skO3qNqO4xyZFyUWlBClqGqUu/UPAw=
	=
X-Received: from ejja21.prod.google.com ([2002:a17:906:3e95:b0:c3e:edc5:36b1])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6d08:b0:c34:e9fe:82ed
 with SMTP id a640c23a62f3a-c50963d803amr901765866b.28.1794847386433; Mon, 16
 Nov 2026 08:43:06 -0800 (PST)
Date: Mon, 16 Nov 2026 16:43:05 +0000
In-Reply-To: <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com> <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner> <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com> <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
Message-ID: <avsymRBSulVZfouF@google.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, Nov 11, 2026 at 04:20:02PM +0100, Christian Brauner wrote:
> Just a note on the essay I cut off. I really object to any arguments
> that amount to "it's too much work" propped up by a few thin arguments
> sprinkled in such as rtnetlink.
> 
> I also reject any arguments that amount to underscoping and overscoping
> of the new capability. The scope is clear: empty netns with brought up
> loop device.

Understood, thanks. I'll split the loopback work out into its own
standalone series and handle it separately, keeping the scope strictly
defined as you described.

> But again, I'm more focussed on cells so here's what I find acceptable:
[snip]
> * a new CapUns: line in /proc/<pid>/status
> * new audit mask in AUDIT_CAPSET record

Quick question on AUDIT_CAPSET: today it's only emitted on capset() and
only logs capability sets that capset() can modify (explicitly or
implicitly like cap_ambient). It does not include cap_bset which is
modified via prctl(). Since capset() never modifies cap_userns either,
does it make sense to treat it like cap_bset and leave it out of
AUDIT_CAPSET, relying on prctl auditing instead?

[snip]
> That gets rid of the sysctl, the clone3() field and the clone flags,
> doesn't need a new capability bit, and nothing changes for anyone who
> doesn't opt in, I think.
> 
> And that loopback thing should be its own series. Not as an nsfs ioctl
> though. All nsfs ioctls only report namespace state and I'd like to keep
> it that way.
> 
> Pipe this through an LLM and make sure it makes sense and covers all
> holes.
> 
> Thoughts?

Thanks for the feedback and the detailed proposal. It looks good to me
and nicely ties everything together. I'll prepare a V2 for review based
on this hybrid design.
