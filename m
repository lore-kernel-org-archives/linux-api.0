From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 10/11] tpm: Add documentation for the
	tpm_vtpm device driver
Date: Wed,  9 Mar 2016 12:39:29 -0500
Message-ID: <1457545170-30120-11-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457545170-30120-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add documentation for the tpm_vtpm device driver that implements
support for providing TPM functionality to Linux containers.

Parts of this documentation were recycled from the Xen vTPM
device driver documentation.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 Documentation/tpm/tpm_vtpm.txt | 54 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/tpm/tpm_vtpm.txt

diff --git a/Documentation/tpm/tpm_vtpm.txt b/Documentation/tpm/tpm_vtpm.txt
new file mode 100644
index 0000000..d193573
--- /dev/null
+++ b/Documentation/tpm/tpm_vtpm.txt
@@ -0,0 +1,54 @@
+Virtual TPM Device Driver for Linux Containers
+
+Authors: Stefan Berger (IBM)
+
+This document describes the virtual Trusted Platform Module (vTPM) device
+driver for Linux containers.
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
+To support this, the virtual TPM device driver provides a device /dev/vtpmx
+that is used to create device pairs using an ioctl. The ioctl takes as
+an input flags for configuring the device. The flags  for example indicate
+whether TPM 1.2 or TPM 2 functionality is supported by the TPM emulator.
+The result of the ioctl are the file descriptor for the 'server side'
+as well as the major and minor numbers of the character device that was created.
+Besides that the number of the TPM character device is return. If for
+example /dev/tpm10 was created, the number (dev_num) 10 is returned.
+
+The following is the data structure of the VTPM_NEW_DEV ioctl:
+
+struct vtpm_new_dev {
+	__u32 flags;         /* input */
+	__u32 dev_num;       /* output */
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
+See /usr/include/linux/vtpm.h for definitions related to the public interface
+of this vTPM device driver.
-- 
2.4.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
