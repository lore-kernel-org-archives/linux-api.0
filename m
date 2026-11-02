Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656025;
	b=oWijSuWVLiO9nF1pZsvNZJ78gCp01hY3jc6xAiCoGeHTYljyMoMiElQYFmPwjVTJex7v
	 ljwxKEyxk5tsVa77bS1JA0FsQsjlMQ/CfoFSA4AgIsb85dVbhZyiUpZbcnLVin5fZQyan
	 naCA8Ph1v7gMlkis7rhkAN6Tw9i6fKLKYlXPPZoLBL98c1+xjgtsbkwjVpk3F6Wo8ZQGh
	 7lkcCSzSSadhrKmJh/8sbJLe0FfjkeUte9QA6PBm0jaZXvU2PXlAluQgsq2Vyu+sws68K
	 KH4KzXqIw9AK7F4v9MmSVwgHKdDn85TCuCerxdLaxIkODGIUatMDmzzfw8oUAUI8/PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656025;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=eryNLBdB+9u2OMDHvVsk50PIGXu+I13jRpOSwM//8IU=;
	b=RwoE1rudiIgUPeFMpLXGaRJZMQtIT9jxbbhonc/2pHwuKgZEedzmLmayOrJ79I+qy4xJ
	 zfBdwnGwDkeICEba78GPKzrWLR6LxN+TZB+gKF0iQ+zuxV9sko+OSMbBpamX3foHFK5is
	 tSsZXAh3IVro8zWUjL02wM4xq3scsbBBAi0aDO++2u/IWscLU6PrtaRPNvoiP0jE7hmr7
	 6kgyOQFtI35wRqIT10EglK3hxWbdV3kjyReV3+DQ9fPq/tLyJQVMJ+PteaZIht39Fp2OF
	 6jdolL6Rsq7rX152mv4w2DSZg1ZDmVWoI63gDtRyqEc849NgrO+FA8hcySGf0TTJDpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SQeKXy+q;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yzYijHmJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2PHZxyL7;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Yp4LXDCH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64976606D823;
	Mon,  2 Nov 2026 21:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64976606D823
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=SQeKXy+q;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yzYijHmJ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2PHZxyL7;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Yp4LXDCH
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DFC7021F8E;
	Mon,  2 Nov 2026 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eryNLBdB+9u2OMDHvVsk50PIGXu+I13jRpOSwM//8IU=;
	b=SQeKXy+qzGsdG96mI4gh14ny/OOdlK2hTdsnLfvW2H9iAVjGuWFMrQQR+cPW1fuR+y8emf
	z39hCC28VQfPLljw1ZxZkjdEN9351tkxhqZcWt2/08SsJZkW7UKzzooWzCYYyQ1RGOSdVS
	UdfhFzTL5HZVaiJccs+JNoxYIH8mw7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656024;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eryNLBdB+9u2OMDHvVsk50PIGXu+I13jRpOSwM//8IU=;
	b=yzYijHmJH/Aj36OlYzbq6pb+mM4VaojS6jMRE89Pg1cN2scxo4ZRhBfxH5RUsOLnOeQqJ7
	ii+fiyUNpQRgYDCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eryNLBdB+9u2OMDHvVsk50PIGXu+I13jRpOSwM//8IU=;
	b=2PHZxyL7oHeWpIo2ukq9oBPB5XPYzs854BU0dn6UmvmDBomxJfVY8auLpwGCxRxOrf0JMV
	5rCsdJ31yucilI4RMZSwG16ZDkRbGFHhgprkvZ2jSlUfdObVwgbO9UvlHmhv66DKcRX30N
	VhcwcIJaNOE/wsrI2YJ/YAeUmEs9MdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656023;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eryNLBdB+9u2OMDHvVsk50PIGXu+I13jRpOSwM//8IU=;
	b=Yp4LXDCHKLSJwAu/iZdkNC4p02WFmG1/giR/XUZzV80ueWF7udizasyKTB6H5EeG5/SyRX
	5M7Oqw+fapVB3YCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1ADD134B3;
	Mon,  2 Nov 2026 21:47:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZFf/KNcE6WqSAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:47:03 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6DF03B171; Mon, 02 Nov 2026 22:46:59 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:59 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] statx: add STATX_ATTR_MULTIGRAIN_TIMESTAMP
Message-ID: <vf6shjsmysanedmphb4dpsn6nk3ka47nm5qv2pt7togoha4yrz@cckxyxmzmgtq>
References: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
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
In-Reply-To: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,lst.de:email]
X-Spam-Score: -12.80

On Thu 29-10-26 12:28:16, Jeff Layton wrote:
> Userland has no way to tell whether a file's timestamps are multigrain,
> i.e. whether successive changes after a query are guaranteed to yield
> distinct timestamps.
> 
> Add STATX_ATTR_MULTIGRAIN_TIMESTAMP and set it in vfs_getattr_nosec()
> when is_mgtime() is true (IOP_MGTIME is set from FS_MGTIME at inode
> init). Always advertise it in attributes_mask.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Makes sense to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> HCH suggested this when I posted the fstest for multigrain timestamps. I
> think it makes sense. If this looks good, I'll plan to send a manpage
> update for statx(2).
> ---
>  fs/stat.c                 | 6 +++++-
>  include/uapi/linux/stat.h | 1 +
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/stat.c b/fs/stat.c
> index a2e63c6c45b7..67b9f1784b23 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -206,9 +206,13 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>  	if (IS_VERITY(inode))
>  		stat->attributes |= STATX_ATTR_VERITY;
>  
> +	if (is_mgtime(inode))
> +		stat->attributes |= STATX_ATTR_MULTIGRAIN_TIMESTAMP;
> +
>  	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
>  				  STATX_ATTR_DAX |
> -				  STATX_ATTR_VERITY);
> +				  STATX_ATTR_VERITY |
> +				  STATX_ATTR_MULTIGRAIN_TIMESTAMP);
>  
>  	idmap = mnt_idmap(path->mnt);
>  	if (inode->i_op->getattr) {
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 1686861aae20..b978860590b1 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -255,6 +255,7 @@ struct statx {
>  #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
>  #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
>  #define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
> +#define STATX_ATTR_MULTIGRAIN_TIMESTAMP	0x00800000 /* File uses multigrain timestamps */
>  
>  
>  #endif /* _UAPI_LINUX_STAT_H */
> 
> ---
> base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
> change-id: 20261029-mgtime-statx-26a229f9c3b4
> 
> Best regards,
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
