Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A8B370D5C;
	Wed, 10 Jun 2026 05:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068489; cv=none; b=adYYHTMsczFcFNrsN1LriVMVCZPkFLe/BPxlnnDPLIwP55XzOc5aJ2jb2boHPflDbY1xz7Hz3iEEwwVmqyQJ8+OCYFBcH5mnuLu+O3RHPHFlgBwqytpduKmDjrThkoHk/mWugP+kzWREA8WIGkkELuDXRZee+FKU/6COhHvodjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068489; c=relaxed/simple;
	bh=T7RfpQAYTtKgwwSsHkIlPQZB/3d8rHcE9475/UH+e6k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ZjKevqIMcgMhx3mNg6YD3+ayiRYyvu1HLpJyBvWIrXhquTcCEp1FKIhdVSvrFqjBd4/g4PNXAL0LdiDKOxzne+JEQqlGn+HNN551GXJgvItIZDRQ/O5Prc8pUJSjCfM7GkM1ZlmVhBsFeQOKNm/ICvfjTplXR3CX+QqGZNioiZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SRtexRuX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SRtexRuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=CAQW/woRlD6nMS40SYfYEy04qnRENam7hotbzTsoZO8=; b=SRtexRuXBTK493UySnuP5ALAyo
	Ufy0HINvTDsaMlNa2KbGBrDy3M2mD7oyb3K1uRfPZMycB8X6zumdthneP7PwKuWnxd5zs6rionpGo
	CqVwZyAAgtMS180w2Sww0de4fpAm3YKHdPZPh4Q5m8+BlUowPqXDnOu/OvmIeJeySkzUlQVQ80poU
	UfmB5QYu7L0pjXyJBBSf14lin4VNjPcw7OMXBPS9dJK5aJW8WVlAgKf4YfupIYwp5UaqDfieNMppl
	d2qkzQ1y1nhCAHFMEtboyBji+UBQaYqHGcvs3No1FfiumRPjop7cisWUioyEz0Za2KLJZliLTqXRb
	zHrKaoZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXBGr-00000004AWe-2FLp;
	Wed, 10 Jun 2026 13:14:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2026 13:14:33 +0800
Date: Wed, 10 Jun 2026 13:14:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: metze@samba.org, luto@amacapital.net, safinaskar@gmail.com,
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
	david@kernel.org, dhowells@redhat.com, hch@infradead.org,
	jack@suse.cz, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aijyuX14ahOf53zM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Nope. If your web server opens files with write access, I'd be
> extremely surprised.
> 
> And if you don't have write access, and you're sending out data from
> files you opened just for reading - the onle sane case - you hit all
> the existing problems with "I can certainly look up pages, but I damn
> well shouldn't pass those pages to the networking code without copying
> them".

How about using write access as the gate to zero copy?

IOW allow zero-copy if you already hold write access, otherwise
perform a copy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
