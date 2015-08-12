From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH] fs: Set the size of empty dirs to 0.
Date: Wed, 12 Aug 2015 15:07:19 -0500
Message-ID: <87mvxw46fc.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<878ucrhxi9.fsf@x220.int.ebiederm.org>
	<20150811184426.GH23408@mtj.duckdns.org>
	<877fp1hcuj.fsf@x220.int.ebiederm.org>
	<CAOS58YOHU8SFv4UXeBRr4t88UU=DXQCPg2HU_dMBmgM7WBB1zQ@mail.gmail.com>
	<87fv3pe3zn.fsf@x220.int.ebiederm.org>
	<87a8txb1k8.fsf@x220.int.ebiederm.org>
	<871tf9b19v.fsf@x220.int.ebiederm.org>
	<20150812191515.GA4496@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150812191515.GA4496-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Wed, 12 Aug 2015 15:15:15 -0400")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, LINUXFS-ML <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Before the make_empty_dir_inode calls were introduce into proc, sysfs,
and sysctl those directories when stated reported an i_size of 0.
make_empty_dir_inode started reporting an i_size of 2.  At least one
userspace application depended on stat returning i_size of 0.  So modify
make_empty_dir_inode to cause an i_size of 0 to be reported for these
directories.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reproted-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---

I have tested this and will queue this up shortly.

 fs/libfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 102edfd39000..c7cbfb092e94 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1185,7 +1185,7 @@ void make_empty_dir_inode(struct inode *inode)
 	inode->i_uid = GLOBAL_ROOT_UID;
 	inode->i_gid = GLOBAL_ROOT_GID;
 	inode->i_rdev = 0;
-	inode->i_size = 2;
+	inode->i_size = 0;
 	inode->i_blkbits = PAGE_SHIFT;
 	inode->i_blocks = 0;
 
-- 
2.2.1
