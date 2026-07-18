Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E782727E2;
	Sat, 18 Jul 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784398412; cv=none; b=txkRROdTGcWgvu4tokkQHe5sy96CaYiYly0oIIFrOEAfLvOaGQbxSI91V4DfkfbRtA9YkStXVblY0vhoWjGfUqpWuM7AZDS3bLKTrNPAuQKzoAXvComh9V0Rsif+FrCu7dP1NYT0z8TjbKF2nCCTesfSnxayaQ/gP4IjCz8whDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784398412; c=relaxed/simple;
	bh=r3HVk1Os7nt/G91PDDOnPJIFdKrU6sc8k9e9irNSQkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUrIdpjK/eDwMq3zpy2OY9WPt3Xlxl9+W6q+r3EA/FwTtcEp5yPC6e9OllrC9WKDCG1KaiQGU5lliFrQuWjSEHS+xU1IjcbLAJFK3BsZ91DnxSIxWxQ9fynPjwimgtnr1l2MPE5le1sS6gYPADvxkPtoJpXG9dvIaCs7zkRCClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+wlFviv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+wlFviv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 06CDB1F000E9;
	Sat, 18 Jul 2026 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784398410;
	bh=SCv7D3j6usEg6VvgiOHOz89pnycYkQa0+NUH7DKCPQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T+wlFviv8yDAxEyyQxrdltaabf20f0mX6klSoC++K1N7Q26kzSryiNurmt8Bnc+DZ
	 jRmV9v+4d/PYHdfGTC+TjlKTDvpMUhBTw1dZb0EcMBggqZ4FmV7/OEetgercCIqNwO
	 KRRtBacy5s86k5gV8lyjlEb9un2bG+SVb7fMh14Ma27gHMLdm9TWW5knY+v60qE+qW
	 APhpNv6yneq+v7jQnblxDYfh1epwM19fu13gJ3rUPwDajZSZxNqoleSe8ww3V6fFAG
	 duPJVcEulyhp08USaT+/hiiyYqpjcNMcWSUcd5uIoCxPtPuwRvE0AKDz8gmgi2VbAP
	 edWc+20sFCX7A==
Date: Sat, 18 Jul 2026 21:13:26 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jaewon Yang <yong010301@gmail.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	security@kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2] tpm: Make the TPM character devices non-seekable
Message-ID: <alvCRtFvf15hG7tJ@kernel.org>
References: <CAHk-=wi8aXM9=Y8othMb1oxTv-PDw4isj-FPbXu0MXsm_EPE1g@mail.gmail.com>
 <20260712171147.323213-1-yong010301@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712171147.323213-1-yong010301@gmail.com>

On Mon, Jul 13, 2026 at 02:11:47AM +0900, Jaewon Yang wrote:
> The TPM character devices expose a sequential command/response
> interface, but their open handlers leave FMODE_PREAD and FMODE_PWRITE
> enabled.
> 
> After a command leaves a response pending, pread(fd, buf, 16, 0x1400)
> passes 0x1400 as *off to tpm_common_read(). The transfer length is
> bounded by response_length, but the offset is used unchecked when
> forming data_buffer + *off. A sufficiently large offset therefore
> causes an out-of-bounds heap read through copy_to_user() and, if the
> copy succeeds, an out-of-bounds zero-write through the following
> memset().
> 
> Positional I/O does not provide coherent semantics for this interface.
> An arbitrary pread offset cannot represent how much of a response has
> been consumed sequentially. The write callback always stores a command
> at the start of data_buffer, while pwrite() does not update file->f_pos
> and can leave the sequential read cursor stale.
> 
> Call nonseekable_open() from both open handlers. This removes
> FMODE_PREAD and FMODE_PWRITE, causing positional reads and writes to
> fail with -ESPIPE before reaching the TPM callbacks, and explicitly
> marks the files non-seekable. Normal read() and write() continue to use
> the existing sequential f_pos cursor, leaving the response state
> machine unchanged.
> 
> Tested on Linux 6.12 with KASAN and a swtpm TPM2 device:
> 
> - sequential partial reads returned the complete response;
> - pread() and preadv() with offset 0x1400 returned -ESPIPE;
> - pwrite() and pwritev() with offset zero returned -ESPIPE;
> - the pending response remained intact after the rejected operations;
> - a subsequent normal command/response cycle completed normally; and
> - no KASAN report was produced.
> 
> Fixes: 9488585b21be ("tpm: add support for partial reads")
> Link: https://lore.kernel.org/all/20260710090217.191289-1-yong010301@gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaewon Yang <yong010301@gmail.com>
> ---
> Changes in v2:
> - replace the response-buffer bounds check with nonseekable_open();
> - reject positional read and write at open time;
> - preserve the existing sequential read/write state machine.
> 
> The alternative response_length rework proposed during review was tested
> and not taken: a read-until-EOF loop hangs because cleanup resets *off
> without clearing response_length. It also treats an arbitrary positional
> offset as the consumption cursor; for example,
> 
>     pread(fd, &c, 1, 99)
> 
> on a 100-byte response can discard bytes 0 through 98 without returning
> them.
> 
>  drivers/char/tpm/tpm-dev.c   | 2 +-
>  drivers/char/tpm/tpmrm-dev.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
> index 2779a8738..74488f0a7 100644
> --- a/drivers/char/tpm/tpm-dev.c
> +++ b/drivers/char/tpm/tpm-dev.c
> @@ -36,7 +36,7 @@ static int tpm_open(struct inode *inode, struct file *file)
>  
>  	tpm_common_open(file, chip, priv, NULL);
>  
> -	return 0;
> +	return nonseekable_open(inode, file);
>  
>   out:
>  	clear_bit(0, &chip->is_open);
> diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
> index f48d4d9e1..19e8f2779 100644
> --- a/drivers/char/tpm/tpmrm-dev.c
> +++ b/drivers/char/tpm/tpmrm-dev.c
> @@ -29,7 +29,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
>  
>  	tpm_common_open(file, chip, &priv->priv, &priv->space);
>  
> -	return 0;
> +	return nonseekable_open(inode, file);
>  }
>  
>  static int tpmrm_release(struct inode *inode, struct file *file)
> -- 
> 2.43.0
> 

LGTM


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
