From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] vfs: Introduce a non-repeating system-unique superblock
 ID [ver #15]
Date: Fri, 28 Jun 2019 16:47:15 +0100
Message-ID: <156173683525.14728.15345430508651294965.stgit@warthog.procyon.org.uk>
References: <156173681842.14728.9331700785061885270.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156173681842.14728.9331700785061885270.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, raven@themaw.net, mszeredi@redhat.com, christian@brauner.io, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Introduce an (effectively) non-repeating system-unique superblock ID that
can be used to determine that two object are in the same superblock without
risking reuse of the ID in the meantime (as is possible with device IDs).

The ID is time-based to make it harder to use it as a covert communications
channel.

Also make it so that this ID can be fetched by the fsinfo() system call.
The ID added so that superblock notification messages will also be able to
be tagged with it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fsinfo.c               |    1 +
 fs/super.c                |   24 ++++++++++++++++++++++++
 include/linux/fs.h        |    3 +++
 samples/vfs/test-fsinfo.c |    1 +
 4 files changed, 29 insertions(+)

diff --git a/fs/fsinfo.c b/fs/fsinfo.c
index 4eaa33b2188b..aee7fedace19 100644
--- a/fs/fsinfo.c
+++ b/fs/fsinfo.c
@@ -87,6 +87,7 @@ static int fsinfo_generic_ids(struct path *path, struct fsinfo_ids *p)
 	p->f_fstype	= sb->s_magic;
 	p->f_dev_major	= MAJOR(sb->s_dev);
 	p->f_dev_minor	= MINOR(sb->s_dev);
+	p->f_sb_id	= sb->s_unique_id;
 
 	memcpy(&p->f_fsid, &buf.f_fsid, sizeof(p->f_fsid));
 	strlcpy(p->f_fs_name, path->dentry->d_sb->s_type->name,
diff --git a/fs/super.c b/fs/super.c
index 2739f57515f8..c04f9481a708 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -43,6 +43,8 @@ static int thaw_super_locked(struct super_block *sb);
 
 static LIST_HEAD(super_blocks);
 static DEFINE_SPINLOCK(sb_lock);
+static u64 sb_last_identifier;
+static u64 sb_identifier_offset;
 
 static char *sb_writers_name[SB_FREEZE_LEVELS] = {
 	"sb_writers",
@@ -187,6 +189,27 @@ static void destroy_unused_super(struct super_block *s)
 	destroy_super_work(&s->destroy_work);
 }
 
+/*
+ * Generate a unique identifier for a superblock.
+ */
+static void generate_super_id(struct super_block *s)
+{
+	u64 id = ktime_to_ns(ktime_get());
+
+	spin_lock(&sb_lock);
+
+	id += sb_identifier_offset;
+	if (id <= sb_last_identifier) {
+		id = sb_last_identifier + 1;
+		sb_identifier_offset = sb_last_identifier - id;
+	}
+
+	sb_last_identifier = id;
+	spin_unlock(&sb_lock);
+
+	s->s_unique_id = id;
+}
+
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
@@ -270,6 +293,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 		goto fail;
 	if (list_lru_init_memcg(&s->s_inode_lru, &s->s_shrink))
 		goto fail;
+	generate_super_id(s);
 	return s;
 
 fail:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50f58eac3e1f..61098cded376 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1527,6 +1527,9 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
+
+	/* Superblock event notifications */
+	u64			s_unique_id;
 } __randomize_layout;
 
 /* Helper functions so that in most cases filesystems will
diff --git a/samples/vfs/test-fsinfo.c b/samples/vfs/test-fsinfo.c
index 6389ae781cbb..27c4bb93c219 100644
--- a/samples/vfs/test-fsinfo.c
+++ b/samples/vfs/test-fsinfo.c
@@ -185,6 +185,7 @@ static void dump_attr_IDS(union reply *r, int size)
 	printf("\tdev   : %02x:%02x\n", f->f_dev_major, f->f_dev_minor);
 	printf("\tfs    : type=%x name=%s\n", f->f_fstype, f->f_fs_name);
 	printf("\tfsid  : %llx\n", (unsigned long long)f->f_fsid);
+	printf("\tsbid  : %llx\n", (unsigned long long)f->f_sb_id);
 }
 
 static void dump_attr_LIMITS(union reply *r, int size)
