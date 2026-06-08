Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08053D3D15
	for <linux-api@vger.kernel.org>; Mon,  8 Jun 2026 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780938785; cv=none; b=lFcRDbh6Ponj8aNGfdZfTL5RdceEjclGv648efkj+i7JGbeX1GLdkvW3p0EHCFQimtT3u033m6U06p1o5z5M45/1DpIhqJ0qdp1gE0SLnv/uc+sujPiPGfoLgqn7dEkhOvt68zmOTZj+IOlXHDRlI6oFURSDZql2ypu4vkW3aRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780938785; c=relaxed/simple;
	bh=G2yTdmM+jxM6q4Rp8QMqnUV346H3bZaSNYYTm8fmrQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RN0zBX+eSM2Qvg/p2H/iMR2O+W1gUcGGn4zq2w6tq0vMTDiR6/9ZeokL7JlEBn56m1xc3k6mBI3irFyU9ADcYzDnPS1JL3fTZaAqFyLEQA21PqAA0yQp0W3GrTX0dE4BGU300Tq9/xaDXsdWh485q+IFzQjYN4JFIzEJYs5H/hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkr/iCD/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkr/iCD/"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490ac10e337so42760625e9.3
        for <linux-api@vger.kernel.org>; Mon, 08 Jun 2026 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780938783; x=1781543583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
        b=bkr/iCD/AbT5kMfEEc02CxM786jsvA1Nz2/jJdbfvfMrQ2dg+mLcw9Lx7YaIUlf70Z
         oHzpkCp/I00uyPDcsN7gGv8zR0egau+UlSNTBB5evHFxNwJKTCaWhUdkA783i+zVThN3
         boNLlLu3i95jNdk8y/cTguC30whCTSM2VlZBxKo9/9Wv5Iy20tUP0/Dd86Tq3ewyzBKC
         29BzOzJSHw9hRVytFIKluyZIXgOwu+LARdY/j6eATaTFMtm7Nc0S5rIgZYAEwOSvXrey
         FoJWK6th6hPMPHeRw1WjBpCEKZSVlTOD9jvumo2VeQzLyqc4WNmb7R+Mv006lyRItyDL
         xktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780938783; x=1781543583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
        b=eoUGarIAKIWYP3WEcE3PGz7BHaHV5QQq3ELeQyTmPNBAsFBDJvveRmBFFlh8gGbRes
         k270MlNcOYIG3HUsMFvdX98qIcRe2KrOW5Jk1cv1xQiqBbh5cX0e656sZM2FT+SLC1KP
         00i/obYJZuCUcsoJAv5iCpv49JQtnVDoaEZQVe42VK6zelvYUfZTKqRwb8XTsVl8mdd/
         1KQX3YMXaLaRA2fHbxAURWjR+MeskYHrvVdw+ytD5bUcFkfoPmeszO4pIx9xOnB2jycF
         zkmAl0bvIwiGMYmSOJE6F0X3omZRIDJuseQ4+lOfoffTu4q/NC8KiFBp9N5BZXmf2f7+
         xiqA==
X-Forwarded-Encrypted: i=1; AFNElJ8iTRTa/20TkuETXM/yu2zFL9NtKq3UkXC/QRHYJziw9AKSaoC1M6lB3MLbf9OBe6ot3rbh6XBtzaE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2EDOxSmxj8K8J6CgsY+u28Iwr9eEK8eV6edSqCZ1BaRNgjseK
	ZaVTOwia1K8PBEBfSbbmBTiaSJYFG5IPJH4/pnkkF6zgn87vkh6NHHCJ
X-Gm-Gg: Acq92OGx83IuopG/k5ZO0y422N3WCiAW6jEVkPxV0xpYeenTsBNs/jaEd29SJQMDnOP
	7GMoqKwssbnRJePW2G7iLJwfYKrMOK7KZDKutVTOwRJoEjhU3ZDuq1nyt0A0XrQQwgzZWuPIyvT
	B8ysi7RSSqzECfYUPvv9MwWAz+v+u6rsX165LkBODraQVk2ied3Kwf1r98jf9TQZQn5ZhPvcJ3e
	5nPcFHzZwXjiXmF37mMr52u2Eu4quGOgaFUyMNw7SwhWy0fnIFF/DDUlU41icEdDfu7AjIaMDRq
	N3MKc0j5yfEmt1XctIPZ9MX+YLon3sTnSMlFFijtT8PelyRhPtoETuYOYwWG+m8sW7oI1EbTo67
	xNCr8Y+rYKBqYHyM1/Vm6XpwVJ9eWtYEaH/3GT+0TfYuBJMdqJcl+ppN+nvvlVb1ZQTMV39cSxG
	v6fIvg9oQmc71qaWjPyfeqOfSXSX7Ao+LQjj++JQQZ
X-Received: by 2002:a05:600c:458a:b0:490:389:7644 with SMTP id 5b1f17b1804b1-490c25fbd78mr244360025e9.17.1780938782731;
        Mon, 08 Jun 2026 10:13:02 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f351ac0sm97432933f8f.27.2026.06.08.10.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 10:13:02 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: andrea.cervesato@suse.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	collin.funk1@gmail.com,
	david.laight.linux@gmail.com,
	david@kernel.org,
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
	ltp@lists.linux.it,
	luto@amacapital.net,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	w@1wt.eu,
	willy@infradead.org
Subject: Re: [LTP] [PATCH 0/5] vmsplice: fix some problems in my previous vmsplice patchset
Date: Mon,  8 Jun 2026 20:12:31 +0300
Message-ID: <20260608171231.1480447-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
References: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Andrea Cervesato" <andrea.cervesato@suse.com>:
> Hi Askar,
> 
> the patch-set doesn't apply:

This is patchset for Linux kernel.
(It is expected it will fix some failing LTP tests, among other things.)

-- 
Askar Safin
