Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304F0406290;
	Wed,  3 Jun 2026 20:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780520233; cv=none; b=YFpF/rleYaIxWX5n11AVfeIm4kRJPLc1aXKvlx6yotQp50Sg+Bb//+mSA8kvduDihhUbHLqTs7dz4p53GpOe3ZoL96rSWwvnRP1rcnO4psdQDyfvErC9ZCpwShP1GNgWiVlAQsIDKhHtVIgsQARdDFDzhTpeivfwJC3iz4n0Dcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780520233; c=relaxed/simple;
	bh=V2fXSXVzTIh8my+gZteAmchKNpC3cbws67iXcxUG/DU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NlqqvBqV+FHxJdNB8b9AkKjsEbfR5FaGuM9R+ANsUTiYayY/UJtIF14MgobWoNfSUR6F1xP5WbgBKTdvKediUQR7bL1y9NPFy3Sh4R0qah0TNAf+HDI4U048AOCAxyww+x26E9A98m1OasGQSh7ceSP40dr5rAJVxRCza0qgKlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IkdgwTOo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IkdgwTOo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=8BcJ1AYTFKicCZr4Jz0bUiyIXeLFCzsYHFc8JfDuOPI=; b=IkdgwTOofDKPbnSVfFpsvzvLwX
	eOoOzStETsZ3WEPO0WPXmqBwdzYWHPKtXsWUBnPrhS49AtanwdCw0YdlhOj8U+4uuX/Y+SfTGA994
	V7ALuQ7pbP0qgnPLvhDKoW4JaBX2kBwD+pPOmvpZsDURTw+GW7K1+NI24niCZg1RzD7JOHoHF0SmP
	hdcGlnB/fPmeokjhlU+8VVRBpZh+b/J1zE3upcIPtx9c6TbTI3ByJCL102NkFbqcHCTIoTCffGSni
	xtaEVXw+VwiZSATF2Xkm+AdCErd7J1WdkfDSXvkaDex04ioZI6pz8mSvaUmBgstMGtyOZlp3OjcJW
	P7D6uZnanayQ1fDHOYYKRvi4YPhXlXQZbFaku9paKoIFPTrOzvfo4fQ6ml8lPxemUdrPhChWMRMLB
	KbBvwt5/zIz36T+cmighMPqMSn7ZLdhtyimFeX+K5B0RraYwM92HQ/VTyeWryZpwntdJ1Vx0rG0ql
	oWA+ogV47gyUOm1BondGaIYR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wUse3-0000000Dpix-3X3G;
	Wed, 03 Jun 2026 20:56:59 +0000
Message-ID: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
Date: Wed, 3 Jun 2026 22:56:58 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-api@vger.kernel.org, netdev@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260531010107.1953702-3-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Askar,

> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index f5639d5ac331..a86a88207956 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -514,8 +514,8 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
>   			  struct old_timespec32 __user *, const sigset_t __user *,
>   			  size_t);
>   asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
> -asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
> -			     unsigned long nr_segs, unsigned int flags);
> +asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
> +			     unsigned long vlen, unsigned int flags);

Why is 'int fd' changed to 'unsigned long fd'?
Should that be its own commit if the change is desired?

metze
