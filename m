From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 12/14] kdbus: add Makefile, Kconfig and MAINTAINERS entry
Date: Mon,  9 Mar 2015 14:09:18 +0100
Message-ID: <1425906560-13798-13-git-send-email-gregkh@linuxfoundation.org>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425906560-13798-1-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>

This patch hooks up the build system to actually compile the files
added by previous patches. It also adds an entry to MAINTAINERS to
direct people to Greg KH, David Herrmann, Djalal Harouni and me for
questions and patches.

Signed-off-by: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 MAINTAINERS        | 13 +++++++++++++
 init/Kconfig       | 12 ++++++++++++
 ipc/Makefile       |  2 +-
 ipc/kdbus/Makefile | 22 ++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 ipc/kdbus/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 6239a305dff0..e924246fb545 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5503,6 +5503,19 @@ S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
+KDBUS
+M:	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
+M:	Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
+M:	David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
+M:	Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
+L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Maintained
+F:	ipc/kdbus/*
+F:	samples/kdbus/*
+F:	Documentation/kdbus/*
+F:	include/uapi/linux/kdbus.h
+F:	tools/testing/selftests/kdbus/
+
 KDUMP
 M:	Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Haren Myneni <hbabu-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
diff --git a/init/Kconfig b/init/Kconfig
index f5dbc6d4261b..a7b462e7d647 100644
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
index 86c7300ecdf5..68ec4167d11b 100644
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
index 000000000000..7ee9271e1449
--- /dev/null
+++ b/ipc/kdbus/Makefile
@@ -0,0 +1,22 @@
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
+	reply.o \
+	queue.o \
+	util.o
+
+obj-$(CONFIG_KDBUS) += kdbus.o
-- 
2.3.1
