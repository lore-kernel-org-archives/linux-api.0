Received: from lb2.peda.net (peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAE44A9D7B;
	Thu, 17 Sep 2026 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641483; cv=none; b=DZ+mJ9VIiSBVw8FVMgBApXTMm9+Te66EoLGE01iblpXQvQ0AICKkX72E6fSRyuuZdUUPd0K/qxTURNGQ7YHK9eaNXmkdfx0g2hdDN4rfhpQmqyh4uwjPZKZ01UN3fWm0P5TOkZH3lOUeq0mOwn1dsJeKsfRiTI05HvCJc2KHMOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641483; c=relaxed/simple;
	bh=dtNsTvNZA1X8xqjH5mtH9VdmYHTq9RZ3fsjGDyJ9kOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeK/p26f7EElLl2ghGaaWOipuW3qcLbMG9zvr/TMJdYvA2VXh4gUycMIUY55C35VnqM2DrxaInWwrYKU3lBiRYtTqGZ3YOPzKbI64UMXCnBqUjuIyjWW5Ccn1QrumVgiWYzNM3JGN7Bf3TjW7z8MPjQ/F/oSe2QIN641lLXnnIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=cLN8yhoU; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="cLN8yhoU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789641473; bh=dtNsTvNZA1X8xqjH5mtH9VdmYHTq9RZ3fsjGDyJ9kOk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cLN8yhoUfsmD/EIQORzEWi6FoUFFAprUl3dODmOLGUd5W2PnuHSFXKau8G8svkmI5
	 JOEHKzvSMg7koB0HD3ABY/KHqR8HZE+N64zMtrKTnzrp2pcgepGMSVSsJJ3/052fJV
	 CslQDSir8/0W7/vF565Eoceo58k2V2L4K6coUrB9y/xZpsfa2ZxymDa8H6FJZx6vQe
	 4a1zhyETKeq/CfdsS9yY7PoW2UfMrwPQ6cAUil7YjHd/2HWyoj10gGEza72VRITIZF
	 GA5uH+2GCvJbZK+tndcPw1oW3PjxPMMxUpR+svZInfhwMihx6fdiLl5AFVgpk9eHnH
	 Gtrj+YiEbe5og==
Received: from [130.234.82.94] (semyol-329-b.ktl.jyu.fi [130.234.82.94])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id 19914D600CC;
	Thu, 17 Sep 2026 13:37:53 +0300 (EEST)
Message-ID: <f61886ed-3026-4db7-ae22-b882264141bd@peda.net>
Date: Thu, 17 Sep 2026 13:37:52 +0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Content-Language: en-US
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rich Felker <dalias@libc.org>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, alx@kernel.org
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
 <20260913235145.GY25906@brightrain.aerifal.cx>
 <eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net>
 <CALCETrUgLj4Dz0s6PMofViJwausRWCvNvJphxWHUeWCCaRBtQg@mail.gmail.com>
From: Mikko Rantalainen <mikko.rantalainen@peda.net>
In-Reply-To: <CALCETrUgLj4Dz0s6PMofViJwausRWCvNvJphxWHUeWCCaRBtQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/17/26 02:16, Andy Lutomirski wrote:
> On Mon, Sep 14, 2026 at 2:44 AM Mikko Rantalainen
> <mikko.rantalainen@peda.net> wrote:
> 
>> NFS and devices make the question more interesting, though. Some
>> implementations put meaningful state transitions into their close path.
>> Tape devices are an obvious historical example: depending on the
>> device/mode, close may write filemarks, flush tape buffers, rewind, etc.
>> Those operations are not necessarily replaceable by fsync() before
>> close().
> 
> I realize this would be complex and maybe a can of worms, but maybe we
> should have a new improved syscall here.  close() is indeed deeply
> problematic.
> 
> On the one hand, we have the actual task of closing an fd in the sense
> of removing it from the table.  This should really be doable without
> blocking or without side effects (except possibly for zapping
> old-style POSIX locks -- it doesn't really make sense to be able to
> close all fds to a file while still keeping it locked, especially
> since we report the pid of the lock-holding process).
> 
> On the other hand, close has actual *meaningful* effects, many of
> which you've mentioned in your email.  IMO it would be really nice to
> be able to explicitly *do* those effects separately from closing the
> fd, maybe even asynchronously via io_uring.
> 
> Would it be so bad to have a new operation to do (possibly with
> moderately fine control) the close work and another one to just
> release fd- and process-associated locks and drop the fd?

I think introducing yet another syscall would be bad replacement
for the *inability to decide the exact semantics* we want to use for
the current syscalls, especially close().

It's pretty clear that close() is poorly defined right now. The only
thing that we know for sure is that it releases the file descriptor
and in case of Linux, this happens for sure unless EBADF is returned.

It doesn't matter if you get EIO, EINTR or some other more or less
important sounding error code, the file descriptor will be closed
anyway. It's never possible to workaround the issue using the file
descriptor passed to close() after getting an error because the
file descriptor is not usable no matter the error code.

So all these extra errors happen because of practically undocumented
side-effects which may or may not be optional (that is, even POSIX
defines flushing to maybe happen with some unspecified timeout) and
the close() may return before the flush is complete even though it
apparently should be somewhat synchronous according to POSIX.

However, an implementation doing nothing (logically using zero
length timeout for the best-effort part to maximize performance)
would still appear to be POSIX compatible without *ever* doing
anything else but releasing the file descriptor.

That said, I would assume that for real-world compatibility,
close() must be able to report at least ENOSPC and EIO because
of existing userland code. Otherwise existing programs failing
to call fsync() or fdatasync() could cause silent data loss
too often in practice.

I still think that close() should never emit any error code that
even suggests that the caller should retry. This is because there
is no way to ever retry the close() call on Linux because
the file descriptor is always released.

Returning error from close() makes about same amount of sense
as returning an error code from free().

As a result, close() should internally convert any error codes
suggesting a retry requirement such as EINTR, ERESTART* into
either success or EIO depending on how the caller is expected
to handle the case.

And even then, considering that kernel-internal close_files(),
do_close_on_exec() and close_range() all call filp_close()
without ever checking the return value, any implementation
of filp_close() (basically ->flush()) returning error
that suggests that retry would be *required* is probably buggy.

So even the internal interface filp_close() is poorly defined.
What the caller is expected to do if EINTR, ERESTART* is
returned? Currently in-kernel clients do nothing and userland
programs receive EINTR without any real documentation what is
supposed to happen next. The best we have is a suggestion
to *maybe* log it somewhere and pretend it was success or
failure basically randomly because the correct intepretation
is never defined anywhere.

The only thing we know for sure on Linux, is that returned
EINTR does not allow restart attempt which would be the
correct action to take according to latest POSIX spec.

That's why I think the only sensible thing is to convert
EINTR into success if file descriptor is always released as
in current kernel implementation.

We don't have EMAYBESOMEWHATFAILED which would better describe
the current implementation causing EINTR.

If any kernel driver or subsystem is returning EINTR, ERESTART*
for filp_close(), there's practically no way *any caller* would
ever retry. Therefore any code emitting those errors for
filp_close() is highly probably a bug and would probably need
to be changed to either zero or EIO or some other error code
that actually makes sense for a call where nobody is going to
retry, ever.

If we could decide on actual semantics of close() first, then
we can tell if the "rewind tape synchronously on close()" is
a bug or feature.

I'd prefer style where close() would always release the file
handle and do nothing else. And fsync(fildes) should be
defined to handle the side-effects that historically were
*sometimes* caused by call to close().

I see no problem using fsync(fildes) on tape device to mean
complete all the writing and rewind the tape. If that results in
error, the client can retry as many time as needed. And close()
would just signal, I'm done trying / I accept the results.

Then close() would *always* be successful if you pass a valid
file descriptor to it. This would make a lot of sense for
a syscall that's supposed to release resources.

The POSIX style may result in state where file descriptor can
never be relased if the kernel keeps returning EINTR. That might
be even worse than the current Linux implementation which closes
the file even in case of EINTR, even if the returned value
does not make sense considering the file descriptor was actually
closed, as requested.

As a result, EINTR should never be returned from close() on Linux
because there is no sensible way to proceed after that, other
than pretend it was "success but spelled weirdly".


Here's my suggestion for improved semantics for close():

   close(int fildes)

     Close the file descriptor fildes, or return EBADF if
     given fildes didn't refer to any open file.

     The return value *may* be EIO or ENOSPC if the kernel
     immediately knows that writing the buffer will fail.
     The file descriptor is closed even in this case.

     Otherwise, 0 (success) is returned.

     If calling code needs to know if EIO or ENOSPC happens
     before all the data has been stored in permanent storage,
     the calling code must use fsync() or fdatasync()
     with the file descriptor before calling close().


(I would love to also include "closing the file descriptor
immediately releases all locks acquired via the file descriptor"
but I'm not sure if that's compatible with the current implementation.)

As a result, close() would then *never* return anything else but
success (zero), EIO or NOSPC. And both EIO and NOSPC would be
returned immediately (if status is known) before waiting even
a millisecond for any kind of flush synchronously.

Any other error from internal kernel interfaces would need to
be translated into one of the above status codes.

As far as I can tell this new semantics would be compatible with
POSIX definition and highly probably with existing userspace
code, too. Racy client code that doesn't call fsync or fdatasync
would still be racy; the race might become more visible, which
could be positive or negative depending on if the author of
the client code were then better aware about the race.

And a shell script using a tape drive could just add
`sync /path/to/tape/device` before the user rips the tape out,
if needed to workaround "close() no longer rewinds the tape"
in random binary. Kernel could still start rewinding the
tape on close() but close() would immediately return instead
of waiting for the rewind be complete and the user could
wait for the process to complete using `sync`.

-- 
Mikko

