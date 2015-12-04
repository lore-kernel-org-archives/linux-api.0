From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 2/4] kobject: export kset_find_obj() for
	module use
Date: Fri,  4 Dec 2015 10:29:04 -0500
Message-ID: <1449242946-12062-3-git-send-email-somlo@cmu.edu>
References: <1449242946-12062-1-git-send-email-somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1449242946-12062-1-git-send-email-somlo@cmu.edu>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.maydell@linaro.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, jordan.l.justen@intel.com, mst@redhat.com, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, kraxel@redhat.com, stefanha@gmail.com, pbonzini@redhat.com, revol@free.fr
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
