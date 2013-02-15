From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Fri, 15 Feb 2013 12:05:26 -0800
Message-ID: <20130215200526.GA15811@core.coreip.homeip.net>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
 <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
 <20130215120022.GA23694@x220>
 <20130215135141.1EFCEE0085@blue.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-input-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130215135141.1EFCEE0085@blue.fi.intel.com>
Sender: linux-input-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>, David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org, linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, RavindranathX Doddi <ravindranathx.doddi@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 15, 2013 at 03:51:41PM +0200, Kirill A. Shutemov wrote:
> Johan Hedberg wrote:
> > Hi David,
> > 
> > On Fri, Feb 15, 2013, David Herrmann wrote:
> > > On Fri, Feb 15, 2013 at 12:29 PM, Kirill A. Shutemov
> > > <kirill.shutemov@linux.intel.com> wrote:
> > > > Hi David and all,
> > > >
> > > > There's claim in uhid.h that the interface is "compatible even between
> > > > architectures". But it obviously is not true: struct uhid_create_req
> > > > contains pointer which breaks everything.
> > > >
> > > > The easy way to demonstrate the issue is compile uhid-example.c with -m32
> > > > and try to run it on 64 bit kernel. Creating of the device will fail.
> > > 
> > > Indeed, we missed that. We should probably also notify the HIDP
> > > developers as "struct hidp_connadd_req" suffers from the same
> > > problems. (CC'ed)
> > > 
> > > > I don't see an easy way to fix this. Few options:
> > > >
> > > > 1. Replace the pointer with u64. It will fix the issue, but it breaks ABI
> > > >    which is never a good idea. Not sure how many users interface already
> > > >    has.
> > > 
> > > The only users I am aware of is an HID debugging tool and experimental
> > > HoG Bluetooth support (bluez). Maybe Marcel or Johan can comment
> > > whether this is already used by bluez-5? If it is, then we shouldn't
> > > break ABI and go with #2+#3. Otherwise, I think changing to u64 should
> > > be ok.
> > > On the other hand, it would break any future build for older stable
> > > kernels so not breaking ABI is probably the best idea. Any comments? I
> > > can add a COMPAT fix and a comment to fix this in the next version of
> > > UHID_CREATE.
> > 
> > The HoG code in BlueZ 5 does indeed use this API and it's also not
> > anymore behind any kind of experimental flag (i.e. it is an officially
> > supported feature).
> > 
> > Johan
> 
> Here's my attempt to fix the issue.
> 
> Not sure if tricks with padding in a good idea. We can  just use __u64
> instead of pointer, but it will require update of userspace to silence
> cast warning and will cause warning if you will try to use updated
> userspace with old kernel headers.
> 
> Any comments?

This does not fix anything really, we simply have to deal with compat
interface.

Compiled but not tested.

Thanks.

-- 
Dmitry

UHID: make creating devices work on 64/32 systems

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Unfortunately UHID interface, as it was introduced, is broken with 32 bit
userspace running on 64 bit kernels as it uses a pointer in its userspace
facing API.

Fix it by checking if we are executing compat task and munge the request
appropriately.

Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/hid/uhid.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 714cd8c..fc307e0 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/hid.h>
@@ -276,6 +277,94 @@ static struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 };
 
+#ifdef CONFIG_COMPAT
+
+/* Apparently we haven't stepped on these rakes enough times yet. */
+struct uhid_create_req_compat {
+	__u8 name[128];
+	__u8 phys[64];
+	__u8 uniq[64];
+
+	compat_uptr_t rd_data;
+	__u16 rd_size;
+
+	__u16 bus;
+	__u32 vendor;
+	__u32 product;
+	__u32 version;
+	__u32 country;
+} __attribute__((__packed__));
+
+static int uhid_event_from_user(const char __user *buffer, size_t len,
+				struct uhid_event *event)
+{
+	if (is_compat_task()) {
+		u32 type;
+
+		if (get_user(type, buffer))
+			return -EFAULT;
+
+		if (type == UHID_CREATE) {
+			/*
+			 * This is our messed up request with compat pointer.
+			 * It is largish (more than 256 bytes) so we better
+			 * allocate it from the heap.
+			 */
+			struct uhid_create_req_compat *compat;
+
+			compat = kmalloc(sizeof(*compat), GFP_KERNEL);
+			if (!compat)
+				return -ENOMEM;
+
+			buffer += sizeof(type);
+			len -= sizeof(type);
+			if (copy_from_user(compat, buffer,
+					   min(len, sizeof(*compat)))) {
+				kfree(compat);
+				return -EFAULT;
+			}
+
+			/* Shuffle the data over to proper structure */
+			event->type = type;
+
+			memcpy(event->u.create.name, compat->name,
+				sizeof(compat->name));
+			memcpy(event->u.create.phys, compat->phys,
+				sizeof(compat->phys));
+			memcpy(event->u.create.uniq, compat->uniq,
+				sizeof(compat->uniq));
+
+			event->u.create.rd_data = compat_ptr(compat->rd_data);
+			event->u.create.rd_size = compat->rd_size;
+
+			event->u.create.bus = compat->bus;
+			event->u.create.vendor = compat->vendor;
+			event->u.create.product = compat->product;
+			event->u.create.version = compat->version;
+			event->u.create.country = compat->country;
+
+			kfree(compat);
+			return 0;
+		}
+		/* All others can be copied directly */
+	}
+
+	if (copy_from_user(event, buffer, min(len, sizeof(*event))))
+		return -EFAULT;
+
+	return 0;
+}
+#else
+static int uhid_event_from_user(const char __user *buffer, size_t len,
+				struct uhid_event *event)
+{
+	if (copy_from_user(event, buffer, min(len, sizeof(*event))))
+		return -EFAULT;
+
+	return 0;
+}
+#endif
+
 static int uhid_dev_create(struct uhid_device *uhid,
 			   const struct uhid_event *ev)
 {
@@ -498,10 +587,10 @@ static ssize_t uhid_char_write(struct file *file, const char __user *buffer,
 
 	memset(&uhid->input_buf, 0, sizeof(uhid->input_buf));
 	len = min(count, sizeof(uhid->input_buf));
-	if (copy_from_user(&uhid->input_buf, buffer, len)) {
-		ret = -EFAULT;
+
+	ret = uhid_event_from_user(buffer, len, &uhid->input_buf);
+	if (ret)
 		goto unlock;
-	}
 
 	switch (uhid->input_buf.type) {
 	case UHID_CREATE:

