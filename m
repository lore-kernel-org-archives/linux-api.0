Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0AA4E56CA
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608797; cv=none; b=BJEbdd+HvLIzlVnRESt2tYW45Y1DnQp8C8KCYgwgxTl6knQbTbH4tLfTJd0rH74T3hXLVCwPYwagrcdy84rIAdpUWxCBN+rNKRCgyA+7IwkE5NELpZx56FyYGnYPw1E9//G99yoH3NGUkAB0GTzHEF58DoZrsaogBxkhh7GwsnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608797; c=relaxed/simple;
	bh=4hBQ6kfdK8l+m9caQJD8zZXgKlYL1BsfesWiWNE6vU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6y0sfU/hWyvE2snoR2Ji1kHDc2DoLavq6vs0upO99fW8SPmrxaCdRu4zPvM8T1GPrIxJA4b82PduK89ih/yw77BNPDJRJDuRVtGdbCzppvjCosi3cy0ecVnooojBIW000swp+oPaM7O1AqHG60TcL9Z7Edb1bUQTbIBQQXcCqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sAjDAk3W; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sAjDAk3W"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b43b20bso13445735ad.1
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 08:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608795; x=1791213595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EQrjkRZQeuYzERNWt13KrmtO7dHmdt8dryvfZkIliO0=;
        b=sAjDAk3WoCaqK5yz24zQoH9g4qbtUJ56hp0GgVu73h4G1aMu5+QTzcCvureyhPcMuy
         3a2VJp4h5XrS/Ul5WgK0emp8qWKINH4xR0isVRgVmacktZwHuv7z79OTrCHL3LRbd7vY
         tgYAUj1VQzyU7ZzZy/idF6f9JK2i9TGtaaf3ljNc2atf5YzveV1f5GCOFnE27s4pXwWL
         sjA+DKTZV8BovZtAiP2pPYFumeU0ayQI6uoH5GQykWH5/f884Do+RL2AYw5Gh6+JJcT4
         2+AqFit4j/ingUD4uABr45QUkaS1pqVIPiRLKQ8FcIWHCN2X+/kBctE9nsRExTxb1DYw
         G5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608795; x=1791213595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EQrjkRZQeuYzERNWt13KrmtO7dHmdt8dryvfZkIliO0=;
        b=n7sUN02ZKGs4rWhFjA9mZu0QUiuqpbjxYsok8VFB+F+HLKnJNzXBpLW/1VV2dInjm1
         UYxQLdqtVCf+ICUVMZ1U7FWSGkOBVBqBgIgYc61VHmSaaSJeqlaZuIeGtJQ7d4VSOYA+
         VAJOlO1t/YReqmYZ5QH5j1uD7Pwa2tv9cW2uXYdQL72VXxub1NlVc8moP20ek9gTwkBg
         yq218loNk9g7DoO9KpSFwirhuN/EuavcEUH/Qj42T5WCro0s3UIoNKoDCuNnaJPMOW7+
         kHdPkocJwotPUEn5dwmEMCODiyOkfbkaR/q88RLi4+7MOredbOBC9VaLb80M+O8bGyds
         8IHA==
X-Forwarded-Encrypted: i=1; AKwUvBwGkXrkl6IZVVZi2aGQ6mMVgzAjX81FnkVP+MoBlAw03zUAapvuzhRXibjYvaz5ABI9/EGNX/Ybsvc=@vger.kernel.org
X-Gm-Message-State: AFq9FYKwl2QPJ1Zu2jtLoLtRAPNv309bj33m6+JltA4PO/MZ7uc44SgB
	+Rt+d5oxWSopMhvBW1HFUt6snVEpRSJd4Z/TFm7mp0+1LsAUPNlO1EKS
X-Gm-Gg: AYBFou2O3/myPl/FLyK+RT4pZDylbS0YSRuoof9iY7bR0LMEDfQVmPFpBABHo4z71u7
	NyyEnxnfrcfWY0xg7Y+Bj9sAi8MO6JmdPzUISaS6hg6/jfmBl96DyhSmeGaHtiF5PZ7amD8j5im
	wSVireTggtzj4tifwfWb5H6eTPh1z5joJbTwdmfUL8t57uDZ5iYaMqugN25y5alcoLDsQLOnTVk
	EhbCUgGr0ryc47WuL5Up2GMqXdnyrXGqiCE//I+5HYVdphRd7++Vov5HFupDP/f1SYKpSe5qUZK
	HrnSNkLudY+YwVIAUmIrRFY5CRF88PlK8b/nMKZCGmPAfym0qxR/FPZEfaAVwxR4Xy/eZml5sEN
	7M0E9Kf6znfuVbqL/qA1BKOXhCRcR+UvWPhR2/7Se1lSIb7o600CGF5mstgbv+c+Ilmbf18Auv0
	qMa+lyirdiflmEtKE1BTaz8e3Zk4vBmBo3ec3Tx0FoJa9pzuH6zXQgTg/XOLjM9M4h6Nf/mPq6e
	1X8S2K7iXttm4BaX7KKTy/B/Ch03OrvDaQTs2B0NIZhQ1XUXe7XQt08DYnzqAYM9UozMZnFcWVZ
	EwHEYvVdnNS/adKvJI81bsT/m0hj8MBr78Sr9bq9RdyIwvrkeTpKK9xJRKM=
X-Received: by 2002:a17:903:1987:b0:2dd:3ddf:b87a with SMTP id d9443c01a7336-2df7da68a41mr101388085ad.0.1790608794891;
        Mon, 28 Sep 2026 08:19:54 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91423df7sm43558615ad.43.2026.09.28.08.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:19:54 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:19:44 +0800
Message-ID: <20260928151944.2686626-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kairui,

> Just like we already have a "swappiness=" parameter in the reclaim
> interface, perhaps adding a "swap.tier=" would be better and much
> cleaner to achieve the same goal? Based on Youngjun's work here:
> https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/

Thanks, I think that's the right base.  I tried it: on top of
Youngjun's v11, a "swap.tier=" argument to memory.reclaim is about 40
lines.  In a VM with zram at a higher priority than a disk swap
device, and a cgroup whose tier mask allowed only the disk, ordinary
reclaim in that cgroup stayed on the disk, while memory.reclaim with
"swap.tier=" pointing at zram went to zram only.

What it doesn't cover yet is reclaim outside any configured cgroup:
under global pressure, a cgroup nobody configured still reached the
zram tier.  So for v3 I'd like to add a system-wide limit on which
tiers pressure reclaim may use, on top of the per-cgroup settings.
I'll wait for Youngjun's v12 and build on that.

Thanks,
Matthias
