Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCDC3E49DA;
	Thu, 23 Jul 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837602; cv=none; b=lkg6RsiLbeBucAl1B9t8IFnrqOmfhrMYBf2D5TaO/JwRIMhDZ/LN6gbxtyqU8JJlw1nT74/YApLmxVQZsqcp9hAqTMwJMtudoqq2mtrqPt1u6iGV+z2SjciwEPbAEvv1ncfuHaGYZkpyomzMFzg53eUtdotKuViXSn0KoW5VdsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837602; c=relaxed/simple;
	bh=ZMX51YCuRs8+LU8uPn8Ix3iTH+1eAKuiIIdEyh65wfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fqjdj3P0v70/4LHPf21YG89LX9GUcZjjL+p3RVU0vcq0jJjXK84FejWwkVforI2FsSt+J4WZv2IVTuXZu+n4p5YiycObT8Vh8fkmMQHTnFu2KPeyM88ATxvexyQ5robwVmfiBGr99o+EU20k5um45UBdR3FpVgtjpAJcYN7pMaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=n44c1Q3q; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="n44c1Q3q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Gnn6Un8y8QGuiSUKAgWv2QEw40SpxAJITg03jxDlhmE=; b=n44c1Q3qQVrbJUXLj6qRXaA8xo
	Epdf4SrIgNzIhhiOuzjV0au7h3BOUeej58jIyX5UQa6ZLj037bouNTlawr4w3lRlSY43vXylrTDBF
	E3EegVdnoiG7Zq7eFgWU8VGNlY//QyfCKG0KzUTWYMXIOGSJ0pKy8UqZKqknlo+y8VFHny52x2qN4
	FOgnB/uvBZmsvTavzGOeHvl4or4uhNDmXTG+8sOGSNyYtsFuBR5zn6YGLga/zKun3/oP6JUmPU6g0
	od9KC0EVgpPkYpyc3qRJ2NHRYrdkOVhQ/RBR6V8Pr6A0MS8pYmErSkBlNgRO7noRWKJv/f5UrC4W2
	w/Py26Vw==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wmzn6-00AV4U-1Z;
	Thu, 23 Jul 2026 15:13:12 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH v2 0/5] ntsync miscellaneous patches
Date: Thu, 23 Jul 2026 15:12:56 -0500
Message-ID: <20260723201301.11826-1-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a resend of a series originally submitted as [1], combined with two
patches originally sent as [2].

This supersedes a previous set of patches sent as [3].

The following is the original cover letter sent with the series at [1].

[1] https://lore.kernel.org/all/20260628024239.152852-1-ivanrwcm25@gmail.com/
[2] https://lore.kernel.org/all/20260720175402.44338-1-ivanrwcm25@gmail.com/
[3] https://lore.kernel.org/all/20260720171740.447035-1-zfigura@codeweavers.com/

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

Iván Ezequiel Rodriguez (5):
  selftests: ntsync: fix wake_all CREATE_EVENT fd expectation
  selftests: ntsync: add wait argument validation tests
  ntsync: reject wait ioctls with zero owner
  docs: ntsync: align ioctl names and struct layouts with uapi
  selftests: ntsync: test absolute MONOTONIC waits under time namespaces

 Documentation/userspace-api/ntsync.rst        |  33 ++---
 drivers/misc/ntsync.c                         |   3 +
 .../testing/selftests/drivers/ntsync/ntsync.c | 133 +++++++++++++++++-
 3 files changed, 152 insertions(+), 17 deletions(-)


base-commit: 2cedf2272f1bb42471e646868ac572cc5752bd91
-- 
2.53.0

