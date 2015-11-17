From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V2 0/3] Clean up and enable two testcases in kselftest
Date: Tue, 17 Nov 2015 22:35:40 +0800
Message-ID: <1447770943-10059-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These patches try to enable two testcases (capabilities and ipc) and
make them build successful in cross compiling environment.

Clean up the Makefile of capabilities according to the usage in
kselftest.

Changes since v1
1.  Update Makefile of capabilities according to Michael's suggestion.
    reference commit message for details.

Bamvor Jian Zhang (3):
  selftests/capabilities: clean up for Makefile
  selftests/capabilities: actually test it
  selftest/ipc: actually test it

 tools/testing/selftests/Makefile              |  2 ++
 tools/testing/selftests/capabilities/Makefile | 21 +++++++++------------
 2 files changed, 11 insertions(+), 12 deletions(-)

-- 
1.8.4.5
