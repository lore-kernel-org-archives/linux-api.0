From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 05/11] membarrier: selftest: Test global expedited cmd (v2)
Date: Wed, 17 Jan 2018 11:54:52 -0500
Message-ID: <20180117165458.13330-6-mathieu.desnoyers@efficios.com>
References: <20180117165458.13330-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20180117165458.13330-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Test the new MEMBARRIER_CMD_GLOBAL_EXPEDITED and
MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED commands.

Adapt to the MEMBARRIER_CMD_SHARED -> MEMBARRIER_CMD_GLOBAL rename.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Andrew Hunter <ahh@google.com>
CC: Maged Michael <maged.michael@gmail.com>
CC: Avi Kivity <avi@scylladb.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Dave Watson <davejwatson@fb.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Will Deacon <will.deacon@arm.com>
CC: Andy Lutomirski <luto@kernel.org>
CC: Alice Ferrazzi <alice.ferrazzi@gmail.com>
CC: Paul Elder <paul.elder@pitt.edu>
CC: linux-kselftest@vger.kernel.org
CC: linux-arch@vger.kernel.org
---
Changes since v1:
- Rename SHARED to GLOBAL.
---
 .../testing/selftests/membarrier/membarrier_test.c | 59 ++++++++++++++++++++--
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
index e6ee73d01fa1..eec39a0e1f77 100644
--- a/tools/testing/selftests/membarrier/membarrier_test.c
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -59,10 +59,10 @@ static int test_membarrier_flags_fail(void)
 	return 0;
 }
 
-static int test_membarrier_shared_success(void)
+static int test_membarrier_global_success(void)
 {
-	int cmd = MEMBARRIER_CMD_SHARED, flags = 0;
-	const char *test_name = "sys membarrier MEMBARRIER_CMD_SHARED";
+	int cmd = MEMBARRIER_CMD_GLOBAL, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_GLOBAL";
 
 	if (sys_membarrier(cmd, flags) != 0) {
 		ksft_exit_fail_msg(
@@ -132,6 +132,40 @@ static int test_membarrier_private_expedited_success(void)
 	return 0;
 }
 
+static int test_membarrier_register_global_expedited_success(void)
+{
+	int cmd = MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED";
+
+	if (sys_membarrier(cmd, flags) != 0) {
+		ksft_exit_fail_msg(
+			"%s test: flags = %d, errno = %d\n",
+			test_name, flags, errno);
+	}
+
+	ksft_test_result_pass(
+		"%s test: flags = %d\n",
+		test_name, flags);
+	return 0;
+}
+
+static int test_membarrier_global_expedited_success(void)
+{
+	int cmd = MEMBARRIER_CMD_GLOBAL_EXPEDITED, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_GLOBAL_EXPEDITED";
+
+	if (sys_membarrier(cmd, flags) != 0) {
+		ksft_exit_fail_msg(
+			"%s test: flags = %d, errno = %d\n",
+			test_name, flags, errno);
+	}
+
+	ksft_test_result_pass(
+		"%s test: flags = %d\n",
+		test_name, flags);
+	return 0;
+}
+
 static int test_membarrier(void)
 {
 	int status;
@@ -142,7 +176,7 @@ static int test_membarrier(void)
 	status = test_membarrier_flags_fail();
 	if (status)
 		return status;
-	status = test_membarrier_shared_success();
+	status = test_membarrier_global_success();
 	if (status)
 		return status;
 	status = test_membarrier_private_expedited_fail();
@@ -154,6 +188,19 @@ static int test_membarrier(void)
 	status = test_membarrier_private_expedited_success();
 	if (status)
 		return status;
+	/*
+	 * It is valid to send a global membarrier from a non-registered
+	 * process.
+	 */
+	status = test_membarrier_global_expedited_success();
+	if (status)
+		return status;
+	status = test_membarrier_register_global_expedited_success();
+	if (status)
+		return status;
+	status = test_membarrier_global_expedited_success();
+	if (status)
+		return status;
 	return 0;
 }
 
@@ -173,8 +220,10 @@ static int test_membarrier_query(void)
 		}
 		ksft_exit_fail_msg("sys_membarrier() failed\n");
 	}
-	if (!(ret & MEMBARRIER_CMD_SHARED))
+	if (!(ret & MEMBARRIER_CMD_GLOBAL)) {
+		ksft_test_result_fail("sys_membarrier() CMD_GLOBAL query failed\n");
 		ksft_exit_fail_msg("sys_membarrier is not supported.\n");
+	}
 
 	ksft_test_result_pass("sys_membarrier available\n");
 	return 0;
-- 
2.11.0
