Received: from lb2.peda.net (peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8814F38F255;
	Mon, 14 Sep 2026 09:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376868; cv=none; b=B2NoWqVoQug3O0/l/L2gDPEGIh5im0TEw08Zih6M7DJ6fuZHQlGF1vikBvMYJ+pfoJGlQIpONT6TB/RdKHvidZjaCfpYGEqYRp4Fj9OdtCAdIZ6kYsb3AWns/ZW4YqgRz99qBO9ZP5xyiOkA5vl2C+AYuQJ5i6l72bkBZwjsng8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376868; c=relaxed/simple;
	bh=wjv+OXvVznW9rx3f8jRp1nNUlFIajNw4AjfpWlMy56s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RHA3dyL2oKjEw9IIYN0sl3he9W0Hv37ge6o0zLXFtwtE3bwSSc+pRPvMUb2hm1N7bdRHDkRRUQy452pwBRrjPHI6oJdw7DtuoYtK7E45OM1/XBwJq+LXqf5KJMeUBr8V/t+BhoDErSwxuruk/RHS/ZSvhNh0IcDRcSyE6CMUCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=KFbuuQd6; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="KFbuuQd6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789376861; bh=wjv+OXvVznW9rx3f8jRp1nNUlFIajNw4AjfpWlMy56s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KFbuuQd63qtuiLPwxyJi36aJltIOH76pgjcisqdm0sIFyiGU/bgTUzE5Qx4FsVduz
	 jnYpkM59PYfms+FRFRdA5Laj0Lcq9f2jt+uAxVVaSICxhUdvhAsP+TVXhQQRydy1Re
	 0pAd3j7mAVi9T63WChve+gt3lCEoIbmT3k7XpCtdADIrWv1H/SLjGNqSpm7WrnmYqZ
	 KUuP6XoHGO6Kw1xfyA/t92um3M7cSCVBjG2/JlPbVO1vl0ah7Y2ZpqKWLgdkSaitds
	 8VOGPQLTZ0ION6P1b+78Y/HtSY2ExxmKWnT4pY7BBpfj5QYpBZc804qhzgCwSfYxx/
	 vQGkr1vmwgsLg==
Received: from [86.60.167.233] (86-60-167-233.dynamic.lounea.fi [86.60.167.233])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id 8FD68D60113;
	Mon, 14 Sep 2026 12:07:41 +0300 (EEST)
Message-ID: <bcdb8f85-d53a-4824-8e34-8d190ec7f4b2@peda.net>
Date: Mon, 14 Sep 2026 12:07:41 +0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, alx@kernel.org, dalias@libc.org
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
From: Mikko Rantalainen <mikko.rantalainen@peda.net>
Autocrypt: addr=mikko.rantalainen@peda.net; keydata=
 xjMEWvlVlRYJKwYBBAHaRw8BAQdAJneRuA4reN56nwM7GyQ8Gwkhc4ANBia0NFNcU/qwP63N
 Lk1pa2tvIFJhbnRhbGFpbmVuIDxtaWtrby5yYW50YWxhaW5lbkBwZWRhLm5ldD7ClgQTFggA
 JwUCWvlY9wIbAwUJXfwPAAULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAhCRC4w4yaqAoqKxYh
 BNKwvdN4KAGSgYZmbbjDjJqoCiornGsA+wWoUBgH7S20W4KkYvr5OipJ5FBH0vbHDEvv26V+
 WYt5AQCbgxKfVQD1g9gp67xb2NWkMKccy/5R0oYl7uGBDKHNBc44BGftb9gSCisGAQQBl1UB
 BQEBB0CXgySU7HDsuvqYVVlXWZvvGTyjxz4iEQSemOwJ8BU7EgMBCAfCfgQYFggAJhYhBNKw
 vdN4KAGSgYZmbbjDjJqoCiorBQJn7W/YAhsMBQkX8l8AAAoJELjDjJqoCiorklIBANBBccGb
 g8cV5dSjL2oUNnJKK3ZgkBSfWjk21cISIMIxAP4xRcw/3Kk0sCRbKNFXyGtIk4OQrvYBaAij
 qKI0ItEoBg==
In-Reply-To: <aqcmz5uI7PgN5CT7@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Matthew Wilcox (2026-09-14 01:42 Europe/Helsinki):
> On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
>> However, currently Linux kernel will return EINTR in some cases for
>> close(). There is no good way for caller to recover from this case using
>> the original fd. Whatever action was actually interrupted cannot be
>> resumed or retried through this fd, because the fd has already been
>> consumed. Even worse, EINTR conventionally invites retrying an operation,
>> but retrying close() is unsafe: the same file descriptor number may
>> already refer to another file opened by another thread by the time
>> close() returns EINTR.
>>
>> In addition, POSIX.1-2024 requires that if close() reports EINTR, the
>> descriptor must remain open. It also explicitly permits an interrupted
>> close() to return success after closing the descriptor.
> 
> I think any filesystem / device driver / ... which returns -EINTR from
> close() is broken.  There is one exception though -- if the signal is
> fatal.  It's like read()/write() being killable; if the signal is fatal,
> the task dies before it gets to see the errno.  So it doesn't matter.
> 
> So that's my preferred solution; track down the bad kernel code that's
> doing things in close() that are "interruptible" and convert them to
> "killable".  We don't want SIGWINCH or SIGALRM interrupting close();
> that's just dumb.

Am I reading this correctly as a proposed VFS invariant: ->flush() must
not return an interruption result which could become visible as EINTR
to a surviving userspace caller of close()? A fatal signal is the
exception because the task will die before observing the return value.

That seems like a reasonable invariant, but I couldn't find it
documented anywhere. Documentation/filesystems/vfs.rst currently says
only:

    flush
        called by the close(2) system call to flush a file

without specifying allowed return values or signal semantics.

I had originally approached this from the userspace contract. close(2)
guarantees relinquishing the descriptor, but does not provide a general
synchronization guarantee. In particular, successful close() does not
mean regular-file data has reached storage. Applications which require
that guarantee need an explicit synchronization operation such as
fsync() or fdatasync() before close().

The close(2) documentation does say that later close-time operations,
including flushing data to a filesystem or device, *can* report errors.
But I don't read it as guaranteeing that all such work completes or that
all outstanding errors are discovered before close() returns.

That's why I was thinking EINTR should simply be converted to success
by close() implementation.

So I think the important distinction is:

1. userspace is not generally promised completion of arbitrary
   close-time work; but

2. if a subsystem deliberately performs synchronous work in ->flush(),
   the kernel may nevertheless require that work to complete for the
   subsystem's own semantics.

If (2) is the intended VFS rule, then I agree that converting EINTR to
success in close() would hide a bug rather than fix it. The bug would
be an ->flush() implementation allowing an ordinary signal to abandon
work which it intended to perform synchronously.

Would it make sense to document that invariant explicitly, e.g. that
->flush() must not return -EINTR or -ERESTART* due to an ordinary
non-fatal signal?

If those results should be considered implementation bugs, perhaps a
useful diagnostic would also be something along these lines:

---
retval = filp_flush(file, current->files);

WARN_ONCE(retval == -EINTR ||
          retval == -ERESTARTSYS ||
          retval == -ERESTARTNOINTR ||
          retval == -ERESTARTNOHAND ||
          retval == -ERESTART_RESTARTBLOCK,
          "close: ->flush %ps returned interrupt error %d\n",
          file->f_op->flush, retval);
---

That would leave the existing userspace ABI unchanged while making
remaining offending implementations easier to find and fix.

I also considered retrying filp_flush() inside close(), but I don't
think that can be done generically. ->flush() is not documented as
safe to restart from the beginning after partial execution, and
an interruptible wait could immediately encounter the same
still-pending signal again. So fixing the interruptibility at the
offending wait seems safer if the above invariant is indeed
the intended one.

-- 
Mikko

