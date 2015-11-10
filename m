From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH 4/5] samples: livepatch: init reloc list and mark as klp module
Date: Mon,  9 Nov 2015 23:45:54 -0500
Message-ID: <1447130755-17383-5-git-send-email-jeyu@redhat.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Intialize the list of relocation sections in the sample
klp_object (even if the list will be empty in this case).
Also mark module as a livepatch module so that the module
loader can appropriately initialize it.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 samples/livepatch/livepatch-sample.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index fb8c861..2ef9345 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -57,6 +57,7 @@ static struct klp_object objs[] = {
 	{
 		/* name being NULL means vmlinux */
 		.funcs = funcs,
+		.reloc_secs = LIST_HEAD_INIT(objs[0].reloc_secs)
 	}, { }
 };
 
@@ -89,3 +90,4 @@ static void livepatch_exit(void)
 module_init(livepatch_init);
 module_exit(livepatch_exit);
 MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
-- 
2.4.3
