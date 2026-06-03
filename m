Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B885F37E2FD
	for <linux-api@vger.kernel.org>; Wed,  3 Jun 2026 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514664; cv=none; b=hmom8D2jsCvRI1Ng/q5gwobaPkaijRlinINsqCSzllBgC/PJegcgAJblfw3hTZhIs3/tpHn9mwZzcVivBexkiuS2g/EBmabWGrbgSc52RneTPBNZfKtjo4n9IIhVLkaPQ+LmnYW3HAa1hPBhohrYLsLgRFjscwO7G/HRG1ca+w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514664; c=relaxed/simple;
	bh=9gfUHrdoR1LzqY63DNhYraq2XhjxJEOvKb6+mvRgSVk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bxbJ7MaXq6hTthVSExmgmivzcU2QNqW4TdF2plwFZy6ligUuRbW+n5wic3QPt+0/kaAVRbH7eOBXWc0tFDlYWXybzzECdBXfJQLSiJ8sfV82T55xBucQXBLC/pnWJzKKcXUsyygUpyoPaaYzF0xYOZemSk4Pq3MQEEgdnCrLw/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClQ+uuBg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClQ+uuBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780514662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9gfUHrdoR1LzqY63DNhYraq2XhjxJEOvKb6+mvRgSVk=;
	b=ClQ+uuBgMx2Y78gHTLyLTVooT3mRxb+8aLUpYgZdtc/1c7/WUQ5bLC+21L/2vUPEvLOlIO
	PLlJyRlwEzw0Dg+aZIjpLmRiE7e8n7UMauGBcjwtgmmMY87eyiJRGakfxrnAb9EidjugUZ
	eux+oygqWjUFLVLyT0cGmTp80FED/ps=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-lMJTVDivP3Ogp6JqZBXk8Q-1; Wed,
 03 Jun 2026 15:24:19 -0400
X-MC-Unique: lMJTVDivP3Ogp6JqZBXk8Q-1
X-Mimecast-MFC-AGG-ID: lMJTVDivP3Ogp6JqZBXk8Q_1780514656
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CFCE18002FF;
	Wed,  3 Jun 2026 19:24:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.52])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 219B0414;
	Wed,  3 Jun 2026 19:24:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
References: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com> <20260531010107.1953702-1-safinaskar@gmail.com> <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com> <ah2nBAdsE5vVJ2PL@casper.infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
    Andy Lutomirski <luto@amacapital.net>,
    Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
    Christian Brauner <brauner@kernel.org>,
    Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    linux-api@vger.kernel.org, netdev@vger.kernel.org,
    Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
    Andrew Morton <akpm@linux-foundation.org>,
    David Hildenbrand <david@kernel.org>,
    Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
    patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22833.1780514647.1@warthog.procyon.org.uk>
Date: Wed, 03 Jun 2026 20:24:07 +0100
Message-ID: <22834.1780514647@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Well, since it pretty much is what I suggested a few years ago, I
> certainly won't NAK it.

I've been wanting to get rid of vmsplice for a while, so I'm in favour of this
too.

David

