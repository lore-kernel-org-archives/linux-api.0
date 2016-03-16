From: Jessica Yu <jeyu@redhat.com>
Subject: [PATCH v5 3/6] module: s390: keep mod_arch_specific for livepatch modules
Date: Wed, 16 Mar 2016 15:47:05 -0400
Message-ID: <1458157628-8264-4-git-send-email-jeyu@redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Livepatch needs to utilize the symbol information contained in the
mod_arch_specific struct in order to be able to call the s390
apply_relocate_add() function to apply relocations. Keep a reference to
syminfo if the module is a livepatch module. Remove the redundant vfree()
in module_finalize() since module_arch_freeing_init() (which also frees
those structures) is called in do_init_module(). If the module isn't a
livepatch module, we free the structures in module_arch_freeing_init() as
usual.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 arch/s390/kernel/module.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 7873e17..fbc0789 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -51,6 +51,10 @@ void *module_alloc(unsigned long size)
 
 void module_arch_freeing_init(struct module *mod)
 {
+	if (is_livepatch_module(mod) &&
+	    mod->state == MODULE_STATE_LIVE)
+		return;
+
 	vfree(mod->arch.syminfo);
 	mod->arch.syminfo = NULL;
 }
@@ -425,7 +429,5 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    struct module *me)
 {
 	jump_label_apply_nops(me);
-	vfree(me->arch.syminfo);
-	me->arch.syminfo = NULL;
 	return 0;
 }
-- 
2.4.3
