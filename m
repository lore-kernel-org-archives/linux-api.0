Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281717;
	b=YJPMnNJhiCZYf/Z+oWT/cRWN9j2Vfsg3bq9msmXQoLFVlMhsyxicCyW1Z9Xn5lCc1NHe
	 dwFN/f5U8qmEOJsUyhxg4I70th7r9ajL4o1GkXTB2FWxgYb62CizecmL2QJxC8evTlvZ7
	 2GzphoPyVvx/wouizBXp2Rfr9gHTQDWrQ5MN5HZbDvWS3Mv921T3vNBgeBjnBKROKGinh
	 tezcVFc6SBdU4mckhUbWv54obFkluDIg0qQBxeNXgISEXnXW8DLyKfQZl9a1g8i4ypiVL
	 GVRKrf75BAyEKxeBCE1fFXXZppU8AnQR6G6wbeXjavXE6bFiTPBcn5evaFLlB9mk6nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281717;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ohIR6Qw82vrbkY4AEMlZ5OFiQyPze3nGc8ZbxW8VQNk=;
	b=XY4F6T9rfb+nHWQLpDhYSnhUPSTB/z3J5GTROslvGN8ckDybQY1Ocauq19FWRXv0oycM
	 L8LnGDeHk2+5YwLy6FngYTWvk0YLTOTwt+05ofhsG4/wCoK5ZUVDKS1jHal6oJbB03E5e
	 j8T4YLPpgu88xkuxVy1EyThVnbHbtMWfOtiBrKfxrPBahf9AuRsZ+EiicAqEMG50sIZF1
	 koWeT1Zm9bx8Nfq1oCOD17X9tweO0bHXWvTHy+GwBEktH9sBglZYqncwpk7RNKUQP9OWp
	 DCy9Adx4s/8RDHKXyiX7B2V/k560Qe3VIQmc6VB6E57UW3vB8AOnnmrQm9BpJqOJ2iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfOJU2OB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 23E20606A320;
	Sat, 21 Nov 2026 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfOJU2OB
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 34F461F000C0;
	Sat, 21 Nov 2026 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795281716;
	bh=ohIR6Qw82vrbkY4AEMlZ5OFiQyPze3nGc8ZbxW8VQNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MfOJU2OB8lw5gSY9BnMmPvchn99+EsG8UzO4ZvAUo1WYMnnEcq9l22P9SFCMIfG97
	 6g1DB1fPOHkkhNeQyatKx6xx82XIKQq6NmVa7ROmN01aXYxgdXSh+pSXWh7ZQo9nrb
	 VuEg7DF7+VCLLHrN2rKKof0hdINX2MahCtu7DK97H5v+99TQtkYaYP+EmJrWbSPfZ8
	 w+WXxHVoDa4iCMOGX0YxSgkypG1gOGZhRWzBQzr6JMwomnHh5KIaqjJJWoMW3McUpJ
	 apwmVODt2VzXn5CnaPnu7Ie+YskEZN+V3ZYeFSpJHkDC8zS5rqBo7LJqcHZFHJxnLg
	 NMzrk1GVnTNEg==
Date: Sat, 21 Nov 2026 19:21:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 25/25] MAINTAINERS: Add entry for ROOT NAMESPACE
Message-ID: <awHTMNdonDO8IQtF@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-26-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-26-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:44AM +0200, Jarkko Sakkinen wrote:
> Record maintainership and mailing list routing for the root namespace
> subsystem across its uAPI headers, core implementation, documentation,
> and selftests.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  MAINTAINERS | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7cbce21ba45a..072be5ec7fd8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
>  F:	include/linux/mfd/rohm-generic.h
>  F:	include/linux/mfd/rohm-shared.h
>  
> +ROOT NAMESPACE

Out-of-date.

Not sure if rootns is a great name overall, it just randomly picked WiP
name. What gets produced are opaque fd-bound containers so maybe even
calling syscall as container() would not be such a bad idea (unweighted
and unconsidered idea).

Br, Jarkko
