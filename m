Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088659;
	b=Z4omVWRtnildhn9uaooF/cBoZ5vLQYB/k5qD/U9Sa/BQ9etVGMu0nflzSS8HuoPjATfl
	 hTvvttqg5X1Nzc3Fvn9ZIvrP0+De6IdlMZlBbqV+VIPgi5rDmgH7+LaC1XGvA1HdOGt7H
	 tCZi2Ofm3CvKG2B6bieIkg1mROWgvLmW1hJfaCQ7SZwb4+9hRa19jbn28FJxnySoxylrx
	 sEg1hhLg68F3OmDnKHCpbxYVapLikfx/5D8fokc9iUk5EqQmCq5A1EiEMIi14MVwQ8xf4
	 W8fkJIzDZe+AczGxS8zukTI4JyPNbvX6a9ysY75htmnFNTa7CNulfeeDd7Cx86mKK9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088659;
	h=Received:DKIM-Signature:Date:From:List-Id:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f3jdZQAHmZ+JK3cDj2CNx20QLUXC8cd0nkm77BPQd/k=;
	b=fWA5W5RzgHadzqzHPhJpajKWqDAWNHAKzO4Xz9YZOi525o8Fx/mbm80uJ0TKTaFMHjqS
	 xLYlNm5jqevGABYbQMDnC81lAYOLasKUoO8LW1dyZuMaxBs+ZD/KvQ64/Fq5+oj30cyvV
	 nxG+hALUbalTgNjqLEkorvgXZiFpZ/CaKa1xWxVgj8LfZZnt81C/sxY1uiaxmGdZA90d5
	 vOKkyCPQuMrkllwsaYhadVhIQ8OWH/e/xlDCVS6uZV389bPFo5fV/0mA2HrPI+ktJzNw1
	 TdOHd8/KsJoEMZjAzuqzYfX5WUUU7zbleL9KvAK8U0z8LkelqfDsWd832FtQpGufY8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cH3CgerR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BFC606A31B;
	Tue, 27 Oct 2026 08:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cH3CgerR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57951F01825;
	Tue, 27 Oct 2026 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793088659;
	bh=f3jdZQAHmZ+JK3cDj2CNx20QLUXC8cd0nkm77BPQd/k=;
	h=Date:From:List-Id:To:Cc:Subject:References:In-Reply-To;
	b=cH3CgerR6hIi0dmML93OYHRjmqHIl5iaCS+LgkvN5Cnnnbum2BsfC/DMEk5g3IP8j
	 V1zeIdtFq8fh7rW4HH7m47PSxF1Hxs3R7oO9GCf8a4Ctrp1xziiArBcy8wQoWdHLyP
	 hXu8ddA3k9C9nq8X/8X/Shcw36DY+5HQ2dOPRjdX0yArOxv+SQd0nYjg7ukPS60oog
	 6rlB2wTohVtSmM0LSEM+a1G7EE9AccsETeWBR84aAsCDRhUzk10evltOccfNVa/zNe
	 1BnZq4j2Xu74YY1t0FnQ4d7k/YhEoqGnp8iixbO3fISJTjy82IIb6B9iqDn1lc8eyu
	 CSSNFzSR4nw/Q==
Date: Tue, 27 Oct 2026 09:10:54 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx+linux-man@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <auBca_PItGrHKrhF@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
 <at9GMQsNivNuE_jH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <at90QEmbZ2bLPdTc@debian>
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
In-Reply-To: <at90QEmbZ2bLPdTc@debian>

On 2026-10-26 16:42:46, Alejandro Colomar wrote:
> ...
> 
> Agree; I'm working on patching pages to refer to this one.
> 
> And also agree: the differences should be stated in each page, and
> avoided in the main at(2) page.
> 
> However, we should minimize differences.  And also, there are
> differences that are currently undocumented, and we should discover
> them (by asking someone who knows, I guess).  Who is the right person to
> be CCed on this?  Do you know anyone who's been working in at()
> functions heavily?

no

-- 
- Andrey
