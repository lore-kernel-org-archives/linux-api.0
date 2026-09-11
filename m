Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2932E37B3E4
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139120; cv=none; b=YpVe4UF44pCuDJem22NjN+oUi489w8b5H1zY9lli8BIpu/6MeV9GplBe0gS5897oI+WctmumlHHDbK5q35X9HRNbg8pSLCGrrS1+8HezJsgbBeR7U2ZCo9helNIlJZx3sKrxY6V9NU9gpOoGlMqwUudYLPl1cXNKf37Fr6M3/5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139120; c=relaxed/simple;
	bh=DtJ9ZpMVzp9pBwNVieDXauBpJyGXCHWbrcsUIqWrCLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cgSPnqMnvaZow1eqXYlgjyBWmZNzgXoyDROE1V+AqVtkzwxBBq5zL5eh5aTIr2pYggJceMUcOHZcAvBUWV6hNpgQNinYCKe4CFOFtN3IJuMGcDsjrjoSg8ipbRBOlpKhJHZiECPbmd0B/ZFYPRiM6uEOX9ptMy0b7WnDhyTmOas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I+ZvYA1m; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I+ZvYA1m"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so11371405e9.1
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 08:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139115; x=1789743915; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nniMuKkVKCBrFfej6b+g/WdQXf4DCG9QFf6qRLzwPt4=;
        b=I+ZvYA1mbICTv0PbrqdQMGSq+gzptDaunsIRkczLkUVPh4RgeYjoWN4vx+l99uj4hc
         zcO7ZRyK98cOCz0YD10nH0BPzXr57Tz5RI0IcGB8yfMyUZ9Vhww1By2HzkboYWvjEs+k
         h5mYmWIInmYh27rNaIxNH4K+GM6nqC77p96zle/MtMjRZ4fGPi1zb5KcBkeExtUBpUuA
         5Rmx/Gcwa6MXoLk3EO5HI9Ut5BuemqDBe5S+Ix+Ahm4A0UySPIX4lovRO03XUBNAbt5n
         T1ZSHMnHfZRWoh5jbgeGxfcHFdOlPs5VkyPNR54wctreyKisukdw5jGWmJwMBvf6+RA+
         oWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139115; x=1789743915;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nniMuKkVKCBrFfej6b+g/WdQXf4DCG9QFf6qRLzwPt4=;
        b=kI2QRXv3C2KmIi0vkIWl808DtLBnaEK2Y03Y/hFPyEsTfjaYtKft0CTGj8w6rwJPM2
         3m0UYKhAIjM5oplKhqel58v6qwYw8G4x7oV7PivrIsMJit/25Q/6m9KRUMfhSyhRCVkW
         O1wENpR0/Gi0VvOp1Wz8d3IqSRi3q4IcbasqV6NzhNN3n36M/VTYJX+OoXjIKL131MAL
         Wpu7P1nAUllI+7xjeNkzbQB+j+rMw4VluHjHH/SiZG8kH+tqQp78ulQDpjlxuJhAjt3o
         nnaA0q6HnCgvCCM9i+qCul2XcOeQyf76hHGhtPTMd8KKuzePHML36z2M3qWn6PaIeQ4c
         6rEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxYx7yV/ijExUkHf8ZKWAyH6vjup8arWD6eWoKPbuJksUdgNpM8XrWmnas2oF/8u3Vtpoy+kZpCgAo=@vger.kernel.org
X-Gm-Message-State: AFuF++k1IU7GtfoQH+Hjym23PnnkiupBfEbDGPT8ITpwHZ8bcLAUc6bS
	tQBra3BWNE+1kdVhNmV47uzCLC5KhWsq1PE64FDVgLlsuwKRCMMfEvAISlPrEFhVag0=
X-Gm-Gg: AYBFou0lrN/ufpHUZRRIH+94ogKdSFBoSLtdhwHvvsOHZ/TU9b/bF7xkHW9kK8L8RkZ
	IaE/8vtzH2zh/g9AY75499AuxGMdF0I0n3iwEWOYm5cbra2Ut2qOILS27qsNZ18Coth3yOnHf3T
	8JeC5Emah0FkLogAmJQIXHG4buk0QwnwnYSsIWTOChP+wbdGDnHR4HXZxqCvL/rtjklCj5z8r8R
	M7zdGVux6SQzdqZMsomaWj2dF3pfRJN+jdO+nWvhZMYL3o0CDcR/IEnFZwEXBpk9sQdhxhATNmQ
	QfkzSQ/VNn1oHKdL2GgKGfgLCnG0chJ25CTzqHpSIL+Pq59DHbGSzTA3A88/eXFsKuwyZ2Zb3uV
	fC6jojgXLPNh/zofU84MRZzzKw3Py3s8vihhitD+9L/soCkAYu7tZAkq1f0xbUKXLAkhIbJ6Eo3
	nS/VK9lB7RWcFpGWYxW8m8FFdLNNbHAZjn959xdPn6E3CMyN879XSffEjprfaKCKtj41an+tDHD
	dY5brgCzr/7xvVC
X-Received: by 2002:a05:600d:6501:20b0:495:48d7:f178 with SMTP id 5b1f17b1804b1-49e61988e73mr40996545e9.11.1789139114793;
        Fri, 11 Sep 2026 08:05:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb350686sm6853579f8f.27.2026.09.11.08.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:05:14 -0700 (PDT)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: Simon Horman <horms@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Francois Dugast <francois.dugast@intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	linux-block@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-api@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] drm/xe: Include error-injection.h for ALLOW_ERROR_INJECTION()
Date: Fri, 11 Sep 2026 17:04:05 +0200
Message-ID: <20260911-module-include-error_injection-v1-5-5da895d8c84d@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
References: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Several drivers/gpu/drm/xe/*.c files use ALLOW_ERROR_INJECTION(), which is
defined in asm-generic/error-injection.h. They currently rely on this
header being included indirectly through linux/module.h ->
linux/error-injection.h.

Add the missing includes in preparation for removing the
linux/error-injection.h include from linux/module.h.

Remove also the linux/fault-injection.h include, which commit 91b2c42c214f
("drm/xe: Use fault injection infrastructure to find issues at probe time")
mistakenly used to provide the definition of ALLOW_ERROR_INJECTION().

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 drivers/gpu/drm/xe/xe_device.c                | 2 +-
 drivers/gpu/drm/xe/xe_exec_queue.c            | 1 +
 drivers/gpu/drm/xe/xe_ggtt.c                  | 2 +-
 drivers/gpu/drm/xe/xe_guc.c                   | 1 +
 drivers/gpu/drm/xe/xe_guc_ads.c               | 2 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                | 2 +-
 drivers/gpu/drm/xe/xe_guc_log.c               | 2 +-
 drivers/gpu/drm/xe/xe_guc_relay.c             | 2 +-
 drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c | 1 +
 drivers/gpu/drm/xe/xe_hw_engine_group.c       | 2 ++
 drivers/gpu/drm/xe/xe_mmio.c                  | 1 +
 drivers/gpu/drm/xe/xe_oa.c                    | 1 +
 drivers/gpu/drm/xe/xe_pm.c                    | 2 +-
 drivers/gpu/drm/xe/xe_pt.c                    | 2 ++
 drivers/gpu/drm/xe/xe_pxp.c                   | 2 ++
 drivers/gpu/drm/xe/xe_sriov.c                 | 2 +-
 drivers/gpu/drm/xe/xe_sync.c                  | 1 +
 drivers/gpu/drm/xe/xe_tile.c                  | 2 +-
 drivers/gpu/drm/xe/xe_tuning.c                | 2 ++
 drivers/gpu/drm/xe/xe_uc_fw.c                 | 2 +-
 drivers/gpu/drm/xe/xe_vm.c                    | 1 +
 drivers/gpu/drm/xe/xe_wa.c                    | 2 +-
 drivers/gpu/drm/xe/xe_wopcm.c                 | 2 +-
 23 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index ee732e5495f7..fcef8d5fc7ca 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -7,7 +7,7 @@
 
 #include <linux/aperture.h>
 #include <linux/delay.h>
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 #include <linux/units.h>
 
 #include <drm/drm_client.h>
diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index cd053de3c6b5..3e46c14584c4 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -5,6 +5,7 @@
 
 #include "xe_exec_queue.h"
 
+#include <linux/error-injection.h>
 #include <linux/nospec.h>
 
 #include <drm/drm_device.h>
diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index 8ec23862477f..e05582ad098a 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -6,7 +6,7 @@
 #include "xe_ggtt.h"
 
 #include <kunit/visibility.h>
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/sizes.h>
 
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 4286bd05c686..34e21a70d5ad 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -5,6 +5,7 @@
 
 #include "xe_guc.h"
 
+#include <linux/error-injection.h>
 #include <linux/iopoll.h>
 #include <drm/drm_managed.h>
 
diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index ff8eee3831aa..41a2b8c807d6 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -5,7 +5,7 @@
 
 #include "xe_guc_ads.h"
 
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <drm/drm_managed.h>
 
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index fe70c0fd85c5..ac6cbbaa6cc0 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -8,7 +8,7 @@
 #include <linux/bitfield.h>
 #include <linux/circ_buf.h>
 #include <linux/delay.h>
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <kunit/static_stub.h>
 
diff --git a/drivers/gpu/drm/xe/xe_guc_log.c b/drivers/gpu/drm/xe/xe_guc_log.c
index 538d4df0f7aa..6f0739204d9e 100644
--- a/drivers/gpu/drm/xe/xe_guc_log.c
+++ b/drivers/gpu/drm/xe/xe_guc_log.c
@@ -5,7 +5,7 @@
 
 #include "xe_guc_log.h"
 
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <linux/utsname.h>
 #include <drm/drm_managed.h>
diff --git a/drivers/gpu/drm/xe/xe_guc_relay.c b/drivers/gpu/drm/xe/xe_guc_relay.c
index eed0a750d2eb..e528d95ba7fe 100644
--- a/drivers/gpu/drm/xe/xe_guc_relay.c
+++ b/drivers/gpu/drm/xe/xe_guc_relay.c
@@ -5,7 +5,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/delay.h>
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <drm/drm_managed.h>
 
diff --git a/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c b/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
index d42e263e0611..ac81f382e7dc 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
@@ -4,6 +4,7 @@
  */
 
 #include <drm/drm_managed.h>
+#include <linux/error-injection.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
diff --git a/drivers/gpu/drm/xe/xe_hw_engine_group.c b/drivers/gpu/drm/xe/xe_hw_engine_group.c
index 0804b426b6f9..418ff427ae30 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine_group.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine_group.c
@@ -3,6 +3,8 @@
  * Copyright © 2024 Intel Corporation
  */
 
+#include <linux/error-injection.h>
+
 #include <drm/drm_managed.h>
 
 #include "xe_assert.h"
diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 7fa18dfcb5a2..d8f8a2453bb6 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -6,6 +6,7 @@
 #include "xe_mmio.h"
 
 #include <linux/delay.h>
+#include <linux/error-injection.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/minmax.h>
 #include <linux/pci.h>
diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index ab09dcff5860..b15c96e35fab 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -5,6 +5,7 @@
 
 #include <linux/anon_inodes.h>
 #include <linux/delay.h>
+#include <linux/error-injection.h>
 #include <linux/nospec.h>
 #include <linux/poll.h>
 
diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index a5289a9df8d2..c0489a8d8a62 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -5,7 +5,7 @@
 
 #include "xe_pm.h"
 
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
 #include <linux/dmi.h>
diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index a07316a45d79..6c6d9be2717e 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -5,6 +5,8 @@
 
 #include "xe_pt.h"
 
+#include <linux/error-injection.h>
+
 #include "regs/xe_gtt_defs.h"
 #include "xe_bo.h"
 #include "xe_device.h"
diff --git a/drivers/gpu/drm/xe/xe_pxp.c b/drivers/gpu/drm/xe/xe_pxp.c
index 2fef274a585e..2f3632ac201a 100644
--- a/drivers/gpu/drm/xe/xe_pxp.c
+++ b/drivers/gpu/drm/xe/xe_pxp.c
@@ -5,6 +5,8 @@
 
 #include "xe_pxp.h"
 
+#include <linux/error-injection.h>
+
 #include <drm/drm_managed.h>
 #include <uapi/drm/xe_drm.h>
 
diff --git a/drivers/gpu/drm/xe/xe_sriov.c b/drivers/gpu/drm/xe/xe_sriov.c
index f3835867fce5..ec254b950daf 100644
--- a/drivers/gpu/drm/xe/xe_sriov.c
+++ b/drivers/gpu/drm/xe/xe_sriov.c
@@ -3,7 +3,7 @@
  * Copyright © 2023 Intel Corporation
  */
 
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <drm/drm_managed.h>
 
diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
index 37866768d64c..711de22f4986 100644
--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -6,6 +6,7 @@
 #include "xe_sync.h"
 
 #include <linux/dma-fence-array.h>
+#include <linux/error-injection.h>
 #include <linux/kthread.h>
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
diff --git a/drivers/gpu/drm/xe/xe_tile.c b/drivers/gpu/drm/xe/xe_tile.c
index 74d925a337b7..810dfd98d830 100644
--- a/drivers/gpu/drm/xe/xe_tile.c
+++ b/drivers/gpu/drm/xe/xe_tile.c
@@ -3,7 +3,7 @@
  * Copyright © 2023 Intel Corporation
  */
 
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <drm/drm_managed.h>
 #include <drm/drm_pagemap_util.h>
diff --git a/drivers/gpu/drm/xe/xe_tuning.c b/drivers/gpu/drm/xe/xe_tuning.c
index bcec40ca2d35..d3d38b4380be 100644
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -5,6 +5,8 @@
 
 #include "xe_tuning.h"
 
+#include <linux/error-injection.h>
+
 #include <kunit/visibility.h>
 
 #include <drm/drm_managed.h>
diff --git a/drivers/gpu/drm/xe/xe_uc_fw.c b/drivers/gpu/drm/xe/xe_uc_fw.c
index a8e6f18cc9b4..f17925ad53f5 100644
--- a/drivers/gpu/drm/xe/xe_uc_fw.c
+++ b/drivers/gpu/drm/xe/xe_uc_fw.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/bitfield.h>
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 #include <linux/firmware.h>
 
 #include <drm/drm_managed.h>
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 23952ad8951e..f000564f1e59 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -6,6 +6,7 @@
 #include "xe_vm.h"
 
 #include <linux/dma-fence-array.h>
+#include <linux/error-injection.h>
 #include <linux/nospec.h>
 
 #include <drm/drm_drv.h>
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 139434946f8f..98d2fdd3ba6f 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -8,7 +8,7 @@
 #include <drm/drm_managed.h>
 #include <kunit/visibility.h>
 #include <linux/compiler_types.h>
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include <generated/xe_device_wa_oob.h>
 #include <generated/xe_wa_oob.h>
diff --git a/drivers/gpu/drm/xe/xe_wopcm.c b/drivers/gpu/drm/xe/xe_wopcm.c
index fe65ed246775..7da1e3ebc839 100644
--- a/drivers/gpu/drm/xe/xe_wopcm.c
+++ b/drivers/gpu/drm/xe/xe_wopcm.c
@@ -5,7 +5,7 @@
 
 #include "xe_wopcm.h"
 
-#include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 
 #include "regs/xe_guc_regs.h"
 #include "xe_device.h"

-- 
2.55.0
