From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH v2 5/6] samples: livepatch: init reloc section array and mark as klp module
Date: Mon, 30 Nov 2015 23:21:18 -0500
Message-ID: <1448943679-3412-6-git-send-email-jeyu@redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Create the array of klp relocation sections in the sample
klp_object (even if the array is empty in this case).

In addition, mark the module as a livepatch module so that
the module loader can appropriately identify and initialize it.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 samples/livepatch/livepatch-sample.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
index fb8c861..298dc21 100644
--- a/samples/livepatch/livepatch-sample.c
+++ b/samples/livepatch/livepatch-sample.c
@@ -53,10 +53,15 @@ static struct klp_func funcs[] = {
 	}, { }
 };
 
+static struct klp_reloc_sec reloc_secs[] = {
+	{ }
+};
+
 static struct klp_object objs[] = {
 	{
 		/* name being NULL means vmlinux */
 		.funcs = funcs,
+		.reloc_secs = reloc_secs,
 	}, { }
 };
 
@@ -89,3 +94,4 @@ static void livepatch_exit(void)
 module_init(livepatch_init);
 module_exit(livepatch_exit);
 MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
-- 
2.4.3
