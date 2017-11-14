From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 19/24] membarrier: selftest: Test shared expedited cmd
Date: Tue, 14 Nov 2017 15:04:09 -0500
Message-ID: <20171114200414.2188-20-mathieu.desnoyers@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh>
List-Id: linux-api@vger.kernel.org

Test the new MEMBARRIER_CMD_SHARED_EXPEDITED and
MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED commands.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Shuah Khan <shuahkh@osg.samsung.com>
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
 .../testing/selftests/membarrier/membarrier_test.c | 51 +++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
index e6ee73d01fa1..bb9c58072c5c 100644
--- a/tools/testing/selftests/membarrier/membarrier_test.c
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -132,6 +132,40 @@ static int test_membarrier_private_expedited_success(void)
 	return 0;
 }
 
+static int test_membarrier_register_shared_expedited_success(void)
+{
+	int cmd = MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED";
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
+static int test_membarrier_shared_expedited_success(void)
+{
+	int cmd = MEMBARRIER_CMD_SHARED_EXPEDITED, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_SHARED_EXPEDITED";
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
@@ -154,6 +188,19 @@ static int test_membarrier(void)
 	status = test_membarrier_private_expedited_success();
 	if (status)
 		return status;
+	/*
+	 * It is valid to send a shared membarrier from a non-registered
+	 * process.
+	 */
+	status = test_membarrier_shared_expedited_success();
+	if (status)
+		return status;
+	status = test_membarrier_register_shared_expedited_success();
+	if (status)
+		return status;
+	status = test_membarrier_shared_expedited_success();
+	if (status)
+		return status;
 	return 0;
 }
 
@@ -173,8 +220,10 @@ static int test_membarrier_query(void)
 		}
 		ksft_exit_fail_msg("sys_membarrier() failed\n");
 	}
-	if (!(ret & MEMBARRIER_CMD_SHARED))
+	if (!(ret & MEMBARRIER_CMD_SHARED)) {
+		ksft_test_result_fail("sys_membarrier() CMD_SHARED query failed\n");
 		ksft_exit_fail_msg("sys_membarrier is not supported.\n");
+	}
 
 	ksft_test_result_pass("sys_membarrier available\n");
 	return 0;
-- 
2.11.0
