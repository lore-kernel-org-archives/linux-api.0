From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 2/3] selftests: efivars build fails when invoked from kselftest target
Date: Tue, 10 Mar 2015 16:00:58 -0600
Message-ID: <d536b3116b2aa8138808145daa30c83065a9660c.1426022048.git.shuahkh@osg.samsung.com>
References: <cover.1426022048.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1426022048.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1426022048.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1426022048.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

efivars Makefile doesn't have an explicit build rule. As a result,
efivars build fails, when it is run from top level Makefile target
kselftest. Without the explicit rule, make works only when it is
run in the current directory or from selftests directory. Add an
explicit build rule to fix the problem.

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 tools/testing/selftests/efivarfs/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 29e8c6b..bb48d73 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -4,6 +4,8 @@ CFLAGS = -Wall
 test_objs = open-unlink create-read
 
 all: $(test_objs)
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
 
 run_tests: all
 	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
-- 
2.1.0
