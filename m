From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 24/24] task_diag: Enhance fork tool to spawn threads
Date: Mon,  6 Jul 2015 11:47:25 +0300
Message-ID: <1436172445-6979-25-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add option to fork threads as well as processes.
Make the sleep time configurable too so that spawned
tasks exit on their own.

Signed-off-by: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/task_diag/Makefile |  2 ++
 tools/testing/selftests/task_diag/fork.c   | 36 ++++++++++++++++++++++++++----
 tools/testing/selftests/task_diag/run.sh   |  4 ++--
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/task_diag/Makefile b/tools/testing/selftests/task_diag/Makefile
index 7104573..0c53cf6 100644
--- a/tools/testing/selftests/task_diag/Makefile
+++ b/tools/testing/selftests/task_diag/Makefile
@@ -12,6 +12,8 @@ task_diag_comm.o: task_diag_comm.c task_diag_comm.h
 task_diag_all: task_diag_all.o task_diag_comm.o
 task_diag: task_diag.o task_diag_comm.o
 fork: fork.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lpthread
+
 task_proc_all: task_proc_all.c
 
 clean:
diff --git a/tools/testing/selftests/task_diag/fork.c b/tools/testing/selftests/task_diag/fork.c
index c6e17d1..ebddedd2 100644
--- a/tools/testing/selftests/task_diag/fork.c
+++ b/tools/testing/selftests/task_diag/fork.c
@@ -2,15 +2,39 @@
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <pthread.h>
 
+void *f(void *arg)
+{
+	unsigned long t = (unsigned long) arg;
+
+	sleep(t);
+	return NULL;
+}
+
+/* usage: fork nproc [mthreads [sleep]] */
 int main(int argc, char **argv)
 {
-	int i, n;
+	int i, j, n, m = 0;
+	unsigned long t_sleep = 1000;
+	pthread_attr_t attr;
+	pthread_t id;
 
-	if (argc < 2)
+	if (argc < 2) {
+		fprintf(stderr, "usage: fork nproc [mthreads [sleep]]\n");
 		return 1;
+	}
 
 	n = atoi(argv[1]);
+
+	if (argc > 2)
+		m = atoi(argv[2]);
+
+	if (argc > 3)
+		t_sleep = atoi(argv[3]);
+
+	pthread_attr_init(&attr);
+
 	for (i = 0; i < n; i++) {
 		pid_t pid;
 
@@ -20,8 +44,12 @@ int main(int argc, char **argv)
 			return 1;
 		}
 		if (pid == 0) {
-			while (1)
-				sleep(1000);
+			if (m) {
+				for (j = 0; j < m-1; ++j)
+					pthread_create(&id, &attr, f, (void *)t_sleep);
+			}
+
+			sleep(t_sleep);
 			return 0;
 		}
 	}
diff --git a/tools/testing/selftests/task_diag/run.sh b/tools/testing/selftests/task_diag/run.sh
index 62250a5..06e182d 100755
--- a/tools/testing/selftests/task_diag/run.sh
+++ b/tools/testing/selftests/task_diag/run.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
-./fork 1000
+./fork 1000 10
 nproc=`./task_diag_all A | grep 'pid.*tgid.*ppid.*comm fork$' | wc -l`
 killall -9 fork
-[ "$nproc" -eq 1000 ] && exit 0
+[ "$nproc" -eq 10000 ] && exit 0
 echo "Unexpected number of tasks '$nproc'" 1>&2
-- 
2.1.0
