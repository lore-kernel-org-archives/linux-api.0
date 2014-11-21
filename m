From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add Makefile, Kconfig and MAINTAINERS entry
Date: Thu, 20 Nov 2014 21:02:28 -0800
Message-ID: <1416546149-24799-13-git-send-email-gregkh@linuxfoundation.org>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

This patch hooks up the build system to actually compile the files
added by previous patches. It also adds an entry to MAINTAINERS to
direct people to Greg KH, David Herrmann, Djalal Harouni and me for
questions and patches.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS        | 12 ++++++++++++
 init/Kconfig       | 12 ++++++++++++
 ipc/Makefile       |  2 +-
 ipc/kdbus/Makefile | 21 +++++++++++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 ipc/kdbus/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index c444907ccd69..cfb1819667bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5276,6 +5276,18 @@ S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
+KDBUS
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+M:	Daniel Mack <daniel@zonque.org>
+M:	David Herrmann <dh.herrmann@googlemail.com>
+M:	Djalal Harouni <tixxdz@opendz.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	ipc/kdbus/*
+F:	Documentation/kdbus.txt
+F:	include/uapi/linux/kdbus.h
+F:	tools/testing/selftests/kdbus/
+
 KDUMP
 M:	Vivek Goyal <vgoyal@redhat.com>
 M:	Haren Myneni <hbabu@us.ibm.com>
diff --git a/init/Kconfig b/init/Kconfig
index 2081a4d3d917..44bf491c971f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -261,6 +261,18 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
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
+
 config CROSS_MEMORY_ATTACH
 	bool "Enable process_vm_readv/writev syscalls"
 	depends on MMU
diff --git a/ipc/Makefile b/ipc/Makefile
index 9075e172e52c..df8df7c4e33c 100644
--- a/ipc/Makefile
+++ b/ipc/Makefile
@@ -9,4 +9,4 @@ obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 obj-$(CONFIG_IPC_NS) += namespace.o
 obj-$(CONFIG_POSIX_MQUEUE_SYSCTL) += mq_sysctl.o
-
+obj-$(CONFIG_KDBUS) += kdbus/
diff --git a/ipc/kdbus/Makefile b/ipc/kdbus/Makefile
new file mode 100644
index 000000000000..37e5dd4f218a
--- /dev/null
+++ b/ipc/kdbus/Makefile
@@ -0,0 +1,21 @@
+kdbus-y := \
+	bus.o \
+	connection.o \
+	endpoint.o \
+	fs.o \
+	handle.o \
+	item.o \
+	main.o \
+	match.o \
+	message.o \
+	metadata.o \
+	names.o \
+	node.o \
+	notify.o \
+	domain.o \
+	policy.o \
+	pool.o \
+	queue.o \
+	util.o
+
+obj-$(CONFIG_KDBUS) += kdbus.o
-- 
2.1.3
