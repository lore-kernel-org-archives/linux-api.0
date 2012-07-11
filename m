From: Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V3 1/2] driver: add PPI support in tpm driver
Date: Wed, 11 Jul 2012 10:24:31 -0500
Message-ID: <20120711152430.GC21153@linux.vnet.ibm.com>
References: <1340203963.24516.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340203963.24516.2.camel@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Xiaoyan" <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cihula, Joseph" <joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org" <m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org>, "shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Xiaoyan,

On Thu, Jun 21, 2012 at 06:54:51AM +0000, Zhang, Xiaoyan wrote:
> From: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The Physical Presence Interface enables the OS and the BIOS to cooperate
> and provides a simple and straightforward platform user experience for
> administering the TPM without sacrificing security.
> 
> V2: separate the patch out in a separate source file, add #ifdef CONFIG_ACPI
> so it compiles out on ppc, and use standard error instead of ACPI error as
> return code of show/store fns.
> 
> V3: move #ifdef CONFIG_ACPI from .c file to .h file
> 
> Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/tpm/Makefile  |    4 +-
>  drivers/char/tpm/tpm.c     |    5 +
>  drivers/char/tpm/tpm.h     |    8 +
>  drivers/char/tpm/tpm_ppi.c |  461 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 477 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm_ppi.c
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index ea3a1e0..132ad95 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -1,8 +1,10 @@
>  #
>  # Makefile for the kernel tpm device drivers.
>  #
> -obj-$(CONFIG_TCG_TPM) += tpm.o
> +obj-$(CONFIG_TCG_TPM) += tpm_main.o
> +tpm_main-y += tpm.o
>  ifdef CONFIG_ACPI
> +	tpm_main-y += tpm_ppi.o
>  	obj-$(CONFIG_TCG_TPM) += tpm_bios.o

  This will change the name of the tpm driver, which I really don't want
to do. Can you apply on top of [1] and resubmit?  I've added the
following patch which modularizes the event logging code and has a
couple Makefile changes too. This is needed for a future driver on PPC,
but it should make adding your file obvious. Note that the patch below
applies on top of Infineon's I2C driver patches.

[1] git://github.com/shpedoikal/linux.git tpmdd-next

Thanks,
Kent

tpm: modularize event log collection

Break ACPI-specific pieces of the event log handling into their own file
and create tpm_eventlog.[ch] to store common event log handling code.
This will be required to integrate future event log sources on platforms
without ACPI tables.

Signed-off-by: Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile       |    1 +
 drivers/char/tpm/tpm.c          |    1 +
 drivers/char/tpm/tpm_acpi.c     |  104 ++++++++
 drivers/char/tpm/tpm_bios.c     |  556 ---------------------------------------
 drivers/char/tpm/tpm_eventlog.c |  419 +++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_eventlog.h |   71 +++++
 6 files changed, 596 insertions(+), 556 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_acpi.c
 delete mode 100644 drivers/char/tpm/tpm_bios.c
 create mode 100644 drivers/char/tpm/tpm_eventlog.c
 create mode 100644 drivers/char/tpm/tpm_eventlog.h

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a9c3afc..beac52f6 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_TCG_TPM) += tpm.o
 ifdef CONFIG_ACPI
 	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
+	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index d39b1f6..beb98c3 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -30,6 +30,7 @@
 #include <linux/freezer.h>
 
 #include "tpm.h"
+#include "tpm_eventlog.h"
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
new file mode 100644
index 0000000..a1bb5a18
--- /dev/null
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -0,0 +1,104 @@
+/*
+ * Copyright (C) 2005 IBM Corporation
+ *
+ * Authors:
+ *	Seiji Munetoh <munetoh-JE5g2YyFxFHQT0dZR+AlfA@public.gmane.org>
+ *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Access to the eventlog extended by the TCG BIOS of PC platform
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <acpi/acpi.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+struct acpi_tcpa {
+	struct acpi_table_header hdr;
+	u16 platform_class;
+	union {
+		struct client_hdr {
+			u32 log_max_len __attribute__ ((packed));
+			u64 log_start_addr __attribute__ ((packed));
+		} client;
+		struct server_hdr {
+			u16 reserved;
+			u64 log_max_len __attribute__ ((packed));
+			u64 log_start_addr __attribute__ ((packed));
+		} server;
+	};
+};
+
+/* read binary bios log */
+int read_log(struct tpm_bios_log *log)
+{
+	struct acpi_tcpa *buff;
+	acpi_status status;
+	struct acpi_table_header *virt;
+	u64 len, start;
+
+	if (log->bios_event_log != NULL) {
+		printk(KERN_ERR
+		       "%s: ERROR - Eventlog already initialized\n",
+		       __func__);
+		return -EFAULT;
+	}
+
+	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
+	status = acpi_get_table(ACPI_SIG_TCPA, 1,
+				(struct acpi_table_header **)&buff);
+
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
+		       __func__);
+		return -EIO;
+	}
+
+	switch(buff->platform_class) {
+	case BIOS_SERVER:
+		len = buff->server.log_max_len;
+		start = buff->server.log_start_addr;
+		break;
+	case BIOS_CLIENT:
+	default:
+		len = buff->client.log_max_len;
+		start = buff->client.log_start_addr;
+		break;
+	}
+	if (!len) {
+		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n", __func__);
+		return -EIO;
+	}
+
+	/* malloc EventLog space */
+	log->bios_event_log = kmalloc(len, GFP_KERNEL);
+	if (!log->bios_event_log) {
+		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	log->bios_event_log_end = log->bios_event_log + len;
+
+	virt = acpi_os_map_memory(start, len);
+
+	memcpy(log->bios_event_log, virt, len);
+
+	acpi_os_unmap_memory(virt, len);
+	return 0;
+}
diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
deleted file mode 100644
index 0636520..0000000
--- a/drivers/char/tpm/tpm_bios.c
+++ /dev/null
@@ -1,556 +0,0 @@
-/*
- * Copyright (C) 2005 IBM Corporation
- *
- * Authors:
- *	Seiji Munetoh <munetoh-JE5g2YyFxFHQT0dZR+AlfA@public.gmane.org>
- *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
- *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
- *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
- *
- * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
- *
- * Access to the eventlog extended by the TCG BIOS of PC platform
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- */
-
-#include <linux/seq_file.h>
-#include <linux/fs.h>
-#include <linux/security.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <acpi/acpi.h>
-#include "tpm.h"
-
-#define TCG_EVENT_NAME_LEN_MAX	255
-#define MAX_TEXT_EVENT		1000	/* Max event string length */
-#define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
-
-enum bios_platform_class {
-	BIOS_CLIENT = 0x00,
-	BIOS_SERVER = 0x01,
-};
-
-struct tpm_bios_log {
-	void *bios_event_log;
-	void *bios_event_log_end;
-};
-
-struct acpi_tcpa {
-	struct acpi_table_header hdr;
-	u16 platform_class;
-	union {
-		struct client_hdr {
-			u32 log_max_len __attribute__ ((packed));
-			u64 log_start_addr __attribute__ ((packed));
-		} client;
-		struct server_hdr {
-			u16 reserved;
-			u64 log_max_len __attribute__ ((packed));
-			u64 log_start_addr __attribute__ ((packed));
-		} server;
-	};
-};
-
-struct tcpa_event {
-	u32 pcr_index;
-	u32 event_type;
-	u8 pcr_value[20];	/* SHA1 */
-	u32 event_size;
-	u8 event_data[0];
-};
-
-enum tcpa_event_types {
-	PREBOOT = 0,
-	POST_CODE,
-	UNUSED,
-	NO_ACTION,
-	SEPARATOR,
-	ACTION,
-	EVENT_TAG,
-	SCRTM_CONTENTS,
-	SCRTM_VERSION,
-	CPU_MICROCODE,
-	PLATFORM_CONFIG_FLAGS,
-	TABLE_OF_DEVICES,
-	COMPACT_HASH,
-	IPL,
-	IPL_PARTITION_DATA,
-	NONHOST_CODE,
-	NONHOST_CONFIG,
-	NONHOST_INFO,
-};
-
-static const char* tcpa_event_type_strings[] = {
-	"PREBOOT",
-	"POST CODE",
-	"",
-	"NO ACTION",
-	"SEPARATOR",
-	"ACTION",
-	"EVENT TAG",
-	"S-CRTM Contents",
-	"S-CRTM Version",
-	"CPU Microcode",
-	"Platform Config Flags",
-	"Table of Devices",
-	"Compact Hash",
-	"IPL",
-	"IPL Partition Data",
-	"Non-Host Code",
-	"Non-Host Config",
-	"Non-Host Info"
-};
-
-struct tcpa_pc_event {
-	u32 event_id;
-	u32 event_size;
-	u8 event_data[0];
-};
-
-enum tcpa_pc_event_ids {
-	SMBIOS = 1,
-	BIS_CERT,
-	POST_BIOS_ROM,
-	ESCD,
-	CMOS,
-	NVRAM,
-	OPTION_ROM_EXEC,
-	OPTION_ROM_CONFIG,
-	OPTION_ROM_MICROCODE = 10,
-	S_CRTM_VERSION,
-	S_CRTM_CONTENTS,
-	POST_CONTENTS,
-	HOST_TABLE_OF_DEVICES,
-};
-
-static const char* tcpa_pc_event_id_strings[] = {
-	"",
-	"SMBIOS",
-	"BIS Certificate",
-	"POST BIOS ",
-	"ESCD ",
-	"CMOS",
-	"NVRAM",
-	"Option ROM",
-	"Option ROM config",
-	"",
-	"Option ROM microcode ",
-	"S-CRTM Version",
-	"S-CRTM Contents ",
-	"POST Contents ",
-	"Table of Devices",
-};
-
-/* returns pointer to start of pos. entry of tcg log */
-static void *tpm_bios_measurements_start(struct seq_file *m, loff_t *pos)
-{
-	loff_t i;
-	struct tpm_bios_log *log = m->private;
-	void *addr = log->bios_event_log;
-	void *limit = log->bios_event_log_end;
-	struct tcpa_event *event;
-
-	/* read over *pos measurements */
-	for (i = 0; i < *pos; i++) {
-		event = addr;
-
-		if ((addr + sizeof(struct tcpa_event)) < limit) {
-			if (event->event_type == 0 && event->event_size == 0)
-				return NULL;
-			addr += sizeof(struct tcpa_event) + event->event_size;
-		}
-	}
-
-	/* now check if current entry is valid */
-	if ((addr + sizeof(struct tcpa_event)) >= limit)
-		return NULL;
-
-	event = addr;
-
-	if ((event->event_type == 0 && event->event_size == 0) ||
-	    ((addr + sizeof(struct tcpa_event) + event->event_size) >= limit))
-		return NULL;
-
-	return addr;
-}
-
-static void *tpm_bios_measurements_next(struct seq_file *m, void *v,
-					loff_t *pos)
-{
-	struct tcpa_event *event = v;
-	struct tpm_bios_log *log = m->private;
-	void *limit = log->bios_event_log_end;
-
-	v += sizeof(struct tcpa_event) + event->event_size;
-
-	/* now check if current entry is valid */
-	if ((v + sizeof(struct tcpa_event)) >= limit)
-		return NULL;
-
-	event = v;
-
-	if (event->event_type == 0 && event->event_size == 0)
-		return NULL;
-
-	if ((event->event_type == 0 && event->event_size == 0) ||
-	    ((v + sizeof(struct tcpa_event) + event->event_size) >= limit))
-		return NULL;
-
-	(*pos)++;
-	return v;
-}
-
-static void tpm_bios_measurements_stop(struct seq_file *m, void *v)
-{
-}
-
-static int get_event_name(char *dest, struct tcpa_event *event,
-			unsigned char * event_entry)
-{
-	const char *name = "";
-	/* 41 so there is room for 40 data and 1 nul */
-	char data[41] = "";
-	int i, n_len = 0, d_len = 0;
-	struct tcpa_pc_event *pc_event;
-
-	switch(event->event_type) {
-	case PREBOOT:
-	case POST_CODE:
-	case UNUSED:
-	case NO_ACTION:
-	case SCRTM_CONTENTS:
-	case SCRTM_VERSION:
-	case CPU_MICROCODE:
-	case PLATFORM_CONFIG_FLAGS:
-	case TABLE_OF_DEVICES:
-	case COMPACT_HASH:
-	case IPL:
-	case IPL_PARTITION_DATA:
-	case NONHOST_CODE:
-	case NONHOST_CONFIG:
-	case NONHOST_INFO:
-		name = tcpa_event_type_strings[event->event_type];
-		n_len = strlen(name);
-		break;
-	case SEPARATOR:
-	case ACTION:
-		if (MAX_TEXT_EVENT > event->event_size) {
-			name = event_entry;
-			n_len = event->event_size;
-		}
-		break;
-	case EVENT_TAG:
-		pc_event = (struct tcpa_pc_event *)event_entry;
-
-		/* ToDo Row data -> Base64 */
-
-		switch (pc_event->event_id) {
-		case SMBIOS:
-		case BIS_CERT:
-		case CMOS:
-		case NVRAM:
-		case OPTION_ROM_EXEC:
-		case OPTION_ROM_CONFIG:
-		case S_CRTM_VERSION:
-			name = tcpa_pc_event_id_strings[pc_event->event_id];
-			n_len = strlen(name);
-			break;
-		/* hash data */
-		case POST_BIOS_ROM:
-		case ESCD:
-		case OPTION_ROM_MICROCODE:
-		case S_CRTM_CONTENTS:
-		case POST_CONTENTS:
-			name = tcpa_pc_event_id_strings[pc_event->event_id];
-			n_len = strlen(name);
-			for (i = 0; i < 20; i++)
-				d_len += sprintf(&data[2*i], "%02x",
-						pc_event->event_data[i]);
-			break;
-		default:
-			break;
-		}
-	default:
-		break;
-	}
-
-	return snprintf(dest, MAX_TEXT_EVENT, "[%.*s%.*s]",
-			n_len, name, d_len, data);
-
-}
-
-static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
-{
-	struct tcpa_event *event = v;
-	char *data = v;
-	int i;
-
-	for (i = 0; i < sizeof(struct tcpa_event) + event->event_size; i++)
-		seq_putc(m, data[i]);
-
-	return 0;
-}
-
-static int tpm_bios_measurements_release(struct inode *inode,
-					 struct file *file)
-{
-	struct seq_file *seq = file->private_data;
-	struct tpm_bios_log *log = seq->private;
-
-	if (log) {
-		kfree(log->bios_event_log);
-		kfree(log);
-	}
-
-	return seq_release(inode, file);
-}
-
-static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
-{
-	int len = 0;
-	int i;
-	char *eventname;
-	struct tcpa_event *event = v;
-	unsigned char *event_entry =
-	    (unsigned char *) (v + sizeof(struct tcpa_event));
-
-	eventname = kmalloc(MAX_TEXT_EVENT, GFP_KERNEL);
-	if (!eventname) {
-		printk(KERN_ERR "%s: ERROR - No Memory for event name\n ",
-		       __func__);
-		return -EFAULT;
-	}
-
-	seq_printf(m, "%2d ", event->pcr_index);
-
-	/* 2nd: SHA1 */
-	for (i = 0; i < 20; i++)
-		seq_printf(m, "%02x", event->pcr_value[i]);
-
-	/* 3rd: event type identifier */
-	seq_printf(m, " %02x", event->event_type);
-
-	len += get_event_name(eventname, event, event_entry);
-
-	/* 4th: eventname <= max + \'0' delimiter */
-	seq_printf(m, " %s\n", eventname);
-
-	kfree(eventname);
-	return 0;
-}
-
-static const struct seq_operations tpm_ascii_b_measurments_seqops = {
-	.start = tpm_bios_measurements_start,
-	.next = tpm_bios_measurements_next,
-	.stop = tpm_bios_measurements_stop,
-	.show = tpm_ascii_bios_measurements_show,
-};
-
-static const struct seq_operations tpm_binary_b_measurments_seqops = {
-	.start = tpm_bios_measurements_start,
-	.next = tpm_bios_measurements_next,
-	.stop = tpm_bios_measurements_stop,
-	.show = tpm_binary_bios_measurements_show,
-};
-
-/* read binary bios log */
-static int read_log(struct tpm_bios_log *log)
-{
-	struct acpi_tcpa *buff;
-	acpi_status status;
-	struct acpi_table_header *virt;
-	u64 len, start;
-
-	if (log->bios_event_log != NULL) {
-		printk(KERN_ERR
-		       "%s: ERROR - Eventlog already initialized\n",
-		       __func__);
-		return -EFAULT;
-	}
-
-	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
-	status = acpi_get_table(ACPI_SIG_TCPA, 1,
-				(struct acpi_table_header **)&buff);
-
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
-		       __func__);
-		return -EIO;
-	}
-
-	switch(buff->platform_class) {
-	case BIOS_SERVER:
-		len = buff->server.log_max_len;
-		start = buff->server.log_start_addr;
-		break;
-	case BIOS_CLIENT:
-	default:
-		len = buff->client.log_max_len;
-		start = buff->client.log_start_addr;
-		break;
-	}
-	if (!len) {
-		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n", __func__);
-		return -EIO;
-	}
-
-	/* malloc EventLog space */
-	log->bios_event_log = kmalloc(len, GFP_KERNEL);
-	if (!log->bios_event_log) {
-		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	log->bios_event_log_end = log->bios_event_log + len;
-
-	virt = acpi_os_map_memory(start, len);
-
-	memcpy(log->bios_event_log, virt, len);
-
-	acpi_os_unmap_memory(virt, len);
-	return 0;
-}
-
-static int tpm_ascii_bios_measurements_open(struct inode *inode,
-					    struct file *file)
-{
-	int err;
-	struct tpm_bios_log *log;
-	struct seq_file *seq;
-
-	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-
-	if ((err = read_log(log)))
-		goto out_free;
-
-	/* now register seq file */
-	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = log;
-	} else {
-		goto out_free;
-	}
-
-out:
-	return err;
-out_free:
-	kfree(log->bios_event_log);
-	kfree(log);
-	goto out;
-}
-
-static const struct file_operations tpm_ascii_bios_measurements_ops = {
-	.open = tpm_ascii_bios_measurements_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = tpm_bios_measurements_release,
-};
-
-static int tpm_binary_bios_measurements_open(struct inode *inode,
-					     struct file *file)
-{
-	int err;
-	struct tpm_bios_log *log;
-	struct seq_file *seq;
-
-	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-
-	if ((err = read_log(log)))
-		goto out_free;
-
-	/* now register seq file */
-	err = seq_open(file, &tpm_binary_b_measurments_seqops);
-	if (!err) {
-		seq = file->private_data;
-		seq->private = log;
-	} else {
-		goto out_free;
-	}
-
-out:
-	return err;
-out_free:
-	kfree(log->bios_event_log);
-	kfree(log);
-	goto out;
-}
-
-static const struct file_operations tpm_binary_bios_measurements_ops = {
-	.open = tpm_binary_bios_measurements_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = tpm_bios_measurements_release,
-};
-
-static int is_bad(void *p)
-{
-	if (!p)
-		return 1;
-	if (IS_ERR(p) && (PTR_ERR(p) != -ENODEV))
-		return 1;
-	return 0;
-}
-
-struct dentry **tpm_bios_log_setup(char *name)
-{
-	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
-
-	tpm_dir = securityfs_create_dir(name, NULL);
-	if (is_bad(tpm_dir))
-		goto out;
-
-	bin_file =
-	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
-				   &tpm_binary_bios_measurements_ops);
-	if (is_bad(bin_file))
-		goto out_tpm;
-
-	ascii_file =
-	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
-				   &tpm_ascii_bios_measurements_ops);
-	if (is_bad(ascii_file))
-		goto out_bin;
-
-	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
-	if (!ret)
-		goto out_ascii;
-
-	ret[0] = ascii_file;
-	ret[1] = bin_file;
-	ret[2] = tpm_dir;
-
-	return ret;
-
-out_ascii:
-	securityfs_remove(ascii_file);
-out_bin:
-	securityfs_remove(bin_file);
-out_tpm:
-	securityfs_remove(tpm_dir);
-out:
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(tpm_bios_log_setup);
-
-void tpm_bios_log_teardown(struct dentry **lst)
-{
-	int i;
-
-	for (i = 0; i < 3; i++)
-		securityfs_remove(lst[i]);
-}
-EXPORT_SYMBOL_GPL(tpm_bios_log_teardown);
-MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
new file mode 100644
index 0000000..84ddc55
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -0,0 +1,419 @@
+/*
+ * Copyright (C) 2005, 2012 IBM Corporation
+ *
+ * Authors:
+ *	Kent Yoder <key-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
+ *	Seiji Munetoh <munetoh-JE5g2YyFxFHQT0dZR+AlfA@public.gmane.org>
+ *	Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *	Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ *	Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Access to the eventlog created by a system's firmware / BIOS
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+
+static const char* tcpa_event_type_strings[] = {
+	"PREBOOT",
+	"POST CODE",
+	"",
+	"NO ACTION",
+	"SEPARATOR",
+	"ACTION",
+	"EVENT TAG",
+	"S-CRTM Contents",
+	"S-CRTM Version",
+	"CPU Microcode",
+	"Platform Config Flags",
+	"Table of Devices",
+	"Compact Hash",
+	"IPL",
+	"IPL Partition Data",
+	"Non-Host Code",
+	"Non-Host Config",
+	"Non-Host Info"
+};
+
+static const char* tcpa_pc_event_id_strings[] = {
+	"",
+	"SMBIOS",
+	"BIS Certificate",
+	"POST BIOS ",
+	"ESCD ",
+	"CMOS",
+	"NVRAM",
+	"Option ROM",
+	"Option ROM config",
+	"",
+	"Option ROM microcode ",
+	"S-CRTM Version",
+	"S-CRTM Contents ",
+	"POST Contents ",
+	"Table of Devices",
+};
+
+/* returns pointer to start of pos. entry of tcg log */
+static void *tpm_bios_measurements_start(struct seq_file *m, loff_t *pos)
+{
+	loff_t i;
+	struct tpm_bios_log *log = m->private;
+	void *addr = log->bios_event_log;
+	void *limit = log->bios_event_log_end;
+	struct tcpa_event *event;
+
+	/* read over *pos measurements */
+	for (i = 0; i < *pos; i++) {
+		event = addr;
+
+		if ((addr + sizeof(struct tcpa_event)) < limit) {
+			if (event->event_type == 0 && event->event_size == 0)
+				return NULL;
+			addr += sizeof(struct tcpa_event) + event->event_size;
+		}
+	}
+
+	/* now check if current entry is valid */
+	if ((addr + sizeof(struct tcpa_event)) >= limit)
+		return NULL;
+
+	event = addr;
+
+	if ((event->event_type == 0 && event->event_size == 0) ||
+	    ((addr + sizeof(struct tcpa_event) + event->event_size) >= limit))
+		return NULL;
+
+	return addr;
+}
+
+static void *tpm_bios_measurements_next(struct seq_file *m, void *v,
+					loff_t *pos)
+{
+	struct tcpa_event *event = v;
+	struct tpm_bios_log *log = m->private;
+	void *limit = log->bios_event_log_end;
+
+	v += sizeof(struct tcpa_event) + event->event_size;
+
+	/* now check if current entry is valid */
+	if ((v + sizeof(struct tcpa_event)) >= limit)
+		return NULL;
+
+	event = v;
+
+	if (event->event_type == 0 && event->event_size == 0)
+		return NULL;
+
+	if ((event->event_type == 0 && event->event_size == 0) ||
+	    ((v + sizeof(struct tcpa_event) + event->event_size) >= limit))
+		return NULL;
+
+	(*pos)++;
+	return v;
+}
+
+static void tpm_bios_measurements_stop(struct seq_file *m, void *v)
+{
+}
+
+static int get_event_name(char *dest, struct tcpa_event *event,
+			unsigned char * event_entry)
+{
+	const char *name = "";
+	/* 41 so there is room for 40 data and 1 nul */
+	char data[41] = "";
+	int i, n_len = 0, d_len = 0;
+	struct tcpa_pc_event *pc_event;
+
+	switch(event->event_type) {
+	case PREBOOT:
+	case POST_CODE:
+	case UNUSED:
+	case NO_ACTION:
+	case SCRTM_CONTENTS:
+	case SCRTM_VERSION:
+	case CPU_MICROCODE:
+	case PLATFORM_CONFIG_FLAGS:
+	case TABLE_OF_DEVICES:
+	case COMPACT_HASH:
+	case IPL:
+	case IPL_PARTITION_DATA:
+	case NONHOST_CODE:
+	case NONHOST_CONFIG:
+	case NONHOST_INFO:
+		name = tcpa_event_type_strings[event->event_type];
+		n_len = strlen(name);
+		break;
+	case SEPARATOR:
+	case ACTION:
+		if (MAX_TEXT_EVENT > event->event_size) {
+			name = event_entry;
+			n_len = event->event_size;
+		}
+		break;
+	case EVENT_TAG:
+		pc_event = (struct tcpa_pc_event *)event_entry;
+
+		/* ToDo Row data -> Base64 */
+
+		switch (pc_event->event_id) {
+		case SMBIOS:
+		case BIS_CERT:
+		case CMOS:
+		case NVRAM:
+		case OPTION_ROM_EXEC:
+		case OPTION_ROM_CONFIG:
+		case S_CRTM_VERSION:
+			name = tcpa_pc_event_id_strings[pc_event->event_id];
+			n_len = strlen(name);
+			break;
+		/* hash data */
+		case POST_BIOS_ROM:
+		case ESCD:
+		case OPTION_ROM_MICROCODE:
+		case S_CRTM_CONTENTS:
+		case POST_CONTENTS:
+			name = tcpa_pc_event_id_strings[pc_event->event_id];
+			n_len = strlen(name);
+			for (i = 0; i < 20; i++)
+				d_len += sprintf(&data[2*i], "%02x",
+						pc_event->event_data[i]);
+			break;
+		default:
+			break;
+		}
+	default:
+		break;
+	}
+
+	return snprintf(dest, MAX_TEXT_EVENT, "[%.*s%.*s]",
+			n_len, name, d_len, data);
+
+}
+
+static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
+{
+	struct tcpa_event *event = v;
+	char *data = v;
+	int i;
+
+	for (i = 0; i < sizeof(struct tcpa_event) + event->event_size; i++)
+		seq_putc(m, data[i]);
+
+	return 0;
+}
+
+static int tpm_bios_measurements_release(struct inode *inode,
+					 struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct tpm_bios_log *log = seq->private;
+
+	if (log) {
+		kfree(log->bios_event_log);
+		kfree(log);
+	}
+
+	return seq_release(inode, file);
+}
+
+static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
+{
+	int len = 0;
+	int i;
+	char *eventname;
+	struct tcpa_event *event = v;
+	unsigned char *event_entry =
+	    (unsigned char *) (v + sizeof(struct tcpa_event));
+
+	eventname = kmalloc(MAX_TEXT_EVENT, GFP_KERNEL);
+	if (!eventname) {
+		printk(KERN_ERR "%s: ERROR - No Memory for event name\n ",
+		       __func__);
+		return -EFAULT;
+	}
+
+	seq_printf(m, "%2d ", event->pcr_index);
+
+	/* 2nd: SHA1 */
+	for (i = 0; i < 20; i++)
+		seq_printf(m, "%02x", event->pcr_value[i]);
+
+	/* 3rd: event type identifier */
+	seq_printf(m, " %02x", event->event_type);
+
+	len += get_event_name(eventname, event, event_entry);
+
+	/* 4th: eventname <= max + \'0' delimiter */
+	seq_printf(m, " %s\n", eventname);
+
+	kfree(eventname);
+	return 0;
+}
+
+static const struct seq_operations tpm_ascii_b_measurments_seqops = {
+	.start = tpm_bios_measurements_start,
+	.next = tpm_bios_measurements_next,
+	.stop = tpm_bios_measurements_stop,
+	.show = tpm_ascii_bios_measurements_show,
+};
+
+static const struct seq_operations tpm_binary_b_measurments_seqops = {
+	.start = tpm_bios_measurements_start,
+	.next = tpm_bios_measurements_next,
+	.stop = tpm_bios_measurements_stop,
+	.show = tpm_binary_bios_measurements_show,
+};
+
+static int tpm_ascii_bios_measurements_open(struct inode *inode,
+					    struct file *file)
+{
+	int err;
+	struct tpm_bios_log *log;
+	struct seq_file *seq;
+
+	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	if ((err = read_log(log)))
+		goto out_free;
+
+	/* now register seq file */
+	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = log;
+	} else {
+		goto out_free;
+	}
+
+out:
+	return err;
+out_free:
+	kfree(log->bios_event_log);
+	kfree(log);
+	goto out;
+}
+
+static const struct file_operations tpm_ascii_bios_measurements_ops = {
+	.open = tpm_ascii_bios_measurements_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = tpm_bios_measurements_release,
+};
+
+static int tpm_binary_bios_measurements_open(struct inode *inode,
+					     struct file *file)
+{
+	int err;
+	struct tpm_bios_log *log;
+	struct seq_file *seq;
+
+	log = kzalloc(sizeof(struct tpm_bios_log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	if ((err = read_log(log)))
+		goto out_free;
+
+	/* now register seq file */
+	err = seq_open(file, &tpm_binary_b_measurments_seqops);
+	if (!err) {
+		seq = file->private_data;
+		seq->private = log;
+	} else {
+		goto out_free;
+	}
+
+out:
+	return err;
+out_free:
+	kfree(log->bios_event_log);
+	kfree(log);
+	goto out;
+}
+
+static const struct file_operations tpm_binary_bios_measurements_ops = {
+	.open = tpm_binary_bios_measurements_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = tpm_bios_measurements_release,
+};
+
+static int is_bad(void *p)
+{
+	if (!p)
+		return 1;
+	if (IS_ERR(p) && (PTR_ERR(p) != -ENODEV))
+		return 1;
+	return 0;
+}
+
+struct dentry **tpm_bios_log_setup(char *name)
+{
+	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
+
+	tpm_dir = securityfs_create_dir(name, NULL);
+	if (is_bad(tpm_dir))
+		goto out;
+
+	bin_file =
+	    securityfs_create_file("binary_bios_measurements",
+				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
+				   &tpm_binary_bios_measurements_ops);
+	if (is_bad(bin_file))
+		goto out_tpm;
+
+	ascii_file =
+	    securityfs_create_file("ascii_bios_measurements",
+				   S_IRUSR | S_IRGRP, tpm_dir, NULL,
+				   &tpm_ascii_bios_measurements_ops);
+	if (is_bad(ascii_file))
+		goto out_bin;
+
+	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
+	if (!ret)
+		goto out_ascii;
+
+	ret[0] = ascii_file;
+	ret[1] = bin_file;
+	ret[2] = tpm_dir;
+
+	return ret;
+
+out_ascii:
+	securityfs_remove(ascii_file);
+out_bin:
+	securityfs_remove(bin_file);
+out_tpm:
+	securityfs_remove(tpm_dir);
+out:
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(tpm_bios_log_setup);
+
+void tpm_bios_log_teardown(struct dentry **lst)
+{
+	int i;
+
+	for (i = 0; i < 3; i++)
+		securityfs_remove(lst[i]);
+}
+EXPORT_SYMBOL_GPL(tpm_bios_log_teardown);
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
new file mode 100644
index 0000000..8e23ccd
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -0,0 +1,71 @@
+
+#ifndef __TPM_EVENTLOG_H__
+#define __TPM_EVENTLOG_H__
+
+#define TCG_EVENT_NAME_LEN_MAX	255
+#define MAX_TEXT_EVENT		1000	/* Max event string length */
+#define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
+
+enum bios_platform_class {
+	BIOS_CLIENT = 0x00,
+	BIOS_SERVER = 0x01,
+};
+
+struct tpm_bios_log {
+	void *bios_event_log;
+	void *bios_event_log_end;
+};
+
+struct tcpa_event {
+	u32 pcr_index;
+	u32 event_type;
+	u8 pcr_value[20];	/* SHA1 */
+	u32 event_size;
+	u8 event_data[0];
+};
+
+enum tcpa_event_types {
+	PREBOOT = 0,
+	POST_CODE,
+	UNUSED,
+	NO_ACTION,
+	SEPARATOR,
+	ACTION,
+	EVENT_TAG,
+	SCRTM_CONTENTS,
+	SCRTM_VERSION,
+	CPU_MICROCODE,
+	PLATFORM_CONFIG_FLAGS,
+	TABLE_OF_DEVICES,
+	COMPACT_HASH,
+	IPL,
+	IPL_PARTITION_DATA,
+	NONHOST_CODE,
+	NONHOST_CONFIG,
+	NONHOST_INFO,
+};
+
+struct tcpa_pc_event {
+	u32 event_id;
+	u32 event_size;
+	u8 event_data[0];
+};
+
+enum tcpa_pc_event_ids {
+	SMBIOS = 1,
+	BIS_CERT,
+	POST_BIOS_ROM,
+	ESCD,
+	CMOS,
+	NVRAM,
+	OPTION_ROM_EXEC,
+	OPTION_ROM_CONFIG,
+	OPTION_ROM_MICROCODE = 10,
+	S_CRTM_VERSION,
+	S_CRTM_CONTENTS,
+	POST_CONTENTS,
+	HOST_TABLE_OF_DEVICES,
+};
+
+int read_log(struct tpm_bios_log *log);
+#endif
-- 
1.7.5.4
