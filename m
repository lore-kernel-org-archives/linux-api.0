From: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC 1/4] rseq/param_test: Convert test_data_entry::count to intptr_t
Date: Wed, 27 Jul 2016 23:05:14 +0800
Message-ID: <20160727150517.26983-1-boqun.feng@gmail.com>
References: <20160727150352.GA32142@tardis.cn.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727150352.GA32142-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The current semantics of do_resq() is to do a intptr_t type store in
successful cases, however, in test_percpu_{inc,spinlock}, we use
test_data_entry::count as the location to store, whose type is int.

intptr_t and int have different size on LP64 systems, and despite the
inconsistency of types, having test_data_entry::count as int needs more
care on endian handling.

To make things simpler and more consistent, convert
test_data_entry::count to type intptr_t, which also makes the coming
tests for ppc64le and ppc64 share the same code.

Signed-off-by: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/rseq/param_test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
index f95fba5a1b2a..db25e0a818e5 100644
--- a/tools/testing/selftests/rseq/param_test.c
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -124,7 +124,7 @@ struct percpu_lock {
 };
 
 struct test_data_entry {
-	int count;
+	intptr_t count;
 } __attribute__((aligned(128)));
 
 struct spinlock_test_data {
@@ -234,7 +234,8 @@ void *test_percpu_spinlock_thread(void *arg)
 void test_percpu_spinlock(void)
 {
 	const int num_threads = opt_threads;
-	int i, sum, ret;
+	int i, ret;
+	intptr_t sum;
 	pthread_t test_threads[num_threads];
 	struct spinlock_test_data data;
 	struct spinlock_thread_test_data thread_data[num_threads];
@@ -308,7 +309,8 @@ void *test_percpu_inc_thread(void *arg)
 void test_percpu_inc(void)
 {
 	const int num_threads = opt_threads;
-	int i, sum, ret;
+	int i, ret;
+	intptr_t sum;
 	pthread_t test_threads[num_threads];
 	struct inc_test_data data;
 	struct inc_thread_test_data thread_data[num_threads];
-- 
2.9.0
