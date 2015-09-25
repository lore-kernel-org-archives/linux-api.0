From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 25/41] richacl: Isolate the owner and group classes
Date: Fri, 25 Sep 2015 13:25:41 +0200
Message-ID: <1443180341-22911-1-git-send-email-agruenba@redhat.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com> <1441448856-13478-26-git-send-email-agruenba@redhat.com> <20150922190224.GA19127@fieldses.org> <CAHc6FU7_+fbyG0mEu3pUkfaV72AM0DzJnBES=b--koXJgo0a2g@mail.gmail.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU7_+fbyG0mEu3pUkfaV72AM0DzJnBES=b--koXJgo0a2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is another minor improvement that produces deny aces with fewer
permissions in them and avoids creating unnecessary deny aces in some
cases.

Andreas

---
 fs/richacl_compat.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
index 2f53394..bc0bcfe 100644
--- a/fs/richacl_compat.c
+++ b/fs/richacl_compat.c
@@ -605,14 +605,13 @@ __richacl_isolate_who(struct richacl_alloc *alloc, struct richace *who,
 	int n;
 
 	/*
-	 * Compute the permissions already denied to @who.  There are no
+	 * Compute the permissions already defined for @who.  There are no
 	 * everyone@ deny aces left in the acl at this stage.
 	 */
 	richacl_for_each_entry(ace, acl) {
 		if (richace_is_inherit_only(ace))
 			continue;
-		if (richace_is_same_identifier(acl, ace, who) &&
-		    richace_is_deny(ace))
+		if (richace_is_same_identifier(acl, ace, who))
 			deny &= ~ace->e_mask;
 	}
 	if (!deny)
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
