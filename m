Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C133F8898
	for <linux-api@vger.kernel.org>; Fri, 18 Sep 2026 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789736213; cv=none; b=u+IKqpmDivxtGLFsGeryIgvpbrtM5yrgllOaY15FtCsCphmIuhAhn+kZYHbEezQKatxbNicN9JaNqyQibEF/C8C54jNJe1zMqYIJoGPxs0gyUe6+ikuLyWLz/ywFsM+kA+iNqYhx6fO0//bN63jbHEEgSNt97ZMZP496A+BM/bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789736213; c=relaxed/simple;
	bh=gpmTmvtZCfCL7JGUtP0qUUwW6FBPgLdvpGuS4uKcWwc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lWGTgj4K4QQoQvt/DjkCCCN73KpahAFSjVmKeGjxv6kPGOImlopvfhpuuKB+SQ5Rk87QZsowA13OWr3Vf7+Hr3bVHN5tm3pd6DoB4RZwvtYpHZuOVjvmrGc18xaEDdDQKB20AkDDs5UQwlOXSU6jKbDWwKBrhE7zM5jZ4ZlzoF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OuY2prNm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OuY2prNm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789736210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+EW9HBLqFjeeRJTJ16lzHbG7wT3rvh/CLpehC+VpLhw=;
	b=OuY2prNmMNnHnmrCL/IOW4thJxgU3dRMroIhYLaS8EtyKQvZ52/YaunUk9KxPHgcPMpfmE
	H9YpMPxlGb8ISGpQf4Ej4nZ772o3tE6iibDdbKdZu9Yuzanam49EbIqa32/1fJhFF0fL/l
	f2VOVA7oLytY5ivx5lUvRsrQbkH/Yho=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-f5nU6dCQNv6Gy4MFf2zR1w-1; Fri,
 18 Sep 2026 08:56:47 -0400
X-MC-Unique: f5nU6dCQNv6Gy4MFf2zR1w-1
X-Mimecast-MFC-AGG-ID: f5nU6dCQNv6Gy4MFf2zR1w_1789736205
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B1B61802170;
	Fri, 18 Sep 2026 12:56:45 +0000 (UTC)
Received: from fweimer-thinkpadp1gen4i.stuttmso.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 741E318004D4;
	Fri, 18 Sep 2026 12:56:41 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mikko Rantalainen <mikko.rantalainen@peda.net>,  Rich Felker
 <dalias@libc.org>,  Matthew Wilcox <willy@infradead.org>,
  linux-fsdevel@vger.kernel.org,  linux-api@vger.kernel.org,
  linux-kernel@vger.kernel.org,  brauner@kernel.org,
  viro@zeniv.linux.org.uk,  jack@suse.cz,  alx@kernel.org
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
In-Reply-To: <CALCETrVnE2unnjHokG=bGLEXAeC0U8QRx_wb8fQDh-Fe5O6PBg@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 17 Sep 2026 10:03:36 -0700")
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
	<aqcmz5uI7PgN5CT7@casper.infradead.org>
	<20260913235145.GY25906@brightrain.aerifal.cx>
	<eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net>
	<CALCETrUgLj4Dz0s6PMofViJwausRWCvNvJphxWHUeWCCaRBtQg@mail.gmail.com>
	<f61886ed-3026-4db7-ae22-b882264141bd@peda.net>
	<CALCETrVnE2unnjHokG=bGLEXAeC0U8QRx_wb8fQDh-Fe5O6PBg@mail.gmail.com>
Date: Fri, 18 Sep 2026 14:56:39 +0200
Message-ID: <lhu5x02vhtk.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

* Andy Lutomirski:

> I think I mostly agree with your analysis except that I really don't
> like the ENOSPC.  The kernel actually has the ability to commit to
> having space for pending writes on an fd *without syncing*, then I
> think that capability should be expose to userspace.  fsync is a
> pretty poor alternative for code that just wants to make sure that, in
> the absence of a bug, crash or physical failure, the data won't be
> lost.

It's something we might want to call from fflush.

As a replacement, dup3/close doesn't quite work because it releases
POSIX advisory locks on the original descriptor (as they are per
process, not per descriptor).

Thanks,
Florian

