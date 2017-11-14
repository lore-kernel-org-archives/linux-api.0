From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 23/24] membarrier: selftest: Test private expedited sync core cmd
Date: Tue, 14 Nov 2017 15:04:13 -0500
Message-ID: <20171114200414.2188-24-mathieu.desnoyers@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh>
List-Id: linux-api@vger.kernel.org

Test the new MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE and
MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE commands.

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
 .../testing/selftests/membarrier/membarrier_test.c | 73 ++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
index bb9c58072c5c..d9ab8b6ee52e 100644
--- a/tools/testing/selftests/membarrier/membarrier_test.c
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -132,6 +132,63 @@ static int test_membarrier_private_expedited_success(void)
 	return 0;
 }
 
+static int test_membarrier_private_expedited_sync_core_fail(void)
+{
+	int cmd = MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE not registered failure";
+
+	if (sys_membarrier(cmd, flags) != -1) {
+		ksft_exit_fail_msg(
+			"%s test: flags = %d. Should fail, but passed\n",
+			test_name, flags);
+	}
+	if (errno != EPERM) {
+		ksft_exit_fail_msg(
+			"%s test: flags = %d. Should return (%d: \"%s\"), but returned (%d: \"%s\").\n",
+			test_name, flags, EPERM, strerror(EPERM),
+			errno, strerror(errno));
+	}
+
+	ksft_test_result_pass(
+		"%s test: flags = %d, errno = %d\n",
+		test_name, flags, errno);
+	return 0;
+}
+
+static int test_membarrier_register_private_expedited_sync_core_success(void)
+{
+	int cmd = MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE";
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
+static int test_membarrier_private_expedited_sync_core_success(void)
+{
+	int cmd = MEMBARRIER_CMD_PRIVATE_EXPEDITED, flags = 0;
+	const char *test_name = "sys membarrier MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE";
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
 static int test_membarrier_register_shared_expedited_success(void)
 {
 	int cmd = MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED, flags = 0;
@@ -188,6 +245,22 @@ static int test_membarrier(void)
 	status = test_membarrier_private_expedited_success();
 	if (status)
 		return status;
+	status = sys_membarrier(MEMBARRIER_CMD_QUERY, 0);
+	if (status < 0) {
+		ksft_test_result_fail("sys_membarrier() failed\n");
+		return status;
+	}
+	if (status & MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE) {
+		status = test_membarrier_private_expedited_sync_core_fail();
+		if (status)
+			return status;
+		status = test_membarrier_register_private_expedited_sync_core_success();
+		if (status)
+			return status;
+		status = test_membarrier_private_expedited_sync_core_success();
+		if (status)
+			return status;
+	}
 	/*
 	 * It is valid to send a shared membarrier from a non-registered
 	 * process.
-- 
2.11.0
