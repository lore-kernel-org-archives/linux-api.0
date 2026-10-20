Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792531209;
	b=ZhRxgY9Fz5AbVpfxS2flmn3CreeJlsUqF06ehCVcQbkAI+6PtULyjszZalODXEMQfiZp
	 z8NRmhckRM7zbPWWqFc8TLRaPWMu2NCmq6tzAqH7225m8+rCPfE+wWuB6N4bnOwVM2aT2
	 rEpi2WYKXJdGiY2UtxFYLb3kdIew5SaT6E3J7s2JTJMvsVQJvRYsVNcfKhM7L4HaaS9FM
	 kVYlxNBrvwUGUOmLPAVbsLWxJCI5GkyaHvYCVQrMKMi+7+54XNThOZBBHc7rQEllqlL5L
	 LDDLWpUPK4qiriv2o4KZkSpRn5PS/BkZEiZYDELNobJ44Yehits9eiZlN0xVli5030A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531209;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=VshiOr6IjEiTDYCceUxy4nB4sG60JqMkf3bxNJiTdO0=;
	b=zxZIKi7H9CY6vocEJG4SXFeJgJI3iEtR4xV056LL6G4h1IBPTdilh6UaON1EZMWKCnts
	 Er+pE2g6lX3JPcQwOMb/tvmQbnBe3vAI8h8etTNZSya2vsbj1UUfAPMr/KBH8iREaHQ/N
	 g4V9r/3J/mxt8SfDPCKVoQZMkkh2zCp8lVcBEd69s8OCpZGbfoOq2UJCQoj2vejEq63mX
	 Bp/ZaDBneZZgpmoUU4Emb16lMtW83gMNYKyNW0aHaAz11V5fQ2/k1OUWRKF4LwtvOg4eg
	 CqHbDPVcY9S5o/JuV3a1VBgoZzMR8TYRdu/Wl7ojmOqIDi9MfFrG0jHFpZnEm1W5uew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cDu5lYI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0038E606A31F;
	Tue, 20 Oct 2026 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDu5lYI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B181F000CB;
	Tue, 20 Oct 2026 21:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792531208;
	bh=VshiOr6IjEiTDYCceUxy4nB4sG60JqMkf3bxNJiTdO0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=cDu5lYI/8UICnoviT0e3Mq2RFeyikjeb4MPeTDAEuF0fVmL18Ko0qYSoXmbIS8CSy
	 JySWyRHER5IfIwYlyNsPPRudOtZyk6vWzchp/1wqrOIbBjKqOc9Uo/h+8MYBgJZ3ve
	 fDmr0vVCePkBKrlh23At9cZNJKmezw+d3YKpqQ9FMTB/vcaOxYnux1IA9DIRu2imSU
	 pFYgu4AO2QmTkYUxjhWUay6OofS8eFknn7UT+LDbABmOFccmTQz3wiCJ6OBG29c0IM
	 QRdkNThsgFj+cTxbyvgiSAZW+Aw/K+Ls67rdi9QawLVJrPy85umkUXLeeVFq9jBrZV
	 lGZTRx137CoWw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7741B3809A09;
	Tue, 20 Oct 2026 21:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: unix: reject negative max_dgram_qlen values
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179253120703.216428.6433539867424959722.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 21:20:07 +0000
References: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
In-Reply-To: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
To: Yingjie Wang <1075151112@qq.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, stable@vger.kernel.org, kuniyu@google.com,
 skhan@linuxfoundation.org, rdunlap@infradead.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Oct 2026 11:02:58 +0800 you wrote:
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
> [...]

Here is the summary with links:
  - [net,v3] net: unix: reject negative max_dgram_qlen values
    https://git.kernel.org/netdev/net/c/1a4e7bc6e345

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


