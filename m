From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC v2 3/3] Documentation: add ModAutoRestrict LSM documentation
Date: Sun,  9 Apr 2017 12:42:10 +0200
Message-ID: <1491734530-25002-4-git-send-email-tixxdz@gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491734530-25002-1-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/security/00-INDEX            |  2 +
 Documentation/security/ModAutoRestrict.txt | 77 ++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/security/ModAutoRestrict.txt

diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
index 45c82fd..35dbdf0 100644
--- a/Documentation/security/00-INDEX
+++ b/Documentation/security/00-INDEX
@@ -24,3 +24,5 @@ tomoyo.txt
 	- documentation on the TOMOYO Linux Security Module.
 IMA-templates.txt
 	- documentation on the template management mechanism for IMA.
+ModAutoRestrict.txt
+        - documentation on the ModAutoRestrict Linux Security Module.
diff --git a/Documentation/security/ModAutoRestrict.txt b/Documentation/security/ModAutoRestrict.txt
new file mode 100644
index 0000000..47acae8
--- /dev/null
+++ b/Documentation/security/ModAutoRestrict.txt
@@ -0,0 +1,77 @@
+ModAutoRestrict is a Linux Security Module that applies restrictions on
+automatic module loading operations. This is selectable at build-time
+with CONFIG_SECURITY_MODAUTORESTRICT, and can be controlled at run-time
+through sysctls in /proc/sys/kernel/modautorestrict/autoload or as a
+per-process setting via a prctl() interface.
+
+===========================================
+
+A userspace request to use a kernel feature that is implemented by modules
+that are not loaded may trigger the module auto-load feature to load
+these modules in order to satisfy userspace. However as today's Linux use
+cases cover embedded systems to containers where applications are running
+in their own separate environments, reducing or preventing operations
+that may affect external environments is an important constraint.
+Therefore, we need a way to control if automatic module loading is
+allowed or which applications are allowed to trigger the module
+auto-load feature.
+
+The ModAutoRestrict LSM allows system administrators or sandbox
+mechanisms to control the module auto-load feature and prevent loading
+unneeded modules or abuse the interface.
+
+The settings can be applied globally using a sysctl interface which
+completes the core kernel interface "modules_disable".
+
+The feature is also available as a prctl() interface. This allows to
+apply restrictions when sandboxing processes. On embedded Linux systems,
+or containers where only some containers/processes should have the
+right privileges to load modules, this allows to restrict those
+processes from inserting modules. Only privileged processes can be
+allowed to perform so. A more restrictive access can be applied where
+the module autoload feature is completely disabled.
+In this schema the access rules are per-process and inherited by
+children created by fork(2) and clone(2), and preserved across execve(2).
+
+Interface:
+
+*) The per-process prctl() settings are:
+
+ prctl(PR_MOD_AUTO_RESTRICT_OPTS, PR_SET_MOD_AUTO_RESTRICT, value, 0, 0)
+
+ Where value means:
+
+ 0 - Classic module auto-load permissions, nothing changes.
+
+ 1 - The current process must have CAP_SYS_MODULE to be able to
+     auto-load modules. CAP_NET_ADMIN should allow to auto-load
+     modules with a 'netdev-%s' alias.
+
+ 2 - Current process can not auto-load modules. Once set, this prctl
+     value can not be changed.
+
+ The per-process value may only be increased, never decreased, thus ensuring
+ that once applied, processes can never relaxe their setting.
+
+*) The global sysctl setting can be set by writting an integer value to
+   '/proc/sys/kernel/modautorestrict/autoload'
+
+ The valid values are:
+
+ 0 - Classic module auto-load permissions, nothing changes.
+
+ 1 - Processes must have CAP_SYS_MODULE to be able to auto-load modules.
+     CAP_NET_ADMIN should allow to auto-load modules with a 'netdev-%s'
+     alias.
+
+ 2 - Processes can not auto-load modules. Once set, this sysctl value
+     can not be changed.
+
+*) Access rules:
+   First the prctl() settings are checked, if the access is not denied
+   then the global sysctl settings are checked.
+
+
+The original idea and inspiration is from grsecurity 'GRKERNSEC_MODHARDEN'.
+
+==========================================================================
-- 
2.10.2
