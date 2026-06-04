Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F7437CD32;
	Thu,  4 Jun 2026 06:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780554743; cv=none; b=K9zHa0S3wsmAw3pUubpKwILtQyE4aTh1SqN1CIdoiHlzhy9rOZQKmNgpv9Yz7kvh9jivYu+jAEsO4OV1o0APLIDDHuesew2351g6tdcZMocTHjJ63gD9rINN4QOwpdzkV9bIOPVtEk743YWdmtUu9mcRKuTYgd5D1Q9XeTJKQUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780554743; c=relaxed/simple;
	bh=SfnC9yJJuifTGy+OR43943J7ylh76jONzzAr29Kxf08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a8H3R1Euu6iDrq+FJz1Lbsj+Av75SZ7IFHD98zdzlu++AQoHu+VCbABixM1TJXH3UtvuI3GrXX/BoSvIOf2xgKuzJw2q3j4tt2gQYiATq5A2aQMucyiKAIwipr1lV9ASNFBgJdzpai1S4BrkKX0wi5iV8m5nmDJPcgMvZhhZbzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=jpkB2nzY; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="jpkB2nzY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780554737; bh=D9nwLs4KwMwQ80PQ1Q3ExZLliPxSXG1vTX5NNZIw0Hg=;
	h=From:Message-ID:From;
	b=jpkB2nzYMYFGJLo2yxhZ7zzA+WhfbH6IPBDq/rnj5kwadTf4T1dykNg7QvtDS3q/f
	 X1+Gc6B00HW6CKs9VJ9MpDO6InL90L1sxTWsIl/GvAc+96Vwhwlca0ShHaEEmf4bvI
	 0SMiD+Gpq2qOzkk1UhzhXudoxeVA4OeVV8ZoBGyc=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 989C8C0B73;
	Thu, 04 Jun 2026 08:32:17 +0200 (CEST)
Date: Thu, 4 Jun 2026 08:32:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Brauner <brauner@kernel.org>,
        Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aiEb8CTM-ovMIq7-@1wt.eu>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>

On Mon, Jun 01, 2026 at 05:28:25PM -0700, Andrew Morton wrote:
> On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 1 Jun 2026 18:33:25 +0100
> > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > 
> > > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > > 
> > > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > > > a big simplification.  
> > > 
> > > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > > Communications between the kernel and fuse server at least used to
> > > seriously want that, so that would be one place to look for unhappy
> > > userland...
> > > 
> > > splice-related logics in fs/fuse/dev.c is interesting; another place
> > > like this is kernel/trace/, but I'm less familiar with that one.
> > > 
> > > rostedt Cc'd (miklos already had been)
> > 
> > Thanks for the Cc. The tracing ring buffer was specifically made to be used
> > by splice and the libtracefs has a lot of code to use it as well. As
> > reading the ring buffer literally swaps out the write portion with a blank
> > read portion, that portion (sub-buffer) is used to be directly fed into
> > splice, providing a zero-copy of the trace data from the write of the event
> > to going into a file.
> > 
> > trace-cmd defaults to using splice to copy the tracing ring buffer directly
> > into files to avoid as much copying during live recordings as possible.
> > 
> > Whatever changes we make, I would like to make sure there's no regressions
> > in performance of trace-cmd record.
> 
> Well yes, The patchset seems sensible from a quality POV.  But to make
> a decision we should first have a decent understanding of its downside
> impact.
> 
> I haven't seen a description of that impact in the discussion thus far.
> And that description is owed, please.
> 
> I assume a small number of specialized applications are using
> vmsplice() to great effect?  What are those applications?  What is the
> impact of this change?

> Once we are armed with that information, is there some middle ground in
> which we de-feature vmsplice()?  Fall back to pread/pwrite in the
> tricky cases and still permit vmsplicing if the application is
> appropriately restrictive in it usage?

I'm using vmsplice() + tee() + splice() in high-performance applications,
load generators to be precise, and soon a cache. This is super convenient
and extremely efficient:

  - vmsplice() is used to prepare a "master" pipe with data to be sent
    over TCP or kTLS
  - then for each request, we do tee() from this master pipe to per-request
    pipes.
  - the per-request pipes are those that are used to deliver the data to
    the socket via splice().

So we effectively use vmsplice(), tee() and splice() here, and for exactly
the reasons they were designed: only play with page refcount and not copy
data. The code is here for the curious:

   https://git.haproxy.org/?p=haproxy.git;a=blob;f=src/haterm.c

and its ancestor is here:

   https://github.com/wtarreau/httpterm/blob/master/httpterm.c

It simply doubles the network bandwidth compared to not using that.
(62 Gbps per core vs 31). I would seriously miss it if I couldn't use
this anymore.

I also have mid-term plans for using vmsplice() to deliver contents from
a cache to sockets as well via splice(). Right now our cache is split into
too small chunks (1kB) to make that useful, but as soon as we can move to
4kB pages, it will make sense. There the same gains are expected, and I
would particularly dislike the idea of no longer being able to implement
zero-copy!

Maybe some arrangements are possible though. I'm not seeing any other way
to achieve the same things differently, but possibly that the base of the
problem is the easy abuse of vmsplice() to affect the page cache. Maybe
placing certain restrictions such as he area only being mapped to anonymous
pages, or anything similar could make sense. In my use case it wouldn't be
that much of a constraint. Well, for the cache maybe it could be though,
as it would prevent us from sharing it via persistent storage. Or maybe
we could require a CAP_BACKED_VMSPLICE to be allowed to vmsplice file-
backed pages, which could be sufficient to prevent easy LPE each time a
bug is found ?

I think that the users of this APIs are rare enough that we can probably
find a solution that anyone can reasonably adapt to with minimal
constraints. But most likely each of these few users rely on this
*a lot*.

Just my two cents,
Willy
