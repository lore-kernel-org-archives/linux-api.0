From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/11] UAPI: keys: Fix use of C++ keywords as structural
 members [ver #2]
Date: Thu, 06 Sep 2018 10:18:36 +0100
Message-ID: <153622551617.14298.12454094039718200093.stgit@warthog.procyon.org.uk>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

The keyctl_dh_params struct uses a C++ keyword as structural members.  Fix
this by inserting an anonymous union that provides an alternative name and
then hide the reserved name in C++.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
cc: keyrings@vger.kernel.org
---

 include/uapi/linux/keyctl.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 910cc4334b21..170f015d1f25 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -65,7 +65,12 @@
 
 /* keyctl structures */
 struct keyctl_dh_params {
-	__s32 dh_private;
+	union {
+#ifndef __cplusplus
+		__s32 private;
+#endif
+		__s32 dh_private;
+	};
 	__s32 prime;
 	__s32 base;
 };
