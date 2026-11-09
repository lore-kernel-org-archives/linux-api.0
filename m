Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240442;
	b=lVcvfSiMkbEhLMeoQuSBK2naHylNyBVqqlzFL0RYpQhdWQNht5ENEQJ0hUs8hDq0DGj4
	 GLkjpaMMPrFdD+sKfUj4WtSqQMw0QzsX+n+P6BkdcJA4iCGG0d8fbmfkBGKlvj0jlb+q4
	 /HGSrXvUQiAjAveT9xVKE13mWvD5o0d8qithir46TF5p1CD/sYyuwg/bEk0UUh3J80GhL
	 G1VaR1KzHOVqXyUfa3I6hNrE5//Mhwq+bxUrx5IjjvVCJ1p85tAoCRkIhoDPEuvBpR/Q1
	 XqeqCEmO7BnLY0RYXJElC2oJZ3RXewySGkEyYR4wgUH9qoLLG9YdrNcHrJ5DEoV7O4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240442;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7hyR/yJxvg9xYDR1sSfSJhOPoAqUY6qOkImjXOMG9uI=;
	b=XSF8i2oHsJcuu+vGD9dExJCkf3vFYd7gEqPOfhL4uCTlVck/TNpYReiek5yEyr4Z5tXj
	 D+Ul/nQajXPbwWwonFiQAMdTxPDPm6rqZT8E/NpLaumbr4/NKpwz2wHdWIbnaf2JxZoY8
	 6iNdymHwZAdZXWs2tOmttct76fuQMZNZYIWD2tqmU8XBpKxucZpRoX6nnphjo8x5bkkBB
	 MHcyBAFbjeIEdrqU7Oeu+bq4gF2pkAYXJotLgrb/CspJJe513IueQxzou4Xhxkz0IRqGs
	 vwCr4ItjgSWszCzWrgbe8xEE05YXaytOz+bbCXoVx1mzU8LH4w0lVjl7yhmIUFZmjPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGOOR3PV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF01606A33D;
	Mon,  9 Nov 2026 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGOOR3PV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B985B1F008A6;
	Mon,  9 Nov 2026 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794240441;
	bh=7hyR/yJxvg9xYDR1sSfSJhOPoAqUY6qOkImjXOMG9uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iGOOR3PVL9jEjxooSdag5QePKwJ1h88kc/rnXS6zQ8G277NqkHTrivGCooGpS45EO
	 ztsJtHvCfZCWIUPNRnTgbIwWLgHbybYBdB9AYFO9OtRaxpRfIa5D7Uzf4kQPDVD7gi
	 SwZEdXNVExvb7NyEBDXTlXYOw4xCxg2WzOKYG72PMvpS53XO05dSOMQWtg+8h0Bf+s
	 PldqgGmcHySGTvK2bHZI0qrdoQXkH1CSRgXDopm1OpK4+13vaRrtfmFIxZiiCxt0bB
	 x5+kGs+eAVaCC1QR5tliRxurFyvRyDFNOF4Wi0R4cqeGMCqzBxFbe+MZXQQszJQOK5
	 IrY2vLKCM059A==
Date: Mon, 9 Nov 2026 17:07:18 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v2 4/8] man/man2/mount_setattr.2: Refer to at(2)
Message-ID: <avHvbyAX6OFu4Dwr@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <cover.1794055492.git.alx@kernel.org>
 <c206656df1610948d850c51caae22d61f2c3e47d.1794055492.git.alx@kernel.org>
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
In-Reply-To: <c206656df1610948d850c51caae22d61f2c3e47d.1794055492.git.alx@kernel.org>

On 2026-11-07 13:48:02, Alejandro Colomar wrote:
> Signed-off-by: Alejandro Colomar <alx@kernel.org>
> ---
>  man/man2/mount_setattr.2 | 66 +++++++++-------------------------------
>  1 file changed, 15 insertions(+), 51 deletions(-)
> 
> diff --git a/man/man2/mount_setattr.2 b/man/man2/mount_setattr.2
> index 0f4b619d8f38..809fa582e1ad 100644
> --- a/man/man2/mount_setattr.2
> +++ b/man/man2/mount_setattr.2
> @@ -25,34 +25,16 @@ .SH DESCRIPTION
>  .P
>  .BR mount_setattr ()
>  changes the mount properties of a mount or an entire mount tree.
> -If
> -.I path
> -is relative,
> -then it is interpreted relative to
> -the directory referred to by the file descriptor
> -.IR dirfd .
> -If
> -.I dirfd
> -is the special value
> -.BR AT_FDCWD ,
> -then
> -.I path
> -is interpreted relative to
> -the current working directory of the calling process.
> -If
> -.I path
> -is the empty string and
> -.B AT_EMPTY_PATH
> -is specified in
> -.IR flags ,
> -then the mount properties of the mount identified by
> -.I dirfd
> -are changed.
> -(See
> -.BR openat (2)
> -for an explanation of why the
> -.I dirfd
> -argument is useful.)
> +.P
> +.IR dirfd ,
> +.IR path ,
> +and
> +.I flags
> +are interpreted as specified in
> +.BR at (2),
> +but
> +.I flags
> +accepts some more values (see below).
>  .P
>  The
>  .BR mount_setattr ()
> @@ -96,22 +78,14 @@ .SH DESCRIPTION
>  The
>  .I flags
>  argument can be used to alter the pathname resolution behavior.
> +Apart from the values specified in
> +.BR at (2),
> +the following values are supported:
>  The supported values are:
   ^^^^^^^^^^^^^^^^^^^^^^^^^

this needs to be removed too

-- 
- Andrey
