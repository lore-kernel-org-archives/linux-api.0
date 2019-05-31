From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V6] fixup! audit: add containerid filtering
Date: Fri, 31 May 2019 13:53:36 -0400
Message-ID: <fadb320e38a899441fcc693bbbc822a3b57f1a46.1559239558.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, nhorman@tuxdriver.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Remove the BUG() call since we will never have an invalid op value as
audit_data_to_entry()/audit_to_op() ensure that the op value is a a
known good value.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditfilter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 407b5bb3b4c6..385a114a1254 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1244,7 +1244,6 @@ int audit_comparator64(u64 left, u32 op, u64 right)
 	case Audit_bittest:
 		return ((left & right) == right);
 	default:
-		BUG();
 		return 0;
 	}
 }
-- 
1.8.3.1
