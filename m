Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051357;
	b=2swC9UdoO0kfJ47d30nNp6oOvVt76yRnO+toTYoUDqHlAuPfwjK2OLQaaLP8MBRiIorN
	 CYTZfNZ/0dGT3GsxnXpmfNHNBsGEz0G1ZVJFMn7ZzQkZCgtna/qS+JQHYWNLXiX5sKAvu
	 ybwJpfE/TX7tK8rlLJKwZjt1tRIsTuppRanfblHOl/OF19ZInfMpQrXRExNpJdyVtEYI0
	 UayhoN+NQMxMtVX4cM32WAgDNGYFgHgOWUS1Hlog4FVQB6YdBpmBS+edxgM0WtyAWu8L3
	 705CvUuY2FerLjueUT9zyVknNdutonVe8qVTZf3on0tXi2CHHpebJQjMwRJ/Yxu+zAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051357;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=ejaUx9ezICE4zwtUSLPkFEV+FbOgKZT930InXJudjmz4bQ1cNKwFTs5oyyRGkL1kF/FV
	 2mSUybL4qi+ivV2iDKe2QDCpD7tRshz3u7PBwLWOsFT4bBLrJrXfLFiI1GsIx8nPgQAq/
	 /CmQ3hEPguhCOPWtsCAhaLOqrlvOtGE0KCawwKwfdS4vOyqLpUORy5CFXlB1HNVr8vKDI
	 pjWFDRO+V87piF2aBdA2M1Vlk6nZEOsQNQVplUaKJndvPavzVsMuCt0nNQSZ9U0ccGVoY
	 YqLAQ/iphfxnbonc6j9Q3tWmVa9fj9s3ryT0QFBZR34pfhisANhcRczcCG6+eKdmydQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c7Cedkm8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eCinZKry;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c7Cedkm8;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A39A606A31A;
	Mon, 26 Oct 2026 21:49:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A39A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c7Cedkm8;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eCinZKry;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=c7Cedkm8
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F2381F395;
	Mon, 26 Oct 2026 21:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793051354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=eCinZKry9BdBG2Tuub+XI9hK94YcOOBUoAy5NiqDtrxCIfhiDCpKBYosrzHbGoQPdqVcVF
	/qUyW0flh+XLgtYLcWFiEdoa2BT99gfRo3PcAl738bcEs9klDFkXP6z2X4Nbo/EaPFu13F
	/G1VPtqe+OHGGNMTOwe+xOIuqM2+o+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793051354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=c7Cedkm86DrLmBhaRecl63q8E2NQXs91lGx1midza1J1rGGNKflLD0QKxcMpGk83nRyC0X
	IUBu035ZLkrDe3DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eCinZKry;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7Cedkm8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793051354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=eCinZKry9BdBG2Tuub+XI9hK94YcOOBUoAy5NiqDtrxCIfhiDCpKBYosrzHbGoQPdqVcVF
	/qUyW0flh+XLgtYLcWFiEdoa2BT99gfRo3PcAl738bcEs9klDFkXP6z2X4Nbo/EaPFu13F
	/G1VPtqe+OHGGNMTOwe+xOIuqM2+o+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793051354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bVpJ81jbb6s/k9oeKUE3zACKDLs87mB6qiXsiIpROrw=;
	b=c7Cedkm86DrLmBhaRecl63q8E2NQXs91lGx1midza1J1rGGNKflLD0QKxcMpGk83nRyC0X
	IUBu035ZLkrDe3DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D9BA13408;
	Mon, 26 Oct 2026 21:49:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eRk0CtrK32pSBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 21:49:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CCA06A1419; Mon, 26 Oct 2026 22:49:09 +0100 (CET)
Date: Mon, 26 Oct 2026 22:49:09 +0100
From: Jan Kara <jack@suse.cz>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iov_iter: take an unsigned long segment count in
 import_iovec()
Message-ID: <yb2p27fkrqamzmzfwqbqjwsxhw7cdlpgjzc26eqtimw2puhxrz@mhrjegarlm5a>
References: <20261026180619.4147910-1-parri.andrea@gmail.com>
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
In-Reply-To: <20261026180619.4147910-1-parri.andrea@gmail.com>
X-Rspamd-Queue-Id: 9F2381F395
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Spam-Score: -11.51

On Mon 26-10-26 19:06:18, Andrea Parri wrote:
> readv(), writev() and their positional variants, process_vm_readv(),
> process_vm_writev(), vmsplice(), process_madvise(), vectored aio and
> the btrfs encoded I/O ioctls all take a full-width segment count, and
> all of them hand it to import_iovec() or __import_iovec().  Those take
> an unsigned int count, so on 64-bit kernels the upper 32 bits are
> dropped before iovec_from_user() checks the count against UIO_MAXIOV.
> 
> A count of 0x100000001 is therefore imported as one segment: writev()
> on a pipe writes a byte and readv() reads it back, instead of both
> failing with EINVAL.  A count of 0x100000000 returns 0 as an empty
> vector.
> 
> import_iovec() was added with an unsigned int count, but the helper it
> wrapped, rw_copy_check_uvector(), took an unsigned long, as does
> iovec_from_user() today.  Until v4.1, readv(), writev(), preadv(),
> pwritev(), process_vm_readv(), process_vm_writev() and vectored aio
> therefore failed these counts with EINVAL, as did vmsplice() until
> v4.18.
> 
> Widen nr_segs in both import helpers so the UIO_MAXIOV check sees the
> count the caller passed.  Callers with 32-bit counts are unaffected.
> 
> AI assistance was used to find the bug, develop the fix, and run the
> reproducers.
> 
> Fixes: bc917be81059 ("saner iov_iter initialization primitives")
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Tested on x86_64 with virtme-ng, base 734bef548a96e vs patched:
> readv, writev, preadv, pwritev, preadv2, pwritev2, vectored aio,
> process_madvise, process_vm_readv, process_vm_writev and vmsplice with
> counts 0, 1, 1024, 1025, UINT_MAX, 2^32, 2^32+1, 2^32+1024, 2^32+1025
> and ULONG_MAX (LONG_MAX for aio).  The base kernel accepts 2^32,
> 2^32+1 and 2^32+1024 on every path; the patched kernel rejects every
> count above 1024 with EINVAL.  Also built every caller with
> allmodconfig W=1, and lib/iov_iter.o and the readv, vmsplice and
> process_vm callers with i386 defconfig W=1.
> 
> Reproducer (64-bit userspace):
>   cc -Wall -Wextra -O2 repro.c -o repro
>   ./repro
> 
> // SPDX-License-Identifier: GPL-2.0-only
> #define _GNU_SOURCE
> #include <errno.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/uio.h>
> #include <unistd.h>
> 
> int main(void)
> {
> 	char source = 'x', received = '-';
> 	struct iovec wiov = { .iov_base = &source, .iov_len = 1 };
> 	struct iovec riov = { .iov_base = &received, .iov_len = 1 };
> 	const unsigned long count = (1UL << 32) + 1;
> 	long wret, rret;
> 	int pipefd[2], werr;
> 
> 	if (pipe(pipefd)) {
> 		perror("pipe");
> 		return EXIT_FAILURE;
> 	}
> 	errno = 0;
> 	wret = syscall(SYS_writev, pipefd[1], &wiov, count);
> 	werr = errno;
> 	close(pipefd[1]);
> 	errno = 0;
> 	rret = syscall(SYS_readv, pipefd[0], &riov, count);
> 	printf("writev=%ld (%s) readv=%ld (%s) byte=%c\n",
> 	       wret, strerror(werr), rret, strerror(errno), received);
> 	close(pipefd[0]);
> 	return EXIT_SUCCESS;
> }
> 
>  include/linux/uio.h | 8 ++++----
>  lib/iov_iter.c      | 6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index fe2e985d74d24..529c6cd53df7a 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -362,11 +362,11 @@ struct iovec *iovec_from_user(const struct iovec __user *uvector,
>  		unsigned long nr_segs, unsigned long fast_segs,
>  		struct iovec *fast_iov, bool compat);
>  ssize_t import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
> -		 struct iov_iter *i);
> +		 unsigned long nr_segs, unsigned int fast_segs,
> +		 struct iovec **iovp, struct iov_iter *i);
>  ssize_t __import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
> -		 struct iov_iter *i, bool compat);
> +		 unsigned long nr_segs, unsigned int fast_segs,
> +		 struct iovec **iovp, struct iov_iter *i, bool compat);
>  int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter *i);
>  
>  static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direction,
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 2072c04e99d05..55cf2ff5bfdad 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -1362,8 +1362,8 @@ static ssize_t __import_iovec_ubuf(int type, const struct iovec __user *uvec,
>  }
>  
>  ssize_t __import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
> -		 struct iov_iter *i, bool compat)
> +		 unsigned long nr_segs, unsigned int fast_segs,
> +		 struct iovec **iovp, struct iov_iter *i, bool compat)
>  {
>  	ssize_t total_len = 0;
>  	unsigned long seg;
> @@ -1434,7 +1434,7 @@ ssize_t __import_iovec(int type, const struct iovec __user *uvec,
>   * Return: Negative error code on error, bytes imported on success
>   */
>  ssize_t import_iovec(int type, const struct iovec __user *uvec,
> -		 unsigned nr_segs, unsigned fast_segs,
> +		 unsigned long nr_segs, unsigned int fast_segs,
>  		 struct iovec **iovp, struct iov_iter *i)
>  {
>  	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i,
> 
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
