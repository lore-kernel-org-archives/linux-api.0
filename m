Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141803403E8
	for <linux-api@vger.kernel.org>; Wed, 10 Jun 2026 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781101467; cv=none; b=ajzvjxMdfm+wIjD8VJwSGx/x1eShzswd5p1TZXEyug30BD4XFHdj/YUAaWDPpsa2Q+ZJkMgc4MRRu4yhZxc3yfkiIVqKGDFkC9RObDjecHLXzFpe5FJZijzoiNGfv0i7Gxn44/kjE/beTmr2wUJpHtjjzTSk7u0ThFA2T0v8fqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781101467; c=relaxed/simple;
	bh=BJ9c/ol6w+Ube8nVPNM3mIfu3An8puBsF+RZnr8il0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZvrJqCkiNN2w5TzM58rJu0Z6kdxbIyjfvufE/3nPosVRYSvWw3H07KK76J5OR1gXmUHrJlCTzDbGFy/aEV8YaBi2Nu+1RmrMUfg//9oD+MgWhvLYrSpSH1AulJek24vYNyPxgH4v26qkmJpQX6bqAN8cavRuKGfnkuDDXkFtFLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRT4ewAU; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRT4ewAU"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-91578122305so1080187185a.0
        for <linux-api@vger.kernel.org>; Wed, 10 Jun 2026 07:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1781101463; x=1781706263; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
        b=MRT4ewAUDpTAemoN97FYZj/CuTW9W6Phh04txcJCmE+H7tRrvoF2eIJQQFTbJ5SAwC
         P20WDli8Ujzxf8nsFvgwsYQIRHUrMEjEjsz7dcqPtTU7msFrIfdJwR2ZeohmzwN1dLqs
         pccAJcIBinfhVTUuGaOHilEyUvClxRHaz4+Fc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781101463; x=1781706263;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
        b=g5zEmgJDywg6QNxkG/JuYa8CnhXRrg92J9Ug6KwaP61yQmp4lwrzJ+enu84e7It9Z5
         vMMRHBDEEZNlDw1h9b2ZtDNoE1MUqaYiB9C2citzJ/9bNLhogo6sB7GM9MqVdIOUjWM0
         liqppuEOBY7AkPbRnQW33v+S1o84LlCaYMpM+SAB4Ock2z73I6X5QNI/nJRELqgqE230
         XlebEK75xFB9+PfnqTpe5L9Tjp8111W9E5gXgiIw9JW/vM6rbdHqCQedPbbe/bZX7nVQ
         53Ifsoyh+9bBSNP0QGCdZhgLvtS7wmXj1qTFeWZ/IJb6MJOygMB6lqXVHii8clZmcINd
         MrTA==
X-Forwarded-Encrypted: i=1; AFNElJ/crtw7x5qcumV/eV/pMiDi9sEZPcZrQAkElgYhTWx+uQ8xmDo7QJpyAYInbv21vWSu/MBgj0l5HDs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWzGPuNawYxyOBlVKldxNdv+dRjtziN3AXN5DYcUltkg8ORvxU
	1BXTXOq3cFCQuEFHE0WUodZ4H+NqrxneCnqt3ZU9nn2PgvhLQP/wDEufn1WBndw8/CfKIfIfssn
	MfIOQ6aI=
X-Gm-Gg: Acq92OGE8PjpLtMint2GtegLhHVqnBKVOKpFdx0TT4NABCNvd1Mhoz0l3MLSXpHr00E
	q3N9NzIHzzQot0rNytKN6sJkEaPhDE82fMBAtxSdolfxppi/1DR93gJbGVuc+6hVOah0cojoN61
	6CGKftUSTWBjD977twQESt/Ez7NY07lhoTEuMnjx01vpmour3kfea1QzNH/sjTAPMY51EoAAIa0
	vdCHSXKlaevWZmvfTQ45IyLuVFvkN4K5MYuYwG5BbXsStulcUyr+aWRBIl1JXPxmEpZFA83Dfjl
	1W+tYaudddY70vnErMkN6J25AdNbQiZ5IyKS4ckr2B23zhULLcia2aG51QYhG3OMIHsCfoAk6d9
	LfZ+mvW6Hv51bB5E7K7ZIBMRqkTexzzw8I2XeEkGZC12vXdKPqUBRKOb/VZt7gVsgqHUrpPh5Io
	yS+MwN6+oiEwBqcd41dUjW2OFPdF8OHtHPK2E/d1un0n2ffyISdCLhcs5SBgO5NQ31NKsFtk83G
	rx+9LyZeo5NXY0=
X-Received: by 2002:a05:620a:454b:b0:914:bd27:2d1 with SMTP id af79cd13be357-915a9c32794mr3898135085a.11.1781101460713;
        Wed, 10 Jun 2026 07:24:20 -0700 (PDT)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com. [209.85.160.181])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a22dbbesm2405869685a.13.2026.06.10.07.24.19
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 07:24:20 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51764768c36so88508591cf.0
        for <linux-api@vger.kernel.org>; Wed, 10 Jun 2026 07:24:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8LfxfufgCmUNVdny7hJJHS/+W7prABVfAJI743RQgoeg8q2lbTpx0/NeLtgs6xgax+fZbVLE6VzRU=@vger.kernel.org
X-Received: by 2002:a17:903:244e:b0:2c0:ab92:584c with SMTP id
 d9443c01a7336-2c1e8209b98mr287326215ad.25.1781101086478; Wed, 10 Jun 2026
 07:18:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
 <aijyuX14ahOf53zM@gondor.apana.org.au>
In-Reply-To: <aijyuX14ahOf53zM@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jun 2026 07:17:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeLy2n9H82_THob=wzOEfsQT_yP05ZH9qY7NTWgj2R_A@mail.gmail.com>
X-Gm-Features: AVVi8Cf89LEbA8IWp6kUXfdfvHtLXSvqRDQpEPExTR6LsZaq3LaagKRbHX8i3Yg
Message-ID: <CAHk-=wjeLy2n9H82_THob=wzOEfsQT_yP05ZH9qY7NTWgj2R_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: metze@samba.org, luto@amacapital.net, safinaskar@gmail.com, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Jun 2026 at 22:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> How about using write access as the gate to zero copy?

Well, it's too late now - no sane user would open files for writing
just to read from them.

And if the file isn't opened for writing originally, it won't show up
in the fd. So we'd have to do some after-the-fact "is this writable
using the credentials we had at open time" thing.

Which we do for some /proc stuff etc, but it's disgusting, and it
isn't how any of this should work.

Plus honestly, in any *good* setup, the normal case really shouldn't
be that the source is writable anyway. In benchmarks, sure. But in
real life? Hell no.

If you're doing web serving of static content, your web server simply
should not have write access to what it is serving. If it does, your
web server setup is simply hot garbage and probably riddled with
security issues anyway, because you clearly spent absolutely zero time
on any kind of "minimal privileges" model.

(I'm not saying that splice would be primarily for web serving or that
serving static pages like that is an interesting load - I'm using it
purely as an example of why saying that writable files should get
better treatment is crazy: it's not how *any* of this should work at
any level at all).

So no. We should not treat writable files as some kind of preferred
model for performance. We should discourage that kind of behavior, not
encourage it.

                  Linus
