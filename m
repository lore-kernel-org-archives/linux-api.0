From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH v2 3/6] module: s390: keep mod_arch_specific for livepatch modules
Date: Mon, 30 Nov 2015 23:21:16 -0500
Message-ID: <1448943679-3412-4-git-send-email-jeyu@redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Livepatch needs to utilize the symbol information contained in the
mod_arch_specific struct in order to be able to call the s390
apply_relocate_add() function to apply relocations. Remove the redundant
vfree() in module_finalize() since module_arch_freeing_init() (which also frees
said structures) is called in do_init_module(). Keep a reference to syminfo if
the module is a livepatch module and free the structures in
module_arch_cleanup(). If the module isn't a livepatch module, we free the
structures in module_arch_freeing_init() as usual.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 arch/s390/kernel/module.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 0c1a679..17a1979 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -51,6 +51,9 @@ void *module_alloc(unsigned long size)
 
 void module_arch_freeing_init(struct module *mod)
 {
+	if (mod->klp)
+		return;
+
 	vfree(mod->arch.syminfo);
 	mod->arch.syminfo = NULL;
 }
@@ -420,12 +423,18 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
+void module_arch_cleanup(struct module *mod)
+{
+	if (mod->klp) {
+		vfree(mod->arch.syminfo);
+		mod->arch.syminfo = NULL;
+	}
+}
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
 	jump_label_apply_nops(me);
-	vfree(me->arch.syminfo);
-	me->arch.syminfo = NULL;
 	return 0;
 }
-- 
2.4.3

