Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2DD375ADF
	for <linux-api@vger.kernel.org>; Tue, 12 May 2026 02:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778554077; cv=none; b=eEnFDRqPZCAgfJgzTZYKMt7QOIYPn7O/c1THxGaS2vYVXjq39MHdiEkYbZ8DC7X1VBwjBXikfCU0lTcKrSmIfRAq2a6hq8p3hSwhbeKZOgifO8wnaeZZpDAHbO/ZP4xNbOI6Vvk8IhqgHdhX8zKsyk8m8BTItz+d+rW4MSKE874=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778554077; c=relaxed/simple;
	bh=4ffVlS2Av/OzEfrGsAauKtEeTMB+/WTUA0YEhBV65DE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OKxVG549xBtu8zbvDHGhQbBG0gJXYqCGA88BLvhJzJzjGs5GYUvv2YLCpuQkugVHsjv5ucw27URR1n7WqXIRW5TVPmyo0gZhHTMGnNF1SxYoXNSZsGmtdqqgl012LCim0HMk6onFIeyzQJ1WTlTN+56xWDiyKtSf6wY0hANCdpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qe3qmQNV; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qe3qmQNV"
Message-ID: <6d264be9-23fb-47a0-8a0c-7976737cb0a8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778554064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJWfgU1D9MFUvgeM9YT8SM2K4wML6kqPYSeWvZTdA00=;
	b=qe3qmQNVbQiUxLZr+MmBapm/1G42Iu60zb8SqZ/6Gr+OPypshACUUC9+M225yHS8PnsgD5
	huqSMqaSH1gJeqms7/4EX0NfPnlmq4HoaTy62J6KYRD7fy5p1jMm8HIpStVqXIWDnnX0mS
	jH38FQ7+w+aszIBNJCnzH7OGRJZocTU=
Date: Tue, 12 May 2026 10:47:25 +0800
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v13 6/8] bpf: Add syscall common attributes
 support for map_create
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bot+bpf-ci@kernel.org,
 bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
 andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, kpsingh@kernel.org, sdf@fomichev.me,
 haoluo@google.com, jolsa@kernel.org, shuah@kernel.org, brauner@kernel.org,
 sforshee@kernel.org, yuichtsu@amazon.com, aalbersh@redhat.com,
 willemb@google.com, kerneljasonxing@gmail.com, chen.dylane@linux.dev,
 yatsenko@meta.com, memxor@gmail.com, a.s.protopopov@gmail.com,
 ameryhung@gmail.com, rongtao@cestc.cn, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-patches-bot@fb.com, martin.lau@kernel.org, clm@meta.com,
 ihor.solodrai@linux.dev
References: <20260511152817.89191-7-leon.hwang@linux.dev>
 <fad54bcc2f9363f61cda44680e7189ad7a510d81dc52f444a4c30a3fcd37df1d@mail.kernel.org>
 <DIG0G9IFXF42.3O4K6XV8RGQBG@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <DIG0G9IFXF42.3O4K6XV8RGQBG@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/5/26 01:07, Alexei Starovoitov wrote:
> On Mon May 11, 2026 at 9:19 AM PDT, bot+bpf-ci wrote:
[...]
>>
>> Looking at bpf_check() in kernel/bpf/verifier.c (around the verifier log
>> finalization), it uses similar logic with 'err = ret;' reassignment. However,
>> that doesn't appear to have the preserve-original-error comment that would
>> clarify the intended behavior for this scenario.
> 
> I guess sinle line comment wouldn't hurt.
> 

Will add a single line comment.

>>
>>> +	}
>>> +
>>> +free:
>>
>> Does anything use this free: label? The only exit path before it is the early
>> return for IS_ERR(log), which correctly returns directly since log is an error
>> pointer and doesn't need cleanup. There doesn't seem to be any 'goto free;'
>> statement in the function.
>>
>> With -Wunused-label enabled by default in the kernel build (part of -Wall),
>> this will generate a compiler warning. When building with -Werror (common in
>> CI configurations and allmodconfig builds), this would break the build.
> 
> good point. pls fix.

Will fix.

Thanks,
Leon

