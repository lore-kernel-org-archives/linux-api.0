From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH V1 11/12] debug audit: add container id
Date: Thu,  1 Mar 2018 14:41:14 -0500
Message-ID: <1a9d4cdacd1dd3c51c4ba2a3f4888d0591c5b6f3.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
In-Reply-To: <cover.1519930146.git.rgb@redhat.com>
References: <cover.1519930146.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Switch from the 1000 range to the 1300 range for the prototype until it
can be worked out why the former aren't showing up in the logs.
---
 include/uapi/linux/audit.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 8443a8f..c392b3b 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -71,7 +71,8 @@
 #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
 #define AUDIT_SET_FEATURE	1018	/* Turn an audit feature on or off */
 #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
-#define AUDIT_CONTAINER		1020	/* Define the container id and information */
+//#define AUDIT_CONTAINER		1020	/* Define the container id and information */
+#define AUDIT_CONTAINER		1333	/* Define the container id and information */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
-- 
1.8.3.1
