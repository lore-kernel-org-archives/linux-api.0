From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add Makefile, Kconfig and MAINTAINERS entry
Date: Wed, 29 Oct 2014 15:00:55 -0700
Message-ID: <1414620056-6675-12-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org, gregkh@linuxfoundation.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, teg@jklm.no
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

This patch hooks up the build system to actually compile the files
added by previous patches. It also adds an entry to MAINTAINERS to
direct people to Greg KH, David Herrmann, Djalal Harouni and me for
questions and patches.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                 | 12 ++++++++++++
 drivers/misc/Kconfig        |  1 +
 drivers/misc/Makefile       |  1 +
 drivers/misc/kdbus/Kconfig  | 11 +++++++++++
 drivers/misc/kdbus/Makefile | 19 +++++++++++++++++++
 5 files changed, 44 insertions(+)
 create mode 100644 drivers/misc/kdbus/Kconfig
 create mode 100644 drivers/misc/kdbus/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index dab92a78d1d5..15d2677d6d5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5255,6 +5255,18 @@ S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
+KDBUS
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+M:	Daniel Mack <daniel@zonque.org>
+M:	David Herrmann <dh.herrmann@googlemail.com>
+M:	Djalal Harouni <tixxdz@opendz.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/misc/kdbus/*
+F:	Documentation/kdbus.txt
+F:	include/uapi/linux/kdbus.h
+F:	tools/testing/selftests/kdbus/
+
 KDUMP
 M:	Vivek Goyal <vgoyal@redhat.com>
 M:	Haren Myneni <hbabu@us.ibm.com>
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index bbeb4516facf..fa84e5f4b30a 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -528,4 +528,5 @@ source "drivers/misc/mic/Kconfig"
 source "drivers/misc/genwqe/Kconfig"
 source "drivers/misc/echo/Kconfig"
 source "drivers/misc/cxl/Kconfig"
+source "drivers/misc/kdbus/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7d5c4cd118c4..ce6fa2fe7513 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
+obj-$(CONFIG_KDBUS)		+= kdbus/
diff --git a/drivers/misc/kdbus/Kconfig b/drivers/misc/kdbus/Kconfig
new file mode 100644
index 000000000000..204defa7e237
--- /dev/null
+++ b/drivers/misc/kdbus/Kconfig
@@ -0,0 +1,11 @@
+config KDBUS
+	tristate "kdbus interprocess communication"
+	depends on TMPFS
+	help
+	  D-Bus is a system for low-latency, low-overhead, easy to use
+	  interprocess communication (IPC).
+
+	  See Documentation/kdbus.txt
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called kdbus.
diff --git a/drivers/misc/kdbus/Makefile b/drivers/misc/kdbus/Makefile
new file mode 100644
index 000000000000..2867b776b821
--- /dev/null
+++ b/drivers/misc/kdbus/Makefile
@@ -0,0 +1,19 @@
+kdbus-y := \
+        bus.o \
+        connection.o \
+        endpoint.o \
+        handle.o \
+        item.o \
+        main.o \
+        match.o \
+        message.o \
+        metadata.o \
+        names.o \
+        notify.o \
+        domain.o \
+        policy.o \
+        pool.o \
+        queue.o \
+        util.o
+
+obj-$(CONFIG_KDBUS) += kdbus.o
-- 
2.1.2
