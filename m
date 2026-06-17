Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE84370AD6;
	Wed, 17 Jun 2026 11:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781694479; cv=none; b=kjeGArxkuwuUYeXeAORLvBi9AVUKUbo0S09MyRSOyukW/1sFuuH3nO7Mnh8lA86wi2aJhtbT62fqEg6jm/XJymW91bfFGMlnpFKrhXFFgtQQJpl7IEju7Kcrxgwd5X3fqWdKWWBloakeKgyu4WaQhlUPTrFV+QvHJYm0MAGoDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781694479; c=relaxed/simple;
	bh=t8E4VL5k1FCWK4bBsLA60HlUaTKskXgiRWXceTi/Z7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYkfYBRqaGqTMdUGbcl2Qd4dprzdGTDzGflPI5nzMSNhVXlCIVuXwiUlF8S/6usluOXk4NrQuXQ6XNH5Kd8WVXQhG61Ysq/5VcAHIHD7y+PGxg4l+ZX8fQsM8fNJJP0BLZNqqJHPRNFI7NwRC3wNU5T5ZabhyL2CxxpfsQa6jog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLqJtmaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLqJtmaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8091F000E9;
	Wed, 17 Jun 2026 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694477;
	bh=t8E4VL5k1FCWK4bBsLA60HlUaTKskXgiRWXceTi/Z7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NLqJtmafqtIX3Tb8AE5w+R11U0MKcAWK4r/JDthJKBeBFww+/nhMWIF7Vcjo3XlrP
	 C+sMhhL877RwyM+BGepimtw0NisPuB3Fe44rYPXiUZt9dVlwKN4VrqVF9me6YdDbHl
	 pFFXT0/2ZIigetaxoFUza6yYSkGZgku//+clVHrXjPGOM3iNH3j6c9GZ2OoQTBrAiL
	 VNnD6yyvKpw7cHJSzgO6M1+U/I2Q5KYWJMTWD6vE4mdDhWQ/4FmLOGMt9O6OYslvQT
	 ZVS4vIGo6Gf6cZHxw6BlWAWXLCudd7RA3cuiRLh4h9rHyWFqgckeY4P/SUMhk1pdmH
	 DcVGLtqx4J2yA==
Date: Wed, 17 Jun 2026 13:07:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Val Packett <val@packett.cool>, Al Viro <viro@zeniv.linux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, Bernd Schubert <bernd@bsbernd.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>

> After this patch, step b) is a straight copy which means step d)'s
> fixup doesn't modify what's in the pipe. This could be fixed up in
> libfuse to not depend on modify-after-vmsplice, but I don't think this
> helps for applications using already-released libfuse versions. I
> think this patch needs to be reverted.

Note, nothing was merged. I deliberately kept in -next though for a long
time to see how quickly we'd see regressions.
