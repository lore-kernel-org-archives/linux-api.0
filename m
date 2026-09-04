Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3204BB5C7
	for <linux-api@vger.kernel.org>; Fri,  4 Sep 2026 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533614; cv=none; b=jBM0doqGLPKKhtJPoG7iHuC9cZQX0qK002TLxj/TLr0foVEdlhD701oJy7g6MgAEMC0H/0hxXRCv3CNpvNZ2cQNkbQXxS53TAFhFIIZvEVgBw2HpBtcNfaImENv8iCtgrL9h4he/LYMR/69DCxIXUVcv/EbJlkXBtQFnSTdMchA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533614; c=relaxed/simple;
	bh=TBJnaG19xsDF+x4w6zx7YtaC12GwukzzbDomstsRk1A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oQ0dyM3UFs+pDqGoJWupmFbBR5bDWge2+MWdkLjeCypgYE1kPm8HWa8q2W8MVXBnw6qOZX7MAKhk3GneSV2Cw3uPtQIjAYngZUmFzdaQ9DInT3em3gBd5MsvagrKeZoo1g3TLyHWv4Ru6m67/IelnGYRIm7FfjkeHy0tlms7iSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g6F6Fpup; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6F6Fpup"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788533611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lpOLr06SKT9VWUbfIdRTrVaGCYppzQHTCSBPigs1Iqw=;
	b=g6F6Fpupy5/WGes5L42hWwLg+2zcPfLorZ/ui00eR1lyvCTBZeKtrPr8v3CBYL3ODxoN2k
	hOxmNC59BtRGPzaZ3+BNQ3ROIwjiV5EzivQ2XuDkABG1deDF8pebLYnOr5RXqKAzSEaXIi
	f/m+NMJFq8jr3kHYOg8S7ZX7QzXM7Ak=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-SGgM8J6hPr6FYVMWtzv7og-1; Fri,
 04 Sep 2026 10:53:26 -0400
X-MC-Unique: SGgM8J6hPr6FYVMWtzv7og-1
X-Mimecast-MFC-AGG-ID: SGgM8J6hPr6FYVMWtzv7og_1788533602
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41CD18CD2AB;
	Fri,  4 Sep 2026 14:53:19 +0000 (UTC)
Received: from fweimer-thinkpadp1gen4i.stuttmso.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2752A1955F10;
	Fri,  4 Sep 2026 14:53:09 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Jan Kara <jack@suse.cz>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra
 <peterz@infradead.org>,  Juri Lelli <juri.lelli@redhat.com>,  Vincent
 Guittot <vincent.guittot@linaro.org>,  Dietmar Eggemann
 <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>,  Ben
 Segall <bsegall@google.com>,  Mel Gorman <mgorman@suse.de>,  Valentin
 Schneider <vschneid@redhat.com>,  K Prateek Nayak
 <kprateek.nayak@amd.com>,  Kees Cook <kees@kernel.org>,  John Johansen
 <john.johansen@canonical.com>,  Georgia Garcia
 <georgia.garcia@canonical.com>,  Paul Moore <paul@paul-moore.com>,  James
 Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  me@black-desk.cn,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  apparmor@lists.ubuntu.com,  linux-security-module@vger.kernel.org,
  linux-api@vger.kernel.org
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
In-Reply-To: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> (Chen
	Linxuan via's message of "Mon, 31 Aug 2026 10:59:05 +0800")
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
Date: Fri, 04 Sep 2026 16:53:07 +0200
Message-ID: <lhuecf9cbl8.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

* Chen Linxuan via:

> This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> ioctl takes no argument and returns a close-on-exec O_PATH file
> descriptor referencing the corresponding task path.  The new ioctls use
> the same ptrace permission check and nonzero-argument rejection as the
> existing pidfd namespace ioctls.

How would one upgrade the O_PATH descriptor to a full descriptor without
a mounted /proc?

Thanks,
Florian

