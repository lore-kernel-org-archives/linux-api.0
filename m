Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AEF40DFA7;
	Sun, 15 Mar 2026 01:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773537487; cv=none; b=CrjeVg3fc2iJLYx9f4gU8pCsvz+zoH7mdZgtlhJAjQsSg9nJgIfRb+gUA5s0JpDrQzmfn3sNUPRB+hq7KL1oi3yLfZFoSDn5oGMAu2lb8AFJsHMYxCfVN/IdCTyAyulsTK5MTAXCHFN3lina+mb8guaHfNkxsS5dMPxSPIVzIiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773537487; c=relaxed/simple;
	bh=YNQnPMfrXLEjO1gWNZbgBw3RHFV96tMCV2Aa+tznba0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKxmCgw2853uaUYP3shs5oQ+oAgbHVf1Fv5M/rDzew9hK9Qq4m4MveFtYLUt1z/s4vUC16vCmpXb0VPTX4nUYaJ/U4k0K4Tm3DwIUtmn/0g5OCiv+uMDD726AaxqrTFvlUJwztJWpu/L/8wrAePai4VOdYoBQ6HY3nGqqAd3ghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuKl9SZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuKl9SZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA4C116C6;
	Sun, 15 Mar 2026 01:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773537487;
	bh=YNQnPMfrXLEjO1gWNZbgBw3RHFV96tMCV2Aa+tznba0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fuKl9SZ+Ulc7B/DFdGYYyeLo5paKdwGEpW+ed9iWNLFm2nbdGOSlQdpsqfGG3Nduh
	 yRfWtKdWaP6RfMb8K86w26xHj/6HqxOlbg9YqiCw1BgIu5W1fgdb6hr/4mYJsQ7kMn
	 BJqz1cKYH0Zq74hmOjF+wxQxLPdkBwYzDgakdkg5Ob3IhmuB6P1GrjAAdHG78ZD+kc
	 tQSjbRQiOkIBsqnhJNJbhuytGzffjfged/REw/iD1qPCRvmHN0U6IIBbGUwbLdJt39
	 QpeKGaxgIq6LEawDh3n+C0jRzLBiDfrxJOpBfzLkh5q9VxQ/5ED05BCCSTR4shRRg4
	 ib8fKxP4GLnzw==
Date: Sat, 14 Mar 2026 18:18:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: atwellwea@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, ncardwell@google.com, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 mptcp@lists.linux.dev, dsahern@kernel.org, horms@kernel.org,
 kuniyu@google.com, andrew+netdev@lunn.ch, willemdebruijn.kernel@gmail.com,
 jasowang@redhat.com, skhan@linuxfoundation.org, corbet@lwn.net,
 matttbe@kernel.org, martineau@kernel.org, geliang@kernel.org,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 0x7f454c46@gmail.com
Subject: Re: [PATCH net-next v2 13/14] netdevsim: add peer RX truesize
 support for selftests
Message-ID: <20260314181804.6f62712c@kernel.org>
In-Reply-To: <20260314201348.1786972-14-atwellwea@gmail.com>
References: <20260314201348.1786972-1-atwellwea@gmail.com>
	<20260314201348.1786972-14-atwellwea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 14 Mar 2026 14:13:47 -0600 atwellwea@gmail.com wrote:
> diff --git a/tools/testing/selftests/drivers/net/netdevsim/Makefile b/tools/testing/selftests/drivers/net/netdevsim/Makefile
> index 1a228c5430f5..9e9e48d5913b 100644
> --- a/tools/testing/selftests/drivers/net/netdevsim/Makefile
> +++ b/tools/testing/selftests/drivers/net/netdevsim/Makefile
> @@ -14,6 +14,7 @@ TEST_PROGS := \
>  	macsec-offload.sh \
>  	nexthop.sh \
>  	peer.sh \
> +	peer-rx-truesize.sh \
>  	psample.sh \
>  	tc-mq-visibility.sh \
>  	udp_tunnel_nic.sh \

I think our order checker thinks that is not alphabetical.
You can find the scripts here:
https://github.com/linux-netdev/nipa/tree/main/tests/patch/check_selftest

It'd be good if you can try the "running locally" section from README
