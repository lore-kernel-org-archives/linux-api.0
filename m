Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD395343D85;
	Wed, 10 Jun 2026 05:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068180; cv=none; b=eoNHl19jk65qig/o+tVHS+TLLNAj3jGe6g01akfR3zrBAhVXaykPZqycSov6eM4esqiQEVLT6Qu6bJ1wOw6/GjdFDg79tihOsQvWjCWUmHqr8sbNhrYmOLxQNo7bWkG7tRSQWsKAgClagcwQjTB/pc6eZD4Mf/Y+GDpQ1ocPmfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068180; c=relaxed/simple;
	bh=U9uKUooBx4sOnx2QuXms6koNlM4zfz1WGMojOv6/Qcs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=IKxy9v1zS8VPGcogvEgkROvcWkyP4OzS9M/yYv60ou966HmOvpKOEmME3nNWxN5AWm3LXlGeh8T8cIDh89K16KzZ4D37fZAnfy/kep+Ut/5PaYSiYwubQykBmvMcr5FOImx6n9q0YXxKZCxiRQNEfA01EFZmP4VLPTWaJ2ru/6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hzp5pVhD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hzp5pVhD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=RHcfWFsJiVmAbunXLJMpnVW4BYFuN/HfVIVR+xGLhEI=; b=hzp5pVhDHzkGjEcskk8K5YTF4w
	THr3gJHBdtRQFFgqjsAsoO6fdixFyGmx122vU0xpz3axRJBjX349/KHDmcO0t8sH4xw+Nn0lt/jY2
	SCXUJZfn5c4x28vA9gBWC5UStdt2+Xc6Yb2TjcMFlrA/5I6FMTEWn8xqpZJhbkdDPRxN3o2uieafk
	4J+vNNegmU5IXK2JiB6U1o0OAAZk3SKxDW0MlWQqStNrM2RwBxeKqXqhzj2P+8ZrXakgBxE+jXi+6
	pKl3Mfd5HH7xMDICRjPQ+ZIGawzxVsCyCGtqfxXuC327udHGQrdV2ws+61CZGoJ8rbu5CP75oRNoR
	ypNc0+Gg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXBBn-00000004AT4-37fd;
	Wed, 10 Jun 2026 13:09:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2026 13:09:19 +0800
Date: Wed, 10 Jun 2026 13:09:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: luto@amacapital.net, safinaskar@gmail.com, akpm@linux-foundation.org,
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org,
	dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
	viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aijxfxXrWLCVqV6-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Because I think splice() is a *cool* feature. It was always *clever*.
> I just don't think it's worth the pain it has cause.
> 
> And it's been around for a long long time, and after more than two
> decades it's still most definitely not _widely_ used.

A couple of years ago I used tee(2) in dash(1) so that we could
avoid reading the input line byte-by-byte which is what every other
shell does in order to pass the rest of stdin to the executed
command.

https://git.kernel.org/pub/scm/utils/dash/dash.git/commit/?id=44b15ea09a9ee5872cf477e4ffc6b42ef37d1e46

It's definitely niche but made a huge performance difference to
this rather common scenario:

echo 'command
...
rest of stdin' | sh

I didn't even know tee(2) prior to this, even though it was added
way back.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
