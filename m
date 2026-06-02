Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A936EA80
	for <linux-api@vger.kernel.org>; Tue,  2 Jun 2026 21:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434774; cv=none; b=Y4tVs3o3udpS2IYJs7cBuQe0XUvSzfdjcZpIibRKQHUQNzi0OkvjpCUXfZvWxpLKbBOOvmp8KYEFTS2uYxz3Y1rlMNw3tnpJaHEvhWB1NgIuNXAmK00qxARUmWG9FexAwh0+9gLlb6GLF0xqfBqvT1OBh7xo/+9W79h0a4Zgoac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434774; c=relaxed/simple;
	bh=uij0fPrYXhiLn/hkkJMC6Jmrz2271TCJpQyuyCz9648=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+bJdPotSOct0lVlffZ9TqsodZ7nwy6SyjeBB2wAZpdnipZOCcybq98cM0uEkBZA1I0VAMfCB/iyD4OU55nqi1EVTae33o+Wd5tFVQVKPUnpFuflmM1+5WwWvexqmg1+Cb7kXBYXmlPQLUv3YNH2RB4ZPLipzvktRUUOMSxgiyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PBbMtFsm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBbMtFsm"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490abf12f0fso65885e9.0
        for <linux-api@vger.kernel.org>; Tue, 02 Jun 2026 14:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780434771; x=1781039571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
        b=PBbMtFsm7wChxpUx03NtaBWtFJn/EfXqGpb/VEcyERZ2iLqzHMNLMatuyuVR7QWPfu
         8WW8Km1XEKgRVtRqCtPHN3gEyqhtnScsvDIixgY+SJJkqmbpV3efaZaYV/MpDC8bTm8e
         gYdss33U+liT52p6RMSvYoxy2QyNaXnuzCa+sKtK8nUIqJ5pYU6Cy+mxQU8F5dPVe7u1
         oNwY08o05liz3y3GSjB05k6kCEfRohwJ/l9HSMdThLORfytOf2+NyxgPK2L06LQokybP
         6i/kZCzq/KcwJurNssCq+GZzk+85sMQ5Y6AcSdxc6gYMOO3mzAywpIfUxoG+CJ/gzeha
         1nFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780434771; x=1781039571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
        b=BWkPYSgLKftQiR1eFU/FYgX+sDJKgGL9KmOQafNIZ+yySjOfvpslGd3V6IkPAAXWGL
         ljTTb9obdYK69t7FUeEtQ6UwuhE+P4NVyEIdITL53iNeLh8WYWB+x7AGK1GPHlR+iM+s
         /291BNXebnHdxhMRQrb8cJbtU5lHH3EZ3uQlSkyZSqDIAOQzk75FFrDsfmQsA7/xNNHl
         OOPAfHFLHQZeLolN1a42t5qDCPwuR1KC8IfzF4l8fH2yUfZX4wYbcsRyhqqPfpRaujUu
         Eho6YyCg5U2J/tczSGYxUdbJfXMhjrCs2bBM17tta+3L4kg5mqZlfYXgT42DWIILuEqB
         LVzg==
X-Forwarded-Encrypted: i=1; AFNElJ8BglzxcZud4Z6ZGkxVOzA3w/FX5TZVSLV87DUhls/F44HGiINCObGABXM67QszNj/WERzil6WMm9g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc+DTCm54/NhD17mJ1XLyY65guhu3NO2hU+CHuk5OfFd4pQgv9
	r7TUiJ1jvkBSfZ72TevTWSx9fQC/vHfzgQY34GTvNprhSG6z4dI9TiaC
X-Gm-Gg: Acq92OHlbjGMRd4ipzPD1L1e36P+ZRwWowV3nXtChXQt/5inXjfXuUBkxFPdxLrwXkH
	o3pTqWljuDQ4vwiNtxXbK/OWsnjbaFE0zBZLZzvn/dB+uNyclpW2+9XrwuFS63WtSADT+GHzMfs
	V5i9iubyDRiFWdAJDuCTCulT3Q5tDpbXdkhouI4OoMA2IfPzB2zL7Ag5UWHfC1RFWDiv8XQiamO
	VGtz0A9yyrjdTRwER6bNAkjZrzxTy7UIkQU0sWDRfcW9+xJ1OV+BR1hDOBsbYFyMXoTzF7grz2x
	u/nC9TMXR0G5uHYcJ1LRNLNjEaMC9zI4cAFP7YA7Gv2yYoYABcHrN1kBLDTZFzseZ/KFGg8glC4
	264PwR4kYRMidF0jtSHI1C8sVlu6VdSEh4FyP2bXQ3/aH185rQJOOaLS3SqwVxQFCfGmPPyTH0l
	KlTL5MyJ5Y1lDGdhZgwH1nTeDprfnu2Q==
X-Received: by 2002:a05:600c:3b98:b0:490:b11e:e4be with SMTP id 5b1f17b1804b1-490b611105bmr5959595e9.3.1780434771026;
        Tue, 02 Jun 2026 14:12:51 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b0e13f91sm111429715e9.3.2026.06.02.14.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 14:12:50 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: pfalcato@suse.de
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
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 00:12:42 +0300
Message-ID: <20260602211242.13870-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pedro Falcato <pfalcato@suse.de>:
> On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
> > See recent discussion here:
> > https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> 
> So, you took an ongoing discussion with an ongoing RFC patchset, and you
> decided to reimplement part of the idea on your own, as a concurrent patchset.
> 
> Riiiiiight.... I don't think I have to NAK this, do I?

Okay, possibly this was indeed inappropriate.

So this time I'm asking explicitly: is it okay to post new patchset?

I want to post patchset, which will remove pagecache-to-pipe splice.

-- 
Askar Safin
