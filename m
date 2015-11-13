From: Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 3/3 v6] livepatch: function,sympos scheme in livepatch sysfs directory
Date: Fri, 13 Nov 2015 10:23:22 -0600
Message-ID: <1447431804-18786-4-git-send-email-chris.j.arges@canonical.com>
References: <1447347595-30728-1-git-send-email-chris.j.arges@canonical.com>
 <1447431804-18786-1-git-send-email-chris.j.arges@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447431804-18786-1-git-send-email-chris.j.arges@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: live-patching@vger.kernel.org
Cc: jeyu@redhat.com, Chris J Arges <chris.j.arges@canonical.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The following directory structure will allow for cases when the same
function name exists in a single object.
	/sys/kernel/livepatch/<patch>/<object>/<function,sympos>

The sympos number corresponds to the nth occurrence of the symbol name in
kallsyms for the patched object.

An example of patching multiple symbols can be found here:
	https://github.com/dynup/kpatch/issues/493

Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 Documentation/ABI/testing/sysfs-kernel-livepatch |  6 +++++-
 kernel/livepatch/core.c                          | 10 ++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 5bf42a8..da87f43 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -33,7 +33,7 @@ Description:
 		The object directory contains subdirectories for each function
 		that is patched within the object.
 
-What:		/sys/kernel/livepatch/<patch>/<object>/<function>
+What:		/sys/kernel/livepatch/<patch>/<object>/<function,sympos>
 Date:		Nov 2014
 KernelVersion:	3.19.0
 Contact:	live-patching@vger.kernel.org
@@ -41,4 +41,8 @@ Description:
 		The function directory contains attributes regarding the
 		properties and state of the patched function.
 
+		The directory name contains the patched function name and a
+		sympos number corresponding to the nth occurrence of the symbol
+		name in kallsyms for the patched object.
+
 		There are currently no such attributes.
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 5cfe7b5..53ba0ae 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
  * /sys/kernel/livepatch/<patch>
  * /sys/kernel/livepatch/<patch>/enabled
  * /sys/kernel/livepatch/<patch>/<object>
- * /sys/kernel/livepatch/<patch>/<object>/<func>
+ * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
  */
 
 static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -679,8 +679,14 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	INIT_LIST_HEAD(&func->stack_node);
 	func->state = KLP_DISABLED;
 
+	/* The format for the sysfs directory is <function,sympos> where sympos
+	 * is the nth occurrence of this symbol in kallsyms for the patched
+	 * object. If the user selects 0 for old_sympos, then 1 will be used
+	 * since a unique symbol will be the first occurrence.
+	 */
 	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
-				    &obj->kobj, "%s", func->old_name);
+				    &obj->kobj, "%s,%lu", func->old_name,
+				    func->old_sympos ? func->old_sympos : 1);
 }
 
 /* parts of the initialization that is done only when the object is loaded */
-- 
1.9.1
