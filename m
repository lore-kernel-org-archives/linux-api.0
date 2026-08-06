Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBCF36DA04
	for <linux-api@vger.kernel.org>; Thu,  6 Aug 2026 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036146; cv=none; b=FOQw9JBZdjR/vQKAQBx8ramy435sj3CtdYlml1maeSqhmDhlutpW9wbHGnIV5nmgW3r9ojLYRGaA4DocTcPTiWgdGTsmNu0R+Gk+cN9GmLiHUTv2nzJc9HuQJXL745YdcMAeRFExjY02oswFS6B+CPVJ0w9hAUOq6wl262VuoJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036146; c=relaxed/simple;
	bh=6hRNj5U5LHXK7bTyvRwzyPiI+ao/2UL0HBM81PAHajM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSI7I/lJGj0CWY635be0t2EN8StyvZG8JPl2+lgj9VSRrB4pT7oUdt0zCGHTpSCHJXlQxCW8i7D/CRa/QBH4eJJvygg53n9wHNm+vYx+w6D9Lh75+ZveqDOuDyuCoz8aOJNqNNb7m5FdUx/i/h+KzMLxDNL4X0dbwflGkhqQ1sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=G2pLPsTG; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="G2pLPsTG"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4591f35aff3so1135388fac.2
        for <linux-api@vger.kernel.org>; Thu, 06 Aug 2026 10:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1786036143; x=1786640943; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TLsWRBhfzXCtfwMjhcYY+QYQpCsTl2+rExgA5K9laCM=;
        b=G2pLPsTGzHib99otyS6YPI1EDVKK5lDemxjg5hBoOWGH+SdHBVPfuWb3dcUXLXhfuz
         sRC9FBQFErtV2DWJEfxWVtDXSp++nb7ZY+rPViF4BxMkZwgxKRLf2J/BsQzyoSHKw4qt
         /LLCOB6DXjSsFlQKwC3U4Zty0vUjTEyU7JYVO5OCUDBBAi9u6H/1uE4+O5qkVNpCOc+y
         7uqYpQe6hx1eYf2yC7wxN1hg/WKrXdGxMK9E25MYHUKGNyckCxQoNZXX9bx7tqvQ8L3V
         Rpz49Dg+mHU55iHudysgYqHZAJs40Si4BRrm4PIpXpK7PZvMtnDqJhHVwO2lkfTblKGq
         m43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786036143; x=1786640943;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TLsWRBhfzXCtfwMjhcYY+QYQpCsTl2+rExgA5K9laCM=;
        b=OBT+UXF8HFX99yab7jlUIZyHRvHnNHFB8AK4iNGY6AMWP+ex2CbEqDYYETcM77PZOk
         tVhVAb/PgZi8za2onZyVaViuhT7Qo4Xv2xqUFhelTt0frNgD27YlyC3vTXAwKQrNyfH2
         5PDEPkYtOdbVOgxeqtfBh6RwM+PcPDwCpHTlUMF+wCmFDpK8CSGZTHOWF31iOEqENM7C
         6O+Bm4vohGbuC0q3V92VN4mPpIb43vqwSMJQvoPTW5YqWpCrY8SMWjMnLO385IKTimav
         BemasThaOg4oyjrPge5CmzyB8Sbut+Qbzh0Kk6k30vqA/yCDA123P+ixjPe12MHOJvNe
         2UBg==
X-Forwarded-Encrypted: i=1; AHgh+RoVTBLM0CKoqUkN/vEbFLbGstJd1CEuITZXQh/NVzMXkQoof9KS0LPbgS5stBLelPlHRvsddCXtqmE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx27qMAfmkgTJyIC6qNIMaFPm5dxRRIXBXTW6YXVVpUhOOjKE2Z
	NIAp+Wz7w4t4l8XacmOXM3iCXFu79WmTdayrENbeiw2PTGBBUK5827cg12t2jlEkTqU=
X-Gm-Gg: AR+sD12KFSX4TPnUajnXyK0iHCIInF5I4uyvbYt8Bii973+AFmc1K1roZ8lR3JJaoxl
	pQuwt1wWOFkvEr8KUTBdT7j6sJoOqgoVz1488HIPvtzPYgO0Vxl36BOqJhHTqJieMRzDWzMMQxa
	w8iEyDZj18BO3iyy4gzPBaQRLVP/UEuYIN9Y+jXL8Z8LOwk/Y7agnqkjLjSokNmJlyY16dq3PgT
	6noCkkj+9hr9q1nFSzt0ciRt6+ZbfPz5auPo+1RzC6ET+Z6Jb5lohVMonNEeH1Ylrylss4SIp1Q
	XYNr3XPGwTPA+y3DNcNtIPVm7TSkMZR1wPoYk5Dl0DbyXzQwsjMZ3TluJGanXMP6AfQ9oxg5d/C
	EHqQtoWsS6X0b0IvmiUpws+P1eHl6kIxVamHtxAR5FZ6YFi5BwPGO5mZwbNx1dUD5gSWJfM9iZB
	9ffl0QBRp2yF8l/Q/9LWMKczjSnJaDrGxvRHbO/JRfkRSoW696BrmJNtalv91gi03lIdfKlfbYd
	KruUAFxGCV2z9ATiw45VtkMNJw=
X-Received: by 2002:a05:6820:1519:b0:6aa:edca:e171 with SMTP id 006d021491bc7-6ae96ec790cmr7787359eaf.19.1786036143494;
        Thu, 06 Aug 2026 10:09:03 -0700 (PDT)
Received: from [192.168.86.29] ([47.232.46.70])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6ae93d9aec6sm6272448eaf.8.2026.08.06.10.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 10:09:02 -0700 (PDT)
Message-ID: <d889d09d-951e-4414-95bb-625bcab7af9b@oss.tenstorrent.com>
Date: Thu, 6 Aug 2026 12:09:00 -0500
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] riscv: hwprobe: export the availability of vector to
 user
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Chiu <tchiu@tenstorrent.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-doc@vger.kernel.org,
 linux-riscv@lists.infradead.org, kito.cheng@sifive.com,
 dfustini@oss.tenstorrent.com, greentime.hu@sifive.com,
 Andrew Jones <andrew.jones@oss.qualcomm.com>,
 Nutty Liu <nutty.liu@hotmail.com>,
 Pincheng Wang <pincheng.plct@isrc.iscas.ac.cn>,
 Yao Zihong <zihong.plct@isrc.iscas.ac.cn>, Xu Lu
 <luxu.kernel@bytedance.com>, Aleksa Paunovic
 <aleksa.paunovic@htecgroup.com>, Jingwei Wang <wangjingwei@iscas.ac.cn>,
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>,
 =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 linux-api@vger.kernel.org, Jeffrey Law <jeffrey.law@oss.qualcomm.com>
References: <20260723222109.2229089-1-tchiu@tenstorrent.com>
 <20260723222109.2229089-2-tchiu@tenstorrent.com>
 <87bjbwk0q5.fsf@oldenburg.str.redhat.com>
 <cc671848-f954-41bf-b7a9-ba34c29593ec@oss.tenstorrent.com>
 <lhuik5n4v57.fsf@oldenburg.str.redhat.com>
From: Peter Bergner <bergner@oss.tenstorrent.com>
Content-Language: en-US
In-Reply-To: <lhuik5n4v57.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/6/26 1:31 AM, Florian Weimer wrote:
> 
> And if RISCV_HWPROBE_KEY_IMA_EXT_0 comes back at -1, we'd turn on V
> unconditionally?

No.  The unknown key (RISCV_HWPROBE_KEY_IMA_EXT_0 in this case) field would
be reset to -1, but the value field (which is what we test for the presence
of V and other extensions in the resolver) is set to 0, so we would not enable
any ifuncs in that case.

In the "new" case we're discussing, we'll pass RISCV_HWPROBE_KEY_EXT_ENABLED
and RISCV_HWPROBE_KEY_IMA_EXT_0 to hwprobe.  For kernels that don't know about
either key, both key fields will be reset to -1 and their value fields set to 0.
No bugs in this case.

For kernels that know about RISCV_HWPROBE_KEY_IMA_EXT_0, but not the new key
RISCV_HWPROBE_KEY_EXT_ENABLED, the key field holding RISCV_HWPROBE_KEY_EXT_ENABLED
will be reset to -1 and its value field set to 0, while the value field
associated with RISCV_HWPROBE_KEY_IMA_EXT_0 will be set to the "extension is
present" value.  This still suffers from the (already existing) we'll enable V
ifuncs issue you mentioned if prctl was used to disable V, but as you say,
it will be fixed with a kernel upgrade.

For "new" kernels that know about both keys, the value field associated with
RISCV_HWPROBE_KEY_IMA_EXT_0 key will be set to the "extension is enabled" value.

Peter


