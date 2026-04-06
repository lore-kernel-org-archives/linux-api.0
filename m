Received: from mail-m2477.xmail.ntesmail.com (mail-m2477.xmail.ntesmail.com [45.195.24.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D2438838B;
	Mon,  6 Apr 2026 16:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.195.24.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494607; cv=none; b=uSSg4ELwWJmyT88gvFFsDzHzr94Ko6U/qbMm/SAPPuCZMzJCMgscJ0Up/aiHhqLc1Hb9oelCGQbQq0FP8p7WtjTvZUPtFsyBkAamxJ93wfG/CC7+hIRgXqsIxoDZXjKPK8Do1uBofTDGeqnM3mIsiLjVkfBWT8yrfntRhYCd4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494607; c=relaxed/simple;
	bh=7N4XBttMaUfHvT10Bjf8wMO7OY346LDy5mrmbVDtCK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cO1SRPC/dEGH13H5bNE4QwZNW4sDlgZ2mNfp5eK+mRIEXFq3Vr1L5ecbgyQmIrcQv57OAYkFqL6W2rDlX0l86jJMCMSzJBlrCWDWrUhR3T5lY0x83pL9KNhYqW/yaKnJX1BxmrQoOMXW2+/3WEztkSe0j7hf6H/j5XochvWzF2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ruc.edu.cn; spf=pass smtp.mailfrom=ruc.edu.cn; dkim=pass (1024-bit key) header.d=ruc.edu.cn header.i=@ruc.edu.cn header.b=B5oda5J2; arc=none smtp.client-ip=45.195.24.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ruc.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ruc.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ruc.edu.cn header.i=@ruc.edu.cn header.b="B5oda5J2"
Received: from lwz.tail698a0e.ts.net (gy-adaptive-ssl-proxy-1-entmail-virt204.gy.ntes [36.112.3.244])
	by smtp.qiye.163.com (Hmail) with ESMTP id 39aaefbda;
	Tue, 7 Apr 2026 00:51:21 +0800 (GMT+08:00)
From: Wenzhao Liao <wenzhaoliao@ruc.edu.cn>
To: rust-for-linux@vger.kernel.org,
	linux-pci@vger.kernel.org
Cc: ojeda@kernel.org,
	dakr@kernel.org,
	bhelgaas@google.com,
	kwilczynski@kernel.org,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v3 0/6] Rust goldfish_address_space driver (ioctl-only subset)
Date: Mon,  6 Apr 2026 12:51:14 -0400
Message-Id: <20260406165120.166928-1-wenzhaoliao@ruc.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1775456181.git.wenzhaoliao@ruc.edu.cn>
References: <cover.1775456181.git.wenzhaoliao@ruc.edu.cn>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d63b4b85003a2kunm562d3b0d647e52
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDThpMVk5DQktMSxofSB4aGlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlITVVKSklVSFVJT09ZV1kWGg8SFR0UWUFZT0tIVUpLSEpOTE5VSktLVUpCS0
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=B5oda5J2EW5s+7mkPYu2H4P4OvncI9pvTRvKqr+bHhU7kHMJ90kgvYEQ9WC3su49q65DCD25J1pK59lGm2OO65m8tA7y9/C4/T2SyFsEeZhR538ALa3Sr/d+wj72Ef0WFy4hUY5wr9SCXG8DONtSTrEXBYrHUhO14aEK/IZBCMU=; c=relaxed/relaxed; s=default; d=ruc.edu.cn; v=1;
	bh=DrGe7dDIenQDEOD5TVrW9lT5Xaaahb+DDLbuVFdBaKc=;
	h=date:mime-version:subject:message-id:from;

This respin narrows the Rust goldfish_address_space RFC to the
open/release/ioctl ABI subset. Userspace mmap and PING_WITH_DATA are
not part of this series.

I would like to send this as a small first upstream step for the Rust
driver, instead of asking reviewers to take the mmap/VMA lifecycle work
in the same round.

The goal of the respin is to keep only the pieces that are still
required by the current driver:
- the goldfish UAPI header and Rust bindings exposure,
- minimal page helpers for the ping page,
- a small SharedMemoryBar abstraction for shared BAR reservation,
  memremap() lifetime, and physical base discovery,
- hardened miscdevice registration/open boundaries,
- and the Rust goldfish_address_space driver itself.

Compared to the previous round, this drops the Rust VMA/BAR-to-VMA
mapping work from the series and rewrites the driver and miscdevice
pieces around the current teardown and publication model. The driver
remains #![forbid(unsafe_code)].

Feedback would be especially helpful on:
- whether the ioctl-only ABI subset is a reasonable first upstream step
  for goldfish_address_space;
- whether SharedMemoryBar is the right minimal Rust abstraction for
  shared-memory BAR reservation plus memremap() lifetime;
- whether the miscdevice hardening direction makes sense, especially the
  publication-safe open context and the THIS_MODULE-owned safe
  file_operations path.

Changes since v2:
- dropped the userspace mmap portion of the RFC and removed the unused
  Rust VMA/BAR-to-VMA mapping patch from the series;
- narrowed the goldfish Kconfig help text and driver description to the
  open/release/ioctl ABI subset;
- reworked miscdevice so safe open() only sees publication-safe state
  and safe drivers no longer have a raw file_operations escape hatch;
- reworked goldfish teardown around deregister() -> shutdown() ->
  disable_device(), with live-file revocation before PCI disable and
  explicit enable_device_mem() probe unwind;
- kept the in-tree Rust VMA helpers still used by binder out of this
  series, so the respin only carries code with a current caller.

Behavior exercised for the RFC-limited ABI subset:
- open / release
- allocate_block / deallocate_block
- ping
- claim_shared / unclaim_shared
- unknown ioctl
- reopen

No claim is made beyond that subset in this respin.

Build-tested:
- make LLVM=1 rust/kernel.o
- make LLVM=1 drivers/platform/goldfish/goldfish_address_space.o
- make LLVM=1 samples/rust/rust_misc_device.o

Wenzhao Liao (6):
  uapi: add goldfish_address_space userspace ABI header
  rust: bindings: expose goldfish address-space headers
  rust: page: add helpers for page-backed ping state
  rust: pci: add shared BAR memremap support
  rust: miscdevice: harden registration and safe file_operations
    invariants
  platform/goldfish: add Rust goldfish_address_space driver

 MAINTAINERS                                   |  10 +
 drivers/platform/goldfish/Kconfig             |  11 +
 drivers/platform/goldfish/Makefile            |   1 +
 .../goldfish/goldfish_address_space.rs        | 917 ++++++++++++++++++
 include/uapi/linux/goldfish_address_space.h   |  54 ++
 rust/bindings/bindings_helper.h               |   1 +
 rust/helpers/page.c                           |   5 +
 rust/kernel/miscdevice.rs                     | 409 +++++---
 rust/kernel/page.rs                           |  52 +-
 rust/kernel/pci.rs                            |   8 +
 rust/kernel/pci/id.rs                         |   2 +-
 rust/kernel/pci/io.rs                         | 112 ++-
 rust/uapi/uapi_helper.h                       |   1 +
 samples/rust/rust_misc_device.rs              |   9 +-
 14 files changed, 1453 insertions(+), 139 deletions(-)
 create mode 100644 drivers/platform/goldfish/goldfish_address_space.rs
 create mode 100644 include/uapi/linux/goldfish_address_space.h

-- 
2.34.1
