Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B0D38BF60;
	Tue, 24 Feb 2026 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771934718; cv=none; b=l2it+w6H6V09d1m7OP6u6V3umCCcIMBIeLtcXNQKaVLppkrXhgKJCiqxOSTgjWMhao80sW5Xw8Um1FPQ2/qvi4hStFVTp/pDWKrK0ff6km+QJfgfzJzidBnawTCtac/IU+R8ceA5TWcRzueBF4pAfGKJtptupHD6B0dJh8FPTH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771934718; c=relaxed/simple;
	bh=uyHZHiDaI76P3wMbcjfRYTIsblHmF/n0kgvN3nM67TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ug3n5kkiZZiUQVrfJWeFfo3YggddQo8huw2JLQWCMIfLuiCRVq4VZ0//e44tNhHTYjA/yGUyG0hxfrpUiV6pdqnAub0cpgTXE7JXbUjVBUApt43TleHaZ6oC2Zi/EY2JKCiBgtrhsfsfMqMUJRgyfZ/2m8fVgsiMgPd9fYFhY0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrQISAiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrQISAiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68992C116D0;
	Tue, 24 Feb 2026 12:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771934717;
	bh=uyHZHiDaI76P3wMbcjfRYTIsblHmF/n0kgvN3nM67TQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rrQISAiBZbxi014QUg+0NsptwrL/HoyNe8+pINU/fOqAkzXQsDuOc+HYQYbjDNcdj
	 N6xdOuLC/SxMD9Xdhcv7Z98YsMQ9QmF8DRDkt+bXUVV6xi3RpzHjg17N9Y/7VwRLMZ
	 76/KE+jRmQYHAeRgOyoHawrUN6z3yc+KUHErpaMZnbQv+6uGfsCxqDRL6qI1Mx+wNW
	 oHZcdtCST1nMSg6ynsSFVAQZm3BESolWjq70dCl5geiZwATPdeseqECT9dP0rM8MYn
	 qdFpW0IQ1DbuPnN+Bdm0+vOBkvOAjtmYUDullhHcIQClGLF6rWQ/50RlGr6xiMzKwt
	 W+/lgwN81vx2A==
Date: Tue, 24 Feb 2026 13:05:12 +0100
From: Christian Brauner <brauner@kernel.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Amir Goldstein <amir73il@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>, 
	linux-api@vger.kernel.org, rudi@heitbaum.com
Subject: Re: [PATCH 1/2] mount: add OPEN_TREE_NAMESPACE
Message-ID: <20260224-erbitten-kaufleute-6f14e3072c5d@brauner>
References: <20251229-work-empty-namespace-v1-0-bfb24c7b061f@kernel.org>
 <20251229-work-empty-namespace-v1-1-bfb24c7b061f@kernel.org>
 <lhuecmaz8p6.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <lhuecmaz8p6.fsf@oldenburg.str.redhat.com>

On Tue, Feb 24, 2026 at 12:23:33PM +0100, Florian Weimer wrote:
> * Christian Brauner:
> 
> > diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
> > index 5d3f8c9e3a62..acbc22241c9c 100644
> > --- a/include/uapi/linux/mount.h
> > +++ b/include/uapi/linux/mount.h
> > @@ -61,7 +61,8 @@
> >  /*
> >   * open_tree() flags.
> >   */
> > -#define OPEN_TREE_CLONE		1		/* Clone the target tree and attach the clone */
> > +#define OPEN_TREE_CLONE		(1 << 0)	/* Clone the target tree and attach the clone */
> 
> This change causes pointless -Werror=undef errors in projects that have
> settled on the old definition.
> 
> Reported here:
> 
>   Bug 33921 - Building with Linux-7.0-rc1 errors on OPEN_TREE_CLONE
>   <https://sourceware.org/bugzilla/show_bug.cgi?id=33921>

Send a patch to change it back, please.
Otherwise it might take a few days until I get around to it.
