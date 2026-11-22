Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795341013;
	b=HO9jaRZ4kFgUCChcv8jWa2BZXhqiyxqtNAVUAWTkif/d8FmGSqIRuwsLRVXrYjtHy0/X
	 GSosKsMCz6BmESMVZyTSsbhT63YD0gxgGvx0FuY8blhsdycGArOoA2wQoNWS0A5T15dMY
	 gVfWr2EH38LhDGgMvBQP4P3qXERq51BUTI60f3w1XdqfPcfqfhFFk4ETjsL+MvYT5/xq0
	 OBHRi29vDaDHyMU8gZAbwl3Iw3m3Z5fWHMRarNqAjbb1JeVbCSdl4+BnM+6cpF6lOE0hF
	 py7wzkyZUS5n2/mE5s2TWuTe5VIQuMYoBMUJbFv5170QDCazeVAeLNQYUi9JgDE2p4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795341013;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=xfzV/JbzjYiMDIWRSSaim/SwI1CIWk/grhSKbqdBMOc=;
	b=TdMVkBLJlBg6l4QR1yCeFMfLnViHKxmNmiJQVgKG5folDCw2vRn1UWguAtcKlSgzlqhe
	 Mf+vTsyKfFq5KptO+gGWlnBkCnd8GlX6xE1cutbS8jMrHWRo1rmnOOyEGOAEkxPKXHVIp
	 8LTwRfysaVY+TO0Q67xv50YmKSqRtv5enThp4a2vGUf1awTeb44pfgH1OXJ2w9EWG9rwd
	 2HJVd7dqleNkPdl9SNHn9BDBFGlx2GJszGvL870uxiQzlXWXyJq1+lt89Uw11e23AhJg9
	 /hlrxsRzDJRo9Z5z3k8TM9MfiEGLI2ZAZr7NizWvPfPIv8IVtKkz1a2OxNd1D7hUdCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bwl65gyd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB54606A320;
	Sun, 22 Nov 2026 09:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bwl65gyd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F471F000C4;
	Sun, 22 Nov 2026 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795341012;
	bh=xfzV/JbzjYiMDIWRSSaim/SwI1CIWk/grhSKbqdBMOc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Bwl65gydXAnqL+OkGowKb70TsIcZb6PFsMwxlflFq569a6orORLuf1U8kwEpVxIFl
	 CRktWeaoAIQrK2nXpA2ZGIh49lUzVIEuf7LRg30DF8bc1nEWHQngJCcEhS6BLpc6OU
	 q2ps7g9bj4HReoHY8X742irKfI8DYhcDyIo58at9xbHnqTROnBUR4d92L1/Up7WcY8
	 hfQUkeSyjUq8AKUqhr7s/2ZFaZ29v8nY47HBhlV+VvC0KGJYDISwD1RDRi5xdSsOM3
	 qryzhP/B4N5iVlwX0NMC2V/nAOLedrISAJWPyuELDXgJJyI6Z2lGfwFA/AIwZ2Fbkq
	 SIEhMXVZQnYhg==
Subject:
 Re: [PATCH net 1/2] ipv4: accept nexthop dump attributes in route deletes
From: netdev-bot+sashiko@kernel.org
To: zypulsecore@gmail.com
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 stephen@networkplumber.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org
Date: Sun, 22 Nov 2026 09:50:11 +0000
Message-ID: <179534101163.3135.4888476897314424157@kernel.org>
In-Reply-To: <20261118084510.332821-2-zypulsecore@gmail.com>
References: <20261118084510.332821-2-zypulsecore@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch fixes `ip route flush` of nexthop-object routes for
  IPv4 only.
- [Low] The commit message says the failure occurs "with nexthop
  compatibility mode enabled" and gives a reproducer "in a fresh network…

--

ipv4: accept nexthop dump attributes in route deletes

This commit skips the check in rtm_to_fib_config() that makes RTA_NH_ID
and the expanded nexthop attributes mutually exclusive, but only for
RTM_DELROUTE requests. This lets ip route flush delete routes that use
nexthop objects when the dump carries both. The check stays in place for
RTM_NEWROUTE.

Link: https://lists.openwall.net/netdev/2026/10/26/186

> ip route flush reuses route dump messages as RTM_DELROUTE requests.
> With nexthop compatibility mode enabled, the dump includes RTA_NH_ID
> alongside expanded nexthop attributes. rtm_to_fib_config() rejects the
> combination with -EINVAL, leaving the routes installed.

[ ... ]

> report below. An unmodified kernel and iproute2 reproduced it without
> fault injection in a fresh network namespace with compatibility mode
> enabled.

[Severity: Low]
This isn't a bug, but "with nexthop compatibility mode enabled" reads like
an opt-in setting. Isn't compat mode already on by default in every network
namespace?

net/ipv4/af_inet.c:inet_init_net() {
    ...
	net->ipv4.sysctl_nexthop_compat_mode = 1;
    ...
}

fib_dump_info() leaves out the expanded attributes only when compat mode
has been set to 0, so default configurations hit this bug.

Could the commit message say that default configurations are affected? That
would help with stable triage.

> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 8c123b111b3d8..6b012c8c6ea30 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -868,7 +868,10 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
>  		goto errout;
>  	}
>  
> -	if (cfg->fc_nh_id) {
> +	/* Dumps can include both a nexthop ID and compatibility attributes.
> +	 * On deletion, fib_nh_match() uses the ID to match the nexthop.
> +	 */
> +	if (cfg->fc_nh_id && nlh->nlmsg_type != RTM_DELROUTE) {
>  		if (cfg->fc_oif || cfg->fc_gw_family ||
>  		    cfg->fc_encap || cfg->fc_mp) {
>  			NL_SET_ERR_MSG(extack,

[Severity: High]
Does IPv6 need the same change? rtm_to_fib6_config() in net/ipv6/route.c
still runs this check for every message type, including RTM_DELROUTE:

net/ipv6/route.c:rtm_to_fib6_config() {
    ...
	if (tb[RTA_NH_ID]) {
		if (tb[RTA_GATEWAY]   || tb[RTA_OIF] ||
		    tb[RTA_MULTIPATH] || tb[RTA_ENCAP]) {
			NL_SET_ERR_MSG(extack,
				       "Nexthop specification and nexthop id are mutually exclusive");
			goto errout;
		}
		cfg->fc_nh_id = nla_get_u32(tb[RTA_NH_ID]);
	}
    ...
}

err is already -EINVAL at this point.

In compat mode, rt6_fill_node() adds RTA_NH_ID to the dump and then calls
rt6_fill_node_nexthop(). For a group, that adds RTA_MULTIPATH. For a single
nexthop, fib_nexthop_info() adds RTA_OIF, plus RTA_GATEWAY when there is a
gateway. IPv6 nexthops always have a device, so RTA_OIF is always there.

When iproute2 sends that message back as RTM_DELROUTE, won't ip -6 route
flush on nhid routes fail with -EINVAL the same way, and leave the routes
installed?

ip6_route_del() already matches on the nexthop ID:

	if (rt->nh && cfg->fc_nh_id &&
	    rt->nh->id != cfg->fc_nh_id)
		continue;

It also skips routes without a nexthop object when fc_nh_id is set. That
suggests the same RTM_DELROUTE exemption would be safe in
rtm_to_fib6_config().

The commit message also says:

    The IPv4 group and IPv6 compatibility selftests also passed with the fix.

This could be read as saying IPv6 is not affected. However, those selftests
never run ip -6 route flush, and this patch leaves the IPv6 path unchanged.

The later patch in the series ("selftests: net: test flushing IPv4 nexthop
routes in compat mode") also covers only IPv4 and does not touch
net/ipv6/route.c.

Could the series be extended to cover the IPv6 parser too?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118084510.332821-1-zypulsecore%40gmail.com
