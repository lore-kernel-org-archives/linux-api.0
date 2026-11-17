Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794882271;
	b=qEVLQIssOqsKYuKzO4RcF1jIZ11w71oVuJMbgDvtRbXipeuAIHGZm/6z4/kbvE9RMcmM
	 5vFvEf8313HIVkP5L14nzQn3UMNxiF22LLKw37Y9PEpaxTOT+EKho/Jo3Si+0JNi5r97L
	 QoeOrGA+GWbvtab1POvl5hN1+AJyjypzO3BxBvKOONM4G/0Ud3sg715TnxKZAG7WCk22V
	 Y1zqU0Ge31U52yFARQBq+UhWqbF+26YUvHIXjUEWwxd4eTBnLpr6y60o2NgXC0onkzxEK
	 rNXrcGCLo9Qjqb6/Wzc69zDhbXNfe6WfGcIRGU4i3c8VyDbnD7ANchKDGWDGWYuHumw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794882271;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=01IGULUu8K1iyOvpVFwG1UrKHNiQ++Ld6mpinjw7ge8=;
	b=To3lS2zrUmd7Pg+rOx3yqt/Ab3AMavbMtGG/FeUo4qm4LAE7EaYdIGT0VwO89D4ysbB1
	 +IY0V633nBUlhIailoFwC51CxIQAl8VvQn4HCgP3Pt3ftJAWTgWnLe/m+22aXSaN85XWt
	 ++Opr8axvNQuUogl0DBPFI8Mtr3tNMHPlPZhbPDOrgtRpZc30v3LOZdyez7fqoVbvHeV/
	 JrB0SMwLR9XUzMX7Bu+z//KH938vVBt0D0tNKtdFABJXpAOOES8Xp84RskuJROtwYDdwh
	 tiyojpFGw9VeWgm8NikIfWlc2Qb4reh/1IWVjIQfcTIueBiZGpaAOzoaH1qcdLgfb1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fmR77tJk;
	arc=none smtp.remote-ip=95.215.58.137
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3A7606A329
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 02:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B3A7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fmR77tJk
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=01IGULUu8K1iyOvpVFwG1UrKHNiQ++Ld6mpinjw7ge8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794882268; v=1; x=1795487068;
 b=fmR77tJkABHZLJQYMRgthpaJFBCYIDL/W/X6XdFmwKpZGU62qfijNEZI0vgkunURWH+tm6qq
 NSHwVTvWk4mF4Kq2hT3lFmlV9+nJe4H8ivgjIl/h/cK6dwN0w4zERCCh6nAApGSkzZsTtyDGAfz
 3WNXmsy03QdbIMKX5klEKWA4=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 60f46d3006f9954f;
	Tue, 17 Nov 2026 02:24:28 +0000
X-Mizu-Trace-ID: 60f46d3006f9954f
X-Migadu-Flow: FLOW_OUT
Message-ID: <efce8f30-33f9-451a-b2a8-89ca0a39917c@linux.dev>
Date: Tue, 17 Nov 2026 03:24:27 +0100
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
Subject: Re: [PATCH v4 1/2] platform/x86: asus-wmi: add TUF keyboard RGB
 readback support
To: bartu alev <bartualev@gmail.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Corentin Chary <corentin.chary@gmail.com>, "Luke D. Jones"
 <luke@ljones.dev>, Hans de Goede <hansg@kernel.org>,
 platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>
References: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
 <20261029-asus-tuf-rgb-v4-v4-1-0d3b877d2c30@gmail.com>
 <cc9c8655-6f7c-05f9-ad09-4ea30f1dda95@linux.intel.com>
 <228df241-da5e-49cb-b29f-6b9158557f55@gmail.com>
 <def9fb29-3212-4d1f-8041-4bbb1c18e89e@linux.dev>
 <068991e6-ca31-41b5-b9ed-f0902eae8368@gmail.com>
Content-Language: en-US
From: Denis Benato <denis.benato@linux.dev>
In-Reply-To: <068991e6-ca31-41b5-b9ed-f0902eae8368@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/17/26 01:07, bartu alev wrote:
> On 11/17/26 2:53 AM, Denis Benato wrote:
>
>> Yes, it's absolutely reasonable. If the return either doesn't have the
>> presence bit set or is 0xFFF..... it is to be counted as "not implemented".
>>
>> And also yes, we should respect ABIs whenever possible...
>>
>> However... now that I think about it asus_wmi_evaluate_method_buf() can
>> be used on setters and those don't have the presence bit, do we have that
>> covered?
> yes that wont break setters:
>
> 1. asus_wmi_evaluate_method_buf() is strictly a buffer-getter helper (its
>    comment states it returns an error whenever the ACPI output is not a
>    buffer).  Integer-returning DEVS setters use
> asus_wmi_evaluate_method*() /
>    asus_wmi_set_devstate() instead; even today, passing an integer `1`
>    from DEVS through _buf() returns 1 as an error.

Yeah I checked: only one caller. Make it check for known -ENODEV:
0xff...fe.

The only reference (as far as I can tell) to ~0 being "absent" is this:
absent=(l==0xffffffff);
inside asus_rfkill_hotplug, maybe you can exclude checking for that,
albeit it's not going to harm.

Perhaps add proper kernel-doc to that function where possible
errors are documented as well as input parameters.

> 2. We wouldn't check ASUS_WMI_DSTS_PRESENCE_BIT in _buf() at all.  A
>    buffer-returning call (getter or setter) still hits `case
>    ACPI_TYPE_BUFFER` and returns 0 unchanged.  Only `case ACPI_TYPE_INTEGER`
>    changes to decode via `u32 retval`:
>    - 0xfffffffe or (u32)~0 (0xffffffff) -> -ENODEV
>    - 0 or any other integer               -> -ENODATA (matching `default:`)

Sorry I am a bit spoiled by the past work of Marco where he reorganized
the whole thing.

We should really revive that, but it's a long work that touches quite a bit of
very old code...

> Then only kbd_rgb_read_status() maps -ENODATA -> -ENODEV so FX505DT /
> 0-returning firmware matches the ABI without altering setter or legacy
> buffer semantics.

Good. Very good.

