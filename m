From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] [PATCH] namespaces.7: Document the
 /proc/[pid]/ns/pid_for_children file
Date: Thu, 18 May 2017 18:05:30 +0300
Message-ID: <149511988876.22402.2393921521433842598.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Corresponding kernel commit: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eaa0d190bfe1ed891b814a52712dcd852554cb08

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 man7/namespaces.7 |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/man7/namespaces.7 b/man7/namespaces.7
index 09f031347..67ea0ced0 100644
--- a/man7/namespaces.7
+++ b/man7/namespaces.7
@@ -125,6 +125,7 @@ lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 ipc \-> ipc:[4026531839]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 mnt \-> mnt:[4026531840]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 net \-> net:[4026531969]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 pid \-> pid:[4026531836]
+lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 pid_for_children \-> pid:[4026531834]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 user \-> user:[4026531837]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 uts \-> uts:[4026531838]
 .fi
@@ -186,7 +187,14 @@ This file is a handle for the network namespace of the process.
 .TP
 .IR /proc/[pid]/ns/pid " (since Linux 3.8)"
 .\" commit 57e8391d327609cbf12d843259c968b9e5c1838f
-This file is a handle for the PID namespace of the process.
+This file is a handle for the PID namespace of the process. It's
+permanent during the whole process life.
+.TP
+.IR /proc/[pid]/ns/pid_for_children " (since Linux 4.12)"
+.\" commit eaa0d190bfe1ed891b814a52712dcd852554cb08
+This file is a handle for the PID namespace of a next born child
+of the process. It's changed after unshare(2) and via setns(2),
+so the file may differ from /proc/[pid]/ns/pid.
 .TP
 .IR /proc/[pid]/ns/user " (since Linux 3.8)"
 .\" commit cde1975bc242f3e1072bde623ef378e547b73f91
