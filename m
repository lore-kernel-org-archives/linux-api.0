Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449529;
	b=x7cf5hirpQRRlhJLhfbi7nznitzCQb6B2FG0jWGfcWpUFdMWWs+wpHa8y8HROOvE+Xhn
	 +WrSEbAj6WxdEP2CevBy5H7aBF8SaBKuOXog/e3LD6vZeRgM7kpiojDnour1y9VNjKh+4
	 w+O0VFaDrU3xUjjA5GJowc5OkEQrHCVEHSDObaWJgUbQi0hxfE220eoWVum2iwTpqgqmI
	 8in4Kn7aYPA8HAOfAfsfsDWZwhbYp4AevxKJeHuq98D8uLP9kZIXgHSdKrpujZumJoDlY
	 HO9qkZQfK1/ijLi8sFywMeIUtRwg8pFR8TeQS3OQsoP8iRnrCwAt9dE7izBar30Yd4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449529;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=43K4aQKligxqq/vuFO+T8e4jf0Zsw4MIuMv9mG5KIHk=;
	b=M79UU6O3EojHTr8fptLojMs3aT+5xonMJcAs52uZIy4nay73E8mQJ710VvaWe1D2uD0T
	 FILN411Lrwmf9bSrP8o6ORjQDTN7Ff53bMa8TgWboThinoChFPDSl3zsefCedB6PNu62m
	 +0nSyz4snsSt0DH1rzYy7zm7SlOvKrljQzuD0rPD4H/30NQw0GpG2rDE0UZ+PDlFfWGIi
	 2QpK17CQZcHgpVDeJqeTuJogLP6ndkpE/71LoUCY4Jn6nOkDtj41IMVmKyQWMP9f3/1xF
	 /WRM9PHcoJYILSfuRqE7q0MhkVSHtSz6Dc7KX+BSxXwld3rbKaMb1T4+TuhpJMuLzqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=roeck-us.net;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UUs+0Rzc;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE1B606A31B
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 22:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BE1B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UUs+0Rzc
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso1029194a12.3
        for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 15:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792449528; x=1793054328; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=43K4aQKligxqq/vuFO+T8e4jf0Zsw4MIuMv9mG5KIHk=;
        b=UUs+0Rzcflurmt8UXhJYofzLWPIeoSGahP+pbpa6TFBcyi7FvfRdfRnKwInxcyvp8m
         zzGsfKoh6sJ87QXbHusLssoSJiVcQg+Z83TE3Hxp9s7S9PL7QHBYm3vVhoCEVNoXT2LI
         o/dEbz38pzS8v3GrN8xWYieFzOT/pzVAFFVgq8I9Ma4oI14eejAhRC5CcxUmNHhAIiYI
         GG/BsRLGnhg6LL7AHbX1T3l2ncIv24y7wxdzT+j9Cj+DRGMHz/Sj9jfp904a1tZOMlht
         i0vbkuMunNqHzGCTA3+qV8wltGjdJsJgX8UTDufFctuqRzB3EJ3vofGbjs8u9UO63SUX
         phlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792449528; x=1793054328;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=43K4aQKligxqq/vuFO+T8e4jf0Zsw4MIuMv9mG5KIHk=;
        b=plGkJ3nwswILpAK5puOSEC6g9p0E9bAQRjrNYe9wZ/gT+GcvpYaflb+UA3oOC2Kj4r
         i1U3u1DWdb/xnKEGKhC0SvPeLx4uoNTaQFqN83ZbrLTPMam9+s4QvF5y9vRbdt/Yldq1
         CGnLyMtaJ0hnFETwmL/ej00Jt8tJTjkH68YXyk7eZsB4NpsexMKENcoDoroJhCijNvKr
         1whA6Xxg18duZURK0AYgop2IxmdnEkAVLbPLYxHIeq9RJRlO/bfoXXtGC4w8ZUuk8HX1
         37hr5xGebnfbwW8bsl0G6eCqN/+ZiIRDgt1n7ZfOrmlH9BjH9up21G+hhVHqv7MnSe8Y
         6Kag==
X-Forwarded-Encrypted: i=1; AKwUvBy13dg/FHV1BWHS/HUFAhw5t95Y+p18gjYFx4sG9fRlVEXBBVVQPpLno9ejJlM/in1Jg5qj9G6Rwmc=@vger.kernel.org
X-Gm-Message-State: AFq9FYI8Hd/sWISNJGqq0QHoe0169fC0QWxk+Vg5oI0PIqQj+xjwbwJQ
	78KlH+knlzNVbeRmfoWKddVU2ZMx93jq0156ezPUI6NOjzN53Bp9uqQU
X-Gm-Gg: AYBFou3/ewZ83k66BNAo2dOZip/UFAOjO6gN69ngu8Cab5hj/xmVPIwIaKaIoj90Z06
	wals9LwYEsm4pZnt0a14VJmAjXkcNZixSm7cckH3wy1mdaa5He/qRZcKdLjbBpTqR8hR4kDO4Iu
	V8sj7Dy12EDKt6m8VHwqh1ExyMZO03w8bp1UcANWwXtfBdTanAjs5g5G3jAJclxIoXAQgqc3hQ2
	CCfD9GVfR56dCo1PePh/zSTu4NvcpiZF1rfaJDu1N6DKJQEW7m83xqXJKlPZCsf3rp3ScrgexSD
	DQi/QoBxWGLCjnKLYAX51AdN0koboBWZzGn+LZy7LzY9i/ufaOYZGu2K/nmcrebFLOSqaKpDov0
	U8fu6THYdQLgHNxrUdiKL0lCzmAPUghGoh+XU97I6VXOPJdRoXUgp9djb2QeX6dgnONPcKS2AVX
	G/3RJuqjVSwqOR96EfDpdUh8GWUVOj3xJCFqq6yiPdhHZD5IsIko3zK1WM1Vs4NTImfwM4Jg4Hy
	uzn4a7y2vug8GO/XtgoAtOaAmSQy+82JdK2pYppHRfNcsmO4RojZezNFNCV
X-Received: by 2002:a17:90b:5111:b0:3a8:7242:e8d3 with SMTP id 98e67ed59e1d1-3acee293023mr7943932a91.7.1792449528378;
        Mon, 19 Oct 2026 15:38:48 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d4004cbsm1270090a91.3.2026.10.19.15.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 15:38:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4cb23fc0-2939-4ac7-ba0d-c7e0906434d8@roeck-us.net>
Date: Mon, 19 Oct 2026 15:38:46 -0700
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
Subject: Re: [PATCH 5/5] docs: hwmon: Document the uhwmon userspace interface
To: Jihong Min <hurryman2212@gmail.com>
Cc: linux-hwmon@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-api@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1791531025.git.hurryman2212@gmail.com>
 <c02aeee5b7e7a5d159d4df5baabe925e16814e94.1791559095.git.hurryman2212@gmail.com>
 <e77719ee-c813-400e-b49a-9f8a3b0e2e91@roeck-us.net>
 <CAAwencqEVCjtnJfmnut2zXXPvuwju5T89FDSpHN3wPfrrJnRdQ@mail.gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <CAAwencqEVCjtnJfmnut2zXXPvuwju5T89FDSpHN3wPfrrJnRdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/26 10:27, Jihong Min wrote:
> Ok. Then I will withdraw these patch series.
> 
> But then let me ask you the initial question that brought this patch series: Do you think it is at least OK to add kernel drivers for network-based sensors? Or do you think those are also to be subjected to be rejected (or remained in DKMS projects)?
> 

What is a "network-based sensor" ?

Regarding the references, wireview has a USB interface, and I am
quite sure that it should be possible to write a kernel driver for it.
There are several hwmon kernel drivers implementing access through USB,
so the same should be possible here.

The Tapo API reference points to an "Unofficial Tapo API client",
written in AI-guided Rust. Google tells me:

"
There is no official public API documentation released by TP-Link for
Tapo smart devices. Because Tapo uses a cloud-centric and encrypted
local communication protocol, developers rely entirely on
reverse-engineered, community-driven API clients to interact with
these devices locally or via the cloud.
"

I have no idea if it is possible to implement a kernel driver for
this. There are various hwmon drivers with reverse engineered APIs
(such as the Corsair power supply drivers), so relying on reverse
engineering is not a problem. I am, however, not going to dig through
the above mentioned clients to figure out what the API actually is
and how to use it. The guidance provided by Google suggests that
it requires per-client credentials (account email and password),
which would be problematic.

Either case, it appears that this would be about monitoring remote
devices. That is really out of scope for the hardware monitoring
subsystem. The hardware monitoring subsystem is monitoring _this_
system. Adding support for monitoring remote devices would be
a stretch.

Guenter

> 
> Sincerely,
> Jihong Min
> 
> On Mon, Oct 19, 2026 at 01:06 Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>> wrote:
> 
>     On Sat, Oct 10, 2026 at 12:38:44AM +0900, Jihong Min wrote:
>      > Document the uhwmon UAPI for developers implementing userspace hwmon
>      > drivers. Cover device registration, request handling, notifications
>      > and device lifetime.
>      >
>      > Assisted-by: Codex:gpt-6-astra
>      > Signed-off-by: Jihong Min <hurryman2212@gmail.com <mailto:hurryman2212@gmail.com>>
> 
>     I am not going to review, much less apply, this series.
>     Exposing subsystem internals to userspace is a bad idea and would limit
>     future improvements of the hardware monitoring subsystem. User space file
>     systems are bad enough and cause all kinds of trouble. I don't want to have
>     to deal with the same kind of issues in the hardware monitoring subsystem.
> 
>     Interested parties should implement kernel hardware monitoring
>     drivers instead.
> 
>     Guenter
> 

