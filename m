From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Subject: [PATCH v3 2/2] scripts/kconfig/Makefile: add kselftest-mergeconfig
Date: Thu, 17 Dec 2015 17:57:53 +0800
Message-ID: <1450346273-31633-4-git-send-email-bamvor.zhangjian@linaro.org>
References: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450346273-31633-1-git-send-email-bamvor.zhangjian@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, shuahkh@osg.samsung.com, yann.morin.1998@free.fr, khilman@linaro.org, tyler.baker@linaro.org, broonie@kernel.org, mpe@ellerman.id.au, dvhart@infradead.org, Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
List-Id: linux-api@vger.kernel.org

Add kselftest-mergeconfig to enable the dependencies of kernel
config for all the kselftest testcases. User could call it after
create the kernel configuration(.config), eg:

$ make kselftest-mergeconfig

Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
---
 scripts/kconfig/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index d79cba4..2694638 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -126,6 +126,14 @@ PHONY += tinyconfig
 tinyconfig:
 	$(Q)$(MAKE) -f $(srctree)/Makefile allnoconfig tiny.config
 
+PHONY += kselftest-mergeconfig
+kselftest-mergeconfig: $(obj)/conf
+	$(if $(wildcard $(objtree)/.config),, $(error No .config exists, config your kernel first!))
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh \
+		-m $(objtree)/.config \
+		$(srctree)/tools/testing/selftests/*/config
+	+$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
+
 # Help text used by make help
 help:
 	@echo  '  config	  - Update current config utilising a line-oriented program'
@@ -151,6 +159,7 @@ help:
 	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
 	@echo  '  xenconfig       - Enable additional options for xen dom0 and guest kernel support'
 	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
+	@echo  '  kselftest-mergeconfig - Merge all the config dependencies of kselftest to .config'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
-- 
2.1.4
