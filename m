From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v11 4/4] tpm: Add documentation for the
	tpm_vtpm_proxy device driver
Date: Mon, 18 Apr 2016 13:26:16 -0400
Message-ID: <1461000376-2888-5-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461000376-2888-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add documentation for the tpm_vtpm device driver that implements
support for providing TPM functionality to Linux containers.

Parts of this documentation were recycled from the Xen vTPM
device driver documentation.

Update the documentation for the ioctl numbers.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 Documentation/ioctl/ioctl-number.txt |  1 +
 Documentation/tpm/tpm_vtpm_proxy.txt | 71 ++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)
 create mode 100644 Documentation/tpm/tpm_vtpm_proxy.txt

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 91261a3..7dbec90 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -303,6 +303,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:buk-KMFVLCTwZAcb1SvskN2V4Q@public.gmane.org>
 0xA0	all	linux/sdp/sdp.h		Industrial Device Project
 					<mailto:kenji-/mrfy+mawvNBDgjK7y7TUQ@public.gmane.org>
+0xA1	0	linux/vtpm_proxy.h	TPM Emulator Proxy Driver
 0xA2	00-0F	arch/tile/include/asm/hardwall.h
 0xA3	80-8F	Port ACL		in development:
 					<mailto:tlewis-mn4gwa5WIIQysxA8WJXlww@public.gmane.org>
diff --git a/Documentation/tpm/tpm_vtpm_proxy.txt b/Documentation/tpm/tpm_vtpm_proxy.txt
new file mode 100644
index 0000000..30d1902
--- /dev/null
+++ b/Documentation/tpm/tpm_vtpm_proxy.txt
@@ -0,0 +1,71 @@
+Virtual TPM Proxy Driver for Linux Containers
+
+Authors: Stefan Berger (IBM)
+
+This document describes the virtual Trusted Platform Module (vTPM)
+proxy device driver for Linux containers.
+
+INTRODUCTION
+------------
+
+The goal of this work is to provide TPM functionality to each Linux
+container. This allows programs to interact with a TPM in a container
+the same way they interact with a TPM on the physical system. Each
+container gets its own unique, emulated, software TPM.
+
+
+DESIGN
+------
+
+To make an emulated software TPM available to each container, the container
+management stack needs to create a device pair consisting of a client TPM
+character device /dev/tpmX (with X=0,1,2...) and a 'server side' file
+descriptor. The former is moved into the container by creating a character
+device with the appropriate major and minor numbers while the file descriptor
+is passed to the TPM emulator. Software inside the container can then send
+TPM commands using the character device and the emulator will receive the
+commands via the file descriptor and use it for sending back responses.
+
+To support this, the virtual TPM proxy driver provides a device /dev/vtpmx
+that is used to create device pairs using an ioctl. The ioctl takes as
+an input flags for configuring the device. The flags  for example indicate
+whether TPM 1.2 or TPM 2 functionality is supported by the TPM emulator.
+The result of the ioctl are the file descriptor for the 'server side'
+as well as the major and minor numbers of the character device that was created.
+Besides that the number of the TPM character device is return. If for
+example /dev/tpm10 was created, the number (dev_num) 10 is returned.
+
+The following is the data structure of the TPM_PROXY_IOC_NEW_DEV ioctl:
+
+struct vtpm_proxy_new_dev {
+	__u32 flags;         /* input */
+	__u32 tpm_num;       /* output */
+	__u32 fd;            /* output */
+	__u32 major;         /* output */
+	__u32 minor;         /* output */
+};
+
+Note that if unsupported flags are passed to the device driver, the ioctl will
+fail and errno will be set to EOPNOTSUPP. Similarly, if an unsupported ioctl is
+called on the device driver, the ioctl will fail and errno will be set to
+ENOTTY.
+
+See /usr/include/linux/vtpm_proxy.h for definitions related to the public interface
+of this vTPM device driver.
+
+Once the device has been created, the driver will immediately try to talk
+to the TPM. All commands from the driver can be read from the file descriptor
+returned by the ioctl. The commands should be responded to immediately.
+
+Depending on the version of TPM the following commands will be sent by the
+driver:
+
+- TPM 1.2:
+  - the driver will send a TPM_Startup command to the TPM emulator
+  - the driver will send commands to read the command durations and
+    interface timeouts from the TPM emulator
+- TPM 2:
+  - the driver will send a TPM2_Startup command to the TPM emulator
+
+The TPM device /dev/tpmX will only appear if all of the relevant commands
+were responded to properly.
-- 
2.4.3


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
