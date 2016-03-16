From: Jessica Yu <jeyu@redhat.com>
Subject: [PATCH v5 5/6] samples: livepatch: mark as livepatch module
Date: Wed, 16 Mar 2016 15:47:07 -0400
Message-ID: <1458157628-8264-6-git-send-email-jeyu@redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Mark the module as a livepatch module so that the module loader can
appropriately identify and initialize it.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 samples/livepatch/livepatch-sample.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index fb8c861..e34f871 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -89,3 +89,4 @@ static void livepatch_exit(void)
 module_init(livepatch_init);
 module_exit(livepatch_exit);
 MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
-- 
2.4.3
