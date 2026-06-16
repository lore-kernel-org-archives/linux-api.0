Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EB7243376
	for <linux-api@vger.kernel.org>; Tue, 16 Jun 2026 00:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781570256; cv=none; b=DdFpRSBAtLkJgeLhirdilv38IXNXP6AGSqEDCV/pt4bSpcyyCyveiKuij1VFwZRS4x+OpLqtsFombhSLaegQJoD9ZDTt2OsCCRreXPldvlEVC7UtYofxpYAVDDJRb3aYbedj33G1ystORvbxVZ8rCCYKbUBZuOwDZXyvGzx8rKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781570256; c=relaxed/simple;
	bh=p91yC0380ci6RVyhXJ1kuAXKj9VL+EWnmfNds5Mm5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRgmpETIOqu2jQX6vKjF9Ttx/OEAXQcFTzTj/KtI+imZ1wA3Nano1TOfFJgT1P/AU7cDcLcHK+S+5xY1JB37GyprN+VN7+gD6vcXdQ4ueev1TLArNsxDCjUDKMPcV8Z/aEn0hPaGYlXUW3LO3t/kGTcuM5byQpVC5uzglsM5nW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cXKx2If0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cXKx2If0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso29288745e9.1
        for <linux-api@vger.kernel.org>; Mon, 15 Jun 2026 17:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781570253; x=1782175053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFPF4sC2peklNMGORgGTd/4IxXXegAkw7S2lBmPrG1Y=;
        b=cXKx2If0O5uoxGazgOHP2e49iqcvTwTtqYvtYQ9fxEj297PwBpNzV1VGOo+P1bkdGZ
         pL8m/dAJG5/eXlbYJAe4BGkMPFSh7fZJz4GaymjDJVG2iiqVkXPONzbNYNblUaCt9IcO
         3ZPVUlbW/pCjck7mIZNaubCIpo/sWpoKe5YBxE7W+GmPlVgY5Yq4pZuUqcRCHJsZgFfh
         FQuLtOkUOb+zRGi5yMdTORX5WquRPRlKfP9mJi4fBnyLdTpx8lV+dSfDbhxM1yVUJ56d
         yXkQuOJaIe+9pzY1LpC+7WX2iP94q9CkdvyMuevov+StNCINA/hSlxgm0j7bZV/ge2pe
         upqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781570253; x=1782175053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iFPF4sC2peklNMGORgGTd/4IxXXegAkw7S2lBmPrG1Y=;
        b=j7G/mybIkw9QoOXm/JwyqT6PPFdpWp7CWo+IP7yRSmu45qLwwcQs3IxfoZxVCoMJZM
         8hmJdFVgwirQ6FjgVp9dLswJqp1aobU54ffmnDuCgUmfUAEP7UsOvZz8gzoZ6n3CcUPN
         vdfTnI2tH4Nj7Ui5xzw1Gn95xS+aCkxGD7+ihZOHulSyypDA4eYRRI9lAFiTrV/lxP6c
         pL4tpHBYPyrDxTTCHFlBJK8G2ldIvCKBVhm9H2x/SgxOWfWDW42bojv6uWXJd3OZmkYk
         /JIqiNvPoCALss7JIbdorLiN8RtvGbiBOZkppZq0O5PLSjxnGcr81vb78GG3zSuia60y
         5K/g==
X-Forwarded-Encrypted: i=1; AFNElJ9Hy0JDxn6yqTI8I0wIBb77lP5zinYKa0xjkOcrmPZNOUagddzeXcyiTlNHfBN/lgEyC8dD+ndeBUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT03Thq4ylFFUxROrfPZ4xMBSK0V1pS83hNdDstwr5hQawkDzx
	62aZPUXmlBVZcpJjROCXMVdyTv6SxtanNsS4AM2lxjDcWmrGJokT+zuu
X-Gm-Gg: Acq92OEpYov7gPOt0MfzZr+JOEPRpNedT8BHvSNj7SHuRpz5H/oy8DNKi27Dq90UXfZ
	wcsDOkQkVMXBPAbD1FaJkNcjL0VwWDZJEv3jBRYGAND6TE8NGNqOhlE+4WAhokEhzBar78hUkdk
	xmq/2xrFywapLSnXjp+LoOAFIEZk4epAcMleiAHhYraxe6eEj6HnP6dGUS6WUZUeT3E1qpjBfBC
	YN/5MnZC31ZcrkCoR5eJwOQTaFMoLOT982kmH5A6cDzLkv7ERdqaUj6hd6xo98Qn09brjx2VWSj
	f5o3ptYhoeNWH6p88Xygq7vjgLIw+RV7DFN7RRQYew5SJ4EfeJ5Cj+OB8KfDBv2b5QS7rRBQlBc
	mQXiiGjiiKfALvRM4psH488rJHoifY7axh5BeoMbD8qVHXyOrfkoahvVxSatufi6KOr2fuFh/hM
	FvUrtwdDZVzzlof5T3YU8=
X-Received: by 2002:a05:600c:698c:b0:490:b025:f324 with SMTP id 5b1f17b1804b1-4922ffbdad4mr19600415e9.32.1781570253120;
        Mon, 15 Jun 2026 17:37:33 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490ea4b39e9sm238270495e9.0.2026.06.15.17.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 17:37:32 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: agordeev@linux.ibm.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-next@vger.kernel.org,
	linux-s390@vger.kernel.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Tue, 16 Jun 2026 03:36:59 +0300
Message-ID: <20260616003659.4002764-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260608171917.3195488Afc-agordeev@linux.ibm.com>
References: <20260608171917.3195488Afc-agordeev@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alexander Gordeev <agordeev@linux.ibm.com>:
> Hi All,
> 
> This patch as commit e2c0b2368081b ("vmsplice: make vmsplice a trivial
> wrapper for preadv2/pwritev2") in linux-next on s390 causes the selftest
> tools/testing/selftests/mm/cow.c to hang:
> 
> # [RUN] vmsplice() + unmap in child ... with PTE-mapped THP (128 kB)
> 
> Recently there has been changes in THP area, so the problem is not
> necessary linked to this patch per se.
> 
> Please, let me know if you need any additional information.
> 
> Thanks!

As well as I understand, this test uses vmsplice to pin pages.
I. e. if my patch lands, then this test should be rewriten to use
some other mechanism.

-- 
Askar Safin
