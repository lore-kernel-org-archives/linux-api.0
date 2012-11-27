From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 1/4] proc.5: Document /proc/[pid]/uid_map and
	/proc/[pid]/gid_map
Date: Mon, 26 Nov 2012 18:46:00 -0600
Message-ID: <874nkbrhyv.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87a9u4rmz0.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
	"Mon, 26 Nov 2012 16:57:55 -0600")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Document the user namespace files that report the mapping of uids
and gids between user namespaces.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 man5/proc.5 |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/man5/proc.5 b/man5/proc.5
index fb70d2b..840480d 100644
--- a/man5/proc.5
+++ b/man5/proc.5
@@ -317,6 +317,31 @@ The files in this directory are readable only by the owner of the process.
 .\" .TP
 .\" .IR /proc/[pid]/io " (since kernel 2.6.20)"
 .TP
+.IR /proc/[pid]/gid_map " (since kernel 3.6)"
+This file reports the mapping of gids from the user namespace of the process specified by
+.IR pid
+to the user namespace of the process that opened
+.IR /proc/[pid]/gid_map .
+
+Each line specifies a 1 to 1 mapping of a range of contiguous gids from
+the user namespace of the process specified by
+.IR pid
+to the user namespace of the process that opened
+.IR /proc/[pid]/gid_map.
+
+Each line contains three numbers.  The start of the range of gids in
+the user namespace of the process specifed by
+.IR pid.
+The start of the range of gids in the user namespace of the process that
+opened
+.IR /proc/[pid]/gid_map.
+The number of gids in the range of numbers that is mapped between to two
+user namespaces.
+
+After the creation of a new user namespace this file may be written to
+exactly once to specify the mapping of gids in the new user namespace.
+
+.TP
 .IR /proc/[pid]/limits " (since kernel 2.6.24)"
 This file displays the soft limit, hard limit, and units of measurement
 for each of the process's resource limits (see
@@ -1169,6 +1194,31 @@ directory are not available if the main thread has already terminated
 (typically by calling
 .BR pthread_exit (3)).
 .TP
+.IR /proc/[pid]/uid_map " (since kernel 3.6)"
+This file reports the mapping of uids from the user namespace of the process specified by
+.IR pid
+to the user namespace of the process that opened
+.IR /proc/[pid]/uid_map .
+
+Each line specifies a 1 to 1 mapping of a range of contiguous uids from
+the user namespace of the process specified by
+.IR pid
+to the user namespace of the process that opened
+.IR /proc/[pid]/uid_map.
+
+Each line contains three numbers.  The start of the range of uids in
+the user namespace of the process specifed by
+.IR pid.
+The start of the range of uids in the user namespace of the process that
+opened
+.IR /proc/[pid]/uid_map.
+The number of uids in the range of numbers that is mapped between to two
+user namespaces.
+
+After the creation of a new user namespace this file may be written to
+exactly once to specify the mapping of uids in the new user namespace.
+
+.TP
 .I /proc/apm
 Advanced power management version and battery information when
 .B CONFIG_APM
-- 
1.7.5.4
