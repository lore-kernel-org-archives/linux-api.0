Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305CC1A6816
	for <linux-api@vger.kernel.org>; Mon, 15 Jun 2026 06:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781504720; cv=none; b=pUiH/iR/RuDd5VBSrFqGUNfQCMzb+YFm3Hbgbk1IQjNun+n2R+hhkKOY96A/Pth26RfhD0LsHuaOGgkoZAhpqwYXF1rj5tNebZLFN/lVbqJbkP+0JiW1giH4cq7Dg3D4lTH15OQjQOYDud8LByPrA6t2fBAz2uzKo43imAnacVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781504720; c=relaxed/simple;
	bh=eMpF6TIlf6+lXcDXCRWJ1GSlKGnokAF6Mi84MZza0gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdmxhOrLPXpeQhJALV1SVDXW5aB8hgFn1iWQwWGM9N9n+XL506Is9WdduLj5jzKkpokZdLuRB18OxL7ZciVClnvfzb/4q6z4kpxQx9Pjn5x60j1XenVmINj3Od8RpWiGyr0/SrOB5tp2eXtJQBnzobpeWR+Fs8NcqQhSNog5jN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=packett.cool; spf=pass smtp.mailfrom=packett.cool; dkim=pass (2048-bit key) header.d=packett.cool header.i=@packett.cool header.b=ircNaqFJ; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=packett.cool
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=packett.cool
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=packett.cool header.i=@packett.cool header.b="ircNaqFJ"
Message-ID: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=packett.cool;
	s=key1; t=1781504714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIagr78v8+wu8I0zN50DJ/gAtpHtsl0YE4lvqsZn4bE=;
	b=ircNaqFJIqIbLoIQAsKyoXo4rpXEoQiRy6zyFmI9hK3HrAfkw05xW4pZqyr/gEPP8FmgQe
	YCMXXOF0Ojr6Ke64K6mJnYe9JlDM5n9QaPTquf4RxnS2VJebzilW8irZlVAq2ZBbu8tU3H
	Ym5nnlp7yvHYcIa6UVoQguJIN6I828BXaZ6Oa3MyWDm++G633gd71/V0K0NJtv18Wf3rcc
	TGhtZ7HAjNfT3f/melWV8TK5yeAV4SGF18G26grrndY/UhwmBAr77wIkgpV/3r4qCrE+rr
	yyIzP94mT15QER7XOLBnD39ifvW2hpCx+GHe19vIvRAPUfC7zO4rmCN5XEqkKQ==
Date: Mon, 15 Jun 2026 03:25:04 -0300
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Al Viro <viro@zeniv.linux.org.uk>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Askar Safin
 <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-api@vger.kernel.org, netdev@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Joanne Koong <joannelkoong@gmail.com>,
 fuse-devel <fuse-devel@lists.linux.dev>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Val Packett <val@packett.cool>
In-Reply-To: <20260601173325.GH2636677@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

On 6/1/26 2:33 PM, Al Viro wrote:
> On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
>
>> TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
>> a big simplification.
> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> Communications between the kernel and fuse server at least used to
> seriously want that, so that would be one place to look for unhappy
> userland...

speaking of fuse_dev_splice……_write actually, this series has broken 
xdg-document-portal!

https://github.com/flatpak/xdg-desktop-portal/issues/2026

Specifically what happens is that the EINVAL is returned due to oh.len 
!= nbytes:

fuse_dev_do_write: oh.len 16400 != nbytes 15526

(where 16400 == 16384 (read len) + 16, 15526 == 15510 (file len) + 16)

After reverting the series, there is no error because oh.len 
becomes 15526 too.


Thanks,
~val

