From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v7 28/41] nfsd: Keep list of acls to dispose of in compoundargs
Date: Sat,  5 Sep 2015 12:27:23 +0200
Message-ID: <1441448856-13478-29-git-send-email-agruenba@redhat.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441448856-13478-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

We will decode acls in requests into richacls.  Even if unlikely, there
can be more than one acl in a single request; those richacls need to be
richacl_put() at the end of the request instead of kfree()d, so keep a
list of acls in compoundargs for that.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/nfsd/nfs4xdr.c | 27 +++++++++++++++++++++++++++
 fs/nfsd/xdr4.h    |  6 ++++++
 2 files changed, 33 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 75e0563..0768251 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -40,6 +40,7 @@
 #include <linux/utsname.h>
 #include <linux/pagemap.h>
 #include <linux/sunrpc/svcauth_gss.h>
+#include <linux/richacl.h>
 
 #include "idmap.h"
 #include "acl.h"
@@ -196,6 +197,24 @@ svcxdr_tmpalloc(struct nfsd4_compoundargs *argp, u32 len)
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
@@ -4395,6 +4414,13 @@ int nfsd4_release_compoundargs(void *rq, __be32 *p, void *resp)
 		args->to_free = tb->next;
 		kfree(tb);
 	}
+	while (args->acls) {
+		struct svcxdr_richacl *acls = args->acls;
+
+		args->acls = acls->next;
+		richacl_put(acls->acl);
+		kfree(acls);
+	}
 	return 1;
 }
 
@@ -4413,6 +4439,7 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, __be32 *p, struct nfsd4_comp
 	args->pagelen = rqstp->rq_arg.page_len;
 	args->tmpp = NULL;
 	args->to_free = NULL;
+	args->acls = NULL;
 	args->ops = args->iops;
 	args->rqstp = rqstp;
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 9f99100..b698585 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -570,6 +570,11 @@ struct svcxdr_tmpbuf {
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
@@ -579,6 +584,7 @@ struct nfsd4_compoundargs {
 	__be32				tmp[8];
 	__be32 *			tmpp;
 	struct svcxdr_tmpbuf		*to_free;
+	struct svcxdr_richacl		*acls;
 
 	struct svc_rqst			*rqstp;
 
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
