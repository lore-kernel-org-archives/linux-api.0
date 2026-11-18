Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013641;
	b=E8y458hrmzjLY9EPnB1mBcTgClvy8PDVq4SNso801yUnSnuusKFe7DFkgeS+PcM1OJ3Y
	 P1zqakVPT2IXMefdjtlmwsLJWQi6biSUtQldcNKkBT7hfby86+xWdyWjpIf1q89xT59Ln
	 YvOfju3sLwflBhqd23AVmY3xNGtfTGR8Ol2XC2fiCris0gqBY39N0HratPFB/aNHftBDo
	 icKm52B6w9alX8wrZ1Pv3R/NFDfSR8BvYPG5fYWMErta2YvlfSdOBhetP2kjcOR1U91gL
	 Vbz/cKjy2NUaP6QJkc4sw671EiFLnLK5KngmY21m9nurnLDq33n0SDgR0xfQPJARNRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013641;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fpKibxr1wCL6J8mhJ0V540EB0M/awne0OBZSs2pl49c=;
	b=EyjksbuGLbFbZjZsTTUftzt2zMeSB2NfBD2XoJnPXKY3bDYn8t4qHygJfxpzKT6PUptq
	 2VESDuyPTHCtO3gW37Aflzo4pxboMdpA2UwFjAleylcnSdHOxyFRoZ8RW3ymP5+9ceqsc
	 5/yxahx/pjjXMMyYlQtATWOVJciY1p/LZBqXwynbD/XeoU6ks78GSvX1zjZSIavOq+VDR
	 TbGdUM6pQueOMfj/lIKQVddx45ZzSODCFvjzWkYgLPSlLYjVjw06rJK4KKvZ9bm4yvTGj
	 k9JP63FMxf8CfJcxjBm5RqepvNqt9JSs6uWSlZX6KtKicrdTiv+dLkRqzh4lqGCqsFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBztzn3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EABA606A32F;
	Wed, 18 Nov 2026 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBztzn3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215C01F000C5;
	Wed, 18 Nov 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013641;
	bh=fpKibxr1wCL6J8mhJ0V540EB0M/awne0OBZSs2pl49c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QBztzn3vwnqftjRYbiKELGCbu+ivbdY4+L52+CWZ9nC2r9HjvFm7Bq0mzzN3CTpHQ
	 epZCwH5a1G4GR9MXAgUoImsssKr0mWo+6ysFwHPtWWgC06TX9BvDLL6alr2mbugGNa
	 s7/tPjv3NkjEbY+MnmPTQZJFlsD+sJRZPgsNwSZLuOMYV9R3RhbRU1LjGbHOLiFLfG
	 0c5C5AtcyQds29o8BVy0rkqMJx6LcLthj8mwHKBRmM21LgpIpNnJZBf+Pf6cMyihwe
	 +pYNNUITZn9KPStCjf+WJRLaEr6aggsr04yJHmOv1xp9/0pukwfrSFaUmhn/kzjyWY
	 os0IdSM/xGFuA==
Date: Wed, 18 Nov 2026 15:53:56 +0100
From: Christian Brauner <brauner@kernel.org>
To: Stefan Metzmacher <metze@samba.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to set
 IOCB_DIRECT per io
Message-ID: <20261118-leihwagen-bauaufsicht-tritt-5fc43d456a16@brauner>
References: <20261012184642.558349-1-metze@samba.org>
 <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
 <20261103080718.GA4109@lst.de>
 <03f82274-2749-4529-bf98-ede7cc79ad08@samba.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03f82274-2749-4529-bf98-ede7cc79ad08@samba.org>

On Tue, Nov 03, 2026 at 02:06:25PM +0100, Stefan Metzmacher wrote:
> So what about making it opt-in as a start, like RWF_DONTCACHE with
> FOP_DONTCACHE? A new FOP_DIRECT_PER_IO would be set by file systems
> that base their I/O decisions on IOCB_DIRECT, all others return
> -EOPNOTSUPP for RWF_DIRECT.

Sounds kinda ok to me. So xfs, ext4 and btrfs would set it, I guess.
Everything else returns -EOPNOTSUPP they're converted. That's the same
thing we did for RWF_DONTCACHE.

Christoph, how do you feel about that?
