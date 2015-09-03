From: David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 1/3] inotify: move wd lookup out of update_existing_watch()
Date: Thu,  3 Sep 2015 17:10:25 +0200
Message-ID: <1441293027-3363-2-git-send-email-dh.herrmann@gmail.com>
References: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

Currently, inotify_update_existing_watch() first looks up the requested
wd before modifying it. This makes the function unsuitable for cases
where we already know the wd. Change the behavior to directly accept wd
as input and make the only caller do the lookup themself.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 fs/notify/inotify/inotify_user.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 5b1e2a4..5a39ae8 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -513,23 +513,16 @@ static void inotify_free_mark(struct fsnotify_mark *fsn_mark)
 	kmem_cache_free(inotify_inode_mark_cachep, i_mark);
 }
 
-static int inotify_update_existing_watch(struct fsnotify_group *group,
-					 struct inode *inode,
+static int inotify_update_existing_watch(struct fsnotify_mark *fsn_mark,
 					 u32 arg)
 {
-	struct fsnotify_mark *fsn_mark;
+	struct inode *inode = fsn_mark->inode;
 	struct inotify_inode_mark *i_mark;
 	__u32 old_mask, new_mask;
 	__u32 mask;
 	int add = (arg & IN_MASK_ADD);
-	int ret;
 
 	mask = inotify_arg_to_mask(arg);
-
-	fsn_mark = fsnotify_find_inode_mark(group, inode);
-	if (!fsn_mark)
-		return -ENOENT;
-
 	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
 	spin_lock(&fsn_mark->lock);
@@ -555,13 +548,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 
 	}
 
-	/* return the wd */
-	ret = i_mark->wd;
-
-	/* match the get from fsnotify_find_mark() */
-	fsnotify_put_mark(fsn_mark);
-
-	return ret;
+	return i_mark->wd;
 }
 
 static int inotify_new_watch(struct fsnotify_group *group,
@@ -616,14 +603,19 @@ out_err:
 
 static int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
 {
+	struct fsnotify_mark *fsn_mark;
 	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
-	/* try to update and existing watch with the new arg */
-	ret = inotify_update_existing_watch(group, inode, arg);
-	/* no mark present, try to add a new one */
-	if (ret == -ENOENT)
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
+	if (fsn_mark) {
+		/* update an existing watch with the new arg */
+		ret = inotify_update_existing_watch(fsn_mark, arg);
+		fsnotify_put_mark(fsn_mark);
+	} else {
+		/* no mark present, try to add a new one */
 		ret = inotify_new_watch(group, inode, arg);
+	}
 	mutex_unlock(&group->mark_mutex);
 
 	return ret;
-- 
2.5.1
