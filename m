Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C843E3CEB9E
	for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782382301; cv=none; b=tJwnBG3DWGbs84vZ8QetSjLxgG+pcj/dHjzV5HfLQDb73VRpAy6SjeX+e3IBqtBh57CgKupq7oEhJnA4OqubdFGT0Xsq8Mpp/H2+LobdfYUeyjHlgd3XYfDvoeWLIZGbf36XbvEmxbVfa+FCkPj62wp5Bj/eNM5HQ5UuutBKIGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782382301; c=relaxed/simple;
	bh=XGh9YDm1F7Whc/NJ9BuaKR7akM8txwMpeQmBzjBxQ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILPvbBprhCCnGiptpLE98g0hx5x0uk8f/lr3IR0ni/D2eT4AktZlROx6raSg34mt7ok/mjatOzTogzUvpBhvXRdNSd/QIX3OumeROfVsB6FnZIOVKslVyASdYnw5pfaaZeM/Q8IgknQ2kiOAT5JIv+he6LlDEnneBWTSyJ/pYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPrK5FFe; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPrK5FFe"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49249072f03so11602665e9.0
        for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 03:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782382298; x=1782987098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
        b=LPrK5FFeAMFxHQd1eI9ZUBuFijk9vElLzashpH3ekU+3+iA1xRInRhJUtGPNgs4BRM
         MycH7eDTqhClWuBTRmwSV4BCvDRjbC2gLG8KNPZNwjbUue01EuEzRRQgGHPHnVTjXa0y
         CqI1m3QTgipa0o2k4hXrkNG1DFE5JeBx0KRw/DyKJMI2pKY3wHr8yDqBO9MN73rGvG7J
         GFOEResFpLE8U14JyJvM4fYKic6fQuJE2HuPBGjYJMo3eFkV7u93vhjc7ByRfKK1ZmyL
         243GBSKdy15ww8qMuTdeBVtU0IinYc4lSgUKdNvxFA9jtvZ7K9UNlxRp7eBawCOg5S61
         t6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782382298; x=1782987098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
        b=tW+bmfMlQYOvnjX0i//AeIBVNT6o/Kpnah1pP9ZKKdOPrbbI+WVBYrfBLExSwSDX0L
         2QTU1LRMqugMCQnnn+ItepIs5UETLuWBNusStsY0vb3j7PgiX7Wnk6x11XtVwniqdFTL
         Yd2lo4BN2bSX25HtIcoKfEWxwLRLmrBxXxsSj8noCfYltS0pnU0ppUnOg47WqlOb4761
         FOl/LwPMp471d+32Cc8L6QXvkjdnv4wzqBcIil39pT5ICnEBEZZkb8qGRNAqorrBz46n
         vPVLPbKiTQP/BwGIqzgVNOH2lFuHNurNyJkxZOOUPeztbe8OM6xQ63RZmDO3KvW2TMXs
         AYrQ==
X-Forwarded-Encrypted: i=1; AFNElJ8sa+K804R6O1VHn8p2kgHIKp656Nm2LeB1n7dM9lwXpiV0vVIYzjnK57HWQgNdrNSjdRD3UN9qFrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnXzkmM0Uk0V+oFUyVBURcFFWcvZ0oshvW4DrY3afEnKUuJz4C
	iVSYlRiMILoE4w6AS9kGE3irLTiOlnmEOG7VJHacWgVnAjs2BvP24kEC
X-Gm-Gg: AfdE7clIKt6TdQzm/JKPYDGE8XvVHXfAxn6itilMGHNKKzE8W1ZgGqGHFZJx+PQACOt
	7wh9SdnYZ/eaDH6/1xTiMFZKtBYoPLqMJbYsZ90VTlm9LOWTDOjCHVU0v9Pp9ggW6TjGARONprB
	0D6gJLP7KJf6we2VNByctelPZwnYZRNXO4UffGOiqjYoNWOovkHXE98Amf9b2o4TYXhLdwkmSLI
	i615rVndgG+9SpGrg89P39DjAH57Zr35lCJ6XTPIhb0+Z3hG44ynbvSieY6QjxCNd+AHJHEUsKy
	SG2qAjv6w6lvNzrN/0gJ1f0YNPuHJ2VXTxIVVa2vG9JcjrkZjny1RE1ZGwPeiJvi8WuAyePFLTT
	iviHFnGAdUzE2/HmTXRIvbThIDLqiRN8JyoMEAvScuFfD8U/kR4i34/pQlQPLrThLR7K8iDZiDq
	ODGeX5mG0w
X-Received: by 2002:a05:600c:8b53:b0:490:9d1b:f086 with SMTP id 5b1f17b1804b1-49266864977mr24965995e9.14.1782382297752;
        Thu, 25 Jun 2026 03:11:37 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4926417f0c7sm59950125e9.14.2026.06.25.03.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 03:11:37 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	avagin@gmail.com,
	axboe@kernel.dk,
	brauner@kernel.org,
	collin.funk1@gmail.com,
	david.laight.linux@gmail.com,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	kernel@infinite-source.de,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	luto@amacapital.net,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	w@1wt.eu,
	willy@infradead.org
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous vmsplice patchset
Date: Thu, 25 Jun 2026 13:11:32 +0300
Message-ID: <20260625101132.3859505-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"David Hildenbrand (Arm)" <david@kernel.org>:
> I think we concluded that we cannot rip out vmsplice that way at this point, and
> I suspect that Christian will drop that topic branch from -next after -rc1.

I think my patches still have a chance.

On fuse regression: I return EINVAL for particular combination of
flags used by fuse. This causes fuse to fail-back to non-vmsplice
code path. I did Debian code search, and I found none significant
packages, which use same combination of options.

So I think I was able to deal with fuse regression.

On CRIU named fifo "Not supported" regression: it is handled.

On CRIU major performance regression: it is NOT handled. But I still
think my approach is right. (See cover letter for details.)

(I wrote about all these in cover letter for this v2 patchset.)

So all regressions found so far (except for CRIU major performance
regression) are handled.

Other option is to introduce some deprecation period (as
suggested by Andrei Vagin). I can do this, if needed.

-- 
Askar Safin
