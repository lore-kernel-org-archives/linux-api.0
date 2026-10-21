Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580651;
	b=w3+eg7UK4jV/QT/VKqFmJNsMPSmoJ0sfvQlfsicadXYYkhklxRKhKWBdhslEaIRS5eAa
	 oHmywjjDiYJp+ulpeI/EwDY8fyYfOMr+JPUc37aZXBSjMRyOX44rJGgLeJgknyxRpgaoy
	 WFHNa9SvC3lSy9ugE7oPcMK75cQrle/vdbOxL6FZOkN29y/+E+gfDqydfnJJwc+7xsfYO
	 IAYFpuOdfvpriuvKU/pPTMiVn0BSpblzFrelO1ioz3lCPSJHRyfZUug3K7Nbrr7GKLs1e
	 N/OMVUXut5cCc/Iir4vnlbATL7xq6dRg1ly6Yooe2nk8OGeCNm7qJId+jOJ+/TSmz+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580651;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Y9BLVwAg7tky4u3+GEr1wy6UGxbwQP6C85M0OJGx/s4=;
	b=N2RuxjKuR8CKPo49JnirdtTO7kJ3oPiHv7ihR7xNjY3agEMRB1V71nFkeBDEqb2fzk6b
	 RVJY+AWPMb88nYrsSDPFNZ2RZBRaxVLK1cu0qLjOXn7mWa59Ahxh3oPfKnzSvgNikSUqs
	 9KDm/LBHU2Evaa4UwaXtgrVQ6E/7DhzZZbQl8ZarnzcQPlldw65162Iugn/ZKzdiR3yaO
	 NA9sJ6awXeOBahHCTpIZv03ZlZg35uDNmZc7f6NH4PXSGZ+PNZhCVzCIuDq38/20t0uw3
	 j5SywYh5hGok20jyas11lL9zR/So0BPxHyQcq4wz9G9w5Xd2fzLAKu7zQEgQsgOvoHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnesqSLc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825E606A319;
	Wed, 21 Oct 2026 11:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnesqSLc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0ED1F000C9;
	Wed, 21 Oct 2026 11:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792580650;
	bh=Y9BLVwAg7tky4u3+GEr1wy6UGxbwQP6C85M0OJGx/s4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnesqSLc/QVmrQlrPJduUZ677oi7Ni7H+5+2iyvHJisqoOAjj+KoXFhNW7/+ZO7pO
	 aLE1AOnjMTG1zBI1Jw05SMmJHNNcm30aeLUC3rCsaiWZXyn01hPCtW2Z85I0tL/0r1
	 8orH+GynrxfXtBoCLNh6AHtyIZXea9Gp/0deezvnQFqAfSDjVTjX2UQsAghhoRqJRA
	 eQev7pi/PkrTH44S9ugsarKHkhFQpM9wFhZi3FNaWBhHnbrN+mP3p5VXeR5OAoVqPN
	 ZmhdF10S0JslMVMBJqkYR8nuG1+/6nyBvSOajBu9z1O4tc8kz0iuAAEApJhHy3CuMh
	 K2fq5ugwAXhQg==
Date: Wed, 21 Oct 2026 13:04:06 +0200
From: Christian Brauner <brauner@kernel.org>
To: Stefan Metzmacher <metze@samba.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to set
 IOCB_DIRECT per io
Message-ID: <20261021-kontakt-hauen-albern-9053a385d79e@brauner>
References: <20261012184642.558349-1-metze@samba.org>
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
In-Reply-To: <20261012184642.558349-1-metze@samba.org>

On Mon, Oct 12, 2026 at 08:46:42PM +0200, Stefan Metzmacher wrote:
> It's useful to control this per io request instead of using O_DIRECT
> for the file descriptor.

@Christoph thoughts on this?

> E.g. the SMB2_READFLAG_READ_UNBUFFERED and SMB2_WRITEFLAG_WRITE_UNBUFFERED
> are also available per io request and this allows Samba to map then
> to RWF_DIRECT.
> 
> kiocb_set_rw_flags() requires FMODE_CAN_ODIRECT (same check open()
> does for O_DIRECT) and returns -EOPNOTSUPP otherwise, matching the
> convention already used by RWF_NOWAIT/RWF_ATOMIC/RWF_DONTCACHE just
> above it in the same function for "this flag isn't supported on this file".
> 
> IOCB_DIRECT predates RWF_DIRECT used a kernel-internal value,
> but now IOCB_DIRECT is aligned with RWF_DIRECT the same way
> commit ce71bfea207b ("fs: align IOCB_* flags with RWF_* flags")
> already aligned the other shared flags.
> 
> The man-page.git will get something like this for man/man2/readv.2:
> 
>   RWF_DIRECT (since Linux XXX)
>     Provide  a  per-I/O equivalent of the O_DIRECT open(2) flag.
>     This allows a single preadv2() or pwritev2() call to bypass the
>     page cache without the file descriptor having been opened with
>     O_DIRECT.  Unlike enabling O_DIRECT with the fcntl(2) F_SETFL
>     operation, this does not change the file status flags of
>     the open file description, so other I/O on the same file
>     descriptor, or on any file descriptor referring to the same
>     open file description (see dup(2)), is not affected.
>     If the underlying file or block device does not support
>     O_DIRECT, the call fails; see ERRORS.  As with O_DIRECT open(2),
>     the memory buffer, the file offset, and the I/O length
>     generally need to be aligned to the logical block size of
>     the underlying storage.
> 
> man/man2/io_submit.2 will also get updated and liburing
> in man/io_uring_prep_readv2.3 and man/io_uring_prep_writev2.3
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: io-uring@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  include/linux/fs.h      | 10 ++++++++--
>  include/uapi/linux/fs.h |  5 ++++-
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 83d41d9f1130..40d013a49378 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -344,10 +344,11 @@ struct readahead_control;
>  #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
>  #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
>  #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
> +#define IOCB_DIRECT		(__force int) RWF_DIRECT
>  
>  /* non-RWF related bits - start at 16 */
> +#define IOCB_NON_RWF_MASK	(~0xffff)
>  #define IOCB_EVENTFD		(1 << 16)
> -#define IOCB_DIRECT		(1 << 17)
>  #define IOCB_WRITE		(1 << 18)
>  /* iocb->ki_waitq is valid */
>  #define IOCB_WAITQ		(1 << 19)
> @@ -3453,7 +3454,7 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
>  	int kiocb_flags = 0;
>  
>  	/* make sure there's no overlap between RWF and private IOCB flags */
> -	BUILD_BUG_ON((__force int) RWF_SUPPORTED & IOCB_EVENTFD);
> +	BUILD_BUG_ON((__force int) RWF_SUPPORTED & IOCB_NON_RWF_MASK);
>  
>  	if (!flags)
>  		return 0;
> @@ -3480,6 +3481,11 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
>  		if (IS_DAX(ki->ki_filp->f_mapping->host))
>  			return -EOPNOTSUPP;
>  	}
> +	if (flags & RWF_DIRECT) {
> +		/* file system must support it, same as O_DIRECT */
> +		if (!(ki->ki_filp->f_mode & FMODE_CAN_ODIRECT))
> +			return -EOPNOTSUPP;
> +	}
>  	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
>  	if (flags & RWF_SYNC)
>  		kiocb_flags |= IOCB_DSYNC;
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index a46c33692aa2..3aa5fd73d391 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -451,10 +451,13 @@ typedef int __bitwise __kernel_rwf_t;
>  /* prevent pipe and socket writes from raising SIGPIPE */
>  #define RWF_NOSIGNAL	((__force __kernel_rwf_t)0x00000100)
>  
> +/* per-IO O_DIRECT */
> +#define RWF_DIRECT	((__force __kernel_rwf_t)0x00000200)
> +
>  /* mask of flags supported by the kernel */
>  #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
>  			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
> -			 RWF_DONTCACHE | RWF_NOSIGNAL)
> +			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_DIRECT)
>  
>  #define PROCFS_IOCTL_MAGIC 'f'
>  
> -- 
> 2.43.0
> 

-- 
