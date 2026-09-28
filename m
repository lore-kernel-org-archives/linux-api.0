Received: from mail-pj2-f33.google.com (mail-pj2-f33.google.com [74.125.227.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180524E73AD
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608787; cv=none; b=YpvutRRwi+LPYEYUeaLb+BKb4ftYNUzGbAUU452pX8cGPDToJpkxxHJHVydMf9L1edYWa87O2K0YlCNei4N+5VG6ep8HHyJ31c0gwkqS8prI3ixJNlSO1qqoKe/HlH/YS86V/A/G62u0MHFnQxUMBzrJ3Fpqg6n9RsubpZHu80c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608787; c=relaxed/simple;
	bh=qFYBnXNYmhhsHxNx2COBADOmOdhhnVq5vY9GOOKIOJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N33jEXk5YfKE2zV+3nECxOFJy6s9/Tr0rpUSKc2porOO0B8myQ0h7QAiH3pp81Zj25yELvVI4L+Vtqhqq04VPB++aaJgxgmDu5ULN1WUoE9tYXs2hMP7QHHnexVmXfHHFyoJpal+I7YanCBRkm5UlZAdbM3FAIy7bk38PDD4g9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mcv3pLez; arc=none smtp.client-ip=74.125.227.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mcv3pLez"
Received: by mail-pj2-f33.google.com with SMTP id 98e67ed59e1d1-3a48b349480so254440a91.3
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 08:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608784; x=1791213584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h2+B+TCtU6LhjPX3KEHp5ZhDWyuT2oD8RctAdhdkStc=;
        b=Mcv3pLezAFyOR8F75xJ+N1J+sl5iObide+S4U96tO+DgnijX5Dmv30l2bJPwN1+1O/
         aDuzJbHgkNaz0lfw14o/KwYbNznQUu7xfoxAvpVI93mnAYbKzBCw1eNQDku74CY+HfZZ
         PW4KSnS4CPVrTmns0V/auUXCoQVjg+oAMiGULt1W0MA2xWn7cLmEQSDCHD855uvtV9X3
         gmimRXAP+b8P5tg4Y1swbLZRAvkFTJbDFLJEEFCREXen1/VjjyUloPUHnLfUPQXAU4AV
         74V9RqUw2P+Fwuuwm6XSQxgYih2pRhfqAVjfgoKGuEwYAv6/0uviPGmqijunI+77tcYn
         bP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608784; x=1791213584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h2+B+TCtU6LhjPX3KEHp5ZhDWyuT2oD8RctAdhdkStc=;
        b=dGIiMXH2VmYVW/rUDeXsbjmAh3Ags8WAawntgC2vEGqMDDWw4BpMcLWIc0P5XyWAe6
         SyVJRmCVVF1fTGRfeT9c3AYVKrHPgENq+y6AnJ7k30Oqu+FtMvo5rBVv0hKF9DcoPS8U
         iZHBfBx0Ocl5sADOXGm2EmUaMrv6f0j+55K+vmSWg1LdMRFDOqMxHucmAsSYf6Zp1Mcy
         sGDLrpV8fBVe8cHDCzRh4bgt6USZNaynisKUW9w5feR6WctDFcQaWB7TTdNczY57dyD8
         4ad8eIGnl6qqqE82gHGWTn78hJSG91Z7EDs1p5cmpR8uG+IuagXEFOFhSrd4kpYT4s9W
         ecnQ==
X-Forwarded-Encrypted: i=1; AKwUvByQwW2BOjMAFM/LkG60izBZXkpZGs/c1tyWuSYHJbhqk04AYDcKkZjpDkR0zqPK9aIFdMHuuWPYKaM=@vger.kernel.org
X-Gm-Message-State: AFq9FYKll8t0LMOZrmTtjqqrAJs5oJdq6YATlqffLL95gyvElovHqTLO
	VxO6m5Vn/9a8Kp6UglodRuJlkjyai7niY/7OIWQIlZkrM61lfal8tUyE
X-Gm-Gg: AYBFou3VmPsqAQRaFPedCRyhAupHANdjBUNhKt+i17Vb9SpnAGGrH7C8Q9FBkCJMlEL
	P7gwZk6yuGUzfWFR0S9o0ec5ELvPTmfiLwXiidT/eCNImjk+4HYMV2e6r5f0pvzy5RasIrwTDvX
	SMUHHg1FCpmb6bb7BlwxZMlClFgUejhB88jBDM5obT4s2X+/2gOuG/+iFZEHAANhf2a2gYqJr+w
	3PPwIM0dt1Q+wyMuX5KQ836xfTzgXBBR0W09qq2hE5lZGFDPAuNTUo7DdexsXQNUHvaxUxteaNx
	FsBAcI2pwJVGS+UvVxtIYElSfVBpHUOg6EpND5rnikGEexShb5zifjX4vc8NyOi4CgKcR+J4x87
	gAQB28t9CCUzRGozo7XiH91XzTs+tA6/jxciBnduGSfaYSM97eS2+luleN3K7HimOCYMRAfxPyq
	JJtB8+u5nT9tYEVt1emIOfGhwV+bhkKfuJqQLK8ezIcCCFhbQ4Sxz+89dyLjWVmq0pfuN4POCHV
	9TRLJr36DdL0T3uJ8Jr7fYLHbmQTMKZsFwsxkWIsIwlK9ajgG2gc5EQBqnM2qtngcom3QB0tFBE
	hOrleWYLTSMi1GqAQuM45gq0T/83uHfkF8kPiVBS/O/CoDepjlC5ybPRNqA=
X-Received: by 2002:a17:90b:3908:b0:3a0:c20b:2fdf with SMTP id 98e67ed59e1d1-3a0c20b3132mr6450444a91.17.1790608784281;
        Mon, 28 Sep 2026 08:19:44 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9feddd0sm7247965a91.2.2026.09.28.08.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:19:43 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
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
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:19:34 +0800
Message-ID: <20260928151934.2686418-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arn4xOIxFRD8qY_x@infradead.org>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <arn4xOIxFRD8qY_x@infradead.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph,

> Either way block devices must be safe to be called from paging paths,
> not just for swap but also for file system based paging.  So this is
> a bug in the implementation, and not something worked around in the
> swap code.

Agreed that a backend used for paging has to make progress under
pressure, and the zvol example was a poor lead.  The series isn't
meant to excuse a backend that can deadlock; that would still be a bug
to fix in the backend.

What I'm after is different: backends that are correct but need
memory to accept a write, where the better policy is to use them for
cold-page offload when memory isn't tight and keep pressure reclaim on
areas that don't need to allocate.  Two in-tree examples: zram
allocates on writes and fails with -ENOMEM, with no fallback, while its
logical size still shows free slots; and filesystem swapfiles must
give up copy-on-write, checksums and compression today, because swap
writes bypass the filesystem.  I'll make that the case for v3 instead.

Thanks,
Matthias
