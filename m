Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103230;
	b=V21pePxzCeEVoPopsDSzUy+fA6s6d1y8q6uCm/cwdYxmN7fUt+ogrGmNIeGYCrX1uYkC
	 gesT+1v8kAcSarRhq4SptR+jYQRquHkLToFkBCqTS3pPi9+43G9os9seMbLmG1oTmUqBM
	 +iGYY8yZ9jsaiNxt9mzG5Nk4Q4lJNrR7SvqvMuj00JtbgM5ecC2Ipev7m772A8DJivRTu
	 5XGD/t8BaoXH1zdEfqwbSAH/OUnIf0Ec1U6m2uFAbDMoI+0WW78WK9/0cTlKe6E9/keOj
	 AMvFUBKnSpyJky5ihau14Jz2dw3U9f6sCC9YOWacFkSosfMCFOnKqvclOxCm8EjthTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103230;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=HFucv/1vEFUJ92a1RgUBjjm3jSf0ckrYCwva8AjNNgQ=;
	b=fcMRDIWGsoa/gW93fXgdMwcmD7ubnUxUgZ6xz1y5hcvkg3+O8FFzLnIcdM8NPgOtQwr3
	 CuC7kOoLsSPGj2u0N99mHXJzbGkEsZpBqecotl/z5BDm792ZdWCGk4h26XZ2+GZHc9pQl
	 m8LJyzz1jm6mO+XkIpOsI9jABCmCNmHPLt7s9dvx7IoC0OeRBp/APjQIOgg44cnNCZmHK
	 wX101fHJjfQFsDkZmJcKjNMDZ3rPz5NNaa+TbIOPzhqV3d8+6coklZtLaZ51Eput0lAu/
	 0xSSUpf6EdejK8CJ0NFlgvZYWD5pXjcR7oyLtX0jVO9oFMNk3BN3Ok+UttgfwQ/ZD7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGNlEtNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2355960A2636;
	Thu, 19 Nov 2026 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGNlEtNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C48F1F000CC;
	Thu, 19 Nov 2026 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795103230;
	bh=HFucv/1vEFUJ92a1RgUBjjm3jSf0ckrYCwva8AjNNgQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JGNlEtNhcFbkQJXcCLCkwxp05ZPMCRFWIQRlOdGCe9zmDfhODt0ip8SItKrNc+ClY
	 kmq5ZGkjQSLxB0s2CKgGqdRtXEEpGvy3j8sAPkVti/d3hb/yj4wKpm79BRa+LJo3HV
	 rbykHhN0nNjkb8TDpY7nsmA1gfWtK7yWeJtu+GTrZyo40kTk2vtEtowv5SqZwzRqNR
	 7UnGdww+hBKQsHPRhVrG9nz3I86sRtY8UVViT6vM4O3Ltriw+qEjEWqW9T+UO+SxDD
	 wICHKm5m0oCWBc9JaxCFZPNoFj2cMKLBPlFt1vFD6svgkiaAwM/AlMBXo9p7FPiN38
	 PR/0qv5/H0mag==
Message-ID: <c5fb4561-f12c-431d-b68d-659ea9cd8a90@kernel.org>
Date: Thu, 19 Nov 2026 08:47:08 -0700
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
Subject: Re: [PATCH net 1/2] ipv4: accept nexthop dump attributes in route
 deletes
Content-Language: en-US
To: Yuen Su <zypulsecore@gmail.com>, netdev@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>,
 Stephen Hemminger <stephen@networkplumber.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
References: <20261118084510.332821-1-zypulsecore@gmail.com>
 <20261118084510.332821-2-zypulsecore@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20261118084510.332821-2-zypulsecore@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/26 2:45 AM, Yuen Su wrote:
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 8c123b1..6b012c8 100644
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

as the error message at this point shows, the 2 specifications must be
mutually exclusive. iproute2 will need to strip the nh_id or the nexthop
spec.
