From: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC v4 28/31] nfsd: Keep list of acls to dispose of in compoundargs
Date: Wed, 24 Jun 2015 23:57:17 +0200
Message-ID: <1435183040-22726-29-git-send-email-agruenba@redhat.com>
References: <1435183040-22726-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435183040-22726-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

We will decode acls in requests into richacls.  Even if unlikely, there can be
more than one acl in a single request; those richacls need to be richacl_put()
at the end of the request instead of kfree()d, so keep a list of acls in
compoundargs for that.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/nfsd/nfs4xdr.c | 26 ++++++++++++++++++++++++++
 fs/nfsd/xdr4.h    |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ba81da1..277d9d8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -39,6 +39,7 @@
 #include <linux/utsname.h>
 #include <linux/pagemap.h>
 #include <linux/sunrpc/svcauth_gss.h>
+#include <linux/richacl.h>
 
 #include "idmap.h"
 #include "acl.h"
@@ -195,6 +196,24 @@ svcxdr_tmpalloc(struct nfsd4_compoundargs *argp, u32 len)
 	return tb->buf;
 }
 
+static struct richacl *
+svcxdr_alloc_richacl(struct nfsd4_compoundargs *argp, u32 nace)
+{
+	struct svcxdr_richacl *acls;
+
+	acls = kmalloc(sizeof(*acls), GFP_KERNEL);
+	if (!acls)
+		return NULL;
+	acls->acl = richacl_alloc(nace, GFP_KERNEL);
+	if (!acls->acl) {
+		kfree(acls);
+		return NULL;
+	}
+	acls->next = argp->acls;
+	argp->acls = acls;
+	return acls->acl;
+}
+
 /*
  * For xdr strings that need to be passed to other kernel api's
  * as null-terminated strings.
@@ -4394,6 +4413,12 @@ int nfsd4_release_compoundargs(void *rq, __be32 *p, void *resp)
 		args->to_free = tb->next;
 		kfree(tb);
 	}
+	while (args->acls) {
+		struct svcxdr_richacl *acls = args->acls;
+		args->acls = acls->next;
+		richacl_put(acls->acl);
+		kfree(acls);
+	}
 	return 1;
 }
 
@@ -4412,6 +4437,7 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, __be32 *p, struct nfsd4_comp
 	args->pagelen = rqstp->rq_arg.page_len;
 	args->tmpp = NULL;
 	args->to_free = NULL;
+	args->acls = NULL;
 	args->ops = args->iops;
 	args->rqstp = rqstp;
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 2f8c092..db47af2 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -569,6 +569,11 @@ struct svcxdr_tmpbuf {
 	char buf[];
 };
 
+struct svcxdr_richacl {
+	struct svcxdr_richacl *next;
+	struct richacl *acl;
+};
+
 struct nfsd4_compoundargs {
 	/* scratch variables for XDR decode */
 	__be32 *			p;
@@ -578,6 +583,7 @@ struct nfsd4_compoundargs {
 	__be32				tmp[8];
 	__be32 *			tmpp;
 	struct svcxdr_tmpbuf		*to_free;
+	struct svcxdr_richacl		*acls;
 
 	struct svc_rqst			*rqstp;
 
-- 
2.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
