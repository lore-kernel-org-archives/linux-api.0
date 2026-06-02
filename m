Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8678C3909A4;
	Tue,  2 Jun 2026 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780425883; cv=none; b=T1/OP8ui6Tej0fsXje8xZUpjZiAKt3R8uebIWgW8ygSLxZDKzKhLlA3Wg55cU6lK1pmUrBJIdBxviT2VihhqpuPIVi+m7N+ycBQXArnq+oSUvrkxlTeCNkldeoKkQYgyaN6ybAMnY2g3RKVeqZk40jKQ3ByCFrYchKiUAgRK+iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780425883; c=relaxed/simple;
	bh=IAJgDRvTCvMXiiaxRtRemk9HFoGhIAzgZdjXk1Y3atU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABS9ujdSL4kgrZKxQff3FWl0X4Xzq3ad+hlk/1V/NLA/uSq6Wo984EnRAXyNDaHUs6mKp6Zo2iLcoxrz6bT9ryTPM+cggLF3J0mTwHinPxttrT+ijHigmw7KQ0hJHD0dxIJR0QQCwtHmLfMp19zb/oShCKwBvKbIaNStTAuvO/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkPgGXeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkPgGXeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883B11F00893;
	Tue,  2 Jun 2026 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780425882;
	bh=MLZpb/dBT6Cd/zdymSeQQn2ShIJqYaKuCdbAYTAgCEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZkPgGXeJhcybPoUrwoJsoHbVqWODRisiZEor43NouJ0EOonoHtL5ZjXT5z2iJq2OW
	 GDChFmTvh0mNbkacQwKUaKroi/K5VuMWckc3qDOZkoGWloPBy/BiNDmIsaDfaEbVdt
	 SJIvc7Zr/r1UimXiaMWvOVkDxmTPRqm5nQj0oHRrXQP3pz160C1TveVTP7t69+wX+y
	 4XU2qNwckg8sNPBwiMTbYksGRjLuaZKd4WSdoPd/PXHbT4sUKt38KmcNBD0nQUxgYG
	 yrp+jU8aG/MhN4ziuGvqzI6WZWvejPq1QXRH+RvSiAdjLWhsMCdLfqKnatMcOtteZT
	 VzdugpvG6XUWg==
Date: Tue, 2 Jun 2026 18:44:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-api@vger.kernel.org,
	netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260602184440.GB2503276@google.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <821ed41e-5b2f-4d17-aeb2-71b0361f8e7f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821ed41e-5b2f-4d17-aeb2-71b0361f8e7f@kernel.org>

On Tue, Jun 02, 2026 at 10:25:06AM +0200, David Hildenbrand (Arm) wrote:
> On 6/2/26 02:28, Andrew Morton wrote:
> > On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >> On Mon, 1 Jun 2026 18:33:25 +0100
> >> Al Viro <viro@zeniv.linux.org.uk> wrote:
> >>
> >>>
> >>>
> >>> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> >>> Communications between the kernel and fuse server at least used to
> >>> seriously want that, so that would be one place to look for unhappy
> >>> userland...
> >>>
> >>> splice-related logics in fs/fuse/dev.c is interesting; another place
> >>> like this is kernel/trace/, but I'm less familiar with that one.
> >>>
> >>> rostedt Cc'd (miklos already had been)
> >>
> >> Thanks for the Cc. The tracing ring buffer was specifically made to be used
> >> by splice and the libtracefs has a lot of code to use it as well. As
> >> reading the ring buffer literally swaps out the write portion with a blank
> >> read portion, that portion (sub-buffer) is used to be directly fed into
> >> splice, providing a zero-copy of the trace data from the write of the event
> >> to going into a file.
> >>
> >> trace-cmd defaults to using splice to copy the tracing ring buffer directly
> >> into files to avoid as much copying during live recordings as possible.
> >>
> >> Whatever changes we make, I would like to make sure there's no regressions
> >> in performance of trace-cmd record.
> > 
> > Well yes, The patchset seems sensible from a quality POV.  But to make
> > a decision we should first have a decent understanding of its downside
> > impact.
> 
> I guess most (all?) of us ... dislike ... vmsplice(), so trying to remove it
> entirely is certainly very appealing ...
> 
> > 
> > I haven't seen a description of that impact in the discussion thus far.
> > And that description is owed, please.
> > 
> > I assume a small number of specialized applications are using
> > vmsplice() to great effect?  What are those applications?  What is the
> > impact of this change?
> 
> 
> I did some digging, and the kernel crypto API documents using splice/vmsplice
> for zero-copy[1] and libkcapi [2].
> 
> I did not find performance numbers, how much vmsplice/splice actually gives us.
> Playing with the kcapi-speed tool [3] (specifying --vmsplice vs. --sendmsg)
> doesn't really reveal a big difference at least on my notebook. Not sure if the
> parameters I specify are reasonable.
> 
> I don't know whether downgrading vmsplice to preadv2/pwritev2 would perform
> significantly worse than sendmsg ... and I don't know what the default would
> usually be (default to vmsplice or sendmsg). I might try finding some time to
> play with it more, but I doubt it, so if anybody else has time ... :)

AF_ALG is a mistake and isn't commonly used.  Using a userspace crypto
library is faster and is what almost everyone does anyway, as it avoids
the syscall overhead.  There are many other issues with AF_ALG as well.

7.2 will mark AF_ALG as deprecated, mostly remove AF_ALG's zero-copy
support, and remove AF_ALG's async I/O support:

    https://lore.kernel.org/linux-crypto/20260430011544.31823-1-ebiggers@kernel.org/
    https://lore.kernel.org/linux-crypto/20260504225328.25356-1-ebiggers@kernel.org/
    https://lore.kernel.org/linux-crypto/20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com/

In practice, the programs that are keeping Linux distros from disabling
AF_ALG in their kconfig outright are just iwd, cryptsetup, and bluez.
They use AF_ALG just because it was mistakenly thought to be easier than
using a userspace crypto library.  They don't need maximum performance,
nor do they use vmsplice, splice, or sendfile.

There is other highly niche code out there that does implement the
AF_ALG + vmsplice + splice thing, e.g. libkcapi.  But it's just not
enough of a reason to keep zero-copy support, especially considering
that AF_ALG has always been the wrong solution in the first place.  The
fallback to copying the data is fine for this deprecated API.

- Eric
