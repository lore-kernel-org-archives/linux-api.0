Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795598297;
	b=nCi+wxsIx91F5xzrBfC6Siv1Af+ZICq2z8X4BXhwlrG3NdAjJU3KJOTlfa7/t19fEBPS
	 5cPtrTM21V5hyZJnWfHD3ZDgxiXk/xAJVLaANIFyElmJcJMVJNuhqCMSC++aJI38c7uH9
	 5rPM5XbXcPg8dipVElRjusdoFiut/ALNa4f9YBEzdKf02Q/iX5HRnAFA9om3hwAHAeACs
	 RTsL9ZVTIQocnAuuocpZNclvMn96spKwg4CWPhp92mveNzSKgd15pooFCqzkHXWlW3zvU
	 pP30japGfSr1tPUfqxSDkp/vD+i06NjQtTkKAuQmP5dUKiwo304AnuHDce6kif5284g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598297;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 From:Subject:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=y+2r4fG+UznQIXXE3C+R4pQGdQ5wZVXkmN5K7GeDHs4=;
	b=y0o/xiyNpLNDyKzKqdxFXToRPtu6DY0OtJQCZ6I2VMp4VMQ2ZIJPC9x264itDP9EHTUG
	 IKol8ambqcHb1qjv4/lA0UtjoagPutYpul9i7izj6W8BH7ba4vyuqPrO6elxiHQq3tSEO
	 4zMULruEeoM/7ffz8AQMGPl/7R5yqxDy1o8qmYcNqJLLvuaAxT7aZHf5o5INlGi5u9/MT
	 Wir+zBe5qZtSvtdjZ7UhAzzkUsHhgahFTcAA9z0aHD03yLzWu9IGrzKlCAZmWUUF+t4Qh
	 O5cAYdAuvWXkoLNctLekpheDSo5/+n/JA8sy0WXkqLdLpX5VW6kmlfB7Wg9s3MVVezA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uKEsdvWx;
	arc=none smtp.remote-ip=95.215.58.141
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3C0606A32D
	for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 09:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE3C0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uKEsdvWx
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BMfH48xOt2irIlEx2o6dYqxmMgmYPvLKMXb/KO3WSmE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795598293; v=1; x=1796203093;
 b=uKEsdvWxHdB867Wpku2QYs2M62iVV1ufoqpFaXhYX2tze7GG6wvhSoWqEA2NS7r+jKlA0XW0
 9CykgRivrOahTR24gfYG6n6PBGOnYsH5B37TaP599cq9KFosJi15NntR9l3pVmi2jlBiRMhSmS3
 fiJbPjYHYkyeQnpgyNWTB3fs=
X-Envelope-To: linux-api@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 38a7a00aad77a690;
	Wed, 25 Nov 2026 09:18:13 +0000
X-Mizu-Trace-ID: 38a7a00aad77a690
X-Migadu-Flow: FLOW_OUT
Message-ID: <a337f9fc-b6ef-48c4-ad98-52972b10b4c9@linux.dev>
Date: Wed, 25 Nov 2026 09:18:12 +0000
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: John Garry <john.garry@linux.dev>
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
To: Dave Chinner <dgc@kernel.org>
Cc: Wayne Gao <Wayne.Gao1@solidigm.com>, "cem@kernel.org" <cem@kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread> <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>
 <awXuAESDkLr1nd3n@dread>
Content-Language: en-US
In-Reply-To: <awXuAESDkLr1nd3n@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/26 20:05, Dave Chinner wrote:
>>> Ok, so you want it for your test/dev environment, not production?
>>>
>>> I thought we could already change the block device characteristics (i.e. support hw
>>> atomic wirite or not) at the block device level?
>> The block layer just accepts whatever atomic properties is reported by the
>> block driver and there is no method in the block layer to change these
>> limits or turn them off.
> Isn't that a bit of an oversight? Lots of the hardware related IO
> capabilities are configurable in the bdev queue (e.g. max io sizes,
> max discard/unmap sizes, max queue depth, etc).

Generally anything which affects atomic limits is fixed. As you 
mentioned, there is max io sizes, which can be configured from sysfs - 
however, for HW atomics we ignore max_sectors and just pay attention to 
max_hw_sectors.

For any normal IO, the block layer can slice and dice the IO any way it 
wants. HW atomics are not like this, and the IO must be submitted as a 
single bio/request. For any dynamically changing HW atomic limits, we 
would always have the TOCTOU challenge, i.e. bdev limits can change 
between checking atomic limits and submitting an atomic IO.

> 
> Sure, they are initially populated by the hardware values, but the
> user can then override them (e.g. via udev rules) and that means we
> don't have need to add 'override the <bdev queue property>'
> management interfaces to every filesystem that supports those
> specific bdev hardware offloads.
> 
>> Then for the only block drivers which today support atomic - NVMe and SCSI -
>> similarly these we just use the atomic limits reported in the disk.
> That seems to be inconsistent with how we manage other hardware
> offload size limits on block devices. These are -not- filesystem
> properties, and we should not be trying to manage them at the
> filesystem level.

As mentioned, HW atomic IO is special in this regard. Now for XFS we do 
read the limits once at mount time. We could read the limits dynamically 
instead, but it still has the TOCTOU problem, above.

Thanks,
John


