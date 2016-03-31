From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] leftpad.2: Document new syscall
Date: Fri,  1 Apr 2016 00:33:33 +0200
Message-ID: <1459463613-32473-3-git-send-email-richard@nod.at>
References: <1459463613-32473-1-git-send-email-richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459463613-32473-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Daniel Walter <dwalter@sigma-star.at>, Richard Weinberger <richard@nod.at>
List-Id: linux-api@vger.kernel.org

From: Daniel Walter <dwalter@sigma-star.at>

Signed-off-by: Daniel Walter <dwalter@sigma-star.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 man2/leftpad.2 | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 man2/leftpad.2

diff --git a/man2/leftpad.2 b/man2/leftpad.2
new file mode 100644
index 0000000..ff5f401
--- /dev/null
+++ b/man2/leftpad.2
@@ -0,0 +1,55 @@
+.\" Copyright (c) 2016 sigma-star gmbh
+.\" (office@sigma-star.at)
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.\"
+.TH LEFTPAD 2 2016-04-01 "Linux" "Linux Programmer's Manual"
+.SH NAME
+leftpad
+.SH SYNOPSIS
+.nf
+.B #include <sys/types.h>
+
+.BI "int leftpad(char *src, char pad, char *dst, size_t dst_len);
+.fi
+.SH DESCRIPTION
+This function provides left padding for strings.
+.LP
+The string in
+.I src
+will be left padded with the chosen padding character
+.I pad
+and stored in
+.I dst
+ .
+.SH RETURN VALUE
+On success, returns the number of padding characters added.
+.SH ERRORS
+.TP
+.B EINVAL
+The size of the destination buffer
+.I dst
+is shorter than the source string
+.I src
+ . Or the destination string is longer than 4096 bytes.
+.SH SEE ALSO
+.BR snprintf (3)
-- 
2.7.3
