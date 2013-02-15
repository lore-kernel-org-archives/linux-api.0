From: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
Date: Fri, 15 Feb 2013 15:51:41 +0200 (EET)
Message-ID: <20130215135141.1EFCEE0085@blue.fi.intel.com>
References: <20130215112911.68A98E0085@blue.fi.intel.com> <CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com> <20130215120022.GA23694@x220>
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130215120022.GA23694@x220>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johan Hedberg <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, RavindranathX Doddi <ravindranathx.doddi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Johan Hedberg wrote:
> Hi David,
> 
> On Fri, Feb 15, 2013, David Herrmann wrote:
> > On Fri, Feb 15, 2013 at 12:29 PM, Kirill A. Shutemov
> > <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > Hi David and all,
> > >
> > > There's claim in uhid.h that the interface is "compatible even between
> > > architectures". But it obviously is not true: struct uhid_create_req
> > > contains pointer which breaks everything.
> > >
> > > The easy way to demonstrate the issue is compile uhid-example.c with -m32
> > > and try to run it on 64 bit kernel. Creating of the device will fail.
> > 
> > Indeed, we missed that. We should probably also notify the HIDP
> > developers as "struct hidp_connadd_req" suffers from the same
> > problems. (CC'ed)
> > 
> > > I don't see an easy way to fix this. Few options:
> > >
> > > 1. Replace the pointer with u64. It will fix the issue, but it breaks ABI
> > >    which is never a good idea. Not sure how many users interface already
> > >    has.
> > 
> > The only users I am aware of is an HID debugging tool and experimental
> > HoG Bluetooth support (bluez). Maybe Marcel or Johan can comment
> > whether this is already used by bluez-5? If it is, then we shouldn't
> > break ABI and go with #2+#3. Otherwise, I think changing to u64 should
> > be ok.
> > On the other hand, it would break any future build for older stable
> > kernels so not breaking ABI is probably the best idea. Any comments? I
> > can add a COMPAT fix and a comment to fix this in the next version of
> > UHID_CREATE.
> 
> The HoG code in BlueZ 5 does indeed use this API and it's also not
> anymore behind any kind of experimental flag (i.e. it is an officially
> supported feature).
> 
> Johan

Here's my attempt to fix the issue.

Not sure if tricks with padding in a good idea. We can  just use __u64
instead of pointer, but it will require update of userspace to silence
cast warning and will cause warning if you will try to use updated
userspace with old kernel headers.

Any comments?

>From 0a0989cf08952464f8cab73d066beb876ff42949 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date: Fri, 15 Feb 2013 15:33:59 +0200
Subject: [PATCH] uhid: introduce new create event to fix 32/64-bit
 compatibility issue

Current create event has pointer in payload. It causes problem with
32/64-bit compatibility. In particular it's not possible to use 32-bit
userspace driver with 64-bit kernel.

This patch deprecates old create event and introduce a new one. The new
create event has padding for pointer on 32-bit system to extend pointer
correctly.

Old userspace driver binaries will use old create event. It requires
simple recompile to switch to new one.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/hid/uhid.c        |   31 +++++++++++++++++++++++++++++++
 include/uapi/linux/uhid.h |   24 +++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 714cd8c..2f0b0e4 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -343,6 +343,34 @@ err_free:
 	return ret;
 }
 
+static int uhid_dev_old_create(struct uhid_device *uhid,
+		struct uhid_event *ev)
+{
+	struct uhid_event *new;
+
+	new = kzalloc(sizeof(new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	new->type = UHID_CREATE;
+	memcpy(new->u.create.name, ev->u.old_create.name, 128);
+	memcpy(new->u.create.phys, ev->u.old_create.phys, 64);
+	memcpy(new->u.create.uniq, ev->u.old_create.uniq, 64);
+
+	/* Assume kernel and userspace bitness are the same */
+	new->u.create.rd_data = ev->u.old_create.rd_data;
+
+	new->u.create.rd_size = ev->u.old_create.rd_size;
+	new->u.create.bus = ev->u.old_create.bus;
+	new->u.create.vendor = ev->u.old_create.vendor;
+	new->u.create.product = ev->u.old_create.product;
+	new->u.create.version = ev->u.old_create.version;
+	new->u.create.country = ev->u.old_create.country;
+	memcpy(ev, new, sizeof(new));
+	kfree(new);
+	return uhid_dev_create(uhid, ev);
+}
+
 static int uhid_dev_destroy(struct uhid_device *uhid)
 {
 	if (!uhid->running)
@@ -507,6 +535,9 @@ static ssize_t uhid_char_write(struct file *file, const char __user *buffer,
 	case UHID_CREATE:
 		ret = uhid_dev_create(uhid, &uhid->input_buf);
 		break;
+	case UHID_OLD_CREATE:
+		ret = uhid_dev_old_create(uhid, &uhid->input_buf);
+		break;
 	case UHID_DESTROY:
 		ret = uhid_dev_destroy(uhid);
 		break;
diff --git a/include/uapi/linux/uhid.h b/include/uapi/linux/uhid.h
index 9c6974f..bb18be8 100644
--- a/include/uapi/linux/uhid.h
+++ b/include/uapi/linux/uhid.h
@@ -23,7 +23,7 @@
 #include <linux/types.h>
 
 enum uhid_event_type {
-	UHID_CREATE,
+	UHID_OLD_CREATE,
 	UHID_DESTROY,
 	UHID_START,
 	UHID_STOP,
@@ -34,13 +34,34 @@ enum uhid_event_type {
 	UHID_INPUT,
 	UHID_FEATURE,
 	UHID_FEATURE_ANSWER,
+	UHID_CREATE,
 };
 
+struct uhid_old_create_req {
+	__u8 name[128];
+	__u8 phys[64];
+	__u8 uniq[64];
+	__u8 __user *rd_data;
+	__u16 rd_size;
+
+	__u16 bus;
+	__u32 vendor;
+	__u32 product;
+	__u32 version;
+	__u32 country;
+} __attribute__((__packed__));
+
 struct uhid_create_req {
 	__u8 name[128];
 	__u8 phys[64];
 	__u8 uniq[64];
+#if __BITS_PER_LONG != 64 && __BYTE_ORDER == __BIG_ENDIAN
+	__u32 __pad;
+#endif
 	__u8 __user *rd_data;
+#if __BITS_PER_LONG != 64 && __BYTE_ORDER == __LITTLE_ENDIAN
+	__u32 __pad;
+#endif
 	__u16 rd_size;
 
 	__u16 bus;
@@ -92,6 +113,7 @@ struct uhid_event {
 	__u32 type;
 
 	union {
+		struct uhid_old_create_req old_create;
 		struct uhid_create_req create;
 		struct uhid_input_req input;
 		struct uhid_output_req output;
-- 
 Kirill A. Shutemov
