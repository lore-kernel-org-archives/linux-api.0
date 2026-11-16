Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794866427;
	b=B26s2yOpYCYErB3mgXxRd6/vQNCg+hiqGAopYCmVrLkdzdvtnVirqGtwQUzmnB+yljC3
	 s9utcb5gpbPwNhtK6llQBRd77WSFy3g1gjpiQtJhoVL8Kgi1yu/K+pmBWbnnOjeaoxz7e
	 PcTo94ZflWhqyBC5ZcrJSX0UwBUaOvZP7CuT3cpHtiYIS/Kv52CQ8mrEMGeY5LhgKXEIQ
	 p0DSKH2dkQvQm0j9Ojo2z+oYwrHKk58/jLZAfFBI17WfDuto7Li2nRnf3kSLjLIqi0I3l
	 JlSQzyVopgHMOhFgpelWCkYdt4N2mF02AVqbHn7GmvtDzcHwMboTPWFH8/NJAzIcgBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794866427;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=BTPE9Q1KzFgXOzghIcy1Do+zsJcn2B9P+6aO9CoEBkg=;
	b=LPJ7dWt3O+KznDSZQCvGf8tfWPCImkiEz50t1VyFxnKt9a36u4hIjAUcJEX3c9TDjs54
	 LrPcR3bSN7QqmzOev6PoWRpof+n9+WzBIfD8SPRTwSa+thQZTl3kbM9C7DUy8+kg3Lsnf
	 Gkf+HwLAXjOkRB7lbSrX+Ca2h/kh0dpTJD8nf3s3/57rnBNl8hLqUr741NiZ7id8fQYpz
	 vwU1J3uPb2rKVaHcH008pmRJm4BzVPVqzP5VdqkNCBJ3jFA54KkpI/Hc4J2Y7bN4xij/Y
	 bQYk8SR7j5plb1LPHy+TLeaQs0apejQ1y2K17VHeIS4aTvHlVZaWATOsvPXuvGmW56Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wgaz3sxI;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25CE606A33E
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 22:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A25CE606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wgaz3sxI
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so48315945e9.2
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 14:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794866425; x=1795471225; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTPE9Q1KzFgXOzghIcy1Do+zsJcn2B9P+6aO9CoEBkg=;
        b=Wgaz3sxIxWZLDFT7xVEdmX1ppNgZ14lH2Bd/pkkQY8LuwSm23WSJcoASZdiEoRzwgY
         NrDnUGRd8QWiPBQaGHTSVC3t/pfUMPwHHDcS6QN4v/rhN4wcNK+PQW58WH9kQyQh51/m
         dodS6K1TM1o95Uso14CGLlGiQg+16nqE76ucJu+hS8G1eDddvX5CmuQKKYzcYv+lHhiW
         QsraJwnG1B74v4hIV4DQcwYn+NAEt5Px5tM+fx+hA/Li4DkDMHyRmupnWh4tg+1nAAGd
         PX1eRA47BtO4ClJlF/DMwUrc9Bnw4tkHBPbbcwTtOdOOCduf50BdrndDMGZh5wGc0uyb
         ELFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794866425; x=1795471225;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BTPE9Q1KzFgXOzghIcy1Do+zsJcn2B9P+6aO9CoEBkg=;
        b=2x7WQjeYCZ7WgOF/GhK6IjrwOns4ZBPFDOQCC+PIrOMwW7B/N5K68HUY0FIzGUjYMl
         aGeKiG6CVlJ8tm0FTU+a8ueg54vt1N00y0R0vQnQ6fvHljURsLuBWG7gPVgxMGgcRJin
         diZISWc6/2f2ZuZCdvhZds3q/0Suercq9reqadMykQdwv0MEU7UvRcoW8bsUt8xnTtLP
         V2stSfWJSXx1a4a3xSexhYlTt6WzdxUwFcOf9MTQOu6PCZuPb2CMziVoBJMOO8U/vT71
         HXt7WJ9rmbL1ihPgYEfCuQqfPbfrQt7MTCKaXwWf9wZVscbfXU0XSh8HrlgWXlIyF14o
         E6tw==
X-Forwarded-Encrypted: i=1; AL+hErFJp0S6JBsF6it7kqtfeeLjBnxALvag7ZR/hoiaEMk7ZtY/AmnoM0+Eyuq/tOBZAgCJna55a3nQIZ0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/zRe2ZEAYxIID7WcJIEicPM1PUdKe5F8Gt9PAAAUByrG0EJ8TY
	I1swn5iKJWCzDNpjMWoVeTBAKoGb3zVDWVpMePZtRDDflP4oJxTezxPO
X-Gm-Gg: AYBFou227PpFoftPGtZ0LD/EihF+C0ivyzCrp1Vo1r5RM5OZEOYhpB90qXv9xNUbl/1
	PR7tysWuHlMDmCVl7A9qbYy4Ey3YbQjPB8nkj+y9w3JPX7dohFHvDUZd5rNwm79PkNnBwIk01l5
	N0ecFI3cpl/s5Sk/7RhksM/A5BptnUSzGWKUUdCmW2MsTb+PzWrz9+IhWpWsexSmj6mwHtPEygj
	7lY+HOI155m7XQYedoaICxUV3DiCtfXfLfg1/Q/xpjYCC+30niOIiVpX3iuk2gaZn5MvQCODDlP
	GH9dcRpZaiTHrWk6zyuZGxBT9kWIsv6ccl5LVJED1X33BJ0pCPclFp37P5VGj47Zyefd97j0kWC
	o9QAp/HDN3oZRu73OYhTdAWelZocITHj8aUp1ZIbaapfQr8RucpQhCTbQ14Dxg5OTsvt42+zcXw
	S0KKjAosQ9Wgo1Jt1yUU/kewMkLCMa2WZYYipeZp4idl8eJLYNx76WTy/1UvtYr3UOUl2uLkGnP
	YjDRZ5FtFQ4eiPYqjrAiJagv+/90icCNc79JtG11+/Inb0oT54iJupzkFsFyNXHnrqUmSU9MIY1
	527Ks+SVcp7XSHsg70Xy+Xx8iVuPLw==
X-Received: by 2002:a05:600c:34d0:b0:4a2:133:45e1 with SMTP id 5b1f17b1804b1-4bb55a59f41mr249245185e9.24.1794866424901;
        Mon, 16 Nov 2026 14:00:24 -0800 (PST)
Received: from [10.10.0.26] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56f97257sm207857645e9.4.2026.11.16.14.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:00:24 -0800 (PST)
Message-ID: <228df241-da5e-49cb-b29f-6b9158557f55@gmail.com>
Date: Tue, 17 Nov 2026 01:00:20 +0300
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
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Denis Benato <denis.benato@linux.dev>
Cc: Corentin Chary <corentin.chary@gmail.com>, "Luke D. Jones"
 <luke@ljones.dev>, Hans de Goede <hansg@kernel.org>,
 platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 linux-api@vger.kernel.org, Denis Benato <benato.denis96@gmail.com>
References: <20261029-asus-tuf-rgb-v4-v4-0-0d3b877d2c30@gmail.com>
 <20261029-asus-tuf-rgb-v4-v4-1-0d3b877d2c30@gmail.com>
 <cc9c8655-6f7c-05f9-ad09-4ea30f1dda95@linux.intel.com>
Content-Language: en-US
From: bartu alev <bartualev@gmail.com>
In-Reply-To: <cc9c8655-6f7c-05f9-ad09-4ea30f1dda95@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/9/26 9:02 PM, Ilpo Järvinen wrote:
> What do you (or Denis) think on sashiko's mention about 
> asus_wmi_evaluate_method_buf() casting integer.value to int which might 
> end up aliasing high-bit on return values with errnos?
> 
> The other caller seems to also return that value directly out of _store 
> function().

Hi Ilpo and Denis,

I checked the DSDTs across 102 ASUS models we have dumped as well as the
UEFI/SMM path on my FA507NV (BIOS 318) to see what firmware actually
returns on the DSTS path:

1. Across the 102 DSDTs, no static DSTS branch returns 0xFFFFFFFF or
   Ones. Models without 0x0010005B either hit a DSTS tail of
   0xFFFFFFFE (15), fall through to WMNB's trailing 0xFFFFFFFE (45),
   or return Zero (3 older models: GL553VD, GL553VE, FX505DT).

2. On modern models (including FA507NV, FX517, GA403, GA605WI), DSTS
   delegates unlisted DEVIDs via WCHK/W15H (SW SMI 0xAA, cmd 0x9603).
   Disassembling the FA507NV modules (AsusSmmService ->
   AsusWmiToProtocol -> QuantaDxeWrapperPkg) shows that this dynamic
   chain also returns 0 (unmatched consumer / missing table entry), 1,
   capability/presence bits (e.g. 0x00010000 for 0x00100056/57), MMIO
   reads, or 0xFFFFFFFE -- never 0xFFFFFFFF.

   (Note: on FA507NV, 0x0010005B itself is static in AML and calls
   EC0.KBLS(), while 0x00100056/57 go through WCHK/W15H and return
   0x00010000 on DSTS.)

However, checking those tables did uncover one real mismatch and a clean
reason to still harden asus_wmi_evaluate_method_buf():

- On models like FX505DT, DSTS(0x00100056/57) returns 0x00010000 (so
  kbd_rgb_mode/kbd_rgb_state are registered), while 0x0010005B hits the
  DSTS tail Return (Zero).  asus_wmi_evaluate_method_buf() turns 0 into
  -ENODATA, so v4's `err < 0 ? err : -ENODEV` would return -ENODATA
  instead of -ENODEV as documented in the ABI patch.  The same happens
  if W15H hits an unmatched consumer/table miss in SMM (returns 0).

- Even though 0xFFFFFFFF didn't show up in this set, an unseen BIOS or
  SMM branch returning 0xFFFFFFFF or any bit-31-set integer would still
  alias a negative errno in asus_wmi_evaluate_method_buf().

To avoid disturbing older devices, would a minimal approach like this be
acceptable for v5?

1. Add a small prep patch to asus_wmi_evaluate_method_buf() using a u32
   retval: keep 0xFFFFFFFE -> -ENODEV and 0 -> -ENODATA as today, also
   map (u32)~0 (0xFFFFFFFF) -> -ENODEV (matching asus_wmi_get_devstate()),
   and return -ENODATA for any other unexpected integer (matching the
   `default:` case; the only existing caller fan_curve_get_factory_default()
   already treats any non-zero return as failure).

2. In kbd_rgb_read_status(), translate -ENODATA to -ENODEV so FX505DT /
   0-returning firmware matches the ABI while preserving -EIO / -ENOSPC.

Thanks,
Bartu
