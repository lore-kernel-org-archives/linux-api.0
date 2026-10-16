Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0C037A833;
	Fri, 16 Oct 2026 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792162202; cv=none; b=OG7Y6X3ypXpycVMKA+uBToJ5jROnzLtEwiaPNglNIVyzn/3Unc0KJcmb42553hYbNFLIHiKodWLLl+sm/81Ipbaa5qWQhWBUiqdCnd58wnDCyjQAhKbo6lpBFDXMAT5jrFU/fzcrO/TiBykGpigG3OUKB0xd02udNj2C897So1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792162202; c=relaxed/simple;
	bh=3oVsqgR6QWCr1wnCTiWnz68ltC2UitHUqxVqn9QjEwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrEJIRAM4SlDYQg8aO6gRW58rosgKQjmKy6Slv3pXgsjr9A7mR+KIw+4UDjb4/akVXmKDKzdN1Xy8KOl1yuoLKM60UB/zP2bmKbVfHs+Ja6smW8qSuvlHvY6KPpJbu6jGmfxbqc6Kcg6R3UjYPdx5FlYE65Xp9w3SkMYiYkkkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FG/dhRBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FG/dhRBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01781F000C4;
	Fri, 16 Oct 2026 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792162201;
	bh=sYF+g4bwj7gR3EA8CYKHagb1DJ1vROZwWDQ7o9vjfik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FG/dhRBvbvi3cke4fjRtGCMP/KhOj5N6Gtfzxc2Dk88HhPJ24xnMFFkYCA92Wo3dx
	 igHLjv+KiJLZGBzyYwW9tvO9HG5y+PEuVcWp6drH77Eq75ZvhxvQuwU8QxJexE6alp
	 Ak5HFqu6kpDa7S3wzcBL7bTPIiHcrMFX0hzVxG9U=
Date: Fri, 16 Oct 2026 16:50:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v7 07/12] kernfs: hold kernfs_iattr_rwsem when
 initializing a new inode
Message-ID: <2026101626-idealist-overshoot-26d6@gregkh>
References: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
 <20261016143806.2946578-8-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016143806.2946578-8-jkoolstra@xs4all.nl>

On Fri, Oct 16, 2026 at 04:38:01PM +0200, Jori Koolstra wrote:
> kernfs_refresh_inode() copies the uid, gid, timestamps and nlink of a
> kernfs_node into its VFS inode. Since commit 9caf69614225 ("kernfs:
> Introduce separate rwsem to protect inode attributes.") these are
> protected by kernfs_iattr_rwsem.
> 
> kernfs_init_inode() calls kernfs_refresh_inode(), but was not converted.
> Its callers in turn hold kernfs_rwsem (kernfs_iop_lookup(),
> kernfs_fill_super()) or no lock at all (__kernfs_fh_to_dentry()),
> neither of which excludes a concurrent
> kernfs_setattr()/kernfs_iop_setattr().
> 
> Take kernfs_iattr_rwsem for reading around the refresh in
> kernfs_init_inode(). This nests inside kernfs_rwsem, which matches
> kernfs_link_sibling() and kernfs_unlink_sibling().
> 
> Also, kernfs_get_inode() then does not need to hold kernfs_rwsem, so
> drop it from kernfs_fill_super().

Oh, nice, this fixes the issue of kernfs not keeping the inode like we
talked about at LPC?  Can't argue with this tiny patch, nice work!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
