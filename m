From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak90 (was ghak32) V3 10/10] rfkill: fix spelling mistake contidion to condition
Date: Wed,  6 Jun 2018 12:58:37 -0400
Message-ID: <6118147ea27ab5831956cf9dcad15b241c791420.1528304204.git.rgb@redhat.com>
References: <cover.1528304203.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1528304203.git.rgb@redhat.com>
In-Reply-To: <cover.1528304203.git.rgb@redhat.com>
References: <cover.1528304203.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/rfkill/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 59d0eb9..e89a009 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -494,7 +494,7 @@ void rfkill_remove_epo_lock(void)
 /**
  * rfkill_is_epo_lock_active - returns true EPO is active
  *
- * Returns 0 (false) if there is NOT an active EPO contidion,
+ * Returns 0 (false) if there is NOT an active EPO condition,
  * and 1 (true) if there is an active EPO contition, which
  * locks all radios in one of the BLOCKED states.
  *
-- 
1.8.3.1
