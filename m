Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794758476;
	b=MuhehO15mIbDEMLRcI79w129BF5e05T21MSbgno8qGMfYsLE6mBA9CBKuOWmfaa61rg6
	 /ecVV/o8RCuQcat0X6KftLKz1VVRidrE3/sHqgLir0KeGzEx+otJmCfOkR3ElGSdBfVag
	 vGFNtCmpT8+cTFsNGeC4tS0hmWpGVuQPbP5Nevl83lGvi5HL/KyThVpGYBHSE2cP2Pn55
	 vyNKGVvDqcjUqtS7c0cV+HMsu0VKm8+lG+XOldEVyV+ctkQ2KypnfZgBrYWnxw7ucMDuU
	 AAUV5dd9b9ieDfTh+750BHozbj4GOkI0EC9elQPRApJDsrlMxmMrqmLVLoUMLAsSU5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794758476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=PEtMxT4PROaXkntuICK0I1QFQe5PSnm2qJpCmGFKExY=;
	b=JJGwfbwAr1gwray31rHXJzgVqXgLtqrBt7ABk+fmAYLQJuscPBP6XzrwK1Cgfsa5c+hx
	 Fs5yDWmAuCtFUuJIxzSFc0yMjWyhaUpuOSt+5FOc3tEq3JxUND83q8QbjovtOztr366+i
	 F4St53FHJtpySLo2gCXyUmANzaOkQMgmtWA07hYtZU0by+BsK6o06nKaHUwbOLA0I1vBF
	 JSSsJkyyyQTd6HrjkUa+9sA+5Xwd5v3Lc7A5CT11ACQIEVVD0BmTijXYLO0GnaiJ/pzry
	 eJJkq2EnQ10J3w2KcQ1QM9J564irqsV4g0A1Zk5Uxr3c/5K9ko53+b9aZIOtzML95qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nsKyyuvV;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA36606A8B3
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 16:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFA36606A8B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nsKyyuvV
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ee2d612733so5853275ad.0
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 08:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794758475; x=1795363275; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PEtMxT4PROaXkntuICK0I1QFQe5PSnm2qJpCmGFKExY=;
        b=nsKyyuvVzpf4mEt0LAHbwEkBvfrLoEFPzZVHIcM9v4SHt+x9AnvvvAThxlWrqN9TjX
         1I01/UOnOEqK8y+ksqIeybbchY2UZCv8nEjSbjwAc6+EwcWv1kw9TGpeki6P3tDiQsXl
         zYebv8nVCO0CJRlZdHpUejaNs6GmXYhS9Nmcbl6/eUmnw3OCk9QRij8FpBwz8lVxzgaM
         EGKHO3Nn0IvAlRT7gR373iv124Tm4LDX3HYdMqxtlhXtfJkZ8UnikO021H6daijT4NIq
         iQVZSausiUWFoFtNudvY3FFKjgPXw0QufUNdr1ilo8QtV+F4D50H/iWTtqL7XK3JPey6
         TeJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758475; x=1795363275;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PEtMxT4PROaXkntuICK0I1QFQe5PSnm2qJpCmGFKExY=;
        b=sDqqeyRacBDSNbb9DDd5XLxjjL0ZC9kCYcGT9te5oZoSPrZ5NEiODz3En5t6O6Zq5T
         0c3cYuNPnBarL0/Ad/xavTtr+2BH7aqzUBX6lzViUIOSyMQOoloWB7hGDkdjYPe4r18K
         w57VYjP3EvGO1nk1wFyB6tEBjrHnnzFbrnm3IAPKnQmEEhYaXnJRSoVTLaodlN5WYsh3
         uKQR97STXxNOcWEduIpVtWSG7TdTtlRpSGc5s1D3Vwbr3KmlrQUWAh/DsKDccstwOG0S
         GYSAtcOWweNIDiCsqOQPUjuBVzi3t2eRXQ+XY6h9RbVjA3/IgYIpyh5bOpBccRIoU87Y
         King==
X-Forwarded-Encrypted: i=1; AL+hErHouqzfkCzdPzTvOFIIkJT2A/97HX16DveGwJqyYW5Sj94r4izzctAUwjgiNXWhelyHUMikioJK64w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+bFm784nFrOXaBElPEYuN3cQJbLPKWTusVqQ8pK0Oo8sEch0RQ
	IGr5+SOVN4rnZwEJVZFHL5dSgVr2uUeb9qqAedOSHVpAFIkuSa5bxwm4lcJhDT5f5m/Wwx5kpOP
	/sFe+FHWeWuvWEQ==
X-Received: from plbkf3.prod.google.com ([2002:a17:903:5c3:b0:2e9:7e8e:b72e])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c2c:b0:2e9:93b7:23fc with SMTP id d9443c01a7336-2edf1ed96a2mr76147275ad.17.1794758474742;
 Sun, 15 Nov 2026 08:01:14 -0800 (PST)
Date: Sun, 15 Nov 2026 16:01:05 +0000
In-Reply-To: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261115160105.2507650-4-jiaqiyan@google.com>
Subject: [PATCH v4 3/3] Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, william.roche@oracle.com, ljs@kernel.org, 
	vbabka@kernel.org, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, skhan@linuxfoundation.org, 
	corbet@lwn.net, david@kernel.org, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Document its motivation, userspace API, behaviors, and limitations.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/mfd_mfr_policy.rst          | 81 +++++++++++++++++++
 2 files changed, 82 insertions(+)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..9c40445ea354 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -69,3 +69,4 @@ Everything else
    futex2
    perf_ring_buffer
    ntsync
+   mfd_mfr_policy
diff --git a/Documentation/userspace-api/mfd_mfr_policy.rst b/Documentation/userspace-api/mfd_mfr_policy.rst
new file mode 100644
index 000000000000..a5441bfbe78b
--- /dev/null
+++ b/Documentation/userspace-api/mfd_mfr_policy.rst
@@ -0,0 +1,81 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================================
+Userspace Memory Failure Recovery Policy via memfd
+==================================================
+
+:Author:
+    Jiaqi Yan <jiaqiyan@google.com>
+
+
+Motivation
+==========
+
+When a userspace process is able to recover from memory failures (MF)
+caused by uncorrected memory error (UE) in the DIMM, especially when it is
+able to avoid consuming known UEs, keeping the memory page mapped and
+accessible is beneficial to the owning process for a couple of reasons:
+
+- The memory pages affected by UE have a large smallest granularity, for
+  example 1G hugepage, but the actual corrupted amount of the page is only
+  several cachelines. Losing the entire hugepage of data is unacceptable to
+  the application.
+
+- In addition to keeping the data accessible, the application still wants
+  to access with a large page size for the fastest virtual-to-physical
+  translations.
+
+Memory failure recovery for 1G or larger HugeTLB is a good example. With
+memfd userspace process can control whether the kernel hard offlines its
+hugepages that backs the in-RAM file created by memfd.
+
+
+User API
+========
+
+``int memfd_create(const char *name, unsigned int flags)``
+
+``MFD_MF_KEEP_UE_MAPPED``
+
+	When ``MFD_MF_KEEP_UE_MAPPED`` bit is set in ``flags``, MF recovery
+	in the kernel does not hard offline memory due to UE until the
+	returned ``memfd`` is released. IOW, the HWPoison-ed memory remains
+	accessible via the returned ``memfd`` or the memory mapping created
+	with the returned ``memfd``. Note the affected memory will be
+	immediately isolated and prevented from future use once the memfd
+	is closed. By default ``MFD_MF_KEEP_UE_MAPPED`` is not set, and
+	kernel hard offlines memory having UEs.
+
+Notes about the behavior and limitations
+
+- Even if the page affected by UE is kept, a portion of the (huge)page is
+  already lost due to hardware corruption, and the size of the portion
+  is the smallest page size that kernel uses to manage memory on the
+  architecture, i.e. PAGE_SIZE. Accessing a virtual address within any of
+  these parts results in a SIGBUS (BUS_MCEERR_AR or BUS_MCEERR_AO) with
+  si_addr_lsb = PAGE_SHIFT. Accessing virtual address outside these
+  parts is good until it is corrupted by new UEs.
+
+- ``MFD_MF_KEEP_UE_MAPPED`` currently only works for HugeTLB, so
+  ``MFD_HUGETLB`` must also be set when setting ``MFD_MF_KEEP_UE_MAPPED``.
+  Otherwise ``memfd_create`` returns EINVAL.
+
+- For ``MAP_PRIVATE`` mappings, even with ``MFD_MF_KEEP_UE_MAPPED``,
+  the first write anywhere in a hugepage that has memory error fails
+  for the whole hugepage, because the copy-on-write must copy the
+  entire hugepage and inevitably consumes the UEs. The result is
+  likely a SIGBUS BUS_MCEERR_AR with si_addr_lsb = 30 for 1G hugepage,
+  as modern x86 hardware usually supports CONFIG_ARCH_HAS_COPY_MC to
+  recover various in-kernel memcpy routines from memory error.
+
+- ``MFD_MF_KEEP_UE_MAPPED`` works with ``MFD_ALLOW_SEALING``, and file
+  seals work as usual. Seals, including ``F_SEAL_WRITE``, can still be
+  added after hugepage having UEs, since memory failure recovery doesn't
+  hold extra references on the kept hugepages.
+
+- Truncate, hole punch, and close operations from userspace all dissolve
+  the hugepage. If dissolving fails, the HWPoison-ed HugeTLB page stays
+  out of use. Note that ``F_SEAL_SHRINK``, ``F_SEAL_WRITE`` and
+  ``F_SEAL_FUTURE_WRITE`` prevent truncating or punching holes in the
+  memfd, so a HWPoison-ed hugepage in a sealed memfd is only dissolved
+  when the memfd is finally released.
-- 
2.56.0.611.g1030f0b940-goog

