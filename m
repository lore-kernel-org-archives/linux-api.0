From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v3 3/4] kobject: export kset_find_obj() for
	module use
Date: Sat,  3 Oct 2015 19:28:08 -0400
Message-ID: <1443914889-9619-4-git-send-email-somlo@cmu.edu>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, paul@pwsan.com, galak@codeaurora.org, will.deacon@arm.com, agross@codeaurora.org, mark.rutland@arm.com, zajec5@gmail.com, hanjun.guo@linaro.org, catalin.marinas@arm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peter.maydell@linaro.org, matt.fleming@intel.com, mst@redhat.com, jordan.l.justen@intel.com, kernelnewbies@kernelnewbies.org, qemu-devel@nongnu.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, kraxel@redhat.com, pbonzini@redhat.com, lersek@redhat.com
List-Id: linux-api@vger.kernel.org

From: Gabriel Somlo <somlo@cmu.edu>

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
---
 lib/kobject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kobject.c b/lib/kobject.c
index 3e3a5c3..bea2c9b 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -842,6 +842,7 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 	spin_unlock(&kset->list_lock);
 	return ret;
 }
+EXPORT_SYMBOL(kset_find_obj);
 
 static void kset_release(struct kobject *kobj)
 {
-- 
2.4.3
