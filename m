From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 131/134] selftests: vm: add fragment CONFIG_TEST_VMALLOC
Date: Wed, 11 Dec 2019 10:11:47 -0500
Message-ID: <20191211151150.19073-131-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anders Roxell <anders.roxell@linaro.org>, Shuah Khan <shuah@kernel.org>, "Uladzislau Rezki (Sony)" <urezki@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 746dd4012d215b53152f0001a48856e41ea31730 ]

When running test_vmalloc.sh smoke the following print out states that
the fragment is missing.

 # ./test_vmalloc.sh: You must have the following enabled in your kernel:
 # CONFIG_TEST_VMALLOC=m

Rework to add the fragment 'CONFIG_TEST_VMALLOC=m' to the config file.

Link: http://lkml.kernel.org/r/20190916095217.19665-1-anders.roxell@linaro.org
Fixes: a05ef00c9790 ("selftests/vm: add script helper for CONFIG_TEST_VMALLOC_MODULE")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vm/config b/tools/testing/selftests/vm/config
index 1c0d76cb5adfd..93b90a9b1eebf 100644
--- a/tools/testing/selftests/vm/config
+++ b/tools/testing/selftests/vm/config
@@ -1,2 +1,3 @@
 CONFIG_SYSVIPC=y
 CONFIG_USERFAULTFD=y
+CONFIG_TEST_VMALLOC=m
-- 
2.20.1
