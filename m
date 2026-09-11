Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF3937206B
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139114; cv=none; b=u+/4zH7MMbCo9NtkI0mzsZa6Q7wfXVM/6uFcReVn90ICArJuxkRV7ZC0VaiycKY3q3t+CKJUgjDdHZnwmFmAMxqDJ0hZPLKLaugHmuX2mF39y18Pw0GYtNn05dkMTtPbaJ8AfQ7RJ9/tz0kStCev3TkqxTU0WYY1eLeaoiweazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139114; c=relaxed/simple;
	bh=b5RQb0WbJ1RrTqB8nh+r8QKYRT6EMd81lemOzqrccCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfm1WXSAvlHGuVIj1AC+4s97l3mtBC6rvflYzI/5cuoD19l9KHnqp1MJepyi0nohVPTm2/zIwF9GwvrDG/SAllseshA0flweAo5gy58i6D/CCco7gIcSHVBA6OZTD4fu2vaNZVYWROHJpOVtYiqVRT1FUUX4pHUOla3T3XQ8PyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g2R/ghfw; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g2R/ghfw"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48441fa5c37so694472f8f.3
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 08:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139111; x=1789743911; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=glNc1H2atyKhB4WSC099onb1QIuZPymRMjgiGWekzpE=;
        b=g2R/ghfwA9c7FbD3rDBiA2JMYJ3JDnGvXzdJPZ2/N37pWyUiR5fe/jkoM+S8Xj9Osh
         Td7vi9tajpjbxZnzNHzkS8e+Dle9y/4gEVbukum/7r4YzBBxcJ9RitqsBzYcQQewkuuT
         62U8XWflFKwu+bc9ImtwgSwK1mGCbgzHFI7iDs6ufxupSQo7ROowYWmEEkzxfPmCgujL
         PWtxzIs3VJMWlw1d86Ly2VK+aU/U17WO7B0v3vjjrFWp/wxGHYe78Aj0iov3FPgmgvpA
         cC7KRxN8jXseYdw1Bh1MCEaK5pIOdGK/enujMajEKDEL2DSR+sgdJSlG1X3pYamUW02S
         GAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139111; x=1789743911;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glNc1H2atyKhB4WSC099onb1QIuZPymRMjgiGWekzpE=;
        b=TfFecY0bVN5yqzyxgRhXROn57oLsMdtNH7U+tjG8vIszijxva8KXqd/9BYekys14kt
         nsHDUwqG86z6b6O00VYaC0e5WvpbhuunpeLV1eTSaZc82EXApCkxB/bOH7bNMqEC6SrO
         nCWoGlRCfwNjHQyX1wi6Q88oVJLDFvlU8wpC1ByKWt9SIQ4GJWskDFWkFwiC6f4+MqTW
         DlanFV8XzYw9ave7I576867v/qwYtdEeWbi9FpK5UM5sK9sUpMJl0IcJLIW3ElQeXcgQ
         Rh+094/QiHIJhlH5gFG52I8UhsLuKBLOKMDNlBHBFoohmBHbeFoyyVL9Cab3h3HLmAso
         fpaw==
X-Forwarded-Encrypted: i=1; AKwUvBx1eauBJF4MzmLbVYZUge41TUgXP9XKhG41GxclvuoNQIOeeIszvsKGhA8HsjZGtHJEYCA3722cS14=@vger.kernel.org
X-Gm-Message-State: AFuF++kDbNRDYEFP3M1hMHfT4NiFnHEwblr5bqGmTdN6grbDKbl8UZQx
	1ExTHyBeglqosd0931nrpiT6/NC1m0WXvkvlWZrcqeGlrcTT4USVCXTnE2HNhdaClSA=
X-Gm-Gg: AYBFou3BitgN5M2ANkNqH81J7pkV36gbFuaMOEDVB0ArUlnB7f3UI5X49Vh8t7ZZk1N
	jenYXddzZdSjKTZDJBW9pRWTwuR1HxfjpRy0j3Qeexw8OYoy1lnxUqFPuKoGYDRfurHmmcQMTH9
	mWF8z0Ou3Nc4BL40fNCuncb5Fe/MNTuv9njo/kAZlWQE21vyksjZ9uo4NJI0JwrfVOg3mvYvGkB
	TjWUMKAsQLlR4AlgBrdt4YOkZp+fjONsF/RldBlprUpCPiqrlRiPNk9F/sGTnWGINImLFuERnZa
	HE/8lcEqOXev0udYPXlb3lqanXp+mo+NOgVi65IToX/2FFcvWIfGI7XgkIksYa6NHpvwPGlaY9j
	HVbvN0jW4rfK1SeOVT3WbVFpBgG8hpvP3nhTGJTxtJNYbWA7qC2gINjQBEgr2+h6VR4AThMz19E
	9+V4ltmM1eMjJxHzqDV+JYsAHARAeNGnLZgzVjB3E6GdGultdWwfunz464dKQtq/jNqfdkVnqKF
	MrmX6C7527YJKO7
X-Received: by 2002:a05:6000:1acf:b0:485:8a46:b3b8 with SMTP id ffacd0b85a97d-486eb32253bmr5503727f8f.32.1789139110499;
        Fri, 11 Sep 2026 08:05:10 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb350686sm6853579f8f.27.2026.09.11.08.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:05:10 -0700 (PDT)
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
Subject: [PATCH 2/6] net: Include error-injection.h for ALLOW_ERROR_INJECTION()
Date: Fri, 11 Sep 2026 17:04:02 +0200
Message-ID: <20260911-module-include-error_injection-v1-2-5da895d8c84d@suse.com>
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

drivers/net/netdevsim/tc.c and net/core/skb_fault_injection.c use
ALLOW_ERROR_INJECTION(), which is defined in asm-generic/error-injection.h.
They currently rely on this header being included indirectly through
linux/module.h -> linux/error-injection.h.

Add the missing include in preparation for removing the
linux/error-injection.h include from linux/module.h.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 drivers/net/netdevsim/tc.c     | 1 +
 net/core/skb_fault_injection.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/netdevsim/tc.c b/drivers/net/netdevsim/tc.c
index a415e02a6df1..e2d7d3aba193 100644
--- a/drivers/net/netdevsim/tc.c
+++ b/drivers/net/netdevsim/tc.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/error-injection.h>
 #include <linux/netdevice.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
diff --git a/net/core/skb_fault_injection.c b/net/core/skb_fault_injection.c
index 4235db6bdfad..2c7f519bef80 100644
--- a/net/core/skb_fault_injection.c
+++ b/net/core/skb_fault_injection.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/debugfs.h>
+#include <linux/error-injection.h>
 #include <linux/fault-inject.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>

-- 
2.55.0
