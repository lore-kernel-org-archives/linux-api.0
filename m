Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086237;
	b=Sn/vN6EIpc4idtOXJYt4DmTMMdDtkcaIoZ3YxUsBCGakSxUtaHu5yI/At03OU2QPMqqH
	 XxKTYytqnPyqS6ZMmHkdiyEL6Tah68nel3GuOCq6+ZebymHsnOipAIoor3CNDIaFgmO7K
	 YkRewzBhgokS1aO7BQUPbDrVjTuLP5C2MI7CFDRqYOy3qbIWfbcOWTX+nMlep7ZTcnsRs
	 8U0AkwaEop+7FU48j8SlpRh0XUhMo+0Wj+MF0uBTcBeOz/UqcLJQvyKcxCDi1ZgI1Q5sI
	 EYpVtFoxmspS9xJxFFdGCxmABca2Jq3pvXZMVoqcJnSqDmtfTKB01EljGz9mCblFoXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086237;
	h=Received:DKIM-Signature:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer;
	bh=DbUVBYaOAaZ8N4Yttl9LzlzQUuvFtuX+KuOxQuXrWMY=;
	b=uFlVkv+RUSxdUoh1Zp+/mViAsVhXfZm5W+SKiLJ/vC7fdvpWfjc1UN+/BHlz63Gh2aI5
	 7J0Ct18i50IAVu0aG4rrErnU8gVJ2JLra+eUjyHqhiujh59Ms33R/gTvoBU6Xhgt0EiE8
	 1gwsYTUooS00vDeNSQjG2dKVM5TisQ2sHvlu1uPBqV65gUySr1c/R01UFaEPowyz8/Y0v
	 0mxQsWcNHoCs7aBVX41elyERSioSxc33s1Q85LxAhsTSJaYyFdsIACyc72gAWXnchLmhY
	 lTyT2dtHCMrNfcWCOVyRaSJ/lwrg1HdAVcsLhYw1Sk0U3ilDE/x9QiPqA+HX1PmELiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2osoGBB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3709F606A320;
	Thu, 19 Nov 2026 11:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2osoGBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A866A1F000C4;
	Thu, 19 Nov 2026 11:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795086237;
	bh=DbUVBYaOAaZ8N4Yttl9LzlzQUuvFtuX+KuOxQuXrWMY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=B2osoGBBe7uF8ZbwgVmdo1sn8AqqGcsrxgTxty3Z+7Gbb3d+U684xXU35y+halObR
	 yC9SECXlJe+iYGpGg81eyWdfTSDSJMGqRIaX17m9yhk3Wq+ISjG1q4rxa9Fs1MKwPI
	 4sQugLMQyZUMRvZ1akdf9dG5QQLgv5TQNnif0keBFUyhvhcqGACzZRIwmpfpAgehCv
	 LE44m4hPaO+PPZSE3QCUD5iRmwMWLsnhcsGNxT1DZwcS25qWJFJuxK/1pP+3+8jbxX
	 mxLyREVlSFdK6sVMH1TTITPcC1chHF1mJ12Gj915Lh/urbZdIYPbPGFT579J+25YsM
	 nzuCLdIxjmTyg==
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
Subject: Re: [PATCH v6 2/7] kho: link outgoing blocks lazily in kho_block
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 skhan@linuxfoundation.org, linux-doc@vger.kernel.org, vipinsh@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, linux-api@vger.kernel.org, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 rdunlap@infradead.org, graf@amazon.com
In-Reply-To: <20261118212845.2855249-3-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
 <20261118212845.2855249-3-pasha.tatashin@soleen.com>
Date: Thu, 19 Nov 2026 13:03:49 +0200
Message-Id: <179508622989.425130.3752251663949335075.b4-review@b4>
X-Mailer: b4 0.16.1-dev

Hi,

> Currently, kho_block_add() links each preallocated block onto the
> serialized chain immediately, even while it is still empty. This
> assumes all preallocated blocks are populated together before the
> chain is referenced by KHO.
> 
> When sessions are serialized incrementally ahead of reboot, extra
> blocks may be preallocated for sessions that have not been serialized
> yet. Keeping those blocks linked leaves empty trailing blocks on the
> KHO chain.
> 
> Keep preallocated outgoing blocks unlinked in kho_block_add() and link
> each block lazily in kho_block_set_it_reserve_entry() when advancing
> into it. Also unlink blocks in kho_block_set_clear() and stop at
> unlinked blocks in kho_block_set_it_read_entry().
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kho_block.c | 38 +++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> index 0d2a342ef4228..21cee45fa1cc0 100644
> --- a/kernel/liveupdate/kho_block.c
> +++ b/kernel/liveupdate/kho_block.c
> @@ -16,6 +16,11 @@
>   * array of serialized entries. Multiple blocks are linked together via a
>   * physical pointer in the header, forming a linked list that can be easily
>   * traversed in both the current and the next kernel.
> + *
> + * Outgoing blocks preallocated via kho_block_set_grow() remain unlinked until
> + * entries are reserved via kho_block_set_it_reserve_entry(). This allows
> + * entries to be serialized incrementally without exposing empty trailing blocks
> + * on the physical chain.

With the kho-ro preparation dropped, I don't see what the empty linked
blocks break. Every session is serialized in luo_session_serialize() before
kexec, and nblocks always matches ceil(count / entries per block), so by the
time the chain is handed over all the preallocated blocks are populated.

Empty trailing blocks exist only for a short while before reboot and nobody
looks at them. If they did reach the next kernel, kho_block_set_restore()
would refuse them anyway.

It only matters if something reads the chain while sessions are being
serialized, and that's kho-ro. So either describe here what actually goes
wrong without this patch, or move it to the kho-ro series where it's needed.

-- 
Sincerely yours,
Mike.

