Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240776;
	b=h9aRiJ7PVXAAuFoGjpdLoy6mvyaPeOKsI05WWeZhGvroYKPFWyUVVlZ7CuuA7E5XfKk1
	 wuXQUildYelM2AiYFSfr5UVXRdxsEa/GcSGr5zdVNAope23hTnlzsr0NzRIsSbzYhi7DO
	 baHdtFyKAmPRgU3+h9xDh78sm4CPF7R1y+A/sd3UxWZtf4N01ZAgzzUFEAQAgg2L8n/kp
	 lOKmM4OsxoK2sM71iE7tILzuSohI9kdKfnQt/N1BI8UHuGrtebGMRzPz+dAgQhM1m/eR4
	 bnX78YLWkoAXMI8sWRC5C90Ot9/8rhrLYjAa35dx3yD+smVqXleG+esST9Kdalmxn0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240776;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mBKbpazh05otkfaO7OfASj5opOSKfVbhkpeUZJvVXgA=;
	b=pUudlrKK/NfxyGNNHnLgoZmgk4JRSaaEz1tO4NDUFeWzHwieSt3B0nVYzEgLZXjyoGBA
	 0owjuh2TovIOfaGpVN1nWaFMq87ZTIpinrWOh+CjeSzZhLPZT2FxZ96rOKXmhdMKJCzBf
	 +9pEbScVyPf7mzNSbfdwh+T0poiz4tdJCtJ/aLuzlZZSXf9TfwiEcp/iGkjXsCRjCCh8/
	 YJyinflVD0WvGTWIEt6/HXjiysGzX8S4Q6f1esDdPT6Ix89JKkgQWEwNYmCQCYlnGb80Q
	 u9NlkckkbWMht4LJY78Q04HuuWTdqgqS2DYMDXfWmEChXMxCCXScx/ke975o2Bzs0Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzSmKJ01;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D242606A31C;
	Mon,  9 Nov 2026 16:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzSmKJ01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955901F0089F;
	Mon,  9 Nov 2026 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794240775;
	bh=mBKbpazh05otkfaO7OfASj5opOSKfVbhkpeUZJvVXgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hzSmKJ01Tw8JASgB342zncj63tHbs97KvCdNhmX6tGzNtfWtuCEBVHUezkdqE7DsM
	 5MrSB7bMv/4L3RzZ7sGm83QLsXKM6S206mdqSztR7VLtrrS7/4oiUg3As4s5GhOXJN
	 IEURLEayVLOQ09NL8/WANCSfv+Z1U/DQo/lizWsn4QviRie+bObfifbIhmf+JOheeX
	 TEFhb+j+tSX+OmnXwqRduhj+u2q6bIp7mwVW8A7wy+2BxLIySzwa0EcSHDaE6/tXIs
	 OXHXNXdKD1SH5nywFVox5m4aqEALNFoKsc8MfhFmhkJUdqvS8GnnG4lMdt6RMAaHXB
	 qJ6mDRq0VC/EA==
Date: Mon, 9 Nov 2026 17:12:52 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v2 5/8] man/man2/open_tree.2: Refer to at(2)
Message-ID: <avHwMOF_zPSJ167L@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
 <4e8ce7b9cf9dd32623ab15735a88b393b5e8af0a.1794055492.git.alx@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8ce7b9cf9dd32623ab15735a88b393b5e8af0a.1794055492.git.alx@kernel.org>

On 2026-11-07 13:48:06, Alejandro Colomar wrote:
> Signed-off-by: Alejandro Colomar <alx@kernel.org>
> ---
>  man/man2/open_tree.2 | 168 +++----------------------------------------
>  1 file changed, 8 insertions(+), 160 deletions(-)
> 
> diff --git a/man/man2/open_tree.2 b/man/man2/open_tree.2
> index 3e587f7be14b..9afca6ef91a2 100644
> --- a/man/man2/open_tree.2
> +++ b/man/man2/open_tree.2
> @@ -115,110 +115,17 @@ .SH DESCRIPTION
>  is included in
>  .IR flags .
>  .P
> -As with "*at()" system calls,
> -.BR open_tree ()

Won't it better to restructure it a bit then, the man page seems to
start with description of custom flags cases, then describes dirfd,
path, flags from *at() and then jumps back to list of custom flags.

Maybe start with dirfd, path, flags then list of custom flags and
then the custom flag cases.

-- 
- Andrey
