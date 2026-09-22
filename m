Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D33541457
	for <linux-api@vger.kernel.org>; Tue, 22 Sep 2026 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790079909; cv=none; b=ejo4+NKhTjw8BlBAJ6YkeRx6vPvr9vc9GiyxK2WEZcq8XfcWZnEDh2luCY6Ea+p8OTwnL18V6OQmkD4lemU3bSdMLsFLxZtcPZC8ibbryYWLDZf5NJntAGrJwKqIdFw1ZK4xYHymzT/KWob24vFmVertsgJtX2QmSoqKzkPtWsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790079909; c=relaxed/simple;
	bh=MpdpneTahvV7dd4HcsSGeHrxkz25aKOWFS75pW4RUUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kS5ootY4sOLeZWS8UGd0gOMJxhNWhP4SxY0CcQQ0jQpmkVAfJs9pZD8spzX3y0E0rgWbP2Sk/xArZ3ddx+vNwQW1JC9eIKHZtHeRtbMyLt8CzQHS5CF849wVVMrusks1VMF+IbN4s1jmsaBQ2rqEJW/z/5Rat4V3OOOd6RFuMBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hy+l7Nvs; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hy+l7Nvs"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b91369d18so30481415e9.0
        for <linux-api@vger.kernel.org>; Tue, 22 Sep 2026 05:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790079906; x=1790684706; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z0UH5f4Xwx0eHqEEdAgzMEXfye5CzpFBUkt22qJELao=;
        b=Hy+l7Nvsvo9rIAYpCVWkHs6HGyNyhzOkkQRTy8gSbTEX43W5TBKiKl5Rsq2vL2q4Xa
         tlvCGB3P9/nWTtSS/kfXZsJKmf7DztSyf70rq//z8fnUlWcRY1uUzXYXGROk2IBY33zU
         8oStgmYcQRd6FTmTHt0Y9+SFUZQE1bdXpWy60pf4ldc7VG5wD09wh3X4ErndVWPRQmu7
         J5L0WU+fzwMisPGY/tKfKj7COQr8KU/ym+Ca8T/cKcA8o9dJwP2HVy7rvjeaHsiU8GY7
         vu07oL5xw2yQnNhCyOKJ2ueOAIlDJul1MXNCGAw2fxzkASqhOTkv+y6V25FqfD5TgxDP
         NxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790079906; x=1790684706;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z0UH5f4Xwx0eHqEEdAgzMEXfye5CzpFBUkt22qJELao=;
        b=1upE8yLGlmAFnb64u6QIs5cIJtUvDBhHac3y0e0o/tWGVViUmDi2NusYl2wUIaHpZG
         jZfRjwqpIXIR67UJeljIk+BF/Qz8jNoqidsB3Bgaz8lle97jVek+BFLf0CtlLC2Et6Ra
         EBaRcrmpvubHraUs9pUZrL7VZJQEO8351w/PMoqEm+B9otb5yFq6n2faDAi+2viRYiG0
         9B9A0IDEzM0CbYHs4ezxCRtNzjqRk2f8ic+f+VeaE8Wd4Y60RX7SuxP4q3m01XXoszX8
         H2JVu+8ibdnu3roJQvMMqfRzQ535yRJLs2rXXqr4fbyQEiiEM56Os8WFbtAZ5yRNIBd5
         lNlQ==
X-Forwarded-Encrypted: i=1; AKwUvByifqC6eJY6SNA2eY7c5g46U0AEfpKcTYD5mHEr9bIyPpV/PUQ/uNKZBOd9V/ZNf3UT/kbC3nTyVvY=@vger.kernel.org
X-Gm-Message-State: AFuF++mz00ITnDYv7j5GbYrB7ISQ4ydrbZ5OE1xDn+BBovSES51l1psF
	f8ZPxejAeg4uTDp/ynX/LToUmVT8NrANrZVatNrpeFFSF5i/Czs7gyxWUaeIOXATWMA=
X-Gm-Gg: AYBFou3HMUfduPR8+DArOwgrnkHmVxveT9pJ/YBvorC6IY48zkBsfs0bZQxPm2O7Cq4
	1IDO+NPOqrDBzSCOwYyCj7DuKXrAXKm7vVPlbhJSuYmb/tlNMEGw+BAL5LcmENbamOf3dtDgauD
	AudWG4jH2QVYW4ncc3TtxXlIuyzSPKkHrAXwAyHNWxk1S6EHVsMF8Mw2ReTym3Is4eSBvbL42u4
	VH1KtJ0y+G6buYwdzBXfiL8fCKBC0mLj5RL74/G/Ox3l2pEVIvO99gFNQyvUjySbcvzecHlwAy3
	tvU8Eg1pxmP23/WNliaNSdmACWOo4cc515Cvvyp/mYNKbkeDtzBul7KCToeIBt+n8t2S0MV8xOu
	XXxW8Q4AKvEJ+HPpOS6qTyxOn9EL+8v8jERSmLubAawJOnwkR1wJraUDwzDrV0csD7mDtBAb93K
	6IiodFnhYiOZA68vPIpMCETYrSKIt26uXWHRnf00vHAkzoTbPRGXbrKwsX02TA+YbMsu+E3FoBG
	dMyTNJ76yCtxouSG3nregN//REbi5JzFc1t6D/Gd3YrR1DObAuIDXH3aryn/UO75Yxz4XKUxTKx
	/wnSN+qfYoT+CowgNS8yEQxstHszIC7OBHmNcQsF
X-Received: by 2002:a05:600c:1f95:b0:49e:7862:c09e with SMTP id 5b1f17b1804b1-49fc57238b8mr181860835e9.14.1790079905892;
        Tue, 22 Sep 2026 05:25:05 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdad40b4dsm48644925e9.10.2026.09.22.05.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 05:25:05 -0700 (PDT)
Message-ID: <d7bdb421-4c65-4133-95fa-ecf3ea2b7374@suse.com>
Date: Tue, 22 Sep 2026 14:25:04 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Remove the error-injection.h include from
 linux/module.h
To: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: Simon Horman <horms@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Francois Dugast
 <francois.dugast@intel.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, linux-block@vger.kernel.org,
 netdev@vger.kernel.org, linux-api@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 5:04 PM, Petr Pavlu wrote:
> linux/module.h appears in roughly 15k #include directives across the
> kernel. This makes it a "hot" header, so it should avoid pulling in
> unnecessary definitions.
> 
> The header currently includes linux/error-injection.h to obtain the
> definition of `struct error_injection_entry`. However, this is unnecessary
> because the type is only referenced in the file as a pointer, for which an
> incomplete type is sufficient.
> 
> Add explicit includes of linux/error-injection.h to files that use the
> ALLOW_ERROR_INJECTION() macro and currently rely on it being provided
> indirectly via linux/module.h. Then remove the linux/error-injection.h
> include from linux/module.h.
> 
> The first five patches can go through their respective trees if preferred.
> The final patch depends on the preceding cleanups.

Thanks for the Reviewed-by and Acked-by tags so far. They cover the
majority of the changes, so I plan to pick up this series on
modules-next at the end of the week. Acked-by tags from the relevant
maintainers on the remaining patches are still appreciated.

-- 
Thanks,
Petr
