From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 3/4] selftests: vm: Use the right arguments for main()
Date: Fri,  7 Aug 2015 15:44:14 +0200
Message-ID: <1438955055-587-3-git-send-email-thierry.reding@gmail.com>
References: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Eric B Munson <emunson@akamai.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The prototype for the main() function is:

	int main(int argc, char **argv);

but the mlock2-tests test program lists the arguments in the wrong
order. It gets away with this because the arguments are never used. Fix
it nevertheless to keep recent versions of GCC from complaining.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 tools/testing/selftests/vm/mlock2-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/selftests/vm/mlock2-tests.c
index 2949fd949973..af4bc752797d 100644
--- a/tools/testing/selftests/vm/mlock2-tests.c
+++ b/tools/testing/selftests/vm/mlock2-tests.c
@@ -643,7 +643,7 @@ static int test_mlockall(int (test_function)(bool call_mlock))
 	return ret;
 }
 
-int main(char **argv, int argc)
+int main(int argc, char **argv)
 {
 	int ret = 0;
 	ret += test_mlock_lock();
-- 
2.4.5
