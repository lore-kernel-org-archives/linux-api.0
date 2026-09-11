Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C155E369D6A
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139111; cv=none; b=FeMgEWivXSh276tCgHZszLKu2f1mFSpbVLU4m/33rSdjwF2lyQeGqlnjGSZCjxFHs/GbBQS92LgKO0OMjsUq33JUyXqY3NHERtK7bsEhC+v7VxX7Fcg9yavrAlTskRXFmt0h9dirT+n45e39v70lkhpiW389Niklk7UitMlEPAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139111; c=relaxed/simple;
	bh=X2genqnDXLZF9jJMjeCeymPoDXvSYysWx04NPl080aE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XpzA6KcYXviAufMrYBC0z7QI/PimEnsQMVm+PsOBthLNo7ZdztTdWMeUpJ93E9GLJCyr730idbfmya6fVCDFn25J4t86tz8OzTDo3G6J3BFKt2J9QMqEm31RqwL5Eb72RHGB+/i3z8GEskcqAVROMdJWZ0Laa9FVPEB1YSJOIKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J0BN70gJ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J0BN70gJ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-485850cf499so831704f8f.3
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139108; x=1789743908; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mniijplyGZlkQZmDrYFnOPglJBLK+WFjfb4odBVk/dg=;
        b=J0BN70gJBpALZ5NAb8HVZ41mSP9/J/DQNVlrJkhBvSTR1N8A7x8ddzZfKZh0SJlz0n
         EG59W4FW4OfOLCLDJQ3QW5jOwWevhD5ne941ddcKG6gTU6L6czm4z9xKMrwviUmBV6sV
         d7PEVY/QYi1rssM3VbzKy77hEZqLlViCkV7RuVqrHHmNQTT3y4gJNjbhAd0KHPQmppbF
         GZZ789lfYYlhPD5y7WO/JpDdbqFUbaUF7u3mAlSDATgFCYd+Yjcd2il+A3SX7CfVEgYV
         klEHMqJ59eev7SBZVHUcfH4ZBOyC7J+bgmEqW+MQHONP1dRwGuUwzuRTdJe7ARTxrZt8
         B4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139108; x=1789743908;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mniijplyGZlkQZmDrYFnOPglJBLK+WFjfb4odBVk/dg=;
        b=BNkATX5F3bNoOKfPCsTcXvsguQsgyHG8Jo5tZz1SNNRmSxhWhH15ukb/9CXbGGRHQW
         X9p70PoVXyX6MlrtGnd3A1N+FGig/4ZBmkZz9Q1NqLGTLGtcFcfRkDIUcIWrvXkigs2L
         PZmL3uneY73Rs3QJ2bsheQz5Aefcdsbxym4Xdp7IsWubb7JxFSkXiXz6suYymMSYyPkX
         J59IDZVw46RD+iX+9LADRBT6tvgovaufrBZfF6P7tXyaSqAJO4yZI2YmotGymPWg7rnd
         AyguYRsS6HrdJmsbaYCohw+Rbn47h3LfUVauNryVmP+az3YtySIhh1nLmky5iiqe00Sd
         vHCA==
X-Forwarded-Encrypted: i=1; AKwUvBwXUfVJqKFFupdNy5iMuLKQnOV0/vA/VzwVAVlCfCiP+sHdsg23dbHERh+gP72mHp68CPvEdqCF4Bo=@vger.kernel.org
X-Gm-Message-State: AFuF++ka9cRkPL4mMTro9GxnuA/CdXHGunkd2gETtM4XoTk5H0cVaDHy
	6/rgbMvOlodGXbofOO69D5+iH302w46SjSSL9hiEOMJmRk3aZ/+vh422XGYD25LBxa0=
X-Gm-Gg: AYBFou3b0GZ2/SS+JufJsX38EN7DIy3jRO5YdcZlfbtDYVc/ctghMZZK9FP+Xt5ad80
	/5IAo1YP6H4uDcjaQIghn1iKfFR3uTM6vdKKwzFvBncy9J6wfCmvlBa9BiIbrunOr4gxErvTFkR
	G8KLsG8lhPjYmSibmKntLNxm0XzVpQq/U/9l9v5yFr6oHNv9zNlZa9ebCi7VR7JOOz2xpGqX4gZ
	ueI6kj8Xp84Scwao0zZR21xbW3VB0JFO2XxQOY/tCyvt1Gq0BTT3V6WHw64N+iov8Xue8tW1CD7
	8c15bYDyXHUEO4J+e5I3pkcbIIJVWboXP1tnTZjViQB3C4qOdZRomAtqF2MzCAyB4d3NYa/DhSj
	rmTVYF0i7j0aIxmW3HHPq8leotIcHspZEUJYAOW3CciPMM6CRFmEEehqCGfCItE+Bhztc+QBfol
	HlF7kCSA4HFINBaeRNsFJMUmu1D8FRa5zkkC8jgHO8Pal0YEXSOpNku7QgVGcxGd3MwtTBsCV8v
	G7XSTn+JGv5s03q
X-Received: by 2002:adf:ee86:0:b0:485:8c17:975f with SMTP id ffacd0b85a97d-486eb2ffac7mr4035568f8f.33.1789139107698;
        Fri, 11 Sep 2026 08:05:07 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb350686sm6853579f8f.27.2026.09.11.08.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:05:07 -0700 (PDT)
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
Subject: [PATCH 0/6] Remove the error-injection.h include from linux/module.h
Date: Fri, 11 Sep 2026 17:04:00 +0200
Message-ID: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260816-module-include-error_injection-4f80e37a8ea6
Content-Transfer-Encoding: 8bit

linux/module.h appears in roughly 15k #include directives across the
kernel. This makes it a "hot" header, so it should avoid pulling in
unnecessary definitions.

The header currently includes linux/error-injection.h to obtain the
definition of `struct error_injection_entry`. However, this is unnecessary
because the type is only referenced in the file as a pointer, for which an
incomplete type is sufficient.

Add explicit includes of linux/error-injection.h to files that use the
ALLOW_ERROR_INJECTION() macro and currently rely on it being provided
indirectly via linux/module.h. Then remove the linux/error-injection.h
include from linux/module.h.

The first five patches can go through their respective trees if preferred.
The final patch depends on the preceding cleanups.

---
Petr Pavlu (6):
      block: Include error-injection.h for ALLOW_ERROR_INJECTION()
      net: Include error-injection.h for ALLOW_ERROR_INJECTION()
      syscalls: Include error-injection.h for ALLOW_ERROR_INJECTION()
      drm/i915: Include error-injection.h for ALLOW_ERROR_INJECTION()
      drm/xe: Include error-injection.h for ALLOW_ERROR_INJECTION()
      module: Remove the error-injection.h include from linux/module.h

 block/blk-core.c                                    | 1 +
 drivers/gpu/drm/i915/display/intel_connector.c      | 1 +
 drivers/gpu/drm/i915/display/intel_display_driver.c | 1 +
 drivers/gpu/drm/i915/gt/intel_engine_cs.c           | 1 +
 drivers/gpu/drm/i915/gt/intel_gt.c                  | 2 ++
 drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c           | 1 +
 drivers/gpu/drm/i915/gt/uc/intel_uc.c               | 1 +
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c            | 1 +
 drivers/gpu/drm/i915/i915_driver.c                  | 1 +
 drivers/gpu/drm/i915/i915_pci.c                     | 2 ++
 drivers/gpu/drm/i915/intel_uncore.c                 | 1 +
 drivers/gpu/drm/xe/xe_device.c                      | 2 +-
 drivers/gpu/drm/xe/xe_exec_queue.c                  | 1 +
 drivers/gpu/drm/xe/xe_ggtt.c                        | 2 +-
 drivers/gpu/drm/xe/xe_guc.c                         | 1 +
 drivers/gpu/drm/xe/xe_guc_ads.c                     | 2 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                      | 2 +-
 drivers/gpu/drm/xe/xe_guc_log.c                     | 2 +-
 drivers/gpu/drm/xe/xe_guc_relay.c                   | 2 +-
 drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c       | 1 +
 drivers/gpu/drm/xe/xe_hw_engine_group.c             | 2 ++
 drivers/gpu/drm/xe/xe_mmio.c                        | 1 +
 drivers/gpu/drm/xe/xe_oa.c                          | 1 +
 drivers/gpu/drm/xe/xe_pm.c                          | 2 +-
 drivers/gpu/drm/xe/xe_pt.c                          | 2 ++
 drivers/gpu/drm/xe/xe_pxp.c                         | 2 ++
 drivers/gpu/drm/xe/xe_sriov.c                       | 2 +-
 drivers/gpu/drm/xe/xe_sync.c                        | 1 +
 drivers/gpu/drm/xe/xe_tile.c                        | 2 +-
 drivers/gpu/drm/xe/xe_tuning.c                      | 2 ++
 drivers/gpu/drm/xe/xe_uc_fw.c                       | 2 +-
 drivers/gpu/drm/xe/xe_vm.c                          | 1 +
 drivers/gpu/drm/xe/xe_wa.c                          | 2 +-
 drivers/gpu/drm/xe/xe_wopcm.c                       | 2 +-
 drivers/net/netdevsim/tc.c                          | 1 +
 include/linux/compat.h                              | 1 +
 include/linux/module.h                              | 1 -
 include/linux/syscalls.h                            | 1 +
 kernel/module/main.c                                | 1 +
 net/core/skb_fault_injection.c                      | 1 +
 40 files changed, 45 insertions(+), 13 deletions(-)
---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260816-module-include-error_injection-4f80e37a8ea6
