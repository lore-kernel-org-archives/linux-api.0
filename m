From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/2] prctl.2: document SECCOMP_MODE_FILTER vs EFAULT
Date: Thu, 25 Sep 2014 15:47:47 -0700
Message-ID: <1411685267-27949-3-git-send-email-keescook@chromium.org>
References: <1411685267-27949-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411685267-27949-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

This notes the distinction made between EINVAL and EFAULT when attempting
to use SECCOMP_MODE_FILTER with PR_SET_SECCOMP.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 man2/prctl.2 | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/man2/prctl.2 b/man2/prctl.2
index 1199891..b7ddaac 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -825,6 +825,19 @@ is set appropriately.
 .I arg2
 is an invalid address.
 .TP
+.B EFAULT
+.I option
+is
+.BR PR_SET_SECCOMP ,
+.I arg2
+is
+.BR SECCOMP_MODE_FILTER ,
+the system was built with
+.BR CONFIG_SECCOMP_FILTER
+and
+.I arg3
+is an invalid address.
+.TP
 .B EINVAL
 The value of
 .I option
@@ -859,6 +872,16 @@ and the kernel was not configured with
 .B EINVAL
 .I option
 is
+.BR PR_SET_SECCOMP ,
+.I arg2
+is
+.BR SECCOMP_MODE_FILTER ,
+and the kernel was not configured with
+.BR CONFIG_SECCOMP_FILTER .
+.TP
+.B EINVAL
+.I option
+is
 .BR PR_SET_MM ,
 and one of the following is true
 .RS
-- 
1.9.1
