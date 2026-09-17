Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [104.156.224.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6B516161
	for <linux-api@vger.kernel.org>; Thu, 17 Sep 2026 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.156.224.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667324; cv=none; b=o69E5vrZ5R1TxUaMwq4z2h1Lgm0fNkJh4u1o3giMvhNptOEW5k683zTuV9GIF+0dCvwUFAVym6vsYFCFIPfIGt2qkcEIqkry/8Hv0IYpMjgztH3iWckaXpoSAMo0W7kt9xXBfiiyk/+c/up+AZEqcsW6H5p7dNyaQ6YeNY+uffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667324; c=relaxed/simple;
	bh=lthXXfYekhZmBHsCtT/HT6nQFwm+egeS1LhDy+lkfTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDoafehl8o3yyPauOflMxfqA7gSKw3aKJKbjyh4jYBwBkyNKyv5uhwAqgbSyskEhqi+qGxVLVprNSOEqEYmYDbmfgUehmXuF49giEKdPVvcWa4yJQtJdUr+rmPrqYMAUuOgmLineUzF8GS69w3LzM8YVur3QQ/2OMRoNkUizoc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=libc.org; spf=pass smtp.mailfrom=aerifal.cx; arc=none smtp.client-ip=104.156.224.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=libc.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aerifal.cx
Date: Thu, 17 Sep 2026 13:48:48 -0400
From: Rich Felker <dalias@libc.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mikko Rantalainen <mikko.rantalainen@peda.net>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	alx@kernel.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <20260917174848.GA25906@brightrain.aerifal.cx>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
 <20260913235145.GY25906@brightrain.aerifal.cx>
 <eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net>
 <CALCETrUgLj4Dz0s6PMofViJwausRWCvNvJphxWHUeWCCaRBtQg@mail.gmail.com>
 <f61886ed-3026-4db7-ae22-b882264141bd@peda.net>
 <CALCETrVnE2unnjHokG=bGLEXAeC0U8QRx_wb8fQDh-Fe5O6PBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVnE2unnjHokG=bGLEXAeC0U8QRx_wb8fQDh-Fe5O6PBg@mail.gmail.com>
User-Agent: Mutt/1.9.5 (2018-04-13)

On Thu, Sep 17, 2026 at 10:03:36AM -0700, Andy Lutomirski wrote:
> On Thu, Sep 17, 2026 at 3:37 AM Mikko Rantalainen
> <mikko.rantalainen@peda.net> wrote:
> >
> > On 9/17/26 02:16, Andy Lutomirski wrote:
> > > On Mon, Sep 14, 2026 at 2:44 AM Mikko Rantalainen
> > > <mikko.rantalainen@peda.net> wrote:
> > >
> > >> NFS and devices make the question more interesting, though. Some
> > >> implementations put meaningful state transitions into their close path.
> > >> Tape devices are an obvious historical example: depending on the
> > >> device/mode, close may write filemarks, flush tape buffers, rewind, etc.
> > >> Those operations are not necessarily replaceable by fsync() before
> > >> close().
> > >
> > > I realize this would be complex and maybe a can of worms, but maybe we
> > > should have a new improved syscall here.  close() is indeed deeply
> > > problematic.
> > >
> > > On the one hand, we have the actual task of closing an fd in the sense
> > > of removing it from the table.  This should really be doable without
> > > blocking or without side effects (except possibly for zapping
> > > old-style POSIX locks -- it doesn't really make sense to be able to
> > > close all fds to a file while still keeping it locked, especially
> > > since we report the pid of the lock-holding process).
> > >
> > > On the other hand, close has actual *meaningful* effects, many of
> > > which you've mentioned in your email.  IMO it would be really nice to
> > > be able to explicitly *do* those effects separately from closing the
> > > fd, maybe even asynchronously via io_uring.
> > >
> > > Would it be so bad to have a new operation to do (possibly with
> > > moderately fine control) the close work and another one to just
> > > release fd- and process-associated locks and drop the fd?
> >
> > I think introducing yet another syscall would be bad replacement
> > for the *inability to decide the exact semantics* we want to use for
> > the current syscalls, especially close().
> >
> > It's pretty clear that close() is poorly defined right now. The only
> > thing that we know for sure is that it releases the file descriptor
> > and in case of Linux, this happens for sure unless EBADF is returned.
> 
> I think I mostly agree with your analysis except that I really don't
> like the ENOSPC.  The kernel actually has the ability to commit to
> having space for pending writes on an fd *without syncing*, then I
> think that capability should be expose to userspace.  fsync is a
> pretty poor alternative for code that just wants to make sure that, in
> the absence of a bug, crash or physical failure, the data won't be
> lost.

Yes, if close() can give ENOSPC, that's indicative of a bug in
write(). I think the problem is everyone likes their bad NFS
implementations cutting corners to be fast...

Rich
