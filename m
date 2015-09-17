From: Peter Senna Tschudin <peter.senna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] tools-powerpc: Return false instead of -1
Date: Thu, 17 Sep 2015 13:03:21 +0200
Message-ID: <1442487801-22661-1-git-send-email-peter.senna@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, sam.bobroff-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Senna Tschudin <peter.senna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Returning a negative value for a boolean function seem to have the
undesired effect of returning true. require_paranoia_below() is a
boolean function, but the variable used to store the return value is an
integer, receiving -1 or 0. This patch convert rc to bool, replace -1
by false, and 0 by true.

This issue was found by the following Coccinelle semantic patch:
<smpl>
@@
identifier f, ret;
constant C;
typedef bool;
@@
bool f (...){
<+...
ret = -C;
...
* return ret;
...+>
}
</smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
I could not compile this specific file, but I did some testing on toy examples:

t.c:
_Bool main(void)
{
        return -1;
}

$ powerpc64-linux-gnu-gcc -O2 -S -fomit-frame-pointer t.c

t.s:
...
.L.main:
        li 3,1
        blr

However if the function type is int instead of bool, it behaves as
expected:

t2.c:
int main(void)
{
        return -1;
}

$ powerpc64-linux-gnu-gcc -O2 -S -fomit-frame-pointer t2.c

t2.s:
...
.L.main:
        li 3,-1
        blr

So another solution would be to change the function type to int.

 tools/testing/selftests/powerpc/pmu/lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/lib.c b/tools/testing/selftests/powerpc/pmu/lib.c
index a07104c..2f17110 100644
--- a/tools/testing/selftests/powerpc/pmu/lib.c
+++ b/tools/testing/selftests/powerpc/pmu/lib.c
@@ -219,9 +219,9 @@ bool require_paranoia_below(int level)
 	unsigned long current;
 	char *end, buf[16];
 	FILE *f;
-	int rc;
+	bool rc;
 
-	rc = -1;
+	rc = false;
 
 	f = fopen(PARANOID_PATH, "r");
 	if (!f) {
@@ -244,7 +244,7 @@ bool require_paranoia_below(int level)
 	if (current >= level)
 		goto out;
 
-	rc = 0;
+	rc = true;
 out_close:
 	fclose(f);
 out:
-- 
2.1.0
