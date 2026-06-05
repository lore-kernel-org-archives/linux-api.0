Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399243876CE;
	Fri,  5 Jun 2026 15:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780672839; cv=none; b=O4Z4TB5UB9p4gXeN3aVxWjNXIW7LiaDxlJVQNpSZcjXhkt5yDytV0ICwKNBchQCay4yHhoEwq/Y+XYK+wAV9tg5s208Obnben/dYxnGhM/3/xlZNkV7IfvDdm0bZpxqz92FQs1vSbQY1Qe8ECv17e61M7dosL0rXlQiFqejPRfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780672839; c=relaxed/simple;
	bh=9fWJeOMUheQ4Gtf414dFzn4LFFXdkThVXQLC2cRctGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rkY04fu7A/x37zjZxjy7O9SV1nkfjAt8ErCcXxCEUlL5JxoG4w6i6o94HJ1jwD9GGJD5ZSMxBepB3QQHAaDL4hGOZ1lqEKMQXIEuVkjoX4qCM6rVpt7POpUZmzRtSBqtsY1wCQJT+x28KpsromN3icWti5noTUsHk6UWHx8myTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bXg9PA03; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bXg9PA03"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=eOwiV4Ir0+AZG7wQerQDpTKBJ828HFU+2fFToq4R8DU=; b=bXg9PA03iupcur1W8zNsLEJbSn
	WPIQsFUFOt1tjTFPx3VEwwZmycHAOidk+WXf6OUAYhMmZWSV2Icros8OIx55vd8XKMGcTuZcAFET2
	BZZFGA9Zz5XAizo04SUszT5UUNSVOFV77/3CwRFg/A4QsS+pv9hgsYlIOJIVMEqf71zb6hw2+rhkW
	UmknKXYhZ52hNX8yGlFlLi9QVzLTSX+NIVHkXOQlz7nXw0cJ/qiqyk7MutHtBNCuVaOIwB7vXsDyv
	I8WqM2bl8ZO31yWY7tVo6H36eyeSwgAaS6WDOX9qAJHHskKWKnpVjquP7MlO2ZKcNaa5USncoxLlH
	TAlnaZreCOxo+GcFE9FgvwJQbiIJAf2ILv6Gxv4LNL0cniGNhkYWJtYZJ104yN93+YRd16K8/kAJC
	56gnrQbqwk8IJFUxth/6IMTICraMrYnRWT83BS/1Z2bO5cg9DTZSWZ7o0+3z3vE8awC648WxiWShc
	Gx/sER+fb6Ht88EdEMSAAV6M;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wVWLb-0000000EIWE-2JiY;
	Fri, 05 Jun 2026 15:20:35 +0000
Message-ID: <634c8ae2-3f1c-46b1-b002-1e2ac797dd80@samba.org>
Date: Fri, 5 Jun 2026 17:20:34 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
 <20260605131942.4584728e@pumpkin>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260605131942.4584728e@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,

>>> So sendfile() as a concept (whether you use combinations of splice()
>>> system calls or the sendfile system call itsefl) isn't necessarily
>>> only about the zero-copy, it's really also about avoiding the user
>>> space memory management.
>>
>> I don't think so. Ok, maybe for webservers just serving tiny
>> html files, that's true. But for me with Samba it's really the
>> copy_to/from_iter() that is the major factor.
> 
> Is that copy also doing the ip checksum?

Not in my tests. I guess there's offload in the network hardware
for this.

At least at the syscall layer of sendmsg() there's no checksuming
happening.

metze
