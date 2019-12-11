From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 038/134] selftests/powerpc: Skip tm-signal-sigreturn-nt if TM not available
Date: Wed, 11 Dec 2019 10:10:14 -0500
Message-ID: <20191211151150.19073-38-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 505127068d9b705a6cf335143239db91bfe7bbe2 ]

On systems where TM (Transactional Memory) is disabled the
tm-signal-sigreturn-nt test causes a SIGILL:

  test: tm_signal_sigreturn_nt
  tags: git_version:7c202575ef63
  !! child died by signal 4
  failure: tm_signal_sigreturn_nt

We should skip the test if TM is not available.

Fixes: 34642d70ac7e ("selftests/powerpc: Add checks for transactional sigreturn")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104233524.24348-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c b/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c
index 56fbf9f6bbf30..07c388147b75e 100644
--- a/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c
+++ b/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c
@@ -10,10 +10,12 @@
  */
 
 #define _GNU_SOURCE
+#include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
 
 #include "utils.h"
+#include "tm.h"
 
 void trap_signal_handler(int signo, siginfo_t *si, void *uc)
 {
@@ -29,6 +31,8 @@ int tm_signal_sigreturn_nt(void)
 {
 	struct sigaction trap_sa;
 
+	SKIP_IF(!have_htm());
+
 	trap_sa.sa_flags = SA_SIGINFO;
 	trap_sa.sa_sigaction = trap_signal_handler;
 
-- 
2.20.1
