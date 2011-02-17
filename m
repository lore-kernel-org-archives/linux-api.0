From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 4/5] firmware: Expose DMI type 15 System Event Log
Date: Thu, 17 Feb 2011 13:28:16 -0800
Message-ID: <20110217212816.3967.923.stgit@mike.mtv.corp.google.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Lippert <rlippert@google.com>
Cc: Jon Mayer <jonmayer@google.com>, Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The System Event Log described by DMI entry type 15 may be backed by
either memory or may be indirectly accessed via an IO index/data
register pair.

In order to get read access to this log, expose it in the
"system_event_log" sub-directory of type 15 DMI entries, ie:
/sys/firmware/dmi/entries/15-0/system_event_log/raw_event_log.

This commit handles both IO accessed and memory access system event
logs.  OEM specific access and GPNV support is explicitly not handled
and we error out in the logs when we do not recognize the access method.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/dmi-sysfs.c |  143 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 3f49042..51462fe 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -305,6 +305,140 @@ static struct kobj_type dmi_system_event_log_ktype = {
 	.default_attrs = dmi_sysfs_sel_attrs,
 };
 
+typedef u8 (*sel_io_reader)(const struct dmi_system_event_log *sel,
+			    loff_t offset);
+
+static DEFINE_MUTEX(io_port_lock);
+
+static u8 read_sel_8bit_indexed_io(const struct dmi_system_event_log *sel,
+				   loff_t offset)
+{
+	u8 ret;
+
+	mutex_lock(&io_port_lock);
+	outb((u8)offset, sel->io.index_addr);
+	ret = inb(sel->io.data_addr);
+	mutex_unlock(&io_port_lock);
+	return ret;
+}
+
+static u8 read_sel_2x8bit_indexed_io(const struct dmi_system_event_log *sel,
+				     loff_t offset)
+{
+	u8 ret;
+
+	mutex_lock(&io_port_lock);
+	outb((u8)offset, sel->io.index_addr);
+	outb((u8)(offset >> 8), sel->io.index_addr + 1);
+	ret = inb(sel->io.data_addr);
+	mutex_unlock(&io_port_lock);
+	return ret;
+}
+
+static u8 read_sel_16bit_indexed_io(const struct dmi_system_event_log *sel,
+				    loff_t offset)
+{
+	u8 ret;
+
+	mutex_lock(&io_port_lock);
+	outw((u16)offset, sel->io.index_addr);
+	ret = inb(sel->io.data_addr);
+	mutex_unlock(&io_port_lock);
+	return ret;
+}
+
+static sel_io_reader sel_io_readers[] = {
+	[DMI_SEL_ACCESS_METHOD_IO8]	= read_sel_8bit_indexed_io,
+	[DMI_SEL_ACCESS_METHOD_IO2x8]	= read_sel_2x8bit_indexed_io,
+	[DMI_SEL_ACCESS_METHOD_IO16]	= read_sel_16bit_indexed_io,
+};
+
+static ssize_t dmi_sel_raw_read_io(struct dmi_sysfs_entry *entry,
+				   const struct dmi_system_event_log *sel,
+				   char *buf, loff_t pos, size_t count)
+{
+	ssize_t wrote = 0;
+
+	sel_io_reader io_reader = sel_io_readers[sel->access_method];
+
+	while (count && pos < sel->area_length) {
+		count--;
+		*(buf++) = io_reader(sel, pos++);
+		wrote++;
+	}
+
+	return wrote;
+}
+
+static ssize_t dmi_sel_raw_read_phys32(struct dmi_sysfs_entry *entry,
+				       const struct dmi_system_event_log *sel,
+				       char *buf, loff_t pos, size_t count)
+{
+	u8 __iomem *mapped;
+	ssize_t wrote = 0;
+
+	mapped = ioremap(sel->access_method_address, sel->area_length);
+	if (!mapped)
+		return -EIO;
+
+	while (count && pos < sel->area_length) {
+		count--;
+		*(buf++) = readb(mapped + pos++);
+		wrote++;
+	}
+
+	iounmap(mapped);
+	return wrote;
+}
+
+static ssize_t dmi_sel_raw_read_helper(struct dmi_sysfs_entry *entry,
+				       const struct dmi_header *dh,
+				       void *_state)
+{
+	struct dmi_read_state *state = _state;
+	const struct dmi_system_event_log *sel = to_sel(dh);
+
+	if (sizeof(*sel) > dmi_entry_length(dh))
+		return -EIO;
+
+	switch (sel->access_method) {
+	case DMI_SEL_ACCESS_METHOD_IO8:
+	case DMI_SEL_ACCESS_METHOD_IO2x8:
+	case DMI_SEL_ACCESS_METHOD_IO16:
+		return dmi_sel_raw_read_io(entry, sel, state->buf,
+					   state->pos, state->count);
+	case DMI_SEL_ACCESS_METHOD_PHYS32:
+		return dmi_sel_raw_read_phys32(entry, sel, state->buf,
+					       state->pos, state->count);
+	case DMI_SEL_ACCESS_METHOD_GPNV:
+		pr_info("dmi-sysfs: GPNV support missing.\n");
+		return -EIO;
+	default:
+		pr_info("dmi-sysfs: Unknown access method %02x\n",
+			sel->access_method);
+		return -EIO;
+	}
+}
+
+static ssize_t dmi_sel_raw_read(struct file *filp, struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t pos, size_t count)
+{
+	struct dmi_sysfs_entry *entry = to_entry(kobj->parent);
+	struct dmi_read_state state = {
+		.buf = buf,
+		.pos = pos,
+		.count = count,
+	};
+
+	return find_dmi_entry(entry, dmi_sel_raw_read_helper, &state);
+}
+
+static struct bin_attribute dmi_sel_raw_attr = {
+	.attr = {.name = "raw_event_log", .mode = 0400},
+	.read = dmi_sel_raw_read,
+};
+
 static int dmi_system_event_log(struct dmi_sysfs_entry *entry)
 {
 	int ret;
@@ -318,6 +452,15 @@ static int dmi_system_event_log(struct dmi_sysfs_entry *entry)
 				   "system_event_log");
 	if (ret)
 		goto out_free;
+
+	ret = sysfs_create_bin_file(entry->child, &dmi_sel_raw_attr);
+	if (ret)
+		goto out_del;
+
+	return 0;
+
+out_del:
+	kobject_del(entry->child);
 out_free:
 	kfree(entry->child);
 	return ret;
