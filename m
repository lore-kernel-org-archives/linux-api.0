From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v2 2/3] kobject: export kset_find_obj() to be
	used from modules
Date: Tue, 11 Aug 2015 14:44:48 -0400
Message-ID: <bee098d13c9c7b7b688e71ceb55787766a58f847.1439315079.git.somlo@cmu.edu>
References: <cover.1439315079.git.somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <cover.1439315079.git.somlo@cmu.edu>
In-Reply-To: <cover.1439315079.git.somlo@cmu.edu>
References: <cover.1439315079.git.somlo@cmu.edu>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, ralf@linux-mips.org, zajec5@gmail.com, paul@pwsan.com, galak@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, rjones@redhat.com, jordan.l.justen@intel.com, x86@kernel.org, qemu-devel@nongnu.org, gleb@cloudius-systems.com, matt.fleming@intel.com, kernelnewbies@kernelnewbies.org, kraxel@redhat.com, pbonzini@redhat.com, lersek@redhat.com
List-Id: linux-api@vger.kernel.org

From: "Gabriel Somlo" <somlo@cmu.edu>

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
---
 lib/kobject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kobject.c b/lib/kobject.c
index 0554077..8f07202 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -847,6 +847,7 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 	spin_unlock(&kset->list_lock);
 	return ret;
 }
+EXPORT_SYMBOL(kset_find_obj);
 
 static void kset_release(struct kobject *kobj)
 {
-- 
2.4.3
