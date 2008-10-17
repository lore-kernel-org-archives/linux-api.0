From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Document kernel taint flags properly
Date: Fri, 17 Oct 2008 15:55:15 -0700
Message-ID: <20081017225515.GA14133@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>

This fills in the documentation for all of the current kernel taint
flags, and fixes the number for TAINT_CRAP, which was incorrectly
described.

Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>

---
 Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -363,11 +363,21 @@ tainted: 
 Non-zero if the kernel has been tainted.  Numeric values, which
 can be ORed together:
 
-  1 - A module with a non-GPL license has been loaded, this
-      includes modules with no license.
-      Set by modutils >= 2.4.9 and module-init-tools.
-  2 - A module was force loaded by insmod -f.
-      Set by modutils >= 2.4.9 and module-init-tools.
-  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
- 64 - A module from drivers/staging was loaded.
+   1 - A module with a non-GPL license has been loaded, this
+       includes modules with no license.
+       Set by modutils >= 2.4.9 and module-init-tools.
+   2 - A module was force loaded by insmod -f.
+       Set by modutils >= 2.4.9 and module-init-tools.
+   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
+   8 - A module was forcefully unloaded from the system by rmmod -f.
+  16 - A hardware machine check error occured on the system.
+  32 - A bad page was discovered on the system.
+  64 - The user has asked that the system be marked "tainted".  This
+       could be because they are running software that directly modifies
+       the hardware, or for other reasons.
+ 128 - The system has died.
+ 256 - The ACPI DSDT has been overridden with one supplied by the user
+        instead of using the one provided by the hardware.
+ 512 - A kernel warning has occurred.
+1024 - A module from drivers/staging was loaded.
 
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
