Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D64A8A28;
	Wed,  2 Sep 2026 16:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364892; cv=none; b=Ol+rz76ReGH+Ztzvy6HsbEzn+OLGSGrcYKx6vEOxy1+7RqzNeQSbNXUW+ILgSdc/Ct8ImRaHv4jqX1Rjm1vM9Fi0M9bbnO+31vgfI9buCimo14dgDsmjS54Uodh+9t9ROtN5211SgfGdWMO9WJEqvroioNK0HS8byOOrqRnM8pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364892; c=relaxed/simple;
	bh=KVjK/7G+aWxJKWPskQW4reuYD+4Gb6PJz7C/ALsZOCc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dRO+DQL4ECDMk3zcSancYAGtXMBc4cX9VnopqUKJB1mEZnvzQQTeazsrbMUlLVlTJWyAOe4wyCFmi9dWu4JS51oM3vUfZAV22ZSFTpKz7/B0AdBey1zv0/RXOWenhL7yxKBJ92K855keG0RVjSvjPXmJSQgXPMrxQsCEiC52zNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7GKdxqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7GKdxqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BC91F000E9;
	Wed,  2 Sep 2026 16:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788364890;
	bh=daOyDrVX5X5pUkXTGa6KOCVVVtVLzKoQrNwrrXHvqno=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=i7GKdxqrhbx1kQ4+TSbjbiE394wA05WCFqkhEyfiZWgmlMZ/3JL00KsMBSwMcEHTt
	 mibCMNi7bwWjUoOzbABakf0UmrZbuSwU50pLSXAOAO6EoKRYuU1gCY8nF7Memq1nA5
	 Ym3gvOX/nLpYndr8vTQbVHJ9XUhkSOpyeEBLl/jpYjWqgAHsqj7tmB4Rv4yfsm1e0T
	 JLWB9tDE6UTwcg3hNCZnbGo4ol6g5DwUJwYxTa2Xf6lbNkJJZg24ngp97Lr7Zcpx2O
	 j07oIOOh4e2yyUWsC1VbISEJ/NzukhATovrhrjjQ+R4QsWqj9nl2Zd7hudMHC5InC1
	 I0CBjHR+CMcqA==
Subject: Re: [net,v2] net: unix: reject negative max_dgram_qlen values
From: netdev-bot+sashiko@kernel.org
To: 1075151112@qq.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, stable@vger.kernel.org, kuniyu@google.com
Date: Wed, 02 Sep 2026 16:01:29 +0000
Message-ID: <178836488944.3394541.11634846311460065510@kernel.org>
In-Reply-To: <tencent_9FDB4FAAFE9F3EF38210AC963C73897A2E09@qq.com>
References: <tencent_9FDB4FAAFE9F3EF38210AC963C73897A2E09@qq.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 1 · Low: 0

- [High] Incomplete mitigation: the patch rejects negative writes to
  net.unix.max_dgram_qlen but supplies no .extra1/.extra2 bounds to…
- [Medium] Commit message / Fixes:+stable justification does not match
  what the code does.

--

net: unix: reject negative max_dgram_qlen values

This changes netns_unix::sysctl_max_dgram_qlen from int to unsigned int
and switches the net.unix.max_dgram_qlen handler from proc_dointvec to
proc_douintvec_minmax, so negative writes are rejected while the full u32
range stays writable.  The documentation entry is updated accordingly.

Two questions, one on the changelog and one on the sysctl table entry.

First the changelog.  It describes a concrete malfunction:

>     result, negative values are accepted and converted to large queue limits;
>     for example, -1 becomes UINT_MAX.  A nonblocking sender can then continue
>     enqueueing instead of receiving EAGAIN at a finite limit.

and it carries:

>     Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>     Cc: stable@vger.kernel.org

[Severity: Medium]

Is that description still accurate after this patch?  The message also
says the intent is to "let userspace configure the full u32 range
directly", and with no .extra1/.extra2 in the table entry a write of
4294967295 is still accepted, so sk_max_ack_backlog can still end up at
UINT_MAX by way of unix_create1().

If the sk_max_ack_backlog == UINT_MAX state remains reachable, then the
only behavioural delta is stricter parsing of a namespace-writable knob:
writes of negative values now return -EINVAL where they previously
succeeded.

Would it be clearer to describe this as an input validation and typing
change, and to reconsider the Fixes: and Cc: stable tags, given that a
backporter reading the message would expect a queue-limit malfunction to
be closed and would accept the user-visible tightening on that basis?

[ ... ]

> diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
> index 47660d5726bb..8f6f0657495a 100644
> --- a/net/unix/sysctl_net_unix.c
> +++ b/net/unix/sysctl_net_unix.c
> @@ -17,9 +17,9 @@ static const struct ctl_table unix_table[] = {
>  	{
>  		.procname	= "max_dgram_qlen",
>  		.data		= &init_net.unx.sysctl_max_dgram_qlen,
> -		.maxlen		= sizeof(int),
> +		.maxlen		= sizeof(unsigned int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec
> +		.proc_handler	= proc_douintvec_minmax,
>  	},
>  };

[Severity: High]

Does the min/max handler do any bounding here without .extra1/.extra2?
In kernel/sysctl.c, do_proc_uint_conv_minmax() calls proc_uint_conv()
with the range check enabled, but the check itself is conditional on the
extra pointers:

kernel/sysctl.c:proc_uint_conv() {
	...
		if ((tbl->extra1 &&
		     *(uint *)tbl->extra1 > tmp_k) ||
		    (tbl->extra2 &&
		     *(uint *)tbl->extra2 < tmp_k))
			return -ERANGE;
	...
}

and the conversion only rejects values above UINT_MAX:

kernel/sysctl.c:proc_uint_u2k_conv_uop() {
	...
	if (u > UINT_MAX)
		return -EINVAL;
	WRITE_ONCE(*k_ptr, u);
	...
}

So does echo 4294967295 > /proc/sys/net/unix/max_dgram_qlen still store
UINT_MAX?  That value reaches every new AF_UNIX socket:

net/unix/af_unix.c:unix_create1() {
	...
	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
	...
}

and the queue-full test compares a __u32 queue length against it:

net/unix/af_unix.c:unix_recvq_full_lockless() {
	return skb_queue_len_lockless(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
}

Since sk_buff_head::qlen is itself __u32, can this comparison ever
evaluate true when the limit is UINT_MAX?  If it cannot, the gate in
unix_dgram_sendmsg():

	if (other != sk &&
	    unlikely(unix_peer(other) != sk &&
	    unix_recvq_full_lockless(other))) {
		if (timeo) {
	...

never trips, and the sender falls through to
skb_queue_tail(&other->sk_receive_queue, skb) rather than returning
EAGAIN, which is the same end state that -1 produced before this patch.

If so, would adding a sane .extra2 cap (or, alternatively, documenting
that very large values intentionally disable the limit) be the more
complete change here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/tencent_9FDB4FAAFE9F3EF38210AC963C73897A2E09%40qq.com
