From: Andrei Vagin <avagin@openvz.org>
Subject: [PATCH v2 RFC] mnt: umount mounts one by one in umount_tree()
Date: Fri, 12 May 2017 11:56:52 -0700
Message-ID: <20170512185652.10993-1-avagin@openvz.org>
References: <20170512070838.5037-1-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170512070838.5037-1-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, Linux Containers <containers@lists.linux-foundation.org>, Andrei Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

With this patch, we don't try to umount all mounts of a tree together.
Instead of this we umount them one by one. In this case, we see a significant
improvement in performance for the worsе case.

v2: create a sorted list of mounts, so that umount a child before its
parent.

The reason of this optimization is that umount() can hold namespace_sem
for a long time, this semaphore is global, so it affects all users.
Recently Eric W. Biederman added a per mount namespace limit on the
number of mounts. The default number of mounts allowed per mount
namespace at 100,000. Currently this value is allowed to construct a tree
which requires hours to be umounted.

In a worse case the current complexity of umount_tree() is O(n^3).
* Enumirate all mounts in a target tree (propagate_umount)
* Enumirate mounts to find where these changes have to
  be propagated (mark_umount_candidates)
* Enumirate mounts to find a requered mount by parent and dentry
  (__lookup_mnt). __lookup_mnt() searches a mount in m_hash, but
  the number of mounts is much bigger than a size of the hash.

The worse case is when all mounts from the tree live in the same shared
group. In this case we have to enumirate all mounts on each step.

There is CVE-2016-6213 about this case.

Here are results for the kernel with this patch
$ for i in `seq 10 15`; do  unshare -m sh ./run.sh $i; done
umount -l /mnt/1 -> 	0:00.00
umount -l /mnt/1 -> 	0:00.01
umount -l /mnt/1 -> 	0:00.01
umount -l /mnt/1 -> 	0:00.03
umount -l /mnt/1 -> 	0:00.07
umount -l /mnt/1 -> 	0:00.14

Here are results for the kernel without this patch
$ for i in `seq 10 15`; do  unshare -m sh ./run.sh $i; done
umount -l /mnt/1 -> 	0:00.04
umount -l /mnt/1 -> 	0:00.17
umount -l /mnt/1 -> 	0:00.75
umount -l /mnt/1 -> 	0:05.96
umount -l /mnt/1 -> 	0:34.40
umount -l /mnt/1 -> 	3:46.27

And here is a test script:
$ cat run.sh
set -e -m

mount -t tmpfs zdtm /mnt
mkdir -p /mnt/1 /mnt/2
mount -t tmpfs zdtm /mnt/1
mount --make-shared /mnt/1
mkdir /mnt/1/1

for i in `seq $1`; do
	./mount --bind /mnt/1/1 /mnt/1/1
done

echo -n "umount -l /mnt/1 -> "
/usr/bin/time -f '%E' ./umount -l /mnt/1

And we need these simple mount and umount tools, because the standard
ones read /proc/self/mountinfo, but this is extremely slow when we have
thousands of mounts.
$ cat mount.c
 #include <sys/mount.h>
 #include <stdlib.h>

 int main(int argc, char **argv)
 {
 	return mount(argv[2], argv[3], NULL, MS_BIND, NULL);
 }

$ cat umount.c
 #include <sys/mount.h>

 int main(int argc, char **argv)
 {
 	return umount2(argv[2], MNT_DETACH);
 }

Here is a previous attempt to optimize this code:
https://lkml.org/lkml/2016/10/10/495

Signed-off-by: Andrei Vagin <avagin@openvz.org>
---
 fs/namespace.c | 105 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 38 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3bf0cd2..4f7e36c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1468,62 +1468,91 @@ static bool disconnect_mount(struct mount *mnt, enum umount_tree_flags how)
 	return true;
 }
 
+/* post-order depth-first search */
+static struct mount *next_kid(struct mount *p, struct mount *root)
+{
+	if (p == NULL) {
+		p = root;
+		goto out;
+	}
+	if (p->mnt_child.next != &p->mnt_parent->mnt_mounts) {
+		p = list_entry(p->mnt_child.next, struct mount, mnt_child);
+		goto out;
+	}
+
+	return p->mnt_parent;
+
+out:
+	while (!list_empty(&p->mnt_mounts))
+		p = list_first_entry(&p->mnt_mounts, struct mount, mnt_child);
+	return p;
+}
+
 /*
  * mount_lock must be held
  * namespace_sem must be held for write
  */
 static void umount_tree(struct mount *mnt, enum umount_tree_flags how)
 {
-	LIST_HEAD(tmp_list);
 	struct mount *p;
+	LIST_HEAD(post_order_list);
+
+	/* Create a list of mounts to in an order to umount them */
+	p = NULL;
+	while (1) {
+		p = next_kid(p, mnt);
+		list_move_tail(&p->mnt_list, &post_order_list);
+		if (p == mnt)
+			break;
+	}
 
 	if (how & UMOUNT_PROPAGATE)
 		propagate_mount_unlock(mnt);
 
 	/* Gather the mounts to umount */
-	for (p = mnt; p; p = next_mnt(p, mnt)) {
+	while (!list_empty(&post_order_list)) {
+		LIST_HEAD(tmp_list);
+
+		p = list_first_entry(&post_order_list, struct mount, mnt_list);
+
 		p->mnt.mnt_flags |= MNT_UMOUNT;
 		list_move(&p->mnt_list, &tmp_list);
-	}
-
-	/* Hide the mounts from mnt_mounts */
-	list_for_each_entry(p, &tmp_list, mnt_list) {
 		list_del_init(&p->mnt_child);
-	}
 
-	/* Add propogated mounts to the tmp_list */
-	if (how & UMOUNT_PROPAGATE)
-		propagate_umount(&tmp_list);
-
-	while (!list_empty(&tmp_list)) {
-		struct mnt_namespace *ns;
-		bool disconnect;
-		p = list_first_entry(&tmp_list, struct mount, mnt_list);
-		list_del_init(&p->mnt_expire);
-		list_del_init(&p->mnt_list);
-		ns = p->mnt_ns;
-		if (ns) {
-			ns->mounts--;
-			__touch_mnt_namespace(ns);
-		}
-		p->mnt_ns = NULL;
-		if (how & UMOUNT_SYNC)
-			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
-
-		disconnect = disconnect_mount(p, how);
-
-		pin_insert_group(&p->mnt_umount, &p->mnt_parent->mnt,
-				 disconnect ? &unmounted : NULL);
-		if (mnt_has_parent(p)) {
-			mnt_add_count(p->mnt_parent, -1);
-			if (!disconnect) {
-				/* Don't forget about p */
-				list_add_tail(&p->mnt_child, &p->mnt_parent->mnt_mounts);
-			} else {
-				umount_mnt(p);
+		/* Add propogated mounts to the tmp_list */
+		if (how & UMOUNT_PROPAGATE)
+			propagate_umount(&tmp_list);
+
+		while (!list_empty(&tmp_list)) {
+			struct mnt_namespace *ns;
+			bool disconnect;
+			p = list_first_entry(&tmp_list, struct mount, mnt_list);
+			list_del_init(&p->mnt_expire);
+			list_del_init(&p->mnt_list);
+			ns = p->mnt_ns;
+			if (ns) {
+				ns->mounts--;
+				__touch_mnt_namespace(ns);
+			}
+			p->mnt_ns = NULL;
+			if (how & UMOUNT_SYNC)
+				p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
+
+			disconnect = disconnect_mount(p, how);
+
+			pin_insert_group(&p->mnt_umount, &p->mnt_parent->mnt,
+					 disconnect ? &unmounted : NULL);
+			if (mnt_has_parent(p)) {
+				mnt_add_count(p->mnt_parent, -1);
+				if (!disconnect) {
+					/* Don't forget about p */
+					list_add_tail(&p->mnt_child, &p->mnt_parent->mnt_mounts);
+				} else {
+					umount_mnt(p);
+				}
 			}
+			change_mnt_propagation(p, MS_PRIVATE);
 		}
-		change_mnt_propagation(p, MS_PRIVATE);
 	}
 }
 
-- 
2.9.3
