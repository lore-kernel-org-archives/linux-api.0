Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4EB32C92D;
	Wed,  3 Jun 2026 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780510495; cv=none; b=ppOa62NLkb0Am8ureoxY5cHNxMDnxEjWTsXwWdiPBRVOFB3QE4u1EJQIGFMcHG/QCLSDS+ph4VHYctCC0+1xyv9cO7emRoveHemx70XldCUGXk1YmHeYWjkjhRdted5Ubl32oaSUFp3NCAAVrm4lahRT7AharSnCrfRaz38fjJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780510495; c=relaxed/simple;
	bh=Zh3bOPf3WGGGuDpapVApizEvYFMTNyzllD1587uNksE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SslGmAuJUZIUi15KVeH9QK2rkWRAO/yjdCxOmt03UlA/VTdswZWzjAZ0ZfgjL2YzFC5aOPaq1gI+ZHdCpnmK63IbWkgazeowoubD+CmqWX8opJ14xAQEHtsEwwjEdVdVp8oa7lE7/5tlYrZ0XqdE20l74cS7+Y+mKaXWLYgidjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYt4jGOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYt4jGOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922DF1F0089B;
	Wed,  3 Jun 2026 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780510494;
	bh=6WrRoXO8ws2YpgPqY1eyvviLf48IBcpkEZY8IYp2NLo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EYt4jGOFf5LyezMTLV9dtf2WymLahWZzOV9zIlsR/s0qVRxpHXAAirSEbS46iArUz
	 3jFo9xc18HpY/AIlMplWvxVe2GOAw49DmR+mT+asEMqWykbJ3kaGZxjmXlhW4c8Ors
	 EW/vIn7AffpcwBX08cwjSweCluQTp3Sevfta9TJlQ7MM6F7ZVYwEsQy2HTUikfeGFa
	 xQZRg7I4AP/QtUfwHSQZfCZmhKiph4Mdhz2KEt6agP6Meih8rA58vz+GsKjWNqY2AQ
	 pEIH9ry/aBOAEjUXK0Ra/KnN1Fh7TD8mTUn2t3uUQKfwGWOkiN7vTRf9U+IHj5k+B0
	 fFWYzzBA9yA4Q==
Date: Wed, 3 Jun 2026 11:14:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Linus Torvalds
 <torvalds@linux-foundation.org>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603111452.7e7bb17c@kernel.org>
In-Reply-To: <aiAREqlHK1llOw_y@pedro-suse.lan>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<aiAREqlHK1llOw_y@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Jun 2026 12:43:54 +0100 Pedro Falcato wrote:
> > Am I understanding correctly that this will completely break zerocopy
> > sendfile?  sendfile is, internally, splice-to-a-secret-per-task-pipe
> > and then splice to the socket.  How much to people care?  These days,
> > a lot of high-bandwidth network senders are sending encrypted data,
> > which is not zerocopy frompagecache.  But there are surely some users  
> 
> You can do zerocopy from the page cache, even with TLS on top, by having
> your (fancy) NIC do TLS offloading for you. See https://people.freebsd.org/~gallatin/talks/euro2019-ktls.pdf.
> Linux works similarly. Slide 26 is particularly interesting.
> (No KTLS I assume is using simple sendmsg()'s from user memory, SW TLS
> and NIC KTLS are both sendfile(), per the slides)

FTR this datapoint should come with the caveat that kTLS _offload_ does
not support TLS 1.3 today. So how much that configuration is used in
practice is unclear.
