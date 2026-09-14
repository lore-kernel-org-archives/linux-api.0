Received: from lb2.peda.net (lb2.peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F6A4446E1;
	Mon, 14 Sep 2026 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389609; cv=none; b=jJ7ceoBVKMEQA3oXNBXji70VN06y7mi1yjruJzYsYKBTAHAW5Mjf4utPDDMLwPEv1YwYNVhXcwboAmVBh/n67cStfuCcO3L28MA4wanSK390UqfmMXEsKmbDtc9xA0ZJm9np8EoZQI5aQbmsjc8rBydsZpl8Uh7cNr1E7WhZMxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389609; c=relaxed/simple;
	bh=gNbkOq+Ttw1t7HU8FDpEpcMJuR0DG26Dudi2mfXAPsM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XNdkUlmnLRQMbr+r0JkEwfi6ViDumUVdS5lu/iHBQ4xIDMN4BbCT7DXYrkuoStvMURTViaVPR6lldPW4ZR7feXmZ7s1a7IHU8g0M9Wg2vATTgUqC1jbFSukD9G1eH3KyxqzKbXiQsuwBhjs5gz6MbjDdp9lgi2LPod875/KbIdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=mSIMnDw0; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="mSIMnDw0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789389602; bh=gNbkOq+Ttw1t7HU8FDpEpcMJuR0DG26Dudi2mfXAPsM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=mSIMnDw0JjU2RRMvLsUSIa7CK0FY+ELNTZyx927AwRj+/T+FMk8GEoNfF1smGXo6x
	 uA+iVeXqxJTe5liR3mBhHn+vpIhHWCMe34lw1Sy8FJ41uUSuwGwkDoXMMKTmSadnTV
	 0CYbZS15y/gvSd6Zc/P3saF/mAknWitpuNcpDvxlwhCJGvSrRv0RESY4JZb6v6W+X0
	 0XJWsNppV9xi4ZY8Kx8upyOXKdhfIqAspvB3Lcd+Ku9S48KTEU5EZoduSxFIWNwKEd
	 r4S8Er/BuKZuxDjDFKBdBKcg89MiQBUHPGQmQocz6+Wo2QslQhG7ltFOw6m1viB3Az
	 Y6idRgD4PCrIA==
Received: from [86.60.167.233] (86-60-167-233.dynamic.lounea.fi [86.60.167.233])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id 27A07D600C6;
	Mon, 14 Sep 2026 15:40:02 +0300 (EEST)
Message-ID: <cf83be66-e540-4abf-b377-7e344d62a1dd@peda.net>
Date: Mon, 14 Sep 2026 15:40:01 +0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
From: Mikko Rantalainen <mikko.rantalainen@peda.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, alx@kernel.org, dalias@libc.org
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org>
 <bcdb8f85-d53a-4824-8e34-8d190ec7f4b2@peda.net>
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
In-Reply-To: <bcdb8f85-d53a-4824-8e34-8d190ec7f4b2@peda.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Mikko Rantalainen (2026-09-14 12:07 Europe/Helsinki):
> ---
> retval = filp_flush(file, current->files);
> 
> WARN_ONCE(retval == -EINTR ||
>           retval == -ERESTARTSYS ||
>           retval == -ERESTARTNOINTR ||
>           retval == -ERESTARTNOHAND ||
>           retval == -ERESTART_RESTARTBLOCK,
>           "close: ->flush %ps returned interrupt error %d\n",
>           file->f_op->flush, retval);
> ---
> 
> That would leave the existing userspace ABI unchanged while making
> remaining offending implementations easier to find and fix.
> 
> I also considered retrying filp_flush() inside close(), but I don't
> think that can be done generically. ->flush() is not documented as
> safe to restart from the beginning after partial execution, and
> an interruptible wait could immediately encounter the same
> still-pending signal again. So fixing the interruptibility at the
> offending wait seems safer if the above invariant is indeed
> the intended one.

Another thing I noticed is that there are already several paths where
the kernel calls filp_close() and intentionally ignores its return value.

For example, close_files() does:

    filp_close(file, files);

without checking the result. The same is true for do_close_on_exec(),
and close_range() explicitly says:

    Currently, errors to close a given file descriptor are ignored.

So I don't think a ->flush() implementation can rely on returning EINTR
and having somebody retry the interrupted operation. There are valid
close paths where nobody will ever see that return value, even when the
process itself continues running.

This seems to strengthen Matthew's point: if some work performed by
->flush() is required for correctness, that work has to tolerate these
close paths without depending on userspace retry. Returning an
interruption result cannot be the recovery mechanism.

I'm therefore leaning towards treating an observable -EINTR/-ERESTART*
from ->flush() as suspicious in general, rather than just special-casing
the close(2) syscall. The fatal-signal case is harmless because the task
will not observe the result, but close-on-exec and close_range() show
that unobserved filp_close() errors are already part of normal operation
as well.

That also makes me think documenting the intended ->flush() contract
would be useful: if required close-time work must not depend on the
caller retrying filp_close(), that seems like an important invariant for
implementations to know.

What guarantees must file_operations::flush provide when its caller may
have no way to act on its return value?

In any case, I'm now thinking that returning EINTR for close() is a bug
when file descriptor is already freed. I think the only question is how
it should be solved. I initially thought it should just be mapped to
success. Maybe it should be logged as subsystem bug *and* mapped to
success for userspace instead?

-- 
Mikko
