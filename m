Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873225;
	b=eFLLnjrnnQ5hK+iVv2Ww6Mnv7DrUvJuivEBW7goaZGbFKA3CVeQd7Rxgz55jpcqVhEyP
	 ODKlqUmHkH479HZvJ4wts+LX8+njud0qJAaAl9QawmXoJ6NlhIEjIYMnjChhIVEdZeVf9
	 iFmlPikzNe9bT6IDRIgVB7WjJDMl3IhEokjHE+bQE9Fu/t1QtoruwPMYVgYXiKmgeRikm
	 iojRo7xi8CueGJYi2lrXBORo8yKkHvbVbe7rCwE+94XV+ACMEDSknMIhxRwQPhTcg/4bQ
	 wG9N3vUZrRG9Fbhzt63bxcSFzIZjeWjN7deljke4+dFkkSHfX4G2PK60FxdYUHZcmvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873225;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=NNrK36daNZtQN0yQpzsNCwHN/e1UlEP86bn5liD8cbA=;
	b=j/q4Ti52nvr71l5mDska0oP1K44dJ+A9mX+lyXiMddp/GfvGnl8DCKvugYPUzDddOq0p
	 wPGa/J9qp9tOrVlGmUh3uIvAl7QmdGq/J4zsHg1OYW6k7MqPllhS9UzvWeP9IxiSR12cj
	 efW/V2jgC3hu9mxSMZpRrY2lJEuENZ1QVL4EDzqxxiDZgkDlqi4DCqI4o4WLqZ3ok/jnB
	 P9xlkqbWqjLC6gw3e+jyZoI4bUVoBF7yppvMiG4zGu29HhxDQCURXo3Hj+6iw5t5msdmt
	 qssXUd64BVGiRapwJkMMPDyONL8Is9K5DwFJa18z6hntdzH8glAcIVua2Jo6EZjA/zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=95.215.58.169
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF43606A329
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 23:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACF43606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NNrK36daNZtQN0yQpzsNCwHN/e1UlEP86bn5liD8cbA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794873217; v=1; x=1795478017;
 b=ZEpmsOQOBxwsaBy/JoIlh/lFTwA9kQHivTVw3eBBUA77yH0OYbq44NoBrLGQ3c8nFesrA3ay
 pbOJHUbTTNzFCTmxyS7i2RAHdwL2rpklMeHOtoZIZi9FV8cQyjHiApUKcrfk0BvzWNXzi2JNDCo
 vtOAdsAO4VQ/6J57veZ4ZoF4=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a333d897c954cd59;
	Mon, 16 Nov 2026 23:53:37 +0000
X-Mizu-Trace-ID: a333d897c954cd59
X-Migadu-Flow: FLOW_OUT
Message-ID: <def9fb29-3212-4d1f-8041-4bbb1c18e89e@linux.dev>
Date: Tue, 17 Nov 2026 00:53:34 +0100
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
Content-Language: en-US
From: Denis Benato <denis.benato@linux.dev>
In-Reply-To: <228df241-da5e-49cb-b29f-6b9158557f55@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/16/26 23:00, bartu alev wrote:
> On 11/9/26 9:02 PM, Ilpo Järvinen wrote:
>> What do you (or Denis) think on sashiko's mention about 
>> asus_wmi_evaluate_method_buf() casting integer.value to int which might 
>> end up aliasing high-bit on return values with errnos?
>>  
>> The other caller seems to also return that value directly out of _store 
>> function().
> Hi Ilpo and Denis,
>
> I checked the DSDTs across 102 ASUS models we have dumped as well as the
> UEFI/SMM path on my FA507NV (BIOS 318) to see what firmware actually
> returns on the DSTS path:
>
> 1. Across the 102 DSDTs, no static DSTS branch returns 0xFFFFFFFF or
>    Ones. Models without 0x0010005B either hit a DSTS tail of
>    0xFFFFFFFE (15), fall through to WMNB's trailing 0xFFFFFFFE (45),
>    or return Zero (3 older models: GL553VD, GL553VE, FX505DT).
>
> 2. On modern models (including FA507NV, FX517, GA403, GA605WI), DSTS
>    delegates unlisted DEVIDs via WCHK/W15H (SW SMI 0xAA, cmd 0x9603).
>    Disassembling the FA507NV modules (AsusSmmService ->
>    AsusWmiToProtocol -> QuantaDxeWrapperPkg) shows that this dynamic
>    chain also returns 0 (unmatched consumer / missing table entry), 1,
>    capability/presence bits (e.g. 0x00010000 for 0x00100056/57), MMIO
>    reads, or 0xFFFFFFFE -- never 0xFFFFFFFF.
>
>    (Note: on FA507NV, 0x0010005B itself is static in AML and calls
>    EC0.KBLS(), while 0x00100056/57 go through WCHK/W15H and return
>    0x00010000 on DSTS.)
>
> However, checking those tables did uncover one real mismatch and a clean
> reason to still harden asus_wmi_evaluate_method_buf():
>
> - On models like FX505DT, DSTS(0x00100056/57) returns 0x00010000 (so
>   kbd_rgb_mode/kbd_rgb_state are registered), while 0x0010005B hits the
>   DSTS tail Return (Zero).  asus_wmi_evaluate_method_buf() turns 0 into
>   -ENODATA, so v4's `err < 0 ? err : -ENODEV` would return -ENODATA
>   instead of -ENODEV as documented in the ABI patch.  The same happens
>   if W15H hits an unmatched consumer/table miss in SMM (returns 0).

Not good.

> - Even though 0xFFFFFFFF didn't show up in this set, an unseen BIOS or
>   SMM branch returning 0xFFFFFFFF or any bit-31-set integer would still
>   alias a negative errno in asus_wmi_evaluate_method_buf().

Yeah this much is clear, as I said we are lucky asus isn't using the
most significant bit on wmi dev id we support.

> To avoid disturbing older devices, would a minimal approach like this be
> acceptable for v5?
>
> 1. Add a small prep patch to asus_wmi_evaluate_method_buf() using a u32
>    retval: keep 0xFFFFFFFE -> -ENODEV and 0 -> -ENODATA as today, also
>    map (u32)~0 (0xFFFFFFFF) -> -ENODEV (matching asus_wmi_get_devstate()),
>    and return -ENODATA for any other unexpected integer (matching the
>    `default:` case; the only existing caller fan_curve_get_factory_default()
>    already treats any non-zero return as failure).
>
> 2. In kbd_rgb_read_status(), translate -ENODATA to -ENODEV so FX505DT /
>    0-returning firmware matches the ABI while preserving -EIO / -ENOSPC.

Yes, it's absolutely reasonable. If the return either doesn't have the
presence bit set or is 0xFFF..... it is to be counted as "not implemented".

And also yes, we should respect ABIs whenever possible...

However... now that I think about it asus_wmi_evaluate_method_buf() can
be used on setters and those don't have the presence bit, do we have that
covered?

> Thanks,
> Bartu
