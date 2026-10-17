Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4A83932C2
	for <linux-api@vger.kernel.org>; Sat, 17 Oct 2026 05:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213451; cv=none; b=GAeVMbDx4L2oFQJfGXRjhrG+nvr4CBZsVtuKMPyEGjOBodyyTU9V5/dQEvSHDsBPasHiU5UpefncpE4NUP48NZZFEGErjIGHtfNm0cJFMDnTtNdPD23cyYD+SmZINIsszkofmJjQIax7Om4YRbwyDksf2ahW5bJjMzdKRvExE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213451; c=relaxed/simple;
	bh=8BLUOuobsXVPK0Hk4WClUwg69wNv/LObwP6VEuCQQpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=grU1S3FiOgMCt1x4PKjWPJq3/C+xfZFtXyeoQq8iXvPnsznkbbCgiHX33r29DMYor1XxLFnXWM6/4T539IQNbafebtx7SCo9E6BdWKI32cpgy+LKTE46HKUXeNohKQn/wCxpjjFiwj9PKGkedQJY4/OKSj7Z+zuEs88OoDaadjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vuFAi4DJ; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vuFAi4DJ"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e8dd9b9743so5130945ad.1
        for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 22:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792213449; x=1792818249; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gV9/cHPnIlfRbaMaPitg64wMYECZnHJw7L0U4tqnfHE=;
        b=vuFAi4DJZ3XmakwcmpGKv0lcssWG4LtJUbgyNBHPfk0cJswBAE71rjmLlge6JknNij
         z7yxz4PyXTYr+H5tr/54ENmWbB3973pECVnzStvnUsRZ4aqYOAlo0cEtPVOVpMC4uuh5
         QlpWLZIInRvg0LsOWmXAo7hcX8g8Km4gc1OYddz/KlNZ2fee6aVmHaJz+9c52KTu44oo
         euBZTJQjdAzKpE0JnjWfQXtIZqc+UI8HX7JkvTd/OGkbEI4VObrThX8hC85RKX29lk2r
         tr/047uTvpJTcwHheKedmxp0VyfUaa0OcEiIRkcmR/hZAMtZbd4Q8RsKLCfEw18NwtAJ
         bP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213449; x=1792818249;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gV9/cHPnIlfRbaMaPitg64wMYECZnHJw7L0U4tqnfHE=;
        b=aTBbVExIGKvFCVsrDlQJboQnlXwmotp8mj/TsPxpUcIFSVWr5RM2Iiq8JDNewsCmFq
         HGJWWJCqVWBKd20caf64pxCGqDaXlrEBj7Sg0ftYZFjYl+WmzqxEnlIsnuyBp9+bND6S
         OL6e2J9v+qZztneaedeiYSbkT+BpwMk+Lm8/d3V0FOazAtxTikL0QZqECQtDYStor3lT
         FAzxcv++SZu40cnLOoRx3x9FrarWgLB+7lXsN03WlmUZqMZRbGa7QqfxgpbSOkHwURrd
         6cyO5T4jxUzVAXziWZBYLaW/Qgm1EXXCTfGFJ6Swh4L7NXkT67UwmJdP763fZ/QTem82
         WXpg==
X-Forwarded-Encrypted: i=1; AKwUvBw76vfSp9qrDvGZt18664DKL34uLOAoYTexIw9N8TIkbhq+BI3NiM7BrzimswsJNbIttUIp8G8Kog0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIq7oER13SHJUsgDC0UiQihKYtCOHXEn/eQ8zvkB4oVEGBI9D48
	+hxXtrIwPRPFC4eQAr2fgcTMd7TE1VlGsew5EH5O2L2loR0VttHKKROHWJxJLLq88dnH6cqfGai
	Gu4DPvA==
X-Received: from plbkm15.prod.google.com ([2002:a17:903:27cf:b0:2e9:5442:b91a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c1:b0:2e9:6788:9372
 with SMTP id d9443c01a7336-2e9a6d3668fmr18323965ad.62.1792213448706; Fri, 16
 Oct 2026 22:04:08 -0700 (PDT)
Date: Sat, 17 Oct 2026 05:04:08 +0000
In-Reply-To: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
Message-ID: <atMBc9DNAnFhsR9V@google.com>
Subject: Re: [PATCH net v3] net: unix: reject negative max_dgram_qlen values
From: kuniyu@google.com
To: Yingjie Wang <1075151112@qq.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, stable@vger.kernel.org, skhan@linuxfoundation.org, 
	rdunlap@infradead.org
Content-Type: text/plain; charset="us-ascii"

On Fri, 16 Oct 2026 11:02:58 +0800, Yingjie Wang wrote:
> net.unix.max_dgram_qlen is parsed as a signed int and copied to the u32
> sock::sk_max_ack_backlog when an AF_UNIX socket is created.  Consequently,
> a negative value such as -1 is accepted and converted to UINT_MAX.  Since
> the receive queue length is also u32, its fullness check cannot become true
> for that limit.
> 
> max_dgram_qlen has no documented negative sentinel.  Its existing signed
> interface represents nonnegative values only through INT_MAX; negative bit
> patterns are not a supported encoding for the upper half of the u32
> consumer range.
> 
> Switch to proc_dointvec_minmax and make the established 0..INT_MAX input
> range explicit.  This rejects negative values without adding new accepted
> values or changing the default and zero-value behavior.  Very large valid
> values can still make the queue limit impractical to reach; this change
> corrects the input domain rather than imposing a new resource ceiling.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5
> Signed-off-by: Yingjie Wang <1075151112@qq.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
