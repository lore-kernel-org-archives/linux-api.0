Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [104.156.224.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2939230C160
	for <linux-api@vger.kernel.org>; Sun, 13 Sep 2026 23:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.156.224.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789343499; cv=none; b=YXahb96xJGLpJVpmQr7+QbYifO7IDv4kllvntP7/2bK416Q8XPlOUuEy0nrkAf+g4hixHZLIkQY9tlSk96orOB0Q4vb6qVuDu6/WTaK63N9R7dWZ+4LjYZKi32uEiJy8MRtKTpzdtaG6bkR3phKR6jQZKpanM1TRmPucO9DMPAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789343499; c=relaxed/simple;
	bh=cb4h6jxvv8u95Ky7/LsVRsSqujSylbeIS1PXLc+HefY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhqzoHDFVpwRyfS3z0y2/emmW5ucn1E9l7asY0mORu1RKDRU+nlsXy0ztILZx4m1xIfzgaS+y1ee+A1q0HIWd61TVYyHkejjIOt7WnNpAahdYNZI8A6r4FDB3GP3HqS4OgR/dm7F2sNb5dCOUm5Eek/SmcKAlWpNH1Q5K2pOR4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=libc.org; spf=pass smtp.mailfrom=aerifal.cx; arc=none smtp.client-ip=104.156.224.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=libc.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aerifal.cx
Date: Sun, 13 Sep 2026 19:51:45 -0400
From: Rich Felker <dalias@libc.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Mikko Rantalainen <mikko.rantalainen@peda.net>,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, alx@kernel.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <20260913235145.GY25906@brightrain.aerifal.cx>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqcmz5uI7PgN5CT7@casper.infradead.org>
User-Agent: Mutt/1.9.5 (2018-04-13)

On Sun, Sep 13, 2026 at 11:42:23PM +0100, Matthew Wilcox wrote:
> On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
> > However, currently Linux kernel will return EINTR in some cases for
> > close(). There is no good way for caller to recover from this case using
> > the original fd. Whatever action was actually interrupted cannot be
> > resumed or retried through this fd, because the fd has already been
> > consumed. Even worse, EINTR conventionally invites retrying an operation,
> > but retrying close() is unsafe: the same file descriptor number may
> > already refer to another file opened by another thread by the time
> > close() returns EINTR.
> > 
> > In addition, POSIX.1-2024 requires that if close() reports EINTR, the
> > descriptor must remain open. It also explicitly permits an interrupted
> > close() to return success after closing the descriptor.
> 
> I think any filesystem / device driver / ... which returns -EINTR from
> close() is broken.  There is one exception though -- if the signal is
> fatal.  It's like read()/write() being killable; if the signal is fatal,
> the task dies before it gets to see the errno.  So it doesn't matter.
> 
> So that's my preferred solution; track down the bad kernel code that's
> doing things in close() that are "interruptible" and convert them to
> "killable".

The traditional things that admit EINTR in close are bad NFS
implementations (which intentionally use interruptible instead of
killable because network flaky) and tape drives (which at least
historically performed rewinding as part of the close operation).

> We don't want SIGWINCH or SIGALRM interrupting close();
> that's just dumb.

You don't want a slow close blocking delivery of SIGALRM either.
Freezing the process during a long close is not the answer. The answer
is just getting rid of long close and having it behave properly as a
resource-handle-free-only operation and return immediately. But that's
a more invasive change than just replacing -EINTR with 0 if/when it
gets interrupted.

Rich
