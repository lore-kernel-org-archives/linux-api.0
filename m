Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF17C35AC07
	for <linux-api@vger.kernel.org>; Fri, 10 Jul 2026 18:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783707839; cv=pass; b=Jq+pE6k66zu4NQnqAGS97gdfWZd/zylQrqOSnfEi1+EQcp5D+ao/mCo1BxEUX3qcrJiR/m0xWDx+VXozV66zprflLCSRdJI9TgeQ2TAxuFoa6UI7UyMo3VOWvpvtRgeGguPk6V3MG21Qywtv4Y4QK6XIwcaR6qO1TICD5ZxWt/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783707839; c=relaxed/simple;
	bh=NxfR+RtpV98Uyvh4Vv0TesUuCBi39GQnAHBSA0RW5do=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hnRAJXD5bgFtQ6DO75Ax5HkqXNla7hbzHxpBZoWuOiPmDbl5o0cIQOS1ljRlLKOUIx8aSLhXKp8PRDT6AQ0WFR87MKJcOrn/tRH7R0piO3ns5ullkgID5ClBky/C1wUisrSAlbQnaEvfhKy1TfRGXbBwas0WTOYwqfbgzce1LDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=FlVCE/pd; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="FlVCE/pd"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c21495722so5968351cf.3
        for <linux-api@vger.kernel.org>; Fri, 10 Jul 2026 11:23:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783707837; cv=none;
        d=google.com; s=arc-20260327;
        b=dzN/eD9zbNDjCppw996TBk1SYGV0M0UL6pPsLSLIQ1ChaYkdZgA0XwHUSRsGK3Hu3o
         jHWLgh5hwIK9ALYEQubLcv1ScJW/x7h0GBASxJzBHLMF38RchDzHT1grFi3VqhqjQYwm
         LP8XpXdP+ioDZrDJtmk4irQjYzFfQ7UGDS9CxA0JopfbTg5x4zVBnOpr+nh9wICKuM7L
         j0PhxMqhADtQ+c+KsVEynmyGEMCFG0S9e9P6RvY5fGdkYhtSjfccVWYNPr5EeYre9dh2
         Tw83hu+9EjpCxtX6HSLqy3JorKpD7QSy2DXq9tK4PZot5PxAlfDEx/HqyuAkw53ZeEAZ
         cFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1S5jxvfvOLQgAIm7INh0Q2705ObnY2r648KNCWkCwDU=;
        fh=cB42ZcKaf4M9/boC3OuraBr/Crf3twN9T3Zwr4S4LRg=;
        b=K9evSZzyD/Tcz4xZZ7MPe4p/TT5p6RTg7/XMPD4CICC7ui7r/tGa2nsrs6XI96HX9i
         ohrMmvgnVaE8dfgJqGiskb86t5fvaK19G0LWS9FI8KHzhKWNYZfKZWvBJmSixQ3t2Qy1
         1oM2sT3Ma6xnU5GfyyAWDH+RA4rSe9Z6IuD4SteDCZebmpI4sdK9yqkuKKDNJBwJ79BB
         CWYiWcF5KCpSN7bnXfTkad6DhAj7NhoSpvXLhnc4QjSXJ6GeAIvp/OtbMH3enyfd+40c
         7zHlKVTwYUs9+kzUaJQEtIrNVO8iVz9oGDkLwmSs0ehMZvIbH7x+q8qd+sgunqYg2yLz
         rzWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783707837; x=1784312637; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1S5jxvfvOLQgAIm7INh0Q2705ObnY2r648KNCWkCwDU=;
        b=FlVCE/pdO0oFWx0ONgxLwk/drsbgQg7zpgWJMKhtfHZDdoEaa+2qz7EepyldY88hjI
         UWpOHmwG7/DbggaRisYcEnI9WId1Gl1S2W2C6RgnnmefSb7jFo1lQmuLNVYOUMyp9Jcl
         D/ZaAGSd9/U5YwU2UrFeVuuXcS5i1OexwYRm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783707837; x=1784312637;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1S5jxvfvOLQgAIm7INh0Q2705ObnY2r648KNCWkCwDU=;
        b=dfkZAS5d5QfAhQOZf62B8OhRipoNzmAa/vm4Z2V+j6vj43SIUcb4z7NsFpYpTnonKS
         cQKD/pwOwsWrmX3v7024BEWJWB4j5OiqPtzBod13c0vc7MGALMLlo6X5RhVSKR3OYvSR
         2Efx04dp8YImjGQy07CG+bYBTg1+CFRXQzRRWYcgm8sZwx3NVRt57hCyFWvh3xl60yHU
         +S2aq+Fu9HjfAM5Uc+wHCccbL5TEzm8pvWkZXtU0b/QIhk1GFs8ySB4jZwNtAUr0p+AC
         5kCj9QEWbuSs6XdQdtrOXkCJbEmLym4Muu7Yf++s0T2l7mEiu6vA585Hc+yLEDYLEOtv
         9++w==
X-Forwarded-Encrypted: i=1; AHgh+RoveSt6a0Lsd9tGTT62cnveL3PHZqFNfsfO17TuV4rc1lESGCDkc7okQ1Vq86ApyiMsudfAnvtvRVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZLICaeswpFBGu0t1AsM2JTeHaUU513G39csvJ+GGX7AFjWKvI
	/lp6PyDeyhDhI9deiUsrhV+kfsRyeEmNiJbG5j28Wh3n0CZYKDAstGDAWLLvyqix9Ohe1kCGDBU
	hXF2H8jYEe8wMiBcwYtTDu3HLZ70Jp9HUsYSErOUaUg==
X-Gm-Gg: AfdE7cnLaV8YEOQnb4SacjHUAQ53o1uzvihGY4tgh8yQ9x4ZJ0dAsELI4k7wRpcjgxO
	gbCuxFxuWmMU5bUaQj+qaEnVunT7SqNRn731Zw8RqUCedxXw/QVexVcLsNtZAICqp7vnK4Y4Wjm
	CVvOxRXnr+wx26CdM8NiH7lzUSQMzkbac8x+QScRyBB0A8RJ61I+xZi1CcGH9H4f6jeVruChcZK
	41IArvEiww+29ISp+8+tCX/f4dCkRQObimdV/1oGSvYFszDirN3gGHlk5RICfv7D4uWllJwmpaa
	/Ppv5cP/hxY1x0Th6rcFYWGqwg7WdU+RJwSz9A==
X-Received: by 2002:a05:622a:5a05:b0:51c:14f5:8f9c with SMTP id
 d75a77b69052e-51cbf15ff18mr692361cf.27.1783707832090; Fri, 10 Jul 2026
 11:23:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com> <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
 <87o6gh79yi.fsf@redhat.com> <CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
 <CAOQ4uxgZuJ+=RQDh3577H7PFAfYyF=wRJ55aPuuUW814Htrmbw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgZuJ+=RQDh3577H7PFAfYyF=wRJ55aPuuUW814Htrmbw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 10 Jul 2026 20:23:41 +0200
X-Gm-Features: AVVi8CcKiWkm6xoKpO6GLoDQetvLN0tImMPwxwYtq4HkU1puSjal02fIPnnUZPc
Message-ID: <CAJfpegvGnr2a3u9qTEVgZyUpeYF0FoRg8xzyGg1wfw88Os5rMw@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Amir Goldstein <amir73il@gmail.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Daan De Meyer <daan.j.demeyer@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Jul 2026 at 16:32, Amir Goldstein <amir73il@gmail.com> wrote:

> Ack for this, but please don't use mount/options/... it's a bit ugly
> because most mount options are not opan-able.

True, but I was thinking of doing this as a reverse fsconfig() thing.

> Please stick to something logical like "fs/layers/N" corresponding to
> ovl_fs::layers, where layer 0 is reserved for upper.
> We could also support opening by aliases fs/layers/upper->0 etc,
> but no rush IMO.

Layer numbering has been internal to overlayfs to date.  I'd prefer to
keep the layer enumeration that is external, which is the mount option
interface.  Works for EROFS as well.

> What I am contemplating is whether we should implement
> introspection of the ovl_entry stack for merge dirs in addition or instead
> introspection of fs/layers.

Interesting.

> IIRC, the root dir stack does NOT hold references to lowerdata dirs,
> so support for "fs/layers/N" is still needed.

So let's just stick with the per-superblock layering for now, which is
reflected in the mount options.

>
> For directories we could implement "real/0..N" with aliases
> real/upper->0 real/origin->1.
>
> For a regular file we could have constant aliases real/upper->0
> real/lower->1 real/lowerdata->2 and/or dynamic aliases
> real/data->{0,1,2}, real/metadata->{0,1}, real/origin->{0,1}.
>
> Those could be used to implement "revert to origin".
> Specifically, I think Daan asked for it during the last LSFMM.
> Although I don't think we currently store the original lowerdata
> in ovl_entry when lookup is done post data copy up.

I'm trying to focus on the "return an O_PATH descriptor for stacked
layers" for now.  It avoids having to deal with opening files or
directories within the O_ALT namespace, since magic symlink following
is used.

Thanks,
Miklos
