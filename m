Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90452F60B2
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139418; cv=none; b=Y9ScK5nnumt624r0da2QCdHNTbR8FRtjaGPPXegbf4WYZENI1K/+rt0QGrdiA5P0U9usjrSUN/Rugt3DZ538dxQ2hy+ei8aRxgenC+oJnBLSiiOHzqjQ2lAQQm0tmgYW32M8la6MestnWHJGFvQg11U2jYgIb4Ue6WrqmDGW+P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139418; c=relaxed/simple;
	bh=mqiwDcKpOaRNus8j/Fg3j0JoEM5rH/wkoPe7vyjGseA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W2GFFy4mnptQivm45yZNdUtHuOw12n9chifqOyz4W9IMrwbDE0lLDtP9gPbydJN6jGIg8FkXKqFm/FhqTR2JX391s7ijN59+EVecNg83NL5DKRNC0j70hgUzhnFxS8CuwlQv73+OMpdLODRqWHTRDB0GdEpK7yjJhLvbVDqLMO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=kK4G/F9w; arc=none smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="kK4G/F9w"
Received: by mail-oo2-f43.google.com with SMTP id 46e09a7af769-7f4f0cfb29cso545467a34.1
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 08:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789139415; x=1789744215; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cMKSvjVBgJtd6CjrRqlh3dJgvYQUN3eoWH2kuKct2qs=;
        b=kK4G/F9wPPusW8S1G4rXbeFmBv+/IN48Euc/NhlP+M7DENbx5tgQNCT9J3oNAowLsx
         ugow5y7Oiez1bisxwk6MJ2UIRxoPG5gZPnQYO5mCqAAwB5ZjhTKjRtSJs92RM0yZ+yt1
         CJq1uT7goVyNFuQ15NS/hMr4b4T6bt3YCeoRlMJFQ7IEqkHbZ4NJhB6NMfJqRVLD1Czk
         9QzeEZ4YV7Q7JCuFCRVKamzfNym6sf3Y8yL7V3kKj5ns7po0oiAUVN2UIcw6SXz8dO9C
         3U3VoEuO9qcaMhml2ivm5wRn5w9ISrpjEa5184/d9LUBlicwmSuLk0s6OT0CZ7OZ/T/e
         9zNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139415; x=1789744215;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cMKSvjVBgJtd6CjrRqlh3dJgvYQUN3eoWH2kuKct2qs=;
        b=cMDB2raQ88LKIRznBIKnY7khwXsi0RJ23SE0MZrrtCxH5FFSLxOUMoIPKQhgSEc2H6
         /Kfx0ibQ+y8up6f7SMrH4/WlWgpCjymEGJXFTRz0NPGCyhwl+Tfpk/lVZXOQzULCuv1X
         gEIY0yLz0Z21/Vz7ZBFME4erdhPUpOsu9nkX0JAYG7FLB9GFGcJxmp7a+IQ3Y7DC7nhY
         PBlJTC9orVhPtgwOW5EATDjMLzt8yxRaJI9usfMzH/2XLPHp/jo1SjMdXexg0wady9VY
         e/4ExIOh5YXFLa7smL/1lz52oyeCUhRRn/Snh6e4Fd4yNWXGN+jjuuSu43gfSIKL6cLS
         Yfqw==
X-Forwarded-Encrypted: i=1; AKwUvByNe1e55pN6nSCUUAfSz78js/6vE8KwfyH+6+uHy6lS89iEHpdjAlegHqnj2gVqU9tJ03C1ws1cr5Q=@vger.kernel.org
X-Gm-Message-State: AFuF++nvHyMxf/n/bgqtMk15lTwgLcPJrFYiye2x3p9gIW0mXRUpN7eL
	4XoNJavdqFtpeW7FZ3eK4eiEpELyIxTehnvLfU3hCPNh97dwrYpD4LGi+yTEpNgWFBE=
X-Gm-Gg: AYBFou2sXTDLACLbzK/5cB/hbnnIjMnATxsjP4u8hJ08CStwvo90MFYfFfoC9sWY84B
	VXyNhsGWuwzqu53nKC319ZNEsRFic48c6JtEiAoLhvlXhAD0g+DSafV74YkgTy+IpW3Vx1bGs71
	1Po6g1Vm5l/1eL6Xn+tT3snnioTSSa47ADEb5Ooc246YnFxkGCZm3UGXIm3mWOaWIY0ZbJuP205
	RI0RcW2/2ZnBpVtLsrmrTbvVXM2yPXRAOoEAYZh4aS7uBjT8ONWzVFauKwRQins4dc8S8toZ844
	waHV25pWDoXrAFkwVO4BMXD/ihAdRcB0qYMVkzvWmXb5/DQrrI/Ea05O33d1Ep2xjwn3QzboWPr
	b5+iYJVJaMjx3+7vH0xbkD/JxD3VRGFds6/RsuZPv83Sm5rh4VhJGNMbBhQxRaJTipUfL4rmJYM
	1RUmzgZAmTewSech5nZMPZDzzRbcoiYUeVjbeqvB6aYjBVPxTv0mnFVgY38RGigniX4x+VxSfWz
	L8TJ2+tjOXjNovmUx4je2O7wsvV6tIEyCuDauQvbkUM7O36P9ZAjIa0
X-Received: by 2002:a05:6830:82c3:b0:7f6:ec23:7956 with SMTP id 46e09a7af769-803fe1bd730mr7936240a34.2.1789139414671;
        Fri, 11 Sep 2026 08:10:14 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f6d1875csm2548656a34.22.2026.09.11.08.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 08:10:14 -0700 (PDT)
Message-ID: <258d93cd-a18d-4860-bab7-2c9c7d43a015@kernel.dk>
Date: Fri, 11 Sep 2026 09:10:12 -0600
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] block: Include error-injection.h for
 ALLOW_ERROR_INJECTION()
To: Petr Pavlu <petr.pavlu@suse.com>, Jakub Kicinski <kuba@kernel.org>,
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
 <20260911-module-include-error_injection-v1-1-5da895d8c84d@suse.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260911-module-include-error_injection-v1-1-5da895d8c84d@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 9:04 AM, Petr Pavlu wrote:
> block/blk-core.c uses ALLOW_ERROR_INJECTION(), which is defined in
> asm-generic/error-injection.h. It currently relies on this header being
> included indirectly through linux/module.h -> linux/error-injection.h.
> 
> Add the missing include in preparation for removing the
> linux/error-injection.h include from linux/module.h.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

if you want to shove this upstream somewhere else.

-- 
Jens Axboe

