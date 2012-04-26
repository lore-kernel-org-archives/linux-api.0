From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/6] xstat: NFS: Return extended attributes
Date: Thu, 26 Apr 2012 14:52:40 +0100
Message-ID: <19094.1335448360@redhat.com>
References: <1334846149.21419.22.camel@lade.trondhjem.org> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419140653.17272.95035.stgit@warthog.procyon.org.uk>
Return-path: <libc-alpha-return-27991-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <1334846149.21419.22.camel@lade.trondhjem.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "wine-devel@winehq.org" <wine-devel@winehq.org>, "kfm-devel@kde.org" <kfm-devel@kde.org>, "nautilus-list@gnome.org" <nautilus-list@gnome.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

Myklebust, Trond <Trond.Myklebust@netapp.com> wrote:

> Hmm... As far as I can see you are still doing an nfs_revalidate_inode()
> in the non-forced case. That will cause expired attributes to be
> retrieved from the server.

Revalidation is only done when you force it or explicitly ask for a basic stat
or the data version number:

-	if (need_atime)
-		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	else
-		err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	if (!err) {
-		generic_fillattr(inode, stat);
-		stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+	if (force || stat->request_mask & (XSTAT_BASIC_STATS | XSTAT_VERSION)) {
+		if (force || need_atime)
+			err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		else
+			err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		if (err)
+			goto out;

Unfortunately, I think I have to revalidate if any of XSTAT_BASIC_STATS are
requested to maintain compatibility with stat() so that stat() can be done
with xstat().  On the other hand, stat() could be done by userspace with
xstat() and AT_FORCE_ATTR_SYNC, I suppose.

David
