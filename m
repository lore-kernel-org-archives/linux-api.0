From: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs directory
Date: Mon,  2 Nov 2015 16:59:41 -0600
Message-ID: <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
References: <20151102203241.GF27488@treble.redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102203241.GF27488-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The following directory structure will allow for cases when the same
function name exists in a single object.
	/sys/kernel/livepatch/<patch>/<object>/<function.number>

The number corresponds to the nth occurrence of the symbol name in
kallsyms for the patched object.

An example of this issue is documented here:
	https://github.com/dynup/kpatch/issues/493

Signed-off-by: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-kernel-livepatch |  2 +-
 kernel/livepatch/core.c                          | 45 ++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 5bf42a8..dcd36db 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -33,7 +33,7 @@ Description:
 		The object directory contains subdirectories for each function
 		that is patched within the object.
 
-What:		/sys/kernel/livepatch/<patch>/<object>/<function>
+What:		/sys/kernel/livepatch/<patch>/<object>/<function.number>
 Date:		Nov 2014
 KernelVersion:	3.19.0
 Contact:	live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 6e53441..6bcf600 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -587,7 +587,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
  * /sys/kernel/livepatch/<patch>
  * /sys/kernel/livepatch/<patch>/enabled
  * /sys/kernel/livepatch/<patch>/<object>
- * /sys/kernel/livepatch/<patch>/<object>/<func>
+ * /sys/kernel/livepatch/<patch>/<object>/<func.number>
  */
 
 static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -727,13 +727,54 @@ static void klp_free_patch(struct klp_patch *patch)
 	kobject_put(&patch->kobj);
 }
 
+static int klp_get_func_pos_callback(void *data, const char *name,
+				      struct module *mod, unsigned long addr)
+{
+	struct klp_find_arg *args = data;
+
+	if ((mod && !args->objname) || (!mod && args->objname))
+		return 0;
+
+	if (strcmp(args->name, name))
+		return 0;
+
+	if (args->objname && strcmp(args->objname, mod->name))
+		return 0;
+
+	/* on address match, return 1 to break kallsyms_on_each_symbol loop */
+	if (args->addr == addr)
+		return 1;
+
+	/* if we don't match addr, count instance of named symbol */
+	args->count++;
+
+	return 0;
+}
+
+static int klp_get_func_pos(struct klp_object *obj, struct klp_func *func)
+{
+	struct klp_find_arg args = {
+		.objname = obj->name,
+		.name = func->old_name,
+		.addr = func->old_addr,
+		.count = 0,
+	};
+
+	mutex_lock(&module_mutex);
+	kallsyms_on_each_symbol(klp_get_func_pos_callback, &args);
+	mutex_unlock(&module_mutex);
+
+	return args.count;
+}
+
 static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 {
 	INIT_LIST_HEAD(&func->stack_node);
 	func->state = KLP_DISABLED;
 
 	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
-				    &obj->kobj, "%s", func->old_name);
+				    &obj->kobj, "%s,%d", func->old_name,
+				    klp_get_func_pos(obj, func));
 }
 
 /* parts of the initialization that is done only when the object is loaded */
-- 
1.9.1
