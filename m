Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793896095;
	b=XAdxgUoPXyjbRiVq+cxm3xzVwpvlfB9TcGFgU+68mrrHKbQIDB5ALZI5YMR1+8lA2uxw
	 yoChqd6m5o11QiMYoUqcmExtCB3qxAT2avPmzWyaZYbDMOoChF3F0kFzmZr02ntiSKXB1
	 9SFwoIyC2HmxGK5s48kwluVh9yU+rDy9DiavBsnL191YvBiPFghYYL3HdzyE4jneqW1wl
	 bA8eO9VclVRdnYzoo75x2m24RJuWvRTY+EZzDcslWleb8QSwUFWno9FsVxte8EOL8Wb19
	 MS8dJRbXohTFCTeAX5Gf8k1KDTw7HnN3/NjuUVwxelesS+8I3HOVhRbgOdl8AeNuQUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793896095;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ViB22PhtdvJTfgTdmabUFEVSK81diP/Lp6lp+HQ1/dw=;
	b=Up2DnvP3X0fVGgruNurHzAqeRO7uVCze4cgQP1xd6sBk5yDoSn0fiQ/bfR4kEulldJYg
	 /YJFLmzqDTRC7rjvV656W5i8KaI6YYnGbupfx3n8obZ2gBMJQRFqDfiLrEwnnA8pXHQ0h
	 YTtRjMUQlerAUpVQF7inJqo9Y6h25th0XsysMb+JWwoXqcDIFGws6G3Rwh3yuPgFRiCjN
	 bUapI69KsYfYyRPP17ZbKmGBZG5vsmKQEi4AfyRAzaaaFJIkHzFghL5lDqaI3Jlvmz6pI
	 h/P8ujzrEVS0piMdA3RxBY6SE8+qiLqm2TjQtLq5LaHvXaG4E8hHzaJ1y480pcsoXPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DU1+xN0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E278606A32F;
	Thu,  5 Nov 2026 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DU1+xN0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01A41F000C1;
	Thu,  5 Nov 2026 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793896094;
	bh=ViB22PhtdvJTfgTdmabUFEVSK81diP/Lp6lp+HQ1/dw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DU1+xN0S4hrSiUhuKCm59PhPJnAjG4puGZJ6oHeW/NZRdyZD5qCWNJ5bGwiwhCUid
	 H2TyEhWt8+dbHek4dDNgQKSXtdYHs1xDDW1ffnJV/KheipdrkILjy+9dyDtAHiu+6K
	 l+2A98R2q/yak6sHZzXw9eW2UOrPRSrlSQb9RDVH7JAmzTCJeXEtVJuKgdqWbQIg4H
	 +MfMxVklxgvK7x4ELR2J3DfRKRF6z1jRm6e6LCAaoquzBk2PXXZPKKlLUa04Iq0oz5
	 G3sP0IKD5Nm8OmVj+VvXv+wC99IFu7aW+qFZ9Vve5m6XCIumQjXTIF1GHLhieDyd5c
	 whB9slWb6TIsQ==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Andrea Parri <parri.andrea@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261026180619.4147910-1-parri.andrea@gmail.com>
References: <20261026180619.4147910-1-parri.andrea@gmail.com>
Subject: Re: [PATCH] iov_iter: take an unsigned long segment count in
 import_iovec()
Message-Id: <20261105-fixkosten-firma-regress-e73044c88ac5@brauner>
Date: Thu, 05 Nov 2026 17:28:10 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-ce4c1

On Mon, 26 Oct 2026 19:06:18 +0100, Andrea Parri wrote:
> readv(), writev() and their positional variants, process_vm_readv(),
> process_vm_writev(), vmsplice(), process_madvise(), vectored aio and
> the btrfs encoded I/O ioctls all take a full-width segment count, and
> all of them hand it to import_iovec() or __import_iovec().  Those take
> an unsigned int count, so on 64-bit kernels the upper 32 bits are
> dropped before iovec_from_user() checks the count against UIO_MAXIOV.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iov_iter: take an unsigned long segment count in import_iovec()
      https://git.kernel.org/vfs/vfs/c/7a15349d271b

