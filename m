Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052392;
	b=Pdj3EsDBqdKnOY4Up0stlmuXSaGfiQla3cx+7MFKXTB9MBeSYk5G84WLJL2HayQ6s9+T
	 4V2ISlkU9DgEwXvmSoAXf7uoZ01ShS33z69Fh3syiDHwi8T5OZNoxpVy82oR7IPYzc5jj
	 8AgNwlr3bitoN1zw8Mhh6jgszFPfbJCckyk0sQYBnHKsb8KvFm8zQEMQJnc09FcBbJYRu
	 6ZLDwKATvavH2R1ONuNVrxPQnFnxYWw8mi3HJA5VAf7k8WliWyUbUSd8EGvhIyY3RzBTx
	 lIwXZLOgSx2r8WOVpD4QkHz8xAbD2tiYdCTptJgN9OC16FVacXTMq6/2LNdMe4U3mOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=4Disj2F29OKR5YWAXzU4pjttlvpvFspexRzVXwUoCj0=;
	b=0+LouYnFPjvQ7qhDL8903IxVQUWqus3czWDxs6KbXA2ckLnRA5vn9BmF2aTy/+HImr5r
	 uhd2obAo4ZlJOHlmlzb1cZjQgUaH00MB6uLgygF9Wim1Q5SHC8hXjERUjpGhV0veWqI02
	 nWKrqOmY6dw4zy1DWA7BzpVHOtL9L+Wg1A5YJBJjlp7xBHo4dAjfwPgInbyhMSOF0UrBs
	 KLLkBb6Z6iQ/OJSMP1py0Bz+IOZgrgfzqPQrwz+PjsUCXE+t1/9SnQ5Mir8nUkzrMxcaB
	 tQ4EFZToBWTF2B36rBhLdyRliR9TODm7c6W71Aq/0FVtjfHnCq3lVS9h6QEgBo1LAHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="HdLd/6k1";
	arc=none smtp.remote-ip=209.85.214.200
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30E606A31D
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 22:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F30E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HdLd/6k1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e9572e892dso28344705ad.1
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 15:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793052391; x=1793657191; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4Disj2F29OKR5YWAXzU4pjttlvpvFspexRzVXwUoCj0=;
        b=HdLd/6k1Vn3/4JJBps1LmdwjQ4X79XpP/LH725YPOhZXCz4X4QTFggZUzYVISvXqmw
         4jew6YxeUf6yvf/qibWlWFYzNwu216oAPbx/1sAGfUdCoULXE5SN4gfR5GapdmeTZh9c
         pDHVlDR2wWd13tKtnCMeM4qD3ch+Dsb6MWhpX1Xv51Jwo4eNnqMF8p3bmUwvgLH9YrvZ
         PfWL5P9xinxpahNsTeOfnYxBIIMJojHTy1vjDHrrEaRawn5zEogAyitwihkRkbBpl3dT
         K6qReh9NN8qUCryz40TH3XOQMqCw2V7WKvFXN/a6XsPIKgTJJotQJp/lR/f2Aym2i8JU
         qh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052391; x=1793657191;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Disj2F29OKR5YWAXzU4pjttlvpvFspexRzVXwUoCj0=;
        b=MGoj4FELyXFz/OQkusRHa9KxoqmCaJWWDTwHfKkglROCWUiFZ1qwVV3Pzc/wfmfGpv
         XlPvyEEat++Z31AdwHUl2M3e7SegOk42EBnBa5T72IAf6UGtoGo0nrem9VjXIhs19Zhd
         wdl3l1+Zv7Vo9mRVz6LqOwRp2q6I1tR2gsaX/x4xAE7Lz6Xq9C4e9uR3ud225WMQHpQ1
         ep9ytr7k/zdEJQFqvsVitmybsVcL6/Bmmo8fG+bkMVzprGxmho0zmpWjK3Viw0Uc6goa
         zKmJai5R55vkDVoX+VD4l1Qk/MJb4FrhdfT2z1nlhhpKpBFXjDQLrc4fdR8uDXURXKXm
         YkZg==
X-Forwarded-Encrypted: i=1; AKwUvBxNvIIaomsXhFJr5ugWVkybpTFM4d4Hw3AWWxn3saJy6HKONoRUKqr/7U2f4VvDN9jBuzInQM1aJp8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJWUfaHXpWlQ9cYjjXR3zaDYyluVKgxeNjPzBmdWkEHtwwkKM3d
	1p0s8tFtRTO3q5fwZpyKUykmyAWMvSlOBWmKRJ1YSZEjj38yuVwMGHRVN+Rn5+xDCXXiIJJW7Yg
	OUGynzoEImgaPtA==
X-Received: from plblk3.prod.google.com ([2002:a17:903:8c3:b0:2e5:ff91:ecf1])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3803:b0:2e9:5829:9b48 with SMTP id d9443c01a7336-2ea9c6c359dmr62263545ad.20.1793052390732;
 Mon, 26 Oct 2026 15:06:30 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:05:44 +0000
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026220546.3114241-1-skhawaja@google.com>
Subject: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
holes from being punched into a shmem or hugetlbfs memfd while leaving
the file fully writable.

Background
==========

Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
memfd_pin_folios() to pin the folios backing a memfd and hand them to a
device for DMA. Pinning keeps those folios allocated, but it does not
keep them in the file. If userspace later calls
fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
the folios are dropped from the page cache while the device continues
to use them. The pin holder is never notified, and from that point on
the device and the file silently diverge.

The existing seals only partially address this. F_SEAL_SHRINK prevents
pages from being dropped by truncation, which is why udmabuf requires
it. Hole punching, however, is only blocked by F_SEAL_WRITE and
F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
them unusable for memory that must stay writable, such as guest RAM or
DMA buffers, and udmabuf explicitly rejects memfds that carry them.

Proposal
========

F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
-EPERM, while reads, writes and resizing are unaffected. Combined with
F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
the memfd while the memfd remains writable.

Motivation
==========

The immediate user is IOMMU live update. Before iommufd preserves a
memfd-backed mapping across kexec, it must confirm that every pinned
page still belongs to the file. Today this requires walking each mapped
page at preserve time, which is costly for large mappings. With
F_SEAL_PUNCH_HOLE and F_SEAL_SHRINK in place, iommufd can verify the
seals once at IOMMU_IOAS_MAP_FILE time and skip the walk entirely.
udmabuf can benefit in the same way. Neither user is changed in this
series.

The iommufd change that would use the seal is discussed in the IOMMU
live update series:
https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/

Testing
=======

Patch 2 extends the memfd selftests to cover the new seal on both shmem
and hugetlbfs. Both "memfd_test" and "memfd_test hugetlbfs" pass in
QEMU.

The hugetlbfs run depends on a separately posted fix. Without it, the
run aborts in the existing SEAL-EXEC test before it reaches the new
tests:
https://lore.kernel.org/all/20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org/

Samiullah Khawaja (2):
  mm/memfd: add F_SEAL_PUNCH_HOLE
  selftests/memfd: add F_SEAL_PUNCH_HOLE tests

 fs/hugetlbfs/inode.c                       |   3 +-
 include/uapi/linux/fcntl.h                 |   1 +
 mm/memfd.c                                 |   4 +-
 mm/shmem.c                                 |   3 +-
 tools/testing/selftests/memfd/memfd_test.c | 111 ++++++++++++++++++++-
 5 files changed, 118 insertions(+), 4 deletions(-)


base-commit: 7bf01f16a4d05028fbeff4d90bab40df25142a24
-- 
2.56.0.307.g5fe7bd680c-goog

