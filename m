Received: from lb2.peda.net (lb2.peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E742E41F7D4;
	Mon, 14 Sep 2026 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378733; cv=none; b=sZT/CZq9jT8twzqSDrgHc2mKHl0iWHPpFYgXsI+WpAnECNyvxGqU3SfLcaEb8bwRDviBJY7QRbmBcCMpzomTuNZ1nFoJWPQMXW+lJHnN4xPDS3ygobFDzpimudCviGAwyO0f5v33fneIenlKYVj4JDITeWyzeZpsxmVWKxVHTRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378733; c=relaxed/simple;
	bh=vyFpK8fGHqr3LeMLl/WWwMKxHWVm+bXqNVjamFEmasU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JyiAyFYgl7D7tNfnMDY9DSkoVUeXEg5nBjFP9IsbHyoiY1HUsoO4FbsnRBLqfZlF+P0OOeN4qLLMV2qSUXGAYodyBTizPlHFz5hJXxe/n/cdm5+7tQPrrUGlZZywgizYrq5bjXEYqSIzTasdhns2KT77MWxH8rLEV0GEVNu+B7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=IpiU+2ai; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="IpiU+2ai"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789378727; bh=vyFpK8fGHqr3LeMLl/WWwMKxHWVm+bXqNVjamFEmasU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IpiU+2aiZtrvr2gSDrMIlb4HftdKcISIb2t4QGjjoswbddBNUyDTiD8gRQI22wFKE
	 OiusKEL1IC9W+r+oSRk9R69TYXbagTxvUqF555A/RSYbaxtwXv+rp1C9hkYjOQomBY
	 6tqzGfD5GCpquFOpVOQ78DPTuYGxJu0PAyefm4vZjLhgCGGWDO+rjHmbmoWiLrQNoW
	 PRmzOiNytKX3M5FbNKFNt5nxY6I4ptS6CYt+tkPr3IOlMfbDEBrpeeQLoH1P7BInly
	 LDOKBgrEEGfsuBiWw/BuniQUviDZBbb09laRFOLmrpCVTUaAGZwh9q5lSczhfzNW1J
	 SddR5SNICtv7w==
Received: from [86.60.167.233] (86-60-167-233.dynamic.lounea.fi [86.60.167.233])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id 2DFBAD600F2;
	Mon, 14 Sep 2026 12:38:47 +0300 (EEST)
Message-ID: <eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net>
Date: Mon, 14 Sep 2026 12:38:46 +0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
To: Rich Felker <dalias@libc.org>, Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, alx@kernel.org
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
 <20260913235145.GY25906@brightrain.aerifal.cx>
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
In-Reply-To: <20260913235145.GY25906@brightrain.aerifal.cx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Rich Felker (2026-09-14 02:51 Europe/Helsinki):
> On Sun, Sep 13, 2026 at 11:42:23PM +0100, Matthew Wilcox wrote:
>> On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
>>> In addition, POSIX.1-2024 requires that if close() reports EINTR, the
>>> descriptor must remain open. It also explicitly permits an interrupted
>>> close() to return success after closing the descriptor.
>>
>> I think any filesystem / device driver / ... which returns -EINTR from
>> close() is broken.  There is one exception though -- if the signal is
>> fatal.  It's like read()/write() being killable; if the signal is fatal,
>> the task dies before it gets to see the errno.  So it doesn't matter.
>>
>> So that's my preferred solution; track down the bad kernel code that's
>> doing things in close() that are "interruptible" and convert them to
>> "killable".
> 
> The traditional things that admit EINTR in close are bad NFS
> implementations (which intentionally use interruptible instead of
> killable because network flaky) and tape drives (which at least
> historically performed rewinding as part of the close operation).
> 
>> We don't want SIGWINCH or SIGALRM interrupting close();
>> that's just dumb.
> 
> You don't want a slow close blocking delivery of SIGALRM either.
> Freezing the process during a long close is not the answer. The answer
> is just getting rid of long close and having it behave properly as a
> resource-handle-free-only operation and return immediately. But that's
> a more invasive change than just replacing -EINTR with 0 if/when it
> gets interrupted.


For ordinary filesystems where close-time work is not itself part of a
stronger synchronization contract, I think the answer should be fairly
clear: close() should not expose EINTR to userspace after consuming the
fd.

close() does not provide a durability guarantee. It *may* report
deferred I/O errors or errors discovered during close-time work, but
an application which requires synchronization has an explicit
interface such as fsync() or fdatasync() for that purpose.

So if such close-time work happens to be interrupted, I don't see what
useful recovery semantics exposing EINTR provides. The fd is already
gone and close() cannot safely be retried. Returning success seems more
useful than exposing an interruption which the caller cannot act on.

NFS and devices make the question more interesting, though. Some
implementations put meaningful state transitions into their close path.
Tape devices are an obvious historical example: depending on the
device/mode, close may write filemarks, flush tape buffers, rewind, etc.
Those operations are not necessarily replaceable by fsync() before
close().

But I think EINTR is problematic there too, for almost the opposite
reason. If the semantics require some close-time operation to complete,
then returning EINTR after the fd has already been removed leaves
userspace with no generic way to complete that operation:

  close(fd) -> EINTR

    - fd is already closed on Linux
    - retrying close(fd) is unsafe
    - the interrupted operation cannot be resumed through fd

That seems to leave a few possible designs:

1. The close-time operation is required. Then the kernel should complete
   it despite non-fatal signals, or provide some explicit operation which
   userspace can use to request/check completion.

2. The close-time operation is best-effort. Then interruption should not
   turn an already completed descriptor release into EINTR; returning
   success seems more appropriate.

3. POSIX.1-2024 also provides EINPROGRESS for the case where the fd has
   been closed but close-time work is incomplete. That at least describes
   the state correctly, although I still don't see what useful recovery
   operation userspace has if the work can only be performed through the
   now-consumed fd. In addition, the implementation in musl suggests
   that this wouldn't be compatible with real-world programs.

What seems particularly difficult to justify is the current Linux result:

  close(fd) -> EINTR

while the fd has nevertheless been irrevocably consumed. It has the
usual appearance of a retryable interruption without providing any safe
way to retry it.

So replacing -EINTR with 0 still looks attractive to me as the generic
close() behavior, even if removing all long synchronous close operations
would be a larger project.

It may also make sense independently to diagnose ->flush()
implementations which return an interruption result in cases where that
means required close-time work has been abandoned. I would be interested
in whether there is a good way to warn or trace those cases without
complaining about the fatal-signal case Matthew mentioned.

--
Mikko

