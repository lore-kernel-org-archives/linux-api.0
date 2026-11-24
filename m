Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509180;
	b=ELqKW/zFEIP6dkJnPa8mPHehXi/e1XMP4ABuySaJ5rwsOAVgDQv3KuvqykIY7JBxBJnb
	 UP6w9Pz8kbkkY8yC/r70OBW/a/UlZXZaGonheaLl1FCdlyvv3hkGo35WRyIgMu46MmZRl
	 Tf/a/oV9fyVl0QXpx+jFIxezqXpjDF9W9VH1jAp1ChMBaTakxGsulw/s0dLQMuVHcm/h2
	 zzL+Y57Wznb44J1qZhZ+e9Z9MIX9n8/21nzA1vJMJZExFI55RnkUqttOKECz/Fuzo1ZW3
	 9twB/YhZ3HiOD6bL4Lz1c6PsOMpmTH+Cn3+ov+eTNzjb3lhSdAWZiJUOCYr/to9bGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509180;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=LPO48vD7S5neEvyJHFuA9R1n4Q5zbn7PJYAh8OnsRdY=;
	b=dqo7ma25JcaUxNTspai+x1Zk+6bAOfTO58mzRbspM39hf/8YW1co4Qx1iWUWgE693v3p
	 YIYi0bQ5vorQvDU52b5OV3KubDeaOznnvARued6MXOour8pDlTKBUUtIME2DCPJafsDdu
	 GteH9MNmBQLzAIFhkIK7iI/mxwvQ0nnukm2k61Kzg7ju61CcCUK/kQsDF2uoVY238sioR
	 SLvyrjCJVV8XNKSBhyCmK3dNyZTRIIj8xhyI+MP7Qu+HloLuDLJ1x4ZWnw77xJgfUovOW
	 wQ8JcAscDenVwd1KfUMpwEHhroZD6WHHSEojuxs+M5x9Uh8NsSiS3+odxF0HLbKvrVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QCLMA9d8;
	arc=none smtp.remote-ip=91.218.175.114
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2B606A696
	for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 08:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50F2B606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QCLMA9d8
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ak6FxQoWbpRq2lWcWMnO0gPGQPBuoAXUUj1aeDgPrMQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795509177; v=1; x=1796113977;
 b=QCLMA9d8cZ/yEP+wr8Z7H4euilBqfwFtXNtimp0aEGGML00eXnbstZxYt3YcX4G3/SL+xdPz
 8TnKYZOy96D6oM79iwjQUaZA2DeHp/fp1G1y4dtPjKsrGREmT5ZFPUhkHVZJ6L2IvLzzlAkzSEg
 rIgDciMxXgy2V/TYpkFfewYs=
X-Envelope-To: linux-api@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id ce3c8b98f12528e6;
	Tue, 24 Nov 2026 08:32:57 +0000
X-Mizu-Trace-ID: ce3c8b98f12528e6
X-Migadu-Flow: FLOW_OUT
Message-ID: <2a615ca6-3777-4b71-bea6-4072d4fbd950@linux.dev>
Date: Tue, 24 Nov 2026 08:32:56 +0000
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
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
To: Dave Chinner <dgc@kernel.org>, Wayne Gao <Wayne.Gao1@solidigm.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
 <awSd1JEB0F4WeKt0@dread>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <awSd1JEB0F4WeKt0@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 20:11, Dave Chinner wrote:
>> The intended use is a controlled comparison of hardware-backed and
>> software-backed RWF_ATOMIC writes on the same hardware, without having
>> to construct misaligned mappings to trigger fallback. The existing
>> DEBUG-only always_cow control also affects ordinary writes, which
>> changes the workload being compared.
> Ok, so you want it for your test/dev environment, not production?
> 
> I thought we could already change the block device characteristics (i.e. support hw
> atomic wirite or not) at the block device level?

The block layer just accepts whatever atomic properties is reported by 
the block driver and there is no method in the block layer to change 
these limits or turn them off.

Then for the only block drivers which today support atomic - NVMe and 
SCSI - similarly these we just use the atomic limits reported in the disk.

> If so, why do we
> need this at the fs level? If not, why isn't it the hardware atomic
> write behaviour configurable at the bdev level?
> 
Thanks,
John
