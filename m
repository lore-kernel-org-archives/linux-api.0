Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7202882899;
	Fri, 22 May 2026 04:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779422528; cv=none; b=o3sq0PEw2p/DW7vmgPEOHPRkuMJZh3PVLAPnkNmU8KbemH6zcgaKBt8mWppjXC7x3iOXgOSC5Yxd6wA7X5Je/Xi3C6zh8Ioqsp2jpK+dzAUEGpmmbQIRoF8cQmlcrvVSrD2HyrhqjRqT0yTAB5n8Ex/mNQAECFS0YCoNISrNOiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779422528; c=relaxed/simple;
	bh=a1dlM8iJuJM1TSh53Q3cSojpGU+Vmv7z09jD7VTe34g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyB33F6zIZYOlY851nvcvWoideQJAhOOG3Le0Bdg9ysBlMZsxWskVaqutIKwaK+z+siHqksF1mPN0uaZOT21NCH/Sssl364CnTTEQKmFS6jyfSsAEeO3LWzHEtQbvZNILWmDFL5BlbTKUQIc7BIMhy3GfexYTxnTDgr3qjAX2b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5U8pIq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5U8pIq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80681F000E9;
	Fri, 22 May 2026 04:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779422527;
	bh=GFwLqtBegPrYOeSN0ye6SbCQz3TQv1Qmus2tJiQyxPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V5U8pIq9CYVjKN1M26c9b9NKyxbKNnsst43BpYHw1DsITUIVizoffTmheov44CS5q
	 RC4YKVuVcJV1HeIny7fKMAPNUaVudn/uTOVvE44fxeitC4tGQLrVW5VFS7IbGno+H+
	 cT2aATaZRzZsglm4rt0Y9AF1jrW8fI5GyXvQw0rIyoOyDQW+I92HQ7KEz4K8PpOoiP
	 83HyHOFnC80JpiUmO6zQ2C4JY4DUjKUow0IeN7OzXJfPEspGNm+1XkSkX6RsNMyFZx
	 hWGUUq+V+NminNRePBFveQW0fsFFOrqS7G+6Qjvo70M6y6660opAlN7QRmJHAlwatb
	 Ezhvlm7T0Nwlg==
Date: Fri, 22 May 2026 04:02:05 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ag_VPae3w2z_SXD9@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522035331.GE5937@quark>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522035331.GE5937@quark>

On 05/21, Eric Biggers via Linux-f2fs-devel wrote:
> On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> > On 05/21, Theodore Tso wrote:
> > > On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > > > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > > > patch.  There's no justification for why f2fs is so special that it
> > > > > needs this.  What the hell is going on?  You know this is not the way to
> > > > > get code merged into Linux.
> > > > 
> > > > None of this got properly answers, and this broken interface now landed
> > > > in linux-next. IT is offloading a user.* xattr which is free-form
> > > > user data with semantics that are weird to say it very nicely.
> > > > 
> > > > All this was done against the advice in the mailing list discussion.
> > > 
> > > So let me get this straight.  This is a magic xattr interface which is
> > > not even persisted in the file system, but instead sets a 32-bit
> > > bitmask in the struct inode which disappears once the inode gets
> > > flushed from the inode stack.  And it uses a generic xattr name,
> > > "user.fadvise".
> > > 
> > > There's no way in *hell* any other file system is likely to adopt such
> > > a broken interface, so why didn't you just use an ioctl to set this
> > > magic f2fs-specific flag?
> > 
> > I went this route because Android heavily restricts ioctl() permissions
> > and we needed broader access for this to work within the framework.
> 
> It's straightforward (2 lines I think) to update Android's SELinux
> policy to allow an ioctl in all domains.  So that doesn't seem like a
> reason to not use an ioctl.  In fact this is actually a reason *to* use
> an ioctl, as it shows that ioctls can be allowed/denied independently as
> needed, whereas xattrs just use the file write permission.

Ok, that's also great news to me.

> 
> - Eric
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
