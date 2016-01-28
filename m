From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v8 2/4] kobject: export kset_find_obj() for module use
Date: Thu, 28 Jan 2016 09:23:12 -0500
Message-ID: <1453990994-17801-3-git-send-email-somlo@cmu.edu>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com, peter.maydell@linaro.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com, kraxel@redhat.com, ehabkost@redhat.com, luto@amacapital.net, stefanha@gmail.com, revol@free.fr, matt@codeblueprint.co.uk, rth@twiddle.net
List-Id: linux-api@vger.kernel.org

From: Gabriel Somlo <somlo@cmu.edu>

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
---
 lib/kobject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kobject.c b/lib/kobject.c
index 7cbccd2..90d1be6 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -861,6 +861,7 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 	spin_unlock(&kset->list_lock);
 	return ret;
 }
+EXPORT_SYMBOL(kset_find_obj);
 
 static void kset_release(struct kobject *kobj)
 {
-- 
2.4.3
