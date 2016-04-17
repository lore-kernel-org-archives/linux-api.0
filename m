From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 1/2] kernfs_path_from_node_locked: don't overwrite nlen
Date: Sun, 17 Apr 2016 15:04:31 -0500
Message-ID: <1460923472-29370-2-git-send-email-serge.hallyn@ubuntu.com>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1460923472-29370-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

We've calculated @len to be the bytes we need for '/..' entries from
@kn_from to the common ancestor, and calculated @nlen to be the extra
bytes we need to get from the common ancestor to @kn_to.  We use them
as such at the end.  But in the loop copying the actual entries, we
overwrite @nlen.  Use a temporary variable for that instead.

Without this, the return length, when the buffer is large enough, is
wrong.  (When the buffer is NULL or too small, the returned value is
correct. The buffer contents are also correct.)

Interestingly, no callers of this function are affected by this as of
yet.  However the upcoming cgroup_show_path() will be.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 03b688d..37f9678 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -153,9 +153,9 @@ static int kernfs_path_from_node_locked(struct kernfs_node *kn_to,
 	p = buf + len + nlen;
 	*p = '\0';
 	for (kn = kn_to; kn != common; kn = kn->parent) {
-		nlen = strlen(kn->name);
-		p -= nlen;
-		memcpy(p, kn->name, nlen);
+		size_t tmp = strlen(kn->name);
+		p -= tmp;
+		memcpy(p, kn->name, tmp);
 		*(--p) = '/';
 	}
 
-- 
2.7.4
