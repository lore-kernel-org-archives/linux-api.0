Received: from lb2.peda.net (lb2.peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079D22D7380;
	Mon, 14 Sep 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367825; cv=none; b=nS2bdaSF1GJdemC0Jm6kHl6mNjss+wbFY83FIZoeFdZh3+s0VsL/+IF/9YRscgpRgTSVuU9V4kLIN7EK2Jj9ghVcMJv9HxkPvIuzAg7Mgh3GUalclv55WDmDGSBNeM0kXIFhTyxztQ10wUyOug3a9kPaCDFkglaYOR9U/0z1x70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367825; c=relaxed/simple;
	bh=8N42BmCblJVZfeWu1cm73VCY2czk8tZtyc88nGTs5zE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g8qsx/zz9rJ8iUKPEg2b6n8CN5J37KdYkberobyQ5vw5lM+ElOgRyafgrpifDwj8Lm4xEICf6AB0WspbEL6MSRDMXmROfk51TlwKS1eKv45kjtIolbQUJy+lCx4t6iX18v3UXG2rTy8r+zZFBwwrhBWBGPQYmLRUdFoFH+qAqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=MykX7Eu4; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="MykX7Eu4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789367819; bh=8N42BmCblJVZfeWu1cm73VCY2czk8tZtyc88nGTs5zE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MykX7Eu48WTDqBURwwpcGBIjj2NPoEV00/TaG4Lhlc3mK1V+CdD9KqlIke4bz31II
	 +G7pf4ZPIEpZBuYft+h7dnFQ9Ah4UV1iabclce4AyHoED6GHRy1mVoc2bsuSs8npVm
	 p1zeoPc3SVq52Yfi5ibDyjRT77tU0e26eXCLMJ82SCp8WhbJQODcSxmA30Fyi8fsDA
	 oG9Yp3Fn05pOu9D5IUA6N/dWBgf0PR8D9/4z1P4/LOK+08Msc3zLkwpXieVe1hzL56
	 05Ha+0V88sSGn5MTu6X3fpDQgpxqd1Vc+VUDHL61OgpC6eogjpCgPqZM3aDLlH22O8
	 WhZFFwvXmSAOQ==
Received: from [86.60.167.233] (86-60-167-233.dynamic.lounea.fi [86.60.167.233])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id 26BDED60144;
	Mon, 14 Sep 2026 09:36:59 +0300 (EEST)
Message-ID: <0e27e9dc-3520-436e-aa69-af9e938ab1bf@peda.net>
Date: Mon, 14 Sep 2026 09:36:58 +0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
To: Rich Felker <dalias@libc.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, alx@kernel.org
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <20260913205358.GX25906@brightrain.aerifal.cx>
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
In-Reply-To: <20260913205358.GX25906@brightrain.aerifal.cx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Rich Felker (2026-09-13 23:53 Europe/Helsinki):
> On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
>> In addition, POSIX.1-2024 requires that if close() reports EINTR, the
>> descriptor must remain open. It also explicitly permits an interrupted
>> close() to return success after closing the descriptor.
>>
>> This patch is about implementing the second option to be compatible with
>> both POSIX.1-2024 and real-world applications.
> ...
> 
> I don't think there is serious concern about userspace regressions
> making this change. It would not be changing the meaning of any
> existing result code or adding a new error condition applications need
> to be aware of (like the EINPROGRESS mess).
> 
> But I'm also not sure how helpful the change would be. It's already
> possible to patch this up in userspace, and as you noted, we already
> do that in musl and so does Bionic. So the main practical effect of
> this change would be just forcing the right behavior on glibc systems
> even when glibc doesn't want to fix it. Maybe that's a good idea? I'm
> not sure. I think it would be best to have everyone on the same page
> that this should be fixed, with both glibc fixing it so it's right on
> old-kernel/new-glibc, and the kernel fixing it so it's right on
> new-kernel/old-glibc. That would also avoid hard feelings from a
> unilateral action perceived as dictatorial.

I think there are two important questions:


(1) What is the caller truly expected to do for EINTR? They cannot
retry which would be the typical response to EINTR.

(2) If caller cannot retry because file was already closed, can caller
have any valuable information from EINTR return instead of success?
I think it's pretty safe assumption that success from close() would
be handled correctly by the caller.


I'm currently thinking that the answer to (1) is "???" and answer to
(2) is best you can do is to log "Some unknown action interrupted
some unknown background process while closing file XYZ, pretending
everything went well." because anything else would assume some
specific implementation of close() on Linux.

As I see it, the fact that avoiding EINTR return value when the file
is already closed fixing POSIX.1-2024 compatibility and glibc is just
a bonus for a change that makes sense otherwise, too.

-- 
Mikko

