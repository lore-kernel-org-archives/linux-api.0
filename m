Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58ED3CFF77;
	Sun, 13 Sep 2026 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789339349; cv=none; b=flOgmztyxbZSb084p8350yPNCSoVUdMQ3uFEGsaVw91LltpQEconEWi4vIBYACgJ2qMgSsp5g1Y1bciSZTRn62kEnSeBX0oLq5sCYpkdOVyTXsJwVf93dCP2ZS24om21YUZM8OnUXNiDROm1o7lkVCvyGg0H4r3GOC3tcYVvwhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789339349; c=relaxed/simple;
	bh=jum5occERbNBbaSZbMoYk6Di3daz9BkThsf8Lmvy8zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsNaPeIMIaVpTcJZfpB5AfGL/r3YiMi/XE/3K6+3ohF3Fafx2u9leOe16KKoQGS6b2Kt9WPrbdkikq7o+zlQADmmvgw8OSkbXGNBoY0rJXR3QaCcfpIIeY2I3zr0JTcn/zxKkgkf5t3UYfRp+WUZuBy4t0XoeSJURb9HSaS0p4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gJr0CD3u; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gJr0CD3u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kJ07gVF7Q6jHByQIBcm4K70Gu0E8H+e9687JL9ra4i8=; b=gJr0CD3u3hRruvr4rq1R6BG8yM
	QtHjW1lU983K8wX1bh8NWzU+kIdu+IMb2WY1APMat6WRRC2DmQk0QleQWVhqaAlPsBNfiyFeqoAm+
	qIb9zV/LFJuC/l/vp5uTHk3HWhVOV3LylGZZcGCNGWJ03lJ1Cj+RGBZt8+LGjgPvvgOxY7YK4W0I7
	/m1DvnHsrbXYAHBJmG6dkOmInIly6YodhhQuLgZaEl5MbWZF3au2P7dsgOkLrCLw2805HLHzkLkGz
	TJjvyI12TYw2MO2bvrGJ6X3whV+NyFmXXWaa67ejHQt9fdBrrwmM6MxVlTyLHNp9EgIEhDGWDuMqK
	064HfxNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5stz-00000007NVn-2q4L;
	Sun, 13 Sep 2026 22:42:23 +0000
Date: Sun, 13 Sep 2026 23:42:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mikko Rantalainen <mikko.rantalainen@peda.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, alx@kernel.org,
	dalias@libc.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <aqcmz5uI7PgN5CT7@casper.infradead.org>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913193815.2862366-1-mikko.rantalainen@peda.net>

On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
> However, currently Linux kernel will return EINTR in some cases for
> close(). There is no good way for caller to recover from this case using
> the original fd. Whatever action was actually interrupted cannot be
> resumed or retried through this fd, because the fd has already been
> consumed. Even worse, EINTR conventionally invites retrying an operation,
> but retrying close() is unsafe: the same file descriptor number may
> already refer to another file opened by another thread by the time
> close() returns EINTR.
> 
> In addition, POSIX.1-2024 requires that if close() reports EINTR, the
> descriptor must remain open. It also explicitly permits an interrupted
> close() to return success after closing the descriptor.

I think any filesystem / device driver / ... which returns -EINTR from
close() is broken.  There is one exception though -- if the signal is
fatal.  It's like read()/write() being killable; if the signal is fatal,
the task dies before it gets to see the errno.  So it doesn't matter.

So that's my preferred solution; track down the bad kernel code that's
doing things in close() that are "interruptible" and convert them to
"killable".  We don't want SIGWINCH or SIGALRM interrupting close();
that's just dumb.
