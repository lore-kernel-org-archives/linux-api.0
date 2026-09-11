Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB93369D6F
	for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139115; cv=none; b=evYX9FLKO6kEKYgMQjp7FMJ0c320aC90OHOzsyRylhYZXn2S2oFOx4LzU1L9qfmDz4Ik1AzSmV8DLt54O63A9+fqzHMMp3qhntBN55uMNdNk0SSscnJ/RhC+iYkN4HGHIomDuqqZxFjVuMOTlIyrkogZ/kAWbaidljpJpV10UDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139115; c=relaxed/simple;
	bh=SulItpOpA28ukZfWYCS1+ezWXd+i3c1ust4snZvaoAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6ypg2AXdu0zzqtjzOPMXnLWokBUwouEsaxiTuRMT/KlKEnf6frCu7gb/4WeZM/NOn/Il+R1ZJX2beWLeTWSMGne2BWkRVMqA75f7bs0A2Va+AA6l1i3qrxxLeKfTE7o1GVBqFbzrZ2jbqRepuhNs5wtU7bbYXXUADvqduKId6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dpY9Vw/W; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dpY9Vw/W"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so7989105e9.2
        for <linux-api@vger.kernel.org>; Fri, 11 Sep 2026 08:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139112; x=1789743912; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7/A+IkvGH5yYLsl3B/FA+2ENzgeK330huKjO7uo/XWA=;
        b=dpY9Vw/WbRSQ4vAmcbMbVsDNf97x3fiJTZq1V3vuarPpkrVkQMkq7Qw9A3NT1MpM+z
         L3pCZuHMbsVeZ07kHa79dndIHXwQOCQHY9dcRkLL7qpE1CdxelO59oqkVSOBO5Qd5eNk
         wxQy4TkrGLSeXDH8DQQ/XCg7NpAnbvI1BRBPTHihUJqcg8DnhFFThHW3iT/mcEpbP3DS
         IKx8LonNMoHEscVCzKZsJDlxQZ6poGnEY9yZY1WhsCLpJUNdV7vT30jmqvxP9HVX78cf
         ZLbcHsOOADCJZ+kzBfHM+AGn/66uFYWxppyh3qA1RSoPnSs7px5U0GxR+sv5+QCbGRzL
         aA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139112; x=1789743912;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7/A+IkvGH5yYLsl3B/FA+2ENzgeK330huKjO7uo/XWA=;
        b=j6Why8SczkxDZnXSI4kCJ2jum7JBQ1HSiqt0qNHkiZHB30NQ4DEVjB71JVkhSbC6mp
         w3DY+J9c+fRpl4fE++frK/T0VOgnDuxJ6+nt6/o6bzWr1rpWZn/nj0GUKyuQcz7Ql2yq
         8zcm4ftIQ4LfZ4FX2iHVCjdfmvB29SZFIRfcLjlHLj0KzZGORuJ2U7qLpw0fns54RylQ
         qL/dibrZkpz4/g3ppparJfFfljKHU3IPf8P2iTg1NIKxoS3K4BqKvTLQ9F2mZywIeR7P
         xvFRVYyXY6EAwcr5e4eKe3MRVm/f5No5wISZnNTTXXW+iAQCDL1ROPk6ZlJqLhTfdHgA
         Y1pA==
X-Forwarded-Encrypted: i=1; AKwUvBxRTbt7cX/jPcflgUA2mS+uq6K18wBqY7eVw2+5XYvErGWer5JIRPp1nEZ5xBsi8cWn/m+oh30Mxlw=@vger.kernel.org
X-Gm-Message-State: AFuF++mHAhn5q1bFTcoGVUV4FYaM1fvbi8uv8Xp4yYAT/t51amvuu5RH
	hZ4rljaydT0nM/Ifn1Q4B7aARQ6vpGY3JF+5pxJjtGHr4c9/JnLx6sFM45aMr2pxqFs=
X-Gm-Gg: AYBFou2gfTsWOcmIL+DjGzxMfsb1vmRNx7p2LQT6hK+683bK0THpbs8dLGyESxqu4MU
	XFlm8/r2Gvm62e+PyLnsOPGrB9h8KqtbD2O4qIkIni1V2gNC3sxVqNeEFTnZRZzx+DRPM4KCpHY
	F6zF84yFMeF+XMrBeEq1wH7fmZYJJXpAd9oXEEdKqp8XiRbIi+UNK/J1ocKrA8A87MhYFtJhfj6
	p3rWBwZS2AWg/jRWnP23OZXF4RL1854jkVx16eSvsOWfuJuI3RMrEjYVRGu4y2EWolB7gY2RdBv
	wBmXTOtSLNdtv64Qu0dE6cWZ9Sab53z65/SMNpN1L3yEsrt1melNeaBwZp7ayOZqUytHGghYxaA
	0lQg5bZ3WS5mTCBZw1IH9oUeYwI7tRoy3tAxY85Wmi+92IhhMiyVCzlaVdBXZi5cee8H5MRPFQz
	Y7qPOHVUWQd2H4V43lACpFD+3TPdYlYDrWVeHQ/lM6SAToHlvudJvS6rdebAhYwHM=
X-Received: by 2002:a05:600d:8498:20b0:49c:fc6c:be15 with SMTP id 5b1f17b1804b1-49e619c6eecmr39713085e9.27.1789139111976;
        Fri, 11 Sep 2026 08:05:11 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb350686sm6853579f8f.27.2026.09.11.08.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:05:11 -0700 (PDT)
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
Subject: [PATCH 3/6] syscalls: Include error-injection.h for ALLOW_ERROR_INJECTION()
Date: Fri, 11 Sep 2026 17:04:03 +0200
Message-ID: <20260911-module-include-error_injection-v1-3-5da895d8c84d@suse.com>
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

include/linux/compat.h and include/linux/syscalls.h use
ALLOW_ERROR_INJECTION(), which is defined in asm-generic/error-injection.h.
They currently rely on that header being included indirectly through other
files, typically via linux/module.h -> linux/error-injection.h.

Add the missing include in preparation for removing the
linux/error-injection.h include from linux/module.h.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 include/linux/compat.h   | 1 +
 include/linux/syscalls.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 8da0a15c95f4..ad37ca617e65 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -18,6 +18,7 @@
 #include <linux/aio_abi.h>	/* for aio_context_t */
 #include <linux/uaccess.h>
 #include <linux/unistd.h>
+#include <linux/error-injection.h>
 
 #include <asm/compat.h>
 #include <asm/siginfo.h>
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8413b624ad47..552d9710a0d5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -92,6 +92,7 @@ struct file_attr;
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <linux/personality.h>
+#include <linux/error-injection.h>
 #include <trace/syscall.h>
 
 #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER

-- 
2.55.0
