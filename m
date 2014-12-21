From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH] selftests/exec: Use %zu to format size_t
Date: Sun, 21 Dec 2014 11:58:16 +0100
Message-ID: <1419159496-11558-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 32-bit:

execveat.c: In function 'check_execveat_pathmax':
execveat.c:183: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
execveat.c:187: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
 tools/testing/selftests/exec/execveat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
index 33a5c06d95caa038..d273624c93a64254 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -179,11 +179,11 @@ static int check_execveat_pathmax(int dot_dfd, const char *src, int is_script)
 	 */
 	fd = open(longpath, O_RDONLY);
 	if (fd > 0) {
-		printf("Invoke copy of '%s' via filename of length %lu:\n",
+		printf("Invoke copy of '%s' via filename of length %zu:\n",
 			src, strlen(longpath));
 		fail += check_execveat(fd, "", AT_EMPTY_PATH);
 	} else {
-		printf("Failed to open length %lu filename, errno=%d (%s)\n",
+		printf("Failed to open length %zu filename, errno=%d (%s)\n",
 			strlen(longpath), errno, strerror(errno));
 		fail++;
 	}
-- 
1.9.1
