Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01F52D23B9;
	Fri, 19 Jun 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781888593; cv=none; b=G9GgwOo8VVc4qWa8eh0TF7ihT9SwCrPgTaBNNv56OtpQ0OMthe5jLThMZO7zbDoD/tYB6tKhGc9qOnazNCWZwU7eDQ4XtOEbd947pZwI7KiUexUU0249Pn72TngURz6Swl2aVvByGDOKvdai+CMjjj6A85flsC8IhmXJfDTtqBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781888593; c=relaxed/simple;
	bh=13vWre6vQErlYBEx+qynCCSlbv+70wjnYaeujfU3S0Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h1/jTvuj9uwPVJ7MKjx1HByGAtiWBisBPpKHE9CUOvCrTg00yz4kPBq6ACYQM37pW28zIzKvy/oTU8e3OF0lKUTADH3ec2X0+2hxEscBjG4u7IFMJzuXLaLOdxCK8rLNjSs36/ciV7by0vpLd0z5eMhEvumAsAvNx63NpR0/zxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=KhwOh5Vm; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="KhwOh5Vm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1781888591; x=1813424591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=atzZ8mWDYKYmCqJ3ZEoieLR6uL6N2bSl7KXRcSXPq+U=;
  b=KhwOh5VmxcbTJy47ycNGTSYyvEAnZSN5kf2PyIr3Dg3OkWm+PPf8UG0E
   f4IqtsQkKvijrJdR/cBAiq1jpFXFfC0YG2SbcmSYd0WgiqUIJ2/1HfC1Q
   JvGP/il5pWZP2WkNJNaocBAelUVFTtR0pk5Vcn3eiRpQl6ufgOwLhctJs
   2qXUQgh+ltoj7G0S68lq4xSibYG8FUY5LnX0A1F5yQHAuMUzfki2B8LHY
   6HygRZGia5c8cqrBG9jf+5Oin4qQl17KOcSXR+bbQ+r74yJwGZN10A+ko
   66LKYLMtGM5ncglFBkcn8Nxxi59BJBb0syoznz32WS1ECdtUXcJOuhbQK
   w==;
X-CSE-ConnectionGUID: HuPOm6j7RC2ElefRHHuqvw==
X-CSE-MsgGUID: 4ZPXHre+RDuiUjqIxJuoEA==
X-IronPort-AV: E=Sophos;i="6.24,213,1774310400"; 
   d="scan'208";a="22098218"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2026 17:03:11 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:6734]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.253:2525] with esmtp (Farcaster)
 id d33150b5-9e74-421f-a3cb-be03f99af074; Fri, 19 Jun 2026 17:03:11 +0000 (UTC)
X-Farcaster-Flow-ID: d33150b5-9e74-421f-a3cb-be03f99af074
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 19 Jun 2026 17:03:11 +0000
Received: from dev-dsk-jamz-1e-e35f4cd9.us-east-1.amazon.com (10.189.35.140)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 19 Jun 2026 17:03:10 +0000
From: Jimmy Zuber <jamz@amazon.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-api@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Shuah Khan
	<shuah@kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v2 0/2] fuse: allow FUSE_SYNCFS for privileged userspace servers
Date: Fri, 19 Jun 2026 17:02:49 +0000
Message-ID: <20260619170251.1154562-1-jamz@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260616151909.916667-1-jamz@amazon.com>
References: <20260616151909.916667-1-jamz@amazon.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
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

  Patch 1: the kernel change (UAPI flag + privilege gating).
  Patch 2: a selftest that speaks the raw FUSE protocol over /dev/fuse, so
           it can withhold the flag and directly observe whether the
           FUSE_SYNCFS opcode is forwarded.

A matching libfuse change (FUSE_CAP_SYNCFS negotiation) will be sent to the
libfuse project once the UAPI flag here is settled.

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

Testing: built and booted under QEMU.  The selftest passes all
four cases, including the new case above (verified that the kernel withholds
FUSE_SYNCFS while it would have been granted under the v1 check).

[1] https://lore.kernel.org/20260616151909.916667-1-jamz@amazon.com

Jimmy Zuber (2):
  fuse: allow FUSE_SYNCFS for privileged userspace servers
  selftests/fuse: add test for FUSE_HAS_SYNCFS privilege gating

 fs/fuse/fuse_i.h                              |   9 +
 fs/fuse/inode.c                               |  28 ++
 include/uapi/linux/fuse.h                     |  12 +-
 .../selftests/filesystems/fuse/.gitignore     |   1 +
 .../selftests/filesystems/fuse/Makefile       |   2 +-
 .../selftests/filesystems/fuse/test_syncfs.c  | 370 ++++++++++++++++++
 6 files changed, 420 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/fuse/test_syncfs.c


base-commit: 7d87a5a284bb34edb3f4e7e312ef403b3385a7b7
-- 
2.50.1

