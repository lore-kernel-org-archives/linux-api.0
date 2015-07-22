From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [PATCH v5 34/39] sunrpc: Allow to demand-allocate pages to encode into
Date: Wed, 22 Jul 2015 15:03:24 +0200
Message-ID: <1437570209-29832-35-git-send-email-andreas.gruenbacher@gmail.com>
References: <1437570209-29832-1-git-send-email-andreas.gruenbacher@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437570209-29832-1-git-send-email-andreas.gruenbacher@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, samba-technical@lists.samba.org, linux-security-module@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
List-Id: linux-api@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

When encoding large, variable-length objects such as acls into xdr_bufs, it is
easier to allocate buffer pages on demand rather than precomputing the required
buffer size.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 net/sunrpc/xdr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 4439ac4..e6a1744 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -537,6 +537,14 @@ static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
 	 */
 	xdr->scratch.iov_base = xdr->p;
 	xdr->scratch.iov_len = frag1bytes;
+
+	if (!*xdr->page_ptr) {
+		struct page *page = alloc_page(GFP_NOFS);
+		if (!page)
+			return NULL;
+		*xdr->page_ptr = page;
+	}
+
 	p = page_address(*xdr->page_ptr);
 	/*
 	 * Note this is where the next encode will start after we've
-- 
2.4.3
