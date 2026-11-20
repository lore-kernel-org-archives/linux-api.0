Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172953;
	b=NRlyIp8JPDLvc28Td+QwwoyRGCcNKkyMADNrhUf0weOzhCHUox6G23mT4FxojOdV8jv2
	 0C32dXjvabP2bYc7wj7TmaTvARFc04l+hvwfrnE7+N3ngis9Trf1epbBE5zwjT33fxL1n
	 GsGgAiPwIuWFWz08okOm5ECfJTi4KgwkvJktbbB0KnryrZXpH8rLZfxaovpteLh5Ssh0C
	 Tx3V0qrdlNSkBx8iYAqj76GenfXCRS67zsijISYOjsL74CPtFPGpZ3konR/GmIL4/0vde
	 jUgGACsVhv6SazUr3V5R0OkAAT4eQHyo1f56iAehnUd1hvgnFyvLRSFU0I45qxhL/aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172953;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Z6fjCNd0maTf3ZDeSWMBMSww+6wSokgMYXSsZCtjgGY=;
	b=AUbakmj37OXxN2CNdrH+/l/fKirA+AuR5HLPAJ3bMmbP/YxvhhpdVJjc5/hhF0xG+lIS
	 VjaMlGO3C8M2j5MxweG2S5+3JhP/cLmB3D/+YJ8INVgbBIC32TVdx1ZzLakv2FV5l9u2P
	 51PnonakjLAMA1pfdRLgxiNe1J4uiNoSOA8EuE341KSw3+0I5giQPfiIQuIlN8aixGWy5
	 DGfWgPkNDXpgU2briY333k2aV0EO//E418ICLn1gLxelfR0H0nLS0vmao09iVWviL9Vm7
	 gAnO8K+HQCA1lMNi8vpM3W5h5phsEY7re1YYgfElwDdycmwt5Zrb0jZNn5LrY1E+gaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lhKk7zys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B306606A320
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 11:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lhKk7zys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B131F000CF;
	Fri, 20 Nov 2026 11:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795172952;
	bh=Z6fjCNd0maTf3ZDeSWMBMSww+6wSokgMYXSsZCtjgGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lhKk7zysHEjOB4cYeFDvfVNXsW1b6xo6OjwgjNJrjvGY9y0YpHPkf5FUqxveU1laf
	 lmd5gF/B+VL/ryQ+CxsVILutP8QEns/yHfD2Umo3mnD1TUImsgws0odcSJrSKqP/Q4
	 BDcH9nwP6fM7mQBOZJH06nyPbu9GcLeXbRDa7JbY1XVABWtzJ5RfLAsRP5acPr5h3l
	 ZFRDPOhIvTjoRzjNm0gz+REtnTWeqAe0Crf2HGvkcgi8bQvCiUmlD5d6hHn1QahHgl
	 PWbZJDYLe84QTT9DBqlxAuo2DL0VuTqFIeqXKXuGLq8AUcBOpKz4CDF4ZqNgfZYVif
	 Yd0bXk69YoY7w==
Message-ID: <5b916aaa-cc04-4ad2-8008-04a57d8e83a7@kernel.org>
Date: Fri, 20 Nov 2026 12:09:07 +0100
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
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Wupeng Ma <mawupeng1@huawei.com>,
 Ding Feng <dingf3ng@gmail.com>, Linux API <linux-api@vger.kernel.org>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

+cc linux-api

On 11/20/26 11:59, Lorenzo Stoakes (ARM) wrote:
> Currently the msync() system call will simply return 0 if you provide a
> length parameter which, when page-aligned (rounding up) overflows (i.e.
> SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)

Weird, as if it was intended, but seems to be pre-git, so who knows why.

> This requires broken input, and nobody has complained about this, but for
> correctness this should really return -ENOMEM, so do so.

Right.

> Also, since error is assigned within the following loop, remove the
> unnecessary assignments prior to it.
> 
> Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> Reported-by: Ding Feng <dingf3ng@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/msync.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/msync.c b/mm/msync.c
> index 90b491a27a14..ced41d3c2903 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
>  		goto out;
>  	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
>  		goto out;
> -	error = -ENOMEM;
> +	if (!len)
> +		return 0;
>  	len = (len + ~PAGE_MASK) & PAGE_MASK;

ALIGN(PAGE_SIZE) or something?
But fair if out of scope.

>  	end = start + len;
> -	if (end < start)
> -		goto out;
> -	error = 0;
> -	if (end == start)
> -		goto out;
> +	if (end <= start)
> +		return -ENOMEM;
>  	/*
>  	 * If the interval [start,end) covers some unmapped address ranges,
>  	 * just ignore them, but return -ENOMEM at the end. Besides, if the
> 
> ---
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> change-id: 20261120-msync-enomem-fix-95f830e305dd
> 
> Cheers,

