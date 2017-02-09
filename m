From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4/5] selftests/powerpc: Fix the clean rule since recent changes
Date: Thu,  9 Feb 2017 19:56:29 +1100
Message-ID: <1486630590-9410-4-git-send-email-mpe@ellerman.id.au>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: shuahkh@osg.samsung.com, bamvor.zhangjian@huawei.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The clean rule is broken for the powerpc tests:

  make[1]: Entering directory 'tools/testing/selftests/powerpc'
  Makefile:63: warning: overriding recipe for target 'clean'
  ../lib.mk:51: warning: ignoring old recipe for target 'clean'
  /bin/sh: 3: Syntax error: end of file unexpected (expecting "done")
  Makefile:63: recipe for target 'clean' failed

Fixes: a8ba798bc8ec ("selftests: enable O and KBUILD_OUTPUT")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/powerpc/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index 1d48c0cab596..1c5d0575802e 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -62,7 +62,8 @@ endef
 clean:
 	@for TARGET in $(SUB_DIRS); do \
 		BUILD_TARGET=$$OUTPUT/$$TARGET;	\
-		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\ done;
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean; \
+	done;
 	rm -f tags
 
 tags:
-- 
2.7.4
