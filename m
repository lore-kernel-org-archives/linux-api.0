Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777468;
	b=izkO4QhqtoNvrkQ/fQLzGvezTmCyKXJn+uI19rRaxMaMhxBVHaahrQy33ugt+U3jV9Wr
	 hLklfrO6qClWlGomr64noSZ/1WfzWom1eFRDWVe5sb+DLTKM2MA8V4bMLmmc6Yo7p0TZT
	 yfFJzNL/ifJ/wvRvGUveqDuhyoY3qbNNRs6gshbU/Rlei5+yA/FikscBrgUD7r4/ouGI7
	 TUzw0mgraZZXZv66TKbDKUumWT/m1xlgWNfbIEXRW+isdxMvDeKKU6uLHfhVKwwT66Ee7
	 WBqgf6ERQLwopG1K6bkXmAO2RDm6nJjYAzPgNus2V8W2TPdR/4x66qzrkjeGHUcF7/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777468;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=pkdjWus5knRkpiK/IaGC5F8JUCPOn32ecVHJLQtmr8c=;
	b=bCTSn8lQyUiZBDZZz0gFqtBhS6zeQMWIrAy/G24vt7leERxyVapou5IHHNfm3j1PTJki
	 GIQUmAQfiXD6no6j6d741Hb6EUyc0/et5c821xiO8NiiuuFWDlOS5rJWKWmfb0XFxXCB3
	 GE5KdeoaDgb6wLngb0rxUQat/Xa3/yu5W1yog5f8yWW/F4CsqfUAWrmQDpMyG/H2DfDin
	 BGONhR9BVywgrI9q40VocO1642/LS1jBBxkMgU0uaVhcENe2IqkOUYwk5JoqQ7PpDb9JJ
	 Um+LaUGdUAE+4jdlHmeORZVRKRCYrZtbqs7Zcsbdt3PEJRhZCdYIIlovZFEOBu9Emsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2F6606A31B;
	Wed,  4 Nov 2026 07:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A2F6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 611F368C4E; Wed,  4 Nov 2026 08:31:00 +0100 (CET)
Date: Wed, 4 Nov 2026 08:30:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Stefan Metzmacher <metze@samba.org>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	io-uring@vger.kernel.org, linux-api@vger.kernel.org,
	willy@infradead.org
Subject: direct I/O vs buffered I/O coherency, was: Re: [PATCH] fs: add
 RWF_DIRECT for preadv2/pwritev2/io_uring to set IOCB_DIRECT per io
Message-ID: <20261104073059.GA29199@lst.de>
References: <20261012184642.558349-1-metze@samba.org> <20261021-kontakt-hauen-albern-9053a385d79e@brauner> <20261103080718.GA4109@lst.de> <CALCETrU0jXA7PJwsL059O+ewqTBopdopbDwMuH-Rb8M5yLdUew@mail.gmail.com>
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
In-Reply-To: <CALCETrU0jXA7PJwsL059O+ewqTBopdopbDwMuH-Rb8M5yLdUew@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 03, 2026 at 11:13:32AM -0800, Andy Lutomirski wrote:
> Here's a bit of a taxonomy of page cache access types that I've come
> up with from poking around at the kernel source [0]:
> 
> a) Plain buffered I/O (pread, pwrite, etc) -- I'm sure there is a lot
> of nuance here, but I'm generally referring to I/O, via pagecache,
> done in syscall or io_uring context on behalf of a user request.
> 
> b) Access via MAP_SHARED mmap or via unbroken-cow MAP_PRIVATE read,
> whether this is actual ordinary user access or one of the weirder
> cases like KVM that hits it by cheating a bit and using mmu_notifier.

This really also needs to be split into

b1) Read-only access through MAP_SHARED mmap without PROT_WRITE
    or unbroken-cow MAP_PRIVATE read.

and


b2) Writable access through writable MAP_SHARED mmap.

> 
> c) O_DIRECT: not actually page cache, but it does *logically* touch
> the same data that might be in page cache.

As in the file side of direct I/O to make this clear.

> d) Access via pinned folio.  We have reads and writes, and we have
> non-longterm and longterm pins.

... and this includes the "remote" side of direct I/O if done to file
backed VMAs.

We also still have

e) access through get_user_pages without pins.

e) really needs to die ASAP, but various maintainers have dragged
their feed and kept it.  And of course there's still vmsplice which
kinda hardcodes this into the syscall interface.

> But why can't an O_DIRECT access be coherent vs mmap?  (I'm assuming
> we're talking about O_DIRECT writes, not reads.)  ISTM the kernel has
> two ways to do it coherently: unmap the mapping (slow) or copy the
> data being written into page cache and then write it from page cache
> (differently slow).  If anyone mmaps a file and O_DIRECT-writes it
> while they're touching the mapping at high frequency, I'm not sure
> they deserve excellent performance, and I'd rather give coherence than
> high performance incoherent behavior.

Because reads invalidate the mapping they are just as relevant.
But yes, both could fall back to some form of buffered I/O if the
relevant ranges are mapped.  And maybe that is the best thing to do.

Note that this also means we need to prevent new folio in the page cache
from being instantiated while direct I/O is pending.  For XFS which
always take i_rwsem on buffered reads that's reasonably easy, although
we'd need additional i_dio_count checks (or move to non-owner release
of i_rwsem for direct I/O).
But other file systems don't do this, and they get significantly better
performance for small cached buffered writes, so they probably do not
want to change that.

Leaving the rest in here for context.
> 
> 
> Anyway, I have a sort of proposed definition for what coherence might
> mean -- call this "weak coherence":
> 
> For each address in the file, there are various accesses.  They happen
> in an order -- think of this like a CPU memory model, not a strictly
> linearizable order (if nothing else, mmaped accesses literally follow
> the CPU's memory model).  But we broaden the memory model to pretend
> that it applies to the logical file, not to the physical memory. The
> implementation is weakly coherent if:
> 
> - Accesses via mmap obey the CPU memory model.
> 
> - Accesses via syscall or io_uring *including fixed buffers* obey the
> CPU memory model, except that the access may be broken up into smaller
> accesses that happen in arbitrary order, so long as they all happen
> between the submission and the completion of the request.  This
> includes direct I/O.
> 
> - Accesses via longterm folio pin follow the same rules as mmap.
> 
> - Accesses via shortterm folio pin are like syscalls: they happen some
> time between acquisition and release of the pin but are not
> necessarily ordered at the time that they are made by the CPU.  (This
> is the weak part.)
> 
> I haven't come up with a reason that this would be impossible to
> implement nicely, except that longterm folio pins would need a much
> stricter locking scheme: anything that wants to detach a folio from an
> address_space would need to wait for the pin to be released or
> actively expedite the pin's release.
> 
> Is there a hard issue with O_DIRECT that I haven't thought of?
> 
> And someone would need to go through all the short-term pins in the
> tree and make sure they're all actually okay with the weak form of
> coherence.
> 
> I think there's at least one example that I think is questionable:
> iov_iter_extract_user_pages, as reachable from FUSE and possibly
> elsewhere.  Suppose there are two FUSE filesystems, A and B. A has a
> file a and B has a file b. A process mmaps b, faults it in, and does
> read(a_fd, b_ptr, 1), and the FUSE kernel code takes a short-term pin
> on b_ptr's folio.  Then, before A's daemon responds, B's daemon
> requests invalidation of b (via fuse_notify_inval_inode), which calls
> invalidate_inode_pages2_range, which removes the folio from b's page
> cache. Then A's daemon responds to the read via splice from a pipe,
> causing the kernel to write to the short-term pinned folio, which goes
> off into the void.
> 
> Is this a bug?  If B's invalidation happened because some external
> actor logically wrote to *the entire area covered by the read*, then
> arguably it's not -- under my coherence model, the read syscall can be
> deemed to have occurred immediately before that write and the results
> simply got overwritten.  But if B's invalidation happened for a
> different reason (say an external write to a non-overlapping range),
> then I think this behavior is incorrect.
> 
> Similarly, if there is just one FUSE and B is an ordinary filesystem,
> then userspace can do read(a_fd, b_ptr, 1) and overlap it with an
> O_DIRECT write to b at, say, offset 512, size 512.  If the FS accepts
> that, then the folio gets detached and the read's update goes into the
> void.
> 
> 
> That last example seems more likely to hit if RWF_DIRECT shows up and
> some library is like "hey, cool, now I can use our shiny atomic direct
> I/O features in what used to be a buffered I/O path".  And maybe this
> isn't a *security* bug, but it is an observable case where a simple
> read() call appears to succeed but does not actually update the
> destination buffer.  Ouch.
> 
> 
> Anyway, that's my brain dump.
> 
> 
> [0] Despite the fact that I got my start doing serious kernel work as
> a result of writing a memory mapped database of sorts, I've never
> actually stared at this part of the code before now...
> 
> 
> --Andy
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
---end quoted text---
