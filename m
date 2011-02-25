From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 6/5] Fix unaligned memory accesses in dmi-sysfs
Date: Fri, 25 Feb 2011 15:06:25 -0800
Message-ID: <4D6835F1.2050304@google.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110223015307.13068.14063.stgit-tzAwxxnF6Tt6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

DMI entries are arranged in memory back to back with no alignment
guarantees. This means that the struct dmi_header passed to callbacks
from dmi_walk() itself isn't byte aligned.  This causes problems on
architectures that expect aligned data, such as IA64.

The dmi-sysfs patchset introduced structure member accesses through
this passed in dmi_header.  Fix this by memcpy()ing the structures to
temporary locations on stack when inspecting/copying them.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Tested-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
  dmi-sysfs.c |   28 +++++++++++++---------------
  1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index a5afd80..eb26d62 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -263,20 +263,16 @@ struct dmi_system_event_log {
  	u8	supported_log_type_descriptos[0];
  } __packed;

-static const struct dmi_system_event_log *to_sel(const struct 
dmi_header *dh)
-{
-	return (const struct dmi_system_event_log *)dh;
-}
-
  #define DMI_SYSFS_SEL_FIELD(_field) \
  static ssize_t dmi_sysfs_sel_##_field(struct dmi_sysfs_entry *entry, \
  				      const struct dmi_header *dh, \
  				      char *buf) \
  { \
-	const struct dmi_system_event_log *sel = to_sel(dh); \
-	if (sizeof(*sel) > dmi_entry_length(dh)) \
+	struct dmi_system_event_log sel; \
+	if (sizeof(sel) > dmi_entry_length(dh)) \
  		return -EIO; \
-	return sprintf(buf, "%u\n", sel->_field); \
+	memcpy(&sel, dh, sizeof(sel)); \
+	return sprintf(buf, "%u\n", sel._field); \
  } \
  static DMI_SYSFS_MAPPED_ATTR(sel, _field)

@@ -403,26 +399,28 @@ static ssize_t dmi_sel_raw_read_helper(struct 
dmi_sysfs_entry *entry,
  				       void *_state)
  {
  	struct dmi_read_state *state = _state;
-	const struct dmi_system_event_log *sel = to_sel(dh);
+	struct dmi_system_event_log sel;

-	if (sizeof(*sel) > dmi_entry_length(dh))
+	if (sizeof(sel) > dmi_entry_length(dh))
  		return -EIO;

-	switch (sel->access_method) {
+	memcpy(&sel, dh, sizeof(sel));
+
+	switch (sel.access_method) {
  	case DMI_SEL_ACCESS_METHOD_IO8:
  	case DMI_SEL_ACCESS_METHOD_IO2x8:
  	case DMI_SEL_ACCESS_METHOD_IO16:
-		return dmi_sel_raw_read_io(entry, sel, state->buf,
+		return dmi_sel_raw_read_io(entry, &sel, state->buf,
  					   state->pos, state->count);
  	case DMI_SEL_ACCESS_METHOD_PHYS32:
-		return dmi_sel_raw_read_phys32(entry, sel, state->buf,
+		return dmi_sel_raw_read_phys32(entry, &sel, state->buf,
  					       state->pos, state->count);
  	case DMI_SEL_ACCESS_METHOD_GPNV:
  		pr_info("dmi-sysfs: GPNV support missing.\n");
  		return -EIO;
  	default:
  		pr_info("dmi-sysfs: Unknown access method %02x\n",
-			sel->access_method);
+			sel.access_method);
  		return -EIO;
  	}
  }
@@ -595,7 +593,7 @@ static void __init dmi_sysfs_register_handle(const 
struct dmi_header *dh,
  	}

  	/* Set the key */
-	entry->dh = *dh;
+	memcpy(&entry->dh, dh, sizeof(*dh));
  	entry->instance = instance_counts[dh->type]++;
  	entry->position = position_count++;
