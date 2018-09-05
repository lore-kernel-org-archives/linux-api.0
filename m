From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/11] UAPI: bcache: Fix use of embedded flexible array
Date: Wed, 05 Sep 2018 16:55:03 +0100
Message-ID: <153616290368.23468.7806230605345568524.stgit@warthog.procyon.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

The bkey struct defined by bcache is embedded in the jset struct.  However,
this is illegal in C++ as there's a "flexible array" at the end of the
struct.  Change this to be a 0-length struct instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Coly Li <colyli@suse.de>
cc: Kent Overstreet <kent.overstreet@gmail.com>
cc: linux-bcache@vger.kernel.org
---

 include/uapi/linux/bcache.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 5d4f58e059fd..11863e903bff 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -23,7 +23,7 @@ static inline void SET_##name(type *k, __u64 v)			\
 struct bkey {
 	__u64	high;
 	__u64	low;
-	__u64	ptr[];
+	__u64	ptr[0];
 };
 
 #define KEY_FIELD(name, field, offset, size)				\
