From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] Enable two testcases in kselftest
Date: Sat, 14 Nov 2015 14:01:51 +0800
Message-ID: <1447480914-14834-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Capabilities and ipc exist in selftest but is not enabled in the top
level Makefile. I do not know whether it is intended to.

It seems that both of them are tiny tests. These patches try to enable
them and make them build successful in cross compiling environment.

Bamvor Jian Zhang (3):
  selftests/capabilities: align the usage of CFLAGS with others
  selftests/capabilities: actually test it
  selftest/ipc: actually test it

 tools/testing/selftests/Makefile              | 2 ++
 tools/testing/selftests/capabilities/Makefile | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.1.4
