From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/11] membarrier: selftest: Test global expedited cmd (v2)
Date: Tue, 23 Jan 2018 10:57:27 -0500
Message-ID: <20180123155733.3404-6-mathieu.desnoyers@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Test the new MEMBARRIER_CMD_GLOBAL_EXPEDITED and
MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED commands.

Adapt to the MEMBARRIER_CMD_SHARED -> MEMBARRIER_CMD_GLOBAL rename.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
CC: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
CC: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
CC: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Alice Ferrazzi <alice.ferrazzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Paul Elder <paul.elder-fYq5UfK3d1k@public.gmane.org>
CC: linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
