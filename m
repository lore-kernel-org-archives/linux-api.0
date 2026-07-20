Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A49B445AFC;
	Mon, 20 Jul 2026 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568948; cv=none; b=CdEuFL2XfP7L3xpPW2OffEkPzDHzmUHGr0RCK2Mie6YTqBlANHWAXCvjlYhO0L+pTp3X51F/GiKFCStnYgAks1wD8kXTrOOUfY86tivqhs7GlCp++0jCBtm81lUAvMuYQ3rhkFZfJ2dAkfIjlIhRW4CfPm/ti+YD4qHEA/C1DYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568948; c=relaxed/simple;
	bh=grwcJmljYrm4L5gmHUhp0qtRNkxQlmnxO58CE0jQFx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IHLEo8HxRMDUiMbmWrURH6ubtK1zi1tfwpSWshR94MEbJJgAbv8gmAaaFDujDlEGA1IDitH8aC1t+YB4PND8i2BT0fMj0PD+BzzABSypa63iKl8PaiSvypz+pE3l78qaGjZjKd0/bXE7x3zpOR7iMV21tFdDnbgrGv7Qi+GE0Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=KzsolFHn; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="KzsolFHn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X8fSXpmCwhQg3y2SB4HtoQCv89KmE6nRd47fraE9LQA=; b=KzsolFHnQxpHzcAIczav3NOQ1K
	1fdZBEla+Uizqtv63spB/oemqvn2iGe2lapkAzoJEEXyhbwMp5xx4R2NhUL0Kk1Lp3RYdtyi+fF0m
	YWH8OwvLo9puADZZ31EZfm1hoTT/gQ9RgvcrU01bAXzdl/xw5noAGYVCKs6OKWFbc90lNTE70TIp3
	fzxze0ndUHN0BQSEonYhtx2ORAvEvpbwSk4cUc8R4mOJGfPP2Y3unWI0zwTM4AL+VgAO9kJXErIeO
	t/Xnp8B4/c6WuTcTnI/GUzkz+9qwxbI7KRwfO39pqy07jJztjKO6K5nIYpmzch/4y0b9W7tYoEnej
	4BOhZQGw==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wlrcg-001Fmy-02;
	Mon, 20 Jul 2026 12:17:46 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH 0/4] ntsync miscellaneous patches
Date: Mon, 20 Jul 2026 12:17:36 -0500
Message-ID: <20260720171740.447035-1-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a resend of a series originally submitted as [1], now sent to char-misc.
The following is the original cover letter sent with that series.

[1] https://lore.kernel.org/all/20260628024239.152852-1-ivanrwcm25@gmail.com/

===

This series improves ntsync without changing wait/wake semantics:

 1/4 — Align Documentation/userspace-api/ntsync.rst with
       include/uapi/linux/ntsync.h (ioctl macro names and struct layout).

 2/4 — Fix wake_all selftest: CREATE_EVENT returns an fd, not zero.

 3/4 — Add selftests for documented EINVAL cases (zero owner, non-zero
       pad, cross-instance object use).

 4/4 — Reject wait ioctls when owner is zero, matching the documented
       uAPI (3/4 depends on 4/4 for the owner tests).

Patch 4/4 closes a spec gap: Documentation/userspace-api/ntsync.rst
requires EINVAL when wait owner is zero, but setup_wait() only validated
pad and flags.  Unlock/kill mutex ioctls already reject owner == 0.

Testing:
- scripts/checkpatch.pl --strict --no-tree: clean (4/4 patches)
- make headers && make -C tools/testing/selftests TARGETS=drivers/ntsync
- Kernel 7.1.0-ntsync-test+ (CONFIG_NTSYNC=y), QEMU x86_64 initramfs:
  tools/testing/selftests/drivers/ntsync/ntsync — 12/12 PASS,
  including wake_all and wait_args_validation
- On 6.17.0-35-generic with the distro ntsync.ko (without patch 4/4):
  wait_args_validation fails on owner==0 (wait proceeds instead of
  EINVAL), confirming the gap this series fixes


Iván Ezequiel Rodriguez (4):
  docs: ntsync: align uAPI ioctl names and struct layout with ntsync.h
  selftests: ntsync: fix wake_all CREATE_EVENT fd expectation
  selftests: ntsync: add wait argument validation tests
  ntsync: reject wait ioctls with zero owner

 Documentation/userspace-api/ntsync.rst        | 22 ++++-----
 drivers/misc/ntsync.c                         |  3 ++
 .../testing/selftests/drivers/ntsync/ntsync.c | 46 ++++++++++++++++++-
 3 files changed, 59 insertions(+), 12 deletions(-)


base-commit: 2cedf2272f1bb42471e646868ac572cc5752bd91
-- 
2.53.0

