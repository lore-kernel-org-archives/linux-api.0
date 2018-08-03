From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH v3 1/2] fork: do not rely on SIGNAL_UNKILLABLE for init check
Date: Fri,  3 Aug 2018 16:40:20 +0200
Message-ID: <20180803144021.56920-1-j@bitron.ch>
References: <20180730075241.24002-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180730075241.24002-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
List-Id: linux-api@vger.kernel.org

copy_process() currently checks the SIGNAL_UNKILLABLE flag to determine
whether to accept CLONE_PARENT. In preparation for allowing init
processes to opt out of SIGNAL_UNKILLABLE, directly check whether the
process is an init process with is_child_reaper().

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1b27babc4c78..c019ce461556 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1646,7 +1646,7 @@ static __latent_entropy struct task_struct *copy_process(
 	 * from creating siblings.
 	 */
 	if ((clone_flags & CLONE_PARENT) &&
-				current->signal->flags & SIGNAL_UNKILLABLE)
+				is_child_reaper(task_tgid(current)))
 		return ERR_PTR(-EINVAL);
 
 	/*
-- 
2.18.0
