From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH V4 8/8] audit: initialize at subsystem time rather than device time
Date: Wed, 20 Aug 2014 21:09:41 -0400
Message-ID: <c429c7ae1ad83271ba2c7a8d41eaec4181b4199d.1408581430.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1408581429.git.rgb@redhat.com>
In-Reply-To: <cover.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, arozansk@redhat.com, eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

The audit subsystem should be initialized a bit earlier so that it is in place
in time for initial namespace serial number logging.
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 6d95d1c..aa99518 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1186,7 +1186,7 @@ static int __init audit_init(void)
 
 	return 0;
 }
-__initcall(audit_init);
+subsys_initcall(audit_init);
 
 /* Process kernel command-line parameter at boot time.  audit=0 or audit=1. */
 static int __init audit_enable(char *str)
-- 
1.7.1
