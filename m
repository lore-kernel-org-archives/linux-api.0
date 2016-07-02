From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH review 09/11] quota: Handle quota data stored in s_user_ns.
Date: Sat,  2 Jul 2016 12:20:33 -0500
Message-ID: <20160702172035.19568-9-ebiederm@xmission.com>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160702172035.19568-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In Q_XSETQLIMIT use sb->s_user_ns to detect when we are dealing with
the filesystems notion of id 0.

For the dquot hashfn translate the qid into sb->s_user_ns to remove
extraneous bits before hashing.

When dealing with generic quota files in quota_tree.c, quota_v1.c, and
quota_v2.c before writing quotas to the file encode them in
sb->s_user_ns, and decode ids read from the file from sb->s_user_ns.

One complication comes up in qtree_get_next_id, as it is possible in
principle for id's to be present in the quota file that do not have a
mapping in the filesystems user namespace.  If that is the case the
code is modified to skip the unmapped ids.

Inspired-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/quota/dquot.c      |  4 ++--
 fs/quota/quota.c      |  2 +-
 fs/quota/quota_tree.c | 23 ++++++++++++++---------
 fs/quota/quota_v1.c   |  6 ++++--
 fs/quota/quota_v2.c   | 10 ++++++----
 5 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 74706b6aa747..9b39925f34f4 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -252,7 +252,7 @@ static int __dquot_initialize(struct inode *inode, int type);
 static inline unsigned int
 hashfn(const struct super_block *sb, struct kqid qid)
 {
-	unsigned int id = from_kqid(&init_user_ns, qid);
+	unsigned int id = from_kqid(sb->s_user_ns, qid);
 	int type = qid.type;
 	unsigned long tmp;
 
@@ -748,7 +748,7 @@ void dqput(struct dquot *dquot)
 	if (!atomic_read(&dquot->dq_count)) {
 		quota_error(dquot->dq_sb, "trying to free free dquot of %s %d",
 			    quotatypes[dquot->dq_id.type],
-			    from_kqid(&init_user_ns, dquot->dq_id));
+			    from_kqid(dquot->dq_sb->s_user_ns, dquot->dq_id));
 		BUG();
 	}
 #endif
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 73f6f4cf0a21..35df08ee9c97 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -584,7 +584,7 @@ static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 	if (!qid_has_mapping(sb->s_user_ns, qid))
 		return -EINVAL;
 	/* Are we actually setting timer / warning limits for all users? */
-	if (from_kqid(&init_user_ns, qid) == 0 &&
+	if (from_kqid(sb->s_user_ns, qid) == 0 &&
 	    fdq.d_fieldmask & (FS_DQ_WARNS_MASK | FS_DQ_TIMER_MASK)) {
 		struct qc_info qinfo;
 		int ret;
diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index 0738972e8d3f..4f8f6bdc698c 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -34,7 +34,7 @@ static int __get_index(struct qtree_mem_dqinfo *info, qid_t id, int depth)
 
 static int get_index(struct qtree_mem_dqinfo *info, struct kqid qid, int depth)
 {
-	qid_t id = from_kqid(&init_user_ns, qid);
+	qid_t id = from_kqid(info->dqi_sb->s_user_ns, qid);
 
 	return __get_index(info, id, depth);
 }
@@ -554,7 +554,7 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
 	if (i == qtree_dqstr_in_blk(info)) {
 		quota_error(dquot->dq_sb,
 			    "Quota for id %u referenced but not present",
-			    from_kqid(&init_user_ns, dquot->dq_id));
+			    from_kqid(dquot->dq_sb->s_user_ns, dquot->dq_id));
 		ret = -EIO;
 		goto out_buf;
 	} else {
@@ -624,7 +624,7 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
 			if (offset < 0)
 				quota_error(sb,"Can't read quota structure "
 					    "for id %u",
-					    from_kqid(&init_user_ns,
+					    from_kqid(sb->s_user_ns,
 						      dquot->dq_id));
 			dquot->dq_off = 0;
 			set_bit(DQ_FAKE_B, &dquot->dq_flags);
@@ -643,7 +643,7 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
 		if (ret >= 0)
 			ret = -EIO;
 		quota_error(sb, "Error while reading quota structure for id %u",
-			    from_kqid(&init_user_ns, dquot->dq_id));
+			    from_kqid(sb->s_user_ns, dquot->dq_id));
 		set_bit(DQ_FAKE_B, &dquot->dq_flags);
 		memset(&dquot->dq_dqb, 0, sizeof(struct mem_dqblk));
 		kfree(ddquot);
@@ -721,13 +721,18 @@ out_buf:
 
 int qtree_get_next_id(struct qtree_mem_dqinfo *info, struct kqid *qid)
 {
-	qid_t id = from_kqid(&init_user_ns, *qid);
+	qid_t id = from_kqid(info->dqi_sb->s_user_ns, *qid);
+	struct kqid next_id;
 	int ret;
 
-	ret = find_next_id(info, &id, QT_TREEOFF, 0);
-	if (ret < 0)
-		return ret;
-	*qid = make_kqid(&init_user_ns, qid->type, id);
+	do {
+		ret = find_next_id(info, &id, QT_TREEOFF, 0);
+		if (ret < 0)
+			return ret;
+		next_id = make_kqid(info->dqi_sb->s_user_ns, qid->type, id);
+	} while (!qid_valid(next_id)); /* Loop until a mapped id is found */
+
+	*qid = next_id;
 	return 0;
 }
 EXPORT_SYMBOL(qtree_get_next_id);
diff --git a/fs/quota/quota_v1.c b/fs/quota/quota_v1.c
index 8fe79beced5c..087e7743b996 100644
--- a/fs/quota/quota_v1.c
+++ b/fs/quota/quota_v1.c
@@ -54,6 +54,7 @@ static void v1_mem2disk_dqblk(struct v1_disk_dqblk *d, struct mem_dqblk *m)
 
 static int v1_read_dqblk(struct dquot *dquot)
 {
+	struct user_namespace *dq_user_ns = dquot->dq_sb->s_user_ns;
 	int type = dquot->dq_id.type;
 	struct v1_disk_dqblk dqblk;
 
@@ -64,7 +65,7 @@ static int v1_read_dqblk(struct dquot *dquot)
 	memset(&dqblk, 0, sizeof(struct v1_disk_dqblk));
 	dquot->dq_sb->s_op->quota_read(dquot->dq_sb, type, (char *)&dqblk,
 			sizeof(struct v1_disk_dqblk),
-			v1_dqoff(from_kqid(&init_user_ns, dquot->dq_id)));
+			v1_dqoff(from_kqid(dq_user_ns, dquot->dq_id));
 
 	v1_disk2mem_dqblk(&dquot->dq_dqb, &dqblk);
 	if (dquot->dq_dqb.dqb_bhardlimit == 0 &&
@@ -79,6 +80,7 @@ static int v1_read_dqblk(struct dquot *dquot)
 
 static int v1_commit_dqblk(struct dquot *dquot)
 {
+	struct user_namespace *dq_user_ns = dquot->dq_sb->s_user_ns;
 	short type = dquot->dq_id.type;
 	ssize_t ret;
 	struct v1_disk_dqblk dqblk;
@@ -95,7 +97,7 @@ static int v1_commit_dqblk(struct dquot *dquot)
 	if (sb_dqopt(dquot->dq_sb)->files[type])
 		ret = dquot->dq_sb->s_op->quota_write(dquot->dq_sb, type,
 			(char *)&dqblk, sizeof(struct v1_disk_dqblk),
-			v1_dqoff(from_kqid(&init_user_ns, dquot->dq_id)));
+			v1_dqoff(from_kquid(dq_user_ns, dquot->dq_id)));
 	if (ret != sizeof(struct v1_disk_dqblk)) {
 		quota_error(dquot->dq_sb, "dquota write failed");
 		if (ret >= 0)
diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index ca71bf881ad1..4ecf91611a87 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -199,6 +199,7 @@ static void v2r0_disk2memdqb(struct dquot *dquot, void *dp)
 
 static void v2r0_mem2diskdqb(void *dp, struct dquot *dquot)
 {
+	struct user_namespace *dq_user_ns = dquot->dq_sb->s_user_ns;
 	struct v2r0_disk_dqblk *d = dp;
 	struct mem_dqblk *m = &dquot->dq_dqb;
 	struct qtree_mem_dqinfo *info =
@@ -212,7 +213,7 @@ static void v2r0_mem2diskdqb(void *dp, struct dquot *dquot)
 	d->dqb_bsoftlimit = cpu_to_le32(v2_stoqb(m->dqb_bsoftlimit));
 	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
 	d->dqb_btime = cpu_to_le64(m->dqb_btime);
-	d->dqb_id = cpu_to_le32(from_kqid(&init_user_ns, dquot->dq_id));
+	d->dqb_id = cpu_to_le32(from_kqid(dq_user_ns, dquot->dq_qid));
 	if (qtree_entry_unused(info, dp))
 		d->dqb_itime = cpu_to_le64(1);
 }
@@ -225,7 +226,7 @@ static int v2r0_is_id(void *dp, struct dquot *dquot)
 
 	if (qtree_entry_unused(info, dp))
 		return 0;
-	return qid_eq(make_kqid(&init_user_ns, dquot->dq_id.type,
+	return qid_eq(make_kqid(dquot->dq_sb->s_user_ns, quot->dq_id.type,
 				le32_to_cpu(d->dqb_id)),
 		      dquot->dq_id);
 }
@@ -252,6 +253,7 @@ static void v2r1_disk2memdqb(struct dquot *dquot, void *dp)
 
 static void v2r1_mem2diskdqb(void *dp, struct dquot *dquot)
 {
+	struct user_namespace *dq_user_ns = dquot->dq_sb->s_user_ns;
 	struct v2r1_disk_dqblk *d = dp;
 	struct mem_dqblk *m = &dquot->dq_dqb;
 	struct qtree_mem_dqinfo *info =
@@ -265,7 +267,7 @@ static void v2r1_mem2diskdqb(void *dp, struct dquot *dquot)
 	d->dqb_bsoftlimit = cpu_to_le64(v2_stoqb(m->dqb_bsoftlimit));
 	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
 	d->dqb_btime = cpu_to_le64(m->dqb_btime);
-	d->dqb_id = cpu_to_le32(from_kqid(&init_user_ns, dquot->dq_id));
+	d->dqb_id = cpu_to_le32(from_kqid(dq_user_ns, dquot->dq_id));
 	if (qtree_entry_unused(info, dp))
 		d->dqb_itime = cpu_to_le64(1);
 }
@@ -278,7 +280,7 @@ static int v2r1_is_id(void *dp, struct dquot *dquot)
 
 	if (qtree_entry_unused(info, dp))
 		return 0;
-	return qid_eq(make_kqid(&init_user_ns, dquot->dq_id.type,
+	return qid_eq(make_kqid(dquot->dq_sb->s_user_ns, dquot->dq_id.type,
 				le32_to_cpu(d->dqb_id)),
 		      dquot->dq_id);
 }
-- 
2.8.3
