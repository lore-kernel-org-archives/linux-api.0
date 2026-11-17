Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874068;
	b=yiZfo0UhpJF52rUE2RHauIRBmlEehjfrnGMdNGxBCxDWjT9mK+opcSEs1xRbSPoAc/Iv
	 ShT5UNr44blvNfJno7Nc1EeQP7m8L+9dg3zLQCYWMkjm4Zxzi0+Ii2G21umWdPlUpAceL
	 +UDF1Rut7aaP0Etl77PsBkGRxvshl8Ly8KC/q4eHnuVrZKV/uF9xBi+UHzMwGf2wTGDCe
	 +Y0G+KDO7pIy2LBKnlU3SqatEE776mmGEBy9xYOJ8gbC+lrp2hJGjDe2Rif5dxYbtAnKX
	 JcXeOuu+YQkJsN/4lizikFS7jMJQQo6JV0HqkoLJ4tuufHL8VF+saYXoN0YE7vT6rAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=A+yWjVg/RgP8llwsT9E3rZE971DL0mW9b4bpk6DiidE=;
	b=ehdwCOCMhHPSbJnsWRVxf9kuxVr3u/7IB7EW4ZAgV2QcJrVeUWVvccz9lXpM6Yv9AuIi
	 uqdEjKOvS7HCYzHJLiy2+Fjs0oG5VPK4KJlaJDwsSbh7DBrscgP1W9KSapti0s8DDyyDe
	 2wp3UAcTKQcT7sYEulpiQV0Gg7+FgRoAainamsR5dWUUox5NObcfLz/EOkxXQKIZGUCCQ
	 OzfNwsMGKdPxDBtgy3FhfMg9IWEYI+AGAaACmrAftKciaRb3HncSPYUTXI2VBCfQkyaoO
	 kIE1dykuqHu3sv9NVVq3aWtyvdAcAZYn3kjLNS/oNK1Ch/YKoC3TWQ8YjhR7MGqvxPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L5AeQR09;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EEA606A329
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 00:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10EEA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L5AeQR09
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so11840545e9.0
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 16:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794874066; x=1795478866; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A+yWjVg/RgP8llwsT9E3rZE971DL0mW9b4bpk6DiidE=;
        b=L5AeQR09zRlNinlR0coJoNG6PEssD7POoJ42cgTVSFxn9Vi/t6WT6kwKcKfeVmKN16
         6ol17jStcLbBpf4sSJzL0nDihWHydZD7q/4IbWDEZKo1N12fY0szn5QkYYQxLUWbaGmE
         iD1VXlDrNNyH3lmKRthWt4F0n/v/jU3eN5bcmKYTNEGla/0+oI+ui95tpmSlOSIoQS88
         TJ2YBZ9vgQyP3b3bkiyZZrZmw65dmmNzqsbgj202oUodkbjPegYYQU8jNwGWaq9M1tpP
         8h7mW1wWiZT1GKDJZBwitNaSgGscNiQCuzRXifgyd+J9NNgRFxJa4n9XWjKKyYeablv9
         fYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794874066; x=1795478866;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A+yWjVg/RgP8llwsT9E3rZE971DL0mW9b4bpk6DiidE=;
        b=AnMa5UcDZukiF+RUTUOIGb3z90uw3rS5DSjYNSwPJRUt/I1zsFD2SUcWZUg7qqJOO3
         zPJntDyaAP5WBST6zR7h9S/CQsqNgmU3DzLkwRbUxEdeGiIYtVy6MX5fotKhSYwTdOIB
         Eo/01/s/QGCFj/bR2UeoUvU1RAEZWU/GvD2loIi99+nNf78paBliwXcirzjpse7bvgCe
         r0bZ5BtYt4e3gj1C+Zr849CKxkJ+YhDKIyW6te6lY9ExbUifqflSuQns/Ey8am7z0AnV
         fyBTmp4duIB1RM1EaEKTOevWXe+77Ko1ieuz+XNgmoWlNuyph8NVEN7ypKopFMP9k/bu
         TIcA==
X-Forwarded-Encrypted: i=1; AL+hErEtU87NFzHHXwHj7B3BnvSnu2aG7T4S2o53AX5jtDWBxtF0k976hHCeMEfEKPJmPptMCC0+ydmkDDQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8mPvIupJgWwTLXznTyzvbSw2W6LqTcaykV/xvh6W0VLYjL3GdI
	5uOnd5yOYdIIwef42W5kdEdIZLvDPmc23FmpepfsoQ852WG7x6yoMRQv
X-Gm-Gg: AYBFou29P3mU5NPp9gv4PlMGGCvkKAvdjoAUNY3L7+AGlhyyz88FWOT1nwDTYpr0xY6
	oCzY+QYAnwI080oh3l9zflYMp90vagMEFEVMzp/4U63xvCXT/78UQzQy+zHwm4ksLVFPn6JFRNf
	SjGplCx9sZaRPKItPk7IP0GqgArwBXmo4h2DUkjI9yL4dJZOG4RdaO8WCrHzmFkInHINWjjp0D/
	gsDquPkLEVp12iqysLTM7biJFKgNQ+LCl7jb9RPnIKAeSzfpaJZg8L90d8uI3Qj545aykPqLluI
	pBEDsQJTOPXCC3C/bo7XORNH5iJUVcUuGcjjFvRBgnsW1Qs9rIV23dAsWzIW9V4a6PGet4ESikc
	H4UnIxffC/TkiI9VQzQHW39oFlVcS3mNIQFWAn0AZDL+9KSWZ6iZW8/JuBawoxkjkbPjwgQcnHU
	/t6K40TFaAa17D+AZ6O0zwWV4C/Ku/n5OoHyjNpcGH2/4zT7l3IH7Fqwln2sNQqwGEeqQYtJW8s
	Ud5nYhk8X+pyIJi9TBCA/yZXLNlp+JoZs0s1TJ8MSDCDr8AsiIEcKDukLmEe1Fe2PMnWyAxmyP4
	QMWXY9lM08fJrpx7u3tvCOEUgcVy
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr261294925e9.34.1794874066208;
        Mon, 16 Nov 2026 16:07:46 -0800 (PST)
Received: from [10.10.0.26] ([85.105.252.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7839cad7sm26779855e9.10.2026.11.16.16.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 16:07:45 -0800 (PST)
Message-ID: <068991e6-ca31-41b5-b9ed-f0902eae8368@gmail.com>
Date: Tue, 17 Nov 2026 03:07:41 +0300
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
To: Denis Benato <denis.benato@linux.dev>,
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
Content-Language: en-US
From: bartu alev <bartualev@gmail.com>
In-Reply-To: <def9fb29-3212-4d1f-8041-4bbb1c18e89e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/17/26 2:53 AM, Denis Benato wrote:

> Yes, it's absolutely reasonable. If the return either doesn't have the
> presence bit set or is 0xFFF..... it is to be counted as "not implemented".
>
> And also yes, we should respect ABIs whenever possible...
>
> However... now that I think about it asus_wmi_evaluate_method_buf() can
> be used on setters and those don't have the presence bit, do we have that
> covered?
yes that wont break setters:

1. asus_wmi_evaluate_method_buf() is strictly a buffer-getter helper (its
   comment states it returns an error whenever the ACPI output is not a
   buffer).  Integer-returning DEVS setters use
asus_wmi_evaluate_method*() /
   asus_wmi_set_devstate() instead; even today, passing an integer `1`
   from DEVS through _buf() returns 1 as an error.

2. We wouldn't check ASUS_WMI_DSTS_PRESENCE_BIT in _buf() at all.  A
   buffer-returning call (getter or setter) still hits `case
   ACPI_TYPE_BUFFER` and returns 0 unchanged.  Only `case ACPI_TYPE_INTEGER`
   changes to decode via `u32 retval`:
   - 0xfffffffe or (u32)~0 (0xffffffff) -> -ENODEV
   - 0 or any other integer               -> -ENODATA (matching `default:`)

Then only kbd_rgb_read_status() maps -ENODATA -> -ENODEV so FX505DT /
0-returning firmware matches the ABI without altering setter or legacy
buffer semantics.
