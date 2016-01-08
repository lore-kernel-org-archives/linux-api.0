From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [PATCH v4 2/2] Makefile: add kselftest-merge
Date: Fri,  8 Jan 2016 15:27:34 +0800
Message-ID: <1452238054-15482-3-git-send-email-bamvor.zhangjian@linaro.org>
References: <1452238054-15482-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452238054-15482-1-git-send-email-bamvor.zhangjian@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, shuahkh@osg.samsung.com, yann.morin.1998@free.fr, khilman@linaro.org, tyler.baker@linaro.org, broonie@kernel.org, mpe@ellerman.id.au, dvhart@infradead.org, mmarek@suse.com, Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

Add kselftest-merge to enable the dependencies of kernel config
for all the kselftest testcases. User should call it after create
the kernel configuration(.config), eg:

$ make kselftest-merge

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Makefile b/Makefile
index cd40956..bfb9faa 100644
--- a/Makefile
+++ b/Makefile
@@ -1104,6 +1104,14 @@ kselftest:
 kselftest-clean:
 	$(Q)$(MAKE) -C tools/testing/selftests clean
 
+PHONY += kselftest-merge
+kselftest-merge:
+	$(if $(wildcard $(objtree)/.config),, $(error No .config exists, config your kernel first!))
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh \
+		-m $(objtree)/.config \
+		$(srctree)/tools/testing/selftests/*/config
+	+$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
+
 # ---------------------------------------------------------------------------
 # Modules
 
@@ -1312,6 +1320,8 @@ help:
 	@echo  '                    Build, install, and boot kernel before'
 	@echo  '                    running kselftest on it'
 	@echo  '  kselftest-clean - Remove all generated kselftest files'
+	@echo  '  kselftest-merge - Merge all the config dependencies of kselftest to existed'
+	@echo  '                    .config.'
 	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
-- 
2.1.4
