From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghau40 v2 2/5] AUDIT_CONTAINER_INFO message type basic support
Date: Fri, 16 Mar 2018 05:12:26 -0400
Message-ID: <1521191549-19764-3-git-send-email-rgb@redhat.com>
References: <1521191549-19764-1-git-send-email-rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <1521191549-19764-1-git-send-email-rgb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, Richard Guy Briggs <rgb@redhat.com>, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

This defines the message number for the container ID info record should
the kernel headers not be up to date and gives the record number a name for
printing.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 lib/libaudit.h    | 4 ++++
 lib/msg_typetab.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/lib/libaudit.h b/lib/libaudit.h
index 6d431b9..756a3b8 100644
--- a/lib/libaudit.h
+++ b/lib/libaudit.h
@@ -282,6 +282,10 @@ extern "C" {
 #define AUDIT_FANOTIFY		1331 /* Fanotify access decision */
 #endif
 
+#ifndef AUDIT_CONTAINER_INFO
+#define AUDIT_CONTAINER_INFO    1332 /* Container ID details */
+#endif
+
 #ifndef AUDIT_ANOM_LINK
 #define AUDIT_ANOM_LINK		1702 /* Suspicious use of file links */
 #endif
diff --git a/lib/msg_typetab.h b/lib/msg_typetab.h
index e2fd536..5c4892a 100644
--- a/lib/msg_typetab.h
+++ b/lib/msg_typetab.h
@@ -124,6 +124,7 @@ _S(AUDIT_PROCTITLE,                  "PROCTITLE"                     )
 _S(AUDIT_FEATURE_CHANGE,             "FEATURE_CHANGE"                )
 _S(AUDIT_KERN_MODULE,                "KERN_MODULE"                   )
 _S(AUDIT_FANOTIFY,                   "FANOTIFY"                      )
+_S(AUDIT_CONTAINER_INFO,             "CONTAINER_INFO"                )
 _S(AUDIT_AVC,                        "AVC"                           )
 _S(AUDIT_SELINUX_ERR,                "SELINUX_ERR"                   )
 _S(AUDIT_AVC_PATH,                   "AVC_PATH"                      )
-- 
1.8.3.1
