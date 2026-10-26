Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793017640;
	b=VwXCttgNFtl606fCgp09NCqQNvD31yP7R1VjcUsvc8NZ7kk6/bkpSGT8BqKSPd9AE3qh
	 amU8hsSWbZ3MXBc0i7RyJ1ztp3b2LbRUrDXvdn0SMGK95x4QM8So+6GALD1yrGuEh9Tnf
	 ZnwL07DTyfcXzoBLS0mD9edgs3Ndv392xdxgFrbgZiZFhVWva0gNONKoO4L3cobGOZM4B
	 z49NDcJOws/Fjrx1CXnzCeXWR4HEdaC2fPO7PAxJNYYe4gdmxMf3NViWXaj2+M/U9E4ZT
	 ylVZ7bjK3mvUWmMjC/7lfvgfW2f2eIuLr5vt086aa3aFPPuppXnbfdqXxcVqB2OT7JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793017640;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JUq7w/MEjlMC64AozZ0FFh5Uw3wS5j3PnESrgHAfiCk=;
	b=Yfd4QgGFZsY0CAbC3h19RQ8dSn2cKLGHSxc5xVTUzqHHhC+/jc4U3vfz6MYC7fn7sW0t
	 X882uizZt+07oaoAixUYmuihN1QTCVUniz1EofFW1Z4t8lSwTkgQsbR4lgZ5wGzNgKs/Q
	 uc+eAD+dG/v0ItyonRBYzF4czPtG+1vxriV8pMjH9UlURh221hFTPryg0RY/5WNbpgfEg
	 PfOm5Y6pojxqF07ooM1kNMPSWyjKTXjM8BYznswR0NJuPsDx+T+uOoSw3UKjwRT9GjcAG
	 eX3gbMea+QDfy6QAddlAhP+GXTJkyV6uKRIZjSPc/LFEKgQpd8Y+e955yY9A4PDawwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOXQtYT9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6136D606A31B;
	Mon, 26 Oct 2026 12:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOXQtYT9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C811F01825;
	Mon, 26 Oct 2026 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793017640;
	bh=JUq7w/MEjlMC64AozZ0FFh5Uw3wS5j3PnESrgHAfiCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EOXQtYT9lADPJCJND7ZJAw07knNwgz0d8jZ+TJPnTZn/FU33z31Sl3uePh5gMA02a
	 9KDoy3jsaM62dGWWvWZp3An81cLa7sT7Juwf/uSTq2l6leZlDkPAhu3hCKlHSSwxct
	 uG8rM6WIoza3oKHbzsHTgtz+3M2RzoRX199xaXxBq+kKifWdXWXatzKXYR/6kV8qPm
	 h00ewuYUiPvtPnblTqo66XPbrX4a/JTLLrJ94s4U+5PjRxvnwP+Wc6FnDCYWZs1Wh1
	 XRgF8JcG5Q2PBEvQJFrVTh80mcp27N9eIXG8X/U7yzjsH6Dqk1ROOexVND3XxgA7cr
	 EGQIIxr3pvq8g==
Date: Mon, 26 Oct 2026 13:27:16 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [RFC v1] man/man2/at.2: Add page
Message-ID: <at9GMQsNivNuE_jH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>
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
In-Reply-To: <c93cb32f5d7f4473bdf51465037f1a010348b705.1792776993.git.alx@kernel.org>

On 2026-10-23 19:40:37, Alejandro Colomar wrote:
> This page documents conventions common to several system calls
> (most of them conventionally named ...at()).
> 
> Signed-off-by: Alejandro Colomar <alx@kernel.org>
> ---
> 
> Hi!
> 
> We have a lot of repeated documentation about these system calls, and
> each one has sligght differences, and some syscalls even have actual
> behavior differences (such as some accepting NULL, other not, and others
> documenting that not while they most likely accept NULL).
> 
> This documentation aims to unify the behavior of as many at() syscalls
> as possible, and document the odd ones explicitly so that differences
> are known and justified.
> 
> If you maintain or know of system calls that don't behave as specified
> in this page, I'm very interested in having a disussion about them.
> 
> If you know some mistake in this page (for example, I have not yet
> documented anything about NULL, because I want to have a discussion
> about it), please also let me know.
> 
> I'll reply to this email with a copy of the manual page as it looks when
> formatted, so you don't need to apply the patch to be able to read it.
> 
> 
> Have a lovely night!
> Alex
> 

Looks good to me, this should probably be a series including patches
which update other man pages to reference this. Wouldn't it be
better to describe differences on the pages itself, for examples,
for file_attr:

	The dirfd, path and flags arguments are described in *at()*,
	with following discrepancy - NULL value could be used for
	path argument meaning empty string.

-- 
- Andrey
