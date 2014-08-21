From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 5/8] namespaces: expose ns_entries
Date: Wed, 20 Aug 2014 21:09:38 -0400
Message-ID: <91b9d8da8145ec17b28283b1e3978edcbb0f9e09.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Expose ns_entries so subsystems other than proc can use this set of namespace
operations.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/proc/namespaces.c    |    2 +-
 include/linux/proc_ns.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index e953e0a..29c3909 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -15,7 +15,7 @@
 #include "internal.h"
 
 
-static const struct proc_ns_operations *ns_entries[] = {
+const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_NET_NS
 	&netns_operations,
 #endif
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index aaafe3e..f4563db 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -28,6 +28,7 @@ extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
+extern const struct proc_ns_operations *ns_entries[];
 
 /*
  * We always define these enumerators
-- 
1.7.1
