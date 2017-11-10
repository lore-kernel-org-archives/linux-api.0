From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 10/10] membarrier: selftest: Test shared expedited cmd
Date: Fri, 10 Nov 2017 16:37:17 -0500
Message-ID: <20171110213717.12457-11-mathieu.desnoyers@efficios.com>
References: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.co>
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
 .../testing/selftests/membarrier/membarrier_test.c | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
index a0eae8d51e72..c699227f4d9a 100644
--- a/tools/testing/selftests/membarrier/membarrier_test.c
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -189,6 +189,40 @@ static int test_membarrier_private_expedited_sync_core_success(void)
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
@@ -227,6 +261,19 @@ static int test_membarrier(void)
 		if (status)
 			return status;
 	}
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
 
-- 
2.11.0
