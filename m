Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1924337CD32
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139122; cv=none; b=uW+O4NTsxHAn4PuvfOt4tKwoA/3xrpLK9gYTM2nXST0DTf+frSTda8hvHzrZOIVeCoQEaa6G7CX5wv0/LUVQofbQBkJ/FZNRSTczP3AidfVEnI8EWABui8/JKCLFEQnuaSlAvuBZrY/Vu80zkyaC+AQjPjlBvASkGjej4BZ7I9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139122; c=relaxed/simple;
	bh=JL+uluzocOxsNsOaPXlEzBUTr48C+sSlS5wULgBtFtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1Cv5hyAzu6U6pDymnwNyLtuD4gZjQFQL2ebSTVjYR+MBOPVNi0vhtl+iOzS6DLwXYJcFSF+DfboWvEGmA/XTBL/1EUKuhH6DiZhoQRHMTpmyKvG0U5Jnh5md988ZX8CG/W2wVrXnfOXtlaX0/ysEQ5QSXR01Cv/wO8KAtL8h/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DPoBfuQE; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DPoBfuQE"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48436216a98so664960f8f.0
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 08:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139116; x=1789743916; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a258DNEK6aR0v+xDimWu2caaAUdwCvMljBObmnBjN5k=;
        b=DPoBfuQEnSW5Lg5efeT4TbUM3prqvIUhPd4e5hEY0qDOO+rDm2xucBa0yhmFynP+N3
         WR6a2Gc2Gg4xPJ+/pv/3qqwEuHoTM9zVDN1DceSyYg43HeUzI6htFkmmQett3GeRPX+S
         xEQ+K4u9guKtuLvcCJLF7kLfaqhMbAviVHOQ5JWBbVd5vePW+cWI1A/DKoY3mCEzMOkk
         Y+Hv+yx7UvK8P1P114QbrqXOITDqKZJ8W42XE0Nr58ksWIM7Wqi38tAFD1RGDUieECyv
         64JK9yPfgwbchvz/IWFnDoeyM4gFoUNujTtTHeHvmhhHodv9ecWYuEs/+7UKTO4ibSdO
         p3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139116; x=1789743916;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a258DNEK6aR0v+xDimWu2caaAUdwCvMljBObmnBjN5k=;
        b=VMjoaJHwcX1J5j4zL9H7zuOc36bILR0gfSnq+J4s7ATylhynsdw8SNViH0BVCFWCVL
         Fb3+Gwy6BCxeh9bEJok5VBU7VsHXv5/CQu56itDXJkmHBW2R3jlldCSbBIZNtGMyPGuf
         QS5uPgtpgTJUAPfmaHseO2IP9kVHHxaUA14gIzuy5KPfty79owBaTvKevPguHQlUG+LE
         LrOQ2VlCtEwoIJVBmHG47Cf3mXemF+/yYXBLoXPjDBYuynSHMOu6AD7SxM3Z6VjQ+eCB
         DtKwls5GYg2yCWk1bRCclg7llUZtOUpjXkA3RerVVE8xRrswnsI5fQqOeyLL2j/XvqIR
         d+Pg==
X-Forwarded-Encrypted: i=1; AKwUvBzweJ/QKpu81vUGXiYcrHG0mUENsga8Rp5+JS0fNKHC/J2XG/gEPi4hCUXh9PKaP73MuNoHVUEIZK4=@vger.kernel.org
X-Gm-Message-State: AFuF++kKw4i+tVGI5dD5IWkOCzU6eEc6YxSVlhXOkOeW1w0BPPw7hk0l
	2XG6tNunDRXoMYl+n4WqKd7Q82W2kX7ZtbRTk4ucBlS41asccQIcJlZhkjZb3amC+oQ=
X-Gm-Gg: AYBFou1oFDAEDxMe+M9Peut3FSWKIg0mhvM7IDXNa02BAFwtG93/4EAWKys+6QZkQQS
	rtxTU9WHw7CS9Q2ze/7ec4TjKHnW6cWf5ykcdHjM0IZlRca9ExqQPeCpo/um+DHrdDIxyIv8xzE
	/xIHgYUWX4A8k8bRFpYzIRZxY2DJVwNOV0gYgi1wdne1XVWjEWFRDfXQYGkFhf5zuIDZSi9rj62
	369SHWDzgnrqxLVD2kfJo2W2vTvtOtvOPvSqJyF0QUVkwpdsMn6DbSVgFn0MnY1icq5jWsALhg9
	DYwtV7dBAR6WHyDod9ooSq0Ec95Fy7gaPvkLF/dsSHRLe7QjCTEjBB+6ssezqH0skamB97lOru6
	szBK+FP8TNYfI1O+q7jJeL4cnRJu48FcqkskKZUnO2CJJDcLjCmiOoatx6kE9bk/WFjZXBPqkl0
	Ut75akJFnIL0t7v5bEtOR1HgEvSrRZf6VOb/YIkKlxQJbuRBLcEpGBpr2mJIajwm+R67XG72R68
	j1mctQ=
X-Received: by 2002:a05:6000:491e:b0:486:f4b6:3bce with SMTP id ffacd0b85a97d-486f4b63c4fmr559176f8f.24.1789139115924;
        Fri, 11 Sep 2026 08:05:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb350686sm6853579f8f.27.2026.09.11.08.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:05:15 -0700 (PDT)
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
Subject: [PATCH 6/6] module: Remove the error-injection.h include from linux/module.h
Date: Fri, 11 Sep 2026 17:04:06 +0200
Message-ID: <20260911-module-include-error_injection-v1-6-5da895d8c84d@suse.com>
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

linux/module.h appears in roughly 15k #include directives across the
kernel. This makes it a "hot" header, so it should avoid pulling in
unnecessary definitions.

The header currently includes linux/error-injection.h to obtain the
definition of `struct error_injection_entry`. However, this is unnecessary
because the type is only referenced in the file as a pointer, for which an
incomplete type is sufficient.

Remove the linux/error-injection.h include from linux/module.h and add it
to kernel/module/main.c instead, where
`sizeof(struct error_injection_entry)` is actually needed.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 include/linux/module.h | 1 -
 kernel/module/main.c   | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 96cc98568eea..b3a3d5827384 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -24,7 +24,6 @@
 #include <linux/jump_label.h>
 #include <linux/export.h>
 #include <linux/rbtree_latch.h>
-#include <linux/error-injection.h>
 #include <linux/tracepoint-defs.h>
 #include <linux/srcu.h>
 #include <linux/static_call_types.h>
diff --git a/kernel/module/main.c b/kernel/module/main.c
index d0e1e0bd2ad0..f1392c10907a 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -60,6 +60,7 @@
 #include <linux/codetag.h>
 #include <linux/debugfs.h>
 #include <linux/execmem.h>
+#include <linux/error-injection.h>
 #include <uapi/linux/module.h>
 #include "internal.h"
 

-- 
2.55.0
