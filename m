From: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC v17][PATCH 54/60] c/r: add CKPT_COPY() macro
Date: Wed, 22 Jul 2009 06:00:16 -0400
Message-ID: <1248256822-23416-55-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1248256822-23416-1-git-send-email-orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

As suggested by Dave[1], this provides us a way to make the copy-in and
copy-out processes symmetric.  CKPT_COPY_ARRAY() provides us a way to do
the same thing but for arrays.  It's not critical, but it helps us unify
the checkpoint and restart paths for some things.

Changelog:
    Mar 04:
            . Removed semicolons
            . Added build-time check for __must_be_array in CKPT_COPY_ARRAY
    Feb 27:
            . Changed CKPT_COPY() to use assignment, eliminating the need
              for the CKPT_COPY_BIT() macro
            . Add CKPT_COPY_ARRAY() macro to help copying register arrays,
              etc
            . Move the macro definitions inside the CR #ifdef
    Feb 25:
            . Changed WARN_ON() to BUILD_BUG_ON()

Signed-off-by: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>

1: https://lists.linux-foundation.org/pipermail/containers/2009-February/015821.html (all the way at the bottom)
---
 include/linux/checkpoint.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index aeae2fa..2ee1bc2 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -211,6 +211,34 @@ extern int restore_memory_contents(struct ckpt_ctx *ctx, struct inode *inode);
 	 VM_MAPPED_COPY | VM_INSERTPAGE | VM_MIXEDMAP | VM_SAO)
 
 
+/* useful macros to copy fields and buffers to/from ckpt_hdr_xxx structures */
+#define CKPT_CPT 1
+#define CKPT_RST 2
+
+#define CKPT_COPY(op, SAVE, LIVE)				        \
+	do {							\
+		if (op == CKPT_CPT)				\
+			SAVE = LIVE;				\
+		else						\
+			LIVE = SAVE;				\
+	} while (0)
+
+/*
+ * Copy @count items from @LIVE to @SAVE if op is CKPT_CPT (otherwise,
+ * copy in the reverse direction)
+ */
+#define CKPT_COPY_ARRAY(op, SAVE, LIVE, count)				\
+	do {								\
+		(void)__must_be_array(SAVE);				\
+		(void)__must_be_array(LIVE);				\
+		BUILD_BUG_ON(sizeof(*SAVE) != sizeof(*LIVE));		\
+		if (op == CKPT_CPT)					\
+			memcpy(SAVE, LIVE, count * sizeof(*SAVE));	\
+		else							\
+			memcpy(LIVE, SAVE, count * sizeof(*SAVE));	\
+	} while (0)
+
+
 /* debugging flags */
 #define CKPT_DBASE	0x1		/* anything */
 #define CKPT_DSYS	0x2		/* generic (system) */
@@ -243,6 +271,7 @@ extern unsigned long ckpt_debug_level;
  * CKPT_DBASE is the base flags, doesn't change
  * CKPT_DFLAG is to be redfined in each source file
  */
+
 #define ckpt_debug(fmt, args...)  \
 	_ckpt_debug(CKPT_DBASE | CKPT_DFLAG, fmt, ## args)
 
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
