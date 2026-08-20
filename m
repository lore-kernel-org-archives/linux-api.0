Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2DB33F8A2;
	Thu, 20 Aug 2026 13:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230934; cv=none; b=X/7JWHgfqWOZocxIZO4OgofHnZeWGifWntGnUn+0wZnZB02SJzNWd7xg6nZkJYPPeA34wPl0Fu/52eiTa1KrRQW8uqG3J3L5z1JYeSKAIIO6VBFxKGlzDjtPTuf6iPmjhmEf9Y9hWMT1pYgM6aoTMcgQziPHSAosFfFvBjGJesk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230934; c=relaxed/simple;
	bh=6eDPCzvwfq4ALbMyX+g2YrbSWnbYl2di8/Fa0Ai7KfY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hFCFUOrpfJ3vRDQi6GLJUSl/dJnT8d3g4+NZGnfjuxIlQ4vnzDX+ENyBRjRcSWmH2X+3u3GIMI2RtakktKUsiFqrd5T1xtvurUAaJVXnC1K8gotm++1m1pIZFYzM0vCNb+QmJfdLkp8msB5p1LkWDVP07gBo6BWrP1AGqubpmAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=G7lFy+U8; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="G7lFy+U8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787230933; x=1818766933;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZXxmGYeQ92oV94rXDtDInbSeiKZ5jTA05jjj7SsP3xc=;
  b=G7lFy+U8+/vjkUqNcBaA5UGmJJEyN2CWjUlr+AlmYFHC41OU5Pnl74Z3
   XHqxw5t6lb4GslZoRWbob2MV3vtLqjU7/FxEO5TK3zKqv3rSsBPmGtizn
   7HsaYEJQXnmw9a6bmBEuv01lPFaift2jRD0gSvjPcIOmdvuyIBfyBH5aA
   rDtzumMHw1ci0Azj/y1gRxhjci3a0mIkqKPB7mrBwAx+HoAQQWue/jf+V
   0RR5B6sQeKQKn9dBhsk53VseUutmh6uhsEQ07EGtXLFgN5oRDin2P7Xql
   uSizhYLbGTsLnosFJt5qQ5y3pzUxhD9G/HVTDC/rp007vxImVcygdnhZa
   g==;
X-CSE-ConnectionGUID: Va6p8yoHQGG7crGoTawj9A==
X-CSE-MsgGUID: 5xFm0+6wTb2ygTUSUFBxDQ==
X-IronPort-AV: E=Sophos;i="6.25,233,1779148800"; 
   d="scan'208";a="26466404"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 13:02:13 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:5332]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.76:2525] with esmtp (Farcaster)
 id 0dac1b51-2824-480a-92b8-4b8b88da920c; Thu, 20 Aug 2026 13:02:12 +0000 (UTC)
X-Farcaster-Flow-ID: 0dac1b51-2824-480a-92b8-4b8b88da920c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 20 Aug 2026 13:02:12 +0000
Received: from dev-dsk-jamz-1e-e35f4cd9.us-east-1.amazon.com (10.189.35.140)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 20 Aug 2026 13:02:11 +0000
From: Jimmy Zuber <jamz@amazon.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-api@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Shuah Khan
	<shuah@kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v3 0/2] fuse: allow FUSE_SYNCFS for privileged userspace servers
Date: Thu, 20 Aug 2026 13:01:56 +0000
Message-ID: <20260820130158.254808-1-jamz@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

FUSE_SYNCFS (propagating syncfs()/sync() to the server) is currently
enabled only for virtiofs and fuseblk, since an untrusted server can stall
sync(). Any FUSE filesystem may buffer data in the server that ought to
reach storage on sync(); the only thing that should gate it is whether the
/dev/fuse opener is sufficiently privileged to be trusted to block sync.

This series lets a plain /dev/fuse server opt in via a new FUSE_HAS_SYNCFS
INIT flag, honored only when the server opened /dev/fuse with CAP_SYS_ADMIN
privilege in the initial user namespace -- checked with file_ns_capable() at
mount time.

Extending syncfs propagation to another privileged mount class is not a new
direction: commit d3906d8f3cee ("fuse: enable FUSE_SYNCFS for all fuseblk
servers") already did the same for fuseblk. This series applies the same
reasoning to a plain /dev/fuse server, checking the opener's privilege
directly rather than inferring it from the mount type.

  Patch 1: the kernel change (UAPI flag + privilege gating).
  Patch 2: a selftest that speaks the raw FUSE protocol over /dev/fuse, so
           it can withhold the flag and directly observe whether the
           FUSE_SYNCFS opcode is forwarded.

A matching libfuse change (FUSE_CAP_SYNCFS negotiation) will be sent to the
libfuse project once the UAPI flag here is settled.

Changes since v2 [2]:
 - Rebased on current fuse.git for-next.  Since v2, bit 43 and minor
   version 46 were taken upstream (FUSE_HAS_IO_URING_BUFPOOL); FUSE_HAS_SYNCFS
   is now bit 44 and bumps the interface to minor version 47.
 - Selftest: dropped the v2 T4 case (an unprivileged user-namespace mount).
   With the v2 gating on the /dev/fuse opener's capability, T4 exercised the
   same "not capable -> withheld" branch as T3 while carrying the userns
   setup machinery; T3 (opener without CAP_SYS_ADMIN in the initial user
   namespace) is the surgical test of the gate and is retained.  No kernel
   behavior change.

Changes since v1 [1]:
 - Gate on the privilege of the opener (CAP_SYS_ADMIN in init_user_ns at
   /dev/fuse open time, via file_ns_capable()) rather than on the mount's
   user namespace.  Miklos pointed out that the v1 check
   (fc->user_ns == &init_user_ns) tested a property of the mount, not of
   the server that actually services -- and can stall -- the connection.
   Being in the initial user namespace is not itself a privilege
   (e.g. an ordinary sshfs mount qualifies).  Checking the device opener's
   capability closes that gap.
 - Selftest: add a case covering exactly that distinction -- a server
   in the initial user namespace that opened /dev/fuse without
   CAP_SYS_ADMIN -- which v1 would have wrongly allowed.

Testing: fs/fuse builds clean on the rebased tree.  Built and booted the
patched kernel; the selftest passes all three cases (T1 forwards
FUSE_SYNCFS; T2 and T3 withhold it), and a separate check on a
FUSE_WRITEBACK_CACHE mount confirmed the point of the change: after write()
the server had received 0 bytes (data dirty in the page cache), and after
syncfs() it received the full buffered payload followed by FUSE_SYNCFS.

[1] https://lore.kernel.org/20260616151909.916667-1-jamz@amazon.com
[2] https://lore.kernel.org/20260619170251.1154562-1-jamz@amazon.com

Jimmy Zuber (2):
  fuse: allow FUSE_SYNCFS for privileged userspace servers
  selftests/fuse: add test for FUSE_HAS_SYNCFS privilege gating

 fs/fuse/fuse_i.h                              |   9 +
 fs/fuse/inode.c                               |  28 ++
 include/uapi/linux/fuse.h                     |  12 +-
 .../selftests/filesystems/fuse/.gitignore     |   1 +
 .../selftests/filesystems/fuse/Makefile       |   2 +-
 .../selftests/filesystems/fuse/test_syncfs.c  | 309 ++++++++++++++++++
 6 files changed, 359 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/fuse/test_syncfs.c


base-commit: d1dbc59200b54944f00251ca4dfbb2b318beca13
-- 
2.50.1

