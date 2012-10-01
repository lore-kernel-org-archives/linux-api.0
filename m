From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [patch] Remove proposed ABI change for setitimer(2)
Date: Mon, 01 Oct 2012 10:03:39 +0200
Message-ID: <50694E5B.3030602@gmail.com>
References: <CAHO5Pa2dnFH+SVkrJngR8Vn4VomsfJ00nOCzRB3+Ns4zs_pxnQ@mail.gmail.com> <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sasikantha Babu <sasikanth.v19@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Trevor Woerner <twoerner@gmail.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Commit aa2bf9bc6414b6972b9e51903c1ce7b1f057aee2 scheduled an ABI
change for setitimer() whose rationale is dubious. The standards
are largely silent on the point referred to in that commit's 
changelog. In addition, current behavior is causing no reported
hardship for user-space. So, there are no benefits to the change,
and making it risks breaking userspace applications that rely
on the (so far undocumented) Linux behavior. Finally, if one even 
contemplated making a change to the ABI on this point, the sensible 
change would be to make Linux behave as Solaris and the BSDs where:
setitimer(..., NULL, &ovalue) == getitimer(..., &ovalue)

The sensible thing is no change at all. This patch removes the 
scheduled change from feature-removal-schedule.txt.

Signed-off-by: Michael Kerrisk <mtk.man-pages@gmail.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f4d8c71..cdf4ded 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -528,14 +528,6 @@ Who:	Samuel Ortiz <sameo@linux.intel.com>
 
 ----------------------------
 
-What:	setitimer accepts user NULL pointer (value)
-When:	3.6
-Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
-	violates the spec.
-Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
-
-----------------------------
-
 What:	remove bogus DV presets V4L2_DV_1080I29_97, V4L2_DV_1080I30 and
 	V4L2_DV_1080I25
 When:	3.6
