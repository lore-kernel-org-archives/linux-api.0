From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 1/3] selftests/capabilities: align the usage of CFLAGS
 with others
Date: Mon, 16 Nov 2015 16:16:16 +1100
Message-ID: <1447650976.959.5.camel@ellerman.id.au>
References: <1447480914-14834-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <1447480914-14834-2-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447480914-14834-2-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 2015-11-14 at 14:01 +0800, Bamvor Jian Zhang wrote:

> User need to provide cap-ng.h and libcap-ng.so for cross compiling
> which could be done by pass extra cflags to EXTRA_CLAGS. But other
> testcases pass CFLAGS instead.
> 
> Change CLAGS ':=' to CLAGS '+=' to align with others. Delete useless
> EXTRA_CLAGS at the same time.

Actually I think you can clean this up even more. I don't see any reason it
can't use the implicit rule for compilation.

Also libraries should be in LDLIBS, not CFLAGS. And we can change the ordering
so that we don't need to define all multiple times.

Can you test this works for you?

cheers

diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testing/selftests/capabilities/Makefile
index 8c8f0c1f0889..5f690c1ae894 100644
--- a/tools/testing/selftests/capabilities/Makefile
+++ b/tools/testing/selftests/capabilities/Makefile
@@ -1,18 +1,14 @@
-all:
-
-include ../lib.mk
-
-.PHONY: all clean
-
 TARGETS := validate_cap test_execve
 TEST_PROGS := test_execve
 
-CFLAGS := -O2 -g -std=gnu99 -Wall -lcap-ng
+CFLAGS += -O2 -g -std=gnu99 -Wall
+LDLIBS += -lcap-ng -lrt -ldl
 
 all: $(TARGETS)
 
+include ../lib.mk
+
 clean:
 	$(RM) $(TARGETS)
 
-$(TARGETS): %: %.c
-	$(CC) -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
+.PHONY: all clean
