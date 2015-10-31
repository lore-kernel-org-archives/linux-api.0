From: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] livepatch: old_name@old_addr scheme in livepatch sysfs directory
Date: Fri, 30 Oct 2015 22:44:08 -0500
Message-ID: <1446263060-22175-1-git-send-email-chris.j.arges@canonical.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The following directory structure will allow for cases when the same
function name exists in a single object.
	/sys/kernel/livepatch/<patch>/<object>/<function@address>

An example of this issue is documented here:
	https://github.com/dynup/kpatch/issues/493

Signed-off-by: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-kernel-livepatch | 4 ++--
 kernel/livepatch/core.c                          | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 5bf42a8..afa0470 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -33,12 +33,12 @@ Description:
 		The object directory contains subdirectories for each function
 		that is patched within the object.
 
-What:		/sys/kernel/livepatch/<patch>/<object>/<function>
+What:		/sys/kernel/livepatch/<patch>/<object>/<function@address>
 Date:		Nov 2014
 KernelVersion:	3.19.0
 Contact:	live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:
-		The function directory contains attributes regarding the
+		The function@address directory contains attributes regarding the
 		properties and state of the patched function.
 
 		There are currently no such attributes.
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 6e53441..347cb3e 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -733,7 +733,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	func->state = KLP_DISABLED;
 
 	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
-				    &obj->kobj, "%s", func->old_name);
+				    &obj->kobj, "%s@%p", func->old_name,
+				    (void *)func->old_addr);
 }
 
 /* parts of the initialization that is done only when the object is loaded */
-- 
1.9.1
