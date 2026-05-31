Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850AE3803F7
	for <linux-api@vger.kernel.org>; Sun, 31 May 2026 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780217685; cv=none; b=kFFXDn8djoDPddrvMOUqLneHX3SWJFxI+S18rn+RbmNvxMOS4vM6M01mPKepGIkhsxQD8Z406Tue9s1n/YfSVi41TkLFX9YVIzv1Uyo9JW++jAjuu+FhvhxLesGHhZ/3M7G5Tc1mxaO2Ts4rNMawfrfjmKYEG6t4MkwX+8ThX7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780217685; c=relaxed/simple;
	bh=rwIvYN6/KOpYov6A6govvRNz4aRurtOdWRBbQTzDYe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jckqAd51KdlwwXQCXmLloi5yoJQSbLVPd7dZ4Qbc1VkpEEJmhQweckiPIHtaNmYHDHmbHrL75C61mac/nPzFVQ79Q4X/xQvT5bELcK8aIW6LeakMhaCl4Cn6gPCVfi0JecLZSi76IeWG3J9zgShbXSRFsSaz8y6ANbR8kr8l4TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1PfAKGNY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ksGbBsF0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1PfAKGNY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ksGbBsF0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1PfAKGNY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ksGbBsF0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1PfAKGNY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ksGbBsF0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2B286BA92;
	Sun, 31 May 2026 08:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780217682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=1PfAKGNYLhagnBvHtb+ubUaVyu9eogDCXRol6ohlXDMFxCVLhFUItxHBits6KpctmU2d6t
	hjOkZY+H+sW25hQOlhwUmoBGxnvWinhWyOjXTFHii5/+Zyi1L4jRc0FGHpofRv/ahs6J5V
	2o6/tAb0rqCc+3mrBE1xUVyLpmVJQ3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780217682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=ksGbBsF08j/fhsEIBfTY36miAanUPKePhehRER4eUB5+fCdFIDz6w/p2pNFvC/CmI5vu1X
	Bh+SJJZVD3cLMxAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1PfAKGNY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ksGbBsF0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780217682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=1PfAKGNYLhagnBvHtb+ubUaVyu9eogDCXRol6ohlXDMFxCVLhFUItxHBits6KpctmU2d6t
	hjOkZY+H+sW25hQOlhwUmoBGxnvWinhWyOjXTFHii5/+Zyi1L4jRc0FGHpofRv/ahs6J5V
	2o6/tAb0rqCc+3mrBE1xUVyLpmVJQ3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780217682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=ksGbBsF08j/fhsEIBfTY36miAanUPKePhehRER4eUB5+fCdFIDz6w/p2pNFvC/CmI5vu1X
	Bh+SJJZVD3cLMxAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6892A779A7;
	Sun, 31 May 2026 08:54:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wCuGFVH3G2qdXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 31 May 2026 08:54:41 +0000
Date: Sun, 31 May 2026 09:54:39 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, 
	David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A2B286BA92
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[18];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
> This patchset is for VFS.
> 
> Recently we got a lot of vulnerabilities in splice/vmsplice.
> 
> Also vmsplice already was source of vulnerabilities in the past:
> CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).
> 
> Also vmsplice is problematic for other reasons. Here is what other
> developers say:
> 
> Linus Torvalds in 2023:
> > So I'd personally be perfectly ok with just making vmsplice() be
> > exactly the same as write, and turn all of vmsplice() into just "it's
> > a read() if the pipe is open for read, and a write if it's open for
> > writing".
> https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/
> 
> Christoph Hellwig in May 2026:
> > vmsplice is the worst, as it is one of the few remaining places that
> > can incorrectly dirty file backed pages without telling the file system
> > and cause the other problems fixed by a FOLL_PIN conversion, but it is
> > the only one where we do not have any idea yet how we could convert it
> > to FOLL_PIN due to the unbounded pin time.
> https://lore.kernel.org/all/agwFlBKvKytjURDO@infradead.org/
> 
> See recent discussion here:
> https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u

So, you took an ongoing discussion with an ongoing RFC patchset, and you
decided to reimplement part of the idea on your own, as a concurrent patchset.

Riiiiiight.... I don't think I have to NAK this, do I?

> 
> For all these reasons I propose to make vmsplice a simple wrapper for
> preadv2/pwritev2.
> 
> vmsplice(fd, vec, vlen, vmsplice_flags) will
> be equivalent to preadv2(fd, vec, vlen, -1, rw_flags) if you have
> readable pipe and to pwritev2(fd, vec, vlen, -1, rw_flags) if you have
> writable pipe.

This does not work. https://codesearch.debian.net/search?q=vmsplice%28&literal=1
There are users.

-- 
Pedro
