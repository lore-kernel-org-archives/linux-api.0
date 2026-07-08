Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7B409272
	for <linux-api@vger.kernel.org>; Wed,  8 Jul 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783526113; cv=none; b=IVWNVdvxpcT+i6aY7Jt71vPQFYFTYfLegTar5YbyUUdiNqdjNkK+afX4ppFrHbgkbtq0lIatiqq40YlKNi5IctrXA6bm/MYvtu7o8Q77Hhsi+h37E1xFmaUaSuiky9m7R6HHGlFdQZDmroDkeLU3kdjet1ztzXNb6k1R2DiGgDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783526113; c=relaxed/simple;
	bh=TWucN5P0Ti+W3Qif6YE00wVcOOt4TVZc4gsyZWfX5oA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eyNWoI5MfCPeLV8t9j8/dyVH81Hqb+cgfqSUA2S3n42hDQXffKdS5LJHCmN55vEbrjBZhBYkfg/BC++sNWkyYJm1kyY3+Lc3ajmVaCB/+IEelbxZqK4FNs6Q8m0tqnGTTPzYNd058S3I9g7u5VRsRvuUY8iNys0/2S+ydkMdnrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5eIxUcR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5eIxUcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783526110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0/KFHgfI1XWGP945B9IcYPGes3Xdr4VTjWMSrp9BtfU=;
	b=I5eIxUcRvQkskR0BvG9Mats27FCRco0mZmgKZ2Jzj0IKI3l46PxMAIKxB+edtUl9WURy31
	FDP/8TVXc6VeuiRL9G4APa8J85sfn6DMZm8yoaAjp1Z0UOMlwekO4K2QKNg6FLF+OSrQC7
	KHx9qAvbCeMvtfC6AQaF/uGjhj8LJNo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-uqPD4Yu3PFi4legkiUCjhQ-1; Wed,
 08 Jul 2026 11:55:05 -0400
X-MC-Unique: uqPD4Yu3PFi4legkiUCjhQ-1
X-Mimecast-MFC-AGG-ID: uqPD4Yu3PFi4legkiUCjhQ_1783526104
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E38E91956044;
	Wed,  8 Jul 2026 15:55:03 +0000 (UTC)
Received: from localhost (unknown [10.44.33.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 335E11955F7B;
	Wed,  8 Jul 2026 15:55:02 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-api@vger.kernel.org,  Amir Goldstein <amir73il@gmail.com>, Al Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
In-Reply-To: <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
	(Miklos Szeredi's message of "Wed, 8 Jul 2026 17:37:40 +0200")
References: <20260708095831.3381978-1-gscrivan@redhat.com>
	<CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
	<878q7l8y4y.fsf@redhat.com>
	<CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
	<87wlv57dt1.fsf@redhat.com>
	<CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
Date: Wed, 08 Jul 2026 17:55:01 +0200
Message-ID: <87o6gh79yi.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
>> Amir suggested to add that functionality when I've asked for some
>> feedback before sending the patch here.  I am fine to drop it if this is
>> the consensus although I see its utility from user space.
>
> How about a completely different interface:
>
> int get_fd_opt(const char *name, unsigned int index, unsigned int flags);
>
> Enumerating layers would be as easy as passing an index stating from
> zero and stopping when -ERANGE is received.
>
> It would work for all filesystems that use files as options.  No more
> fs specific ioctls.

Is a new syscall really justified for such a narrow use case?

On the other hand, it would cover both ioctl's I am working on right
now.

Regards,
Giuseppe

