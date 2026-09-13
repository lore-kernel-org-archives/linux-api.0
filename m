Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [104.156.224.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E31A37E5E9
	for <linux-api@vger.kernel.org>; Sun, 13 Sep 2026 21:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.156.224.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789333738; cv=none; b=BOYeFtoqclbQP3P6cKj8f+VzeuI0ukqFOuSjO37Rmmza7TOhoGl7iqJKIg0ciGKlyOW/pCdB0YhBZ/itjrZnejzuGDoF+EhPVq0Tek0gHcLhsh3yghD4GJRUHCKhSPRDiEfzof/7vEU6hea4EJZeNkyScIyj4RNHIQ+6P8FGt2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789333738; c=relaxed/simple;
	bh=VDF7+IRoUFHLhJBkL2NWrpn0d6stf7JY0L3jAz/idOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOk9XnHUWAkhKjnl5EYjDXyDEh2AyVzee5mQQgSBDOnXvefa2IyTT+tuC8dp6dD/aKRC8xNrUkH2tI7QgJIpCoLkWKSm3S1sWfyEezgL09w2bGLcH29LAcXIQAHRCoVjEfd2/H2rxwx6IxWodrvLPJ7irYgRDkZ6aMq/ZacpCbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=libc.org; spf=pass smtp.mailfrom=aerifal.cx; arc=none smtp.client-ip=104.156.224.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=libc.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aerifal.cx
Date: Sun, 13 Sep 2026 16:53:58 -0400
From: Rich Felker <dalias@libc.org>
To: Mikko Rantalainen <mikko.rantalainen@peda.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, alx@kernel.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <20260913205358.GX25906@brightrain.aerifal.cx>
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
User-Agent: Mutt/1.9.5 (2018-04-13)

On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
> This is an RFC because it deliberately changes a long-established raw
> syscall ABI. Jan Kara raised userspace-regression concerns when this was
> discussed in 2025:
> 
>     https://lore.kernel.org/linux-fsdevel/ddqmhjc2rpzk2jjvunbt3l3eukcn4xzkocqzdg3j4msihdhzko@fizekvxndg2d/
> 
> while musl and Android bionic already normalize this result to success
> in libc.
> 
> The Linux implementation of close() will always close the file descriptor
> given as argument, except for the invalid file descriptor which will
> return -EBADF.
> 
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
> 
> This patch is about implementing the second option to be compatible with
> both POSIX.1-2024 and real-world applications.
> 
> Since close() on Linux first relinquishes the file descriptor and only
> then performs ->flush() work, interruption of that later work cannot be
> recovered through the original fd. No matter how important that
> close-time work was, ownership of the fd has already been irrevocably
> relinquished.
> 
> For regular files, applications requiring durability already need an
> explicit synchronization operation such as fsync() or fdatasync() before
> relinquishing the fd. This proposal does not suppress meaningful
> delayed-I/O errors such as EIO, ENOSPC, or EDQUOT; it only changes
> interruption results whose conventional recovery action (retrying the
> operation) is unsafe for close().
> 
> Historical discussions about this subject:
> 
> - https://inbox.sourceware.org/libc-alpha/efaffc5a404cf104f225c26dbc96e0001cede8f9.1747399542.git.alx@kernel.org/T/
> 
> - https://sourceware.org/pipermail/libc-alpha/2025-May/166675.html
> 
> - https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2205.3/06731.html
> 
> - https://lwn.net/Articles/576478/
> 
> - https://yarchive.net/comp/linux/must_check.html
> 
> - https://sourceware.org/pipermail/libc-alpha/2025-May/166907.html
> 
> - https://sourceware.org/pipermail/libc-alpha/2025-May/166722.html
> 
> 
> POSIX.1-2024 also allows EINPROGRESS after the descriptor has been closed.
> I considered using that result, but it appears less useful than success
> for Linux. It would preserve diagnostic information about interrupted
> close-time work, but there is no operation the caller can perform on the
> original fd to resume or complete that work. It would therefore turn an
> irrevocably completed ownership transfer into an apparent failure without
> providing a recovery path. Returning success avoids that ambiguity and
> still leaves genuinely useful delayed-I/O errors such as EIO, ENOSPC, and
> EDQUOT untouched.
> 
> This also matches the direction taken by musl, which initially used
> EINPROGRESS for this case and later changed to success because existing
> applications were prone to interpret EINPROGRESS as a failure and could
> incorrectly infer that the fd was still open.
> 
> Automatically replacing EINTR with success does change the *observable*
> raw syscall ABI for applications that distinguish EINTR from successful
> close(). For applications that already treat the descriptor as consumed,
> this changes control flow to the normal successful-close path. I would be
> particularly interested in concrete examples where distinguishing EINTR
> provides useful recovery semantics, given that the original fd has
> already been consumed and cannot be used to resume the interrupted
> close-time work.
> 
> Mikko Rantalainen (1):
>   fs: don't return EINTR from close()
> 
>  fs/open.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> -- 
> 2.43.0

Hi! I'm one of the first people who pressed this issue while tracking
down the POSIX model for how side effects are supposed to work with
respect to EINTR and how that relates to thread cancellation, and how
glibc was getting all this stuff wrong, back around 2011-2012.

I don't think there is serious concern about userspace regressions
making this change. It would not be changing the meaning of any
existing result code or adding a new error condition applications need
to be aware of (like the EINPROGRESS mess).

But I'm also not sure how helpful the change would be. It's already
possible to patch this up in userspace, and as you noted, we already
do that in musl and so does Bionic. So the main practical effect of
this change would be just forcing the right behavior on glibc systems
even when glibc doesn't want to fix it. Maybe that's a good idea? I'm
not sure. I think it would be best to have everyone on the same page
that this should be fixed, with both glibc fixing it so it's right on
old-kernel/new-glibc, and the kernel fixing it so it's right on
new-kernel/old-glibc. That would also avoid hard feelings from a
unilateral action perceived as dictatorial.

Rich
