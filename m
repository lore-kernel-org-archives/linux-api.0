Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793629496;
	b=olLeW8/sIErv0C0PKM1ctGYVX1kg+X9GlDSy7obpZGPqyBgQjvhXakE6JTAVAQEMQC4h
	 OG03vvv8nGCqOADmLljTw7QIPeeafdDyktH6PHJ6HnGqRNy5JSleYB+7Scmv4WUmvdFiI
	 yxSaxb1SlCe++YhfyF1ToSqHAr136zjOOhD+9teuq3FnSd3m+kGIHxuqDTvbo2kYBD6Mq
	 QGOUPY+D9L4/5uMObManY+q+eh4iKt5u+aC5svKmnryXwF6tUHhPCxYLirgfANSrR0w1Y
	 s/z9PylET88W4tz5IlGq636l0VY8CB8MZ8GSuFQpxqhCGjfga9VjsE7xld4VCH26haw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629496;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 User-Agent;
	bh=h+ps2IWGI8Jg5YPC535dLnENDr9Z+hqvQ5jTtLrvQbU=;
	b=5BWBi5ygl5Vvt4yHD9rYwa4hNCFqlxSwo5nAG6ujC/r4Cjvb8xWahaSJmWm28psPHzzV
	 RwDt7gtN3hi+Mav4vtb1GZJqyEspVSVQejvIjKQru3s13q3MX5yApyYjqJM1Bmka78QIP
	 vrJl1dyW4y4t5zSzxKZhkT1OEbhSBuqXDRZaC7OL+7SBmqlajiHBwgfns1Iv2EcZN3vSd
	 ubdws+Jlnbv0/HeBF9e6lfXq2RBGFOuft0u14dsMwrremDI9whWIWWyAOI5XtxiI9BY1Q
	 0HWnCFoO6bDtyIWXW9bk8R7BJzhGVPDwLPZEhGe2Rk+LQvzuqAFxO47EZW7Uzsuy8kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HG2yBQeJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156AB606A934;
	Mon,  2 Nov 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HG2yBQeJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCCB1F00A17;
	Mon,  2 Nov 2026 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629495;
	bh=h+ps2IWGI8Jg5YPC535dLnENDr9Z+hqvQ5jTtLrvQbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HG2yBQeJkTai0pStmuvVGguBEoEeRXj1gntZ/xxEKbiEoKUs/4KIa/BeiVGx5/Ice
	 RergW1Z3nJx5dXIbmBXp2QD6Ct/PguArKCm88y0ntBp2CYKJLGArVPFwgGLe8YrjMC
	 Aa4AO5G64etC8GM2zQqRTGi4IAgIL2peJcOjgLD+pe4XUHfVe5DxVizaxQKwYGeUOz
	 xbMk9rUtrpH8UeqzSCMP75ymuPCAi+i5jJzhlelP45TXHTgSNewkUqRLlQZ69r3eJY
	 QqJWETkvomX6y09thVyOrS/etcACC41Ss0cCh6yz2xgyoPYDOe3Jf0Na2SDsSPWjS5
	 FlugdEdmmcftQ==
Received: by pali.im (Postfix)
	id 6FDF0A13; Mon,  2 Nov 2026 15:24:52 +0100 (CET)
Date: Mon, 2 Nov 2026 15:24:52 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
Message-ID: <20261102142452.d6jkitgdeuquy23i@pali>
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
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
In-Reply-To: <20261101015551.786044-4-koray.fra@gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (flags & FS_APPEND_FL)
>  		new_fl |= S_APPEND;
>  
> +	if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> +		ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
> +		ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
> +	}
> +
>  	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
>  
>  	/* Save nodump flag to return in ntfs_getattr. */
> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  	if (unlikely(is_bad_ni(ni)))
>  		return -EINVAL;
>  
> -	stat->result_mask |= STATX_BTIME;
> +	stat->result_mask |= (STATX_BTIME | STATX_PTIME);
>  	stat->btime = ni->i_crtime;
> +	stat->ptime = ni->i_crtime;

For me this patch looks dangerous. Somehow I would expect that the
"btime" will never change for existing inode.

But because the ptime is mapped to i_crtime and ptime is settable from
userspace, with this patch it is directly possible to change btime.



I was thinking more about it... Is not this just misunderstanding of how
the security model around the times is working on different systems?
Because on NTFS there is stored just one field which says when the file
was created. There are not two fields like "time set by user and time
set by system".

Windows security model allows anybody with WRITE_ATTRIBUTES access to
change that create time. Linux security model does not allow to change it.

NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
In my opinion if the ext4 or btrfs filesystem is correctly implemented
on Windows systems, then Windows security model should handle it in the
same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
access, then Windows should allow to change also btime on ext4 or btrfs.



On the other hand, I understand the use case to have two creation times.
One time which would never be changed and could be used for any kind of
atomic / synchronization by userspace application logic (this btime).
And another time for human which can be changed at any time to any value
which user wants (this ptime).

In any case, I would suggest that filesystem driver would not report to
userspace unsupported values and would not try to invent other values
and lying about them.
