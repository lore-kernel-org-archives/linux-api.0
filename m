Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4920213790B;
	Sat, 26 Sep 2026 01:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790387861; cv=none; b=YAl7Ea0iBOBuRQdHkjkBnUagNmU6DJtjgHXk6PS5LA23xJyHWAZoCu30heTzIUsxRl0jxAz+BICEfsgpQfL1yALrdPt7G08P2faUPZYp/FVbpXN2NEk3w9UUCg3GrlZp2F1hfUy39R3a2uEIyugmcJdayqSyg17qyGaWiRKyRaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790387861; c=relaxed/simple;
	bh=DGYtecW5DFZ9yJmGrQeINmEVCXjN8K9xicbiogGLMKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwLmzi+owKc6aIOoZDbcXsIryWsR2zZ1Mkm0Em479kLL8OBGipq/4ijG+F84ZEZDczFwN6T8PouU6A/lcpcC16B6Y4ViAsBB2kk2o2SBmdSCbZkbaYahs6p5myptzdmSo4Odv6yzxLIJghApwAZ3UUQN7u80cIoiAS/cKUhaKAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlvD5NPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlvD5NPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E741F000FF;
	Sat, 26 Sep 2026 01:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790387859;
	bh=U9tNhY9XgrNOR5l3ETvbl6rzAQrvUAJBFk7BF7Qx3kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlvD5NPsF36xYxr+WjqTWXmeuhJcNHJWLwqZXEDQBTJj5k3qa5X8BYdmF5P7xIFi9
	 6JT+oBq5vhJpeKqvm8IaV87vaZK6FwuzH7h445qu/fj68ATGb748rQX0bk/oEdaLAo
	 W9bnd87WtqxTA/6v8mmCf2nQSSmrwFvMbHpH33PcO5BAQjRsc9ro9GOHCGqRYG7LYQ
	 N8aKItjnO3hnIcnt6BawN5VBlNNsbELsbcPAcNtV0b9kMwal/3qiQZA8f5qXPlPwMM
	 1Om0Ox6nRBkR+OFVs16Mowo2QQifVf9MmyLf6ttRj/J/kqkW5d4S7WakZAp4xt7Usq
	 bh70qJT52vW+A==
From: Sasha Levin <sashal@kernel.org>
To: Jimmy Zuber <jamz@amazon.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: Sasha Levin <sashal@kernel.org>,
	fuse-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/2] selftests/fuse: add test for FUSE_HAS_SYNCFS privilege gating
Date: Fri, 25 Sep 2026 21:57:28 -0400
Message-ID: <20260926015729.1674206-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820130158.254808-3-jamz@amazon.com>
References: <20260820130158.254808-1-jamz@amazon.com> <20260820130158.254808-3-jamz@amazon.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Aug 20, 2026 at 01:01:58PM +0000, Jimmy Zuber wrote:
> .../selftests/filesystems/fuse/test_syncfs.c  | 309 ++++++++++++++++++

Hi Miklos,

test_syncfs.c didn't make it into the applied version of this patch,
a6ca1a573e1f ("selftests/fuse: add test for FUSE_HAS_SYNCFS privilege gating"),
in fuse.git#for-next. Only the .gitignore and Makefile hunks landed, so the
fuse selftests no longer builds:

-- 
Thanks,
Sasha
