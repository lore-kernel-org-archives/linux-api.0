From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH 2/3] kobject: export kset_find_obj() to be used
	from modules
Date: Mon, 10 Aug 2015 12:31:19 -0400
Message-ID: <5c2bafb073e1386e39c4f73a83e7d835547b6b1f.1439220623.git.somlo@cmu.edu>
References: <cover.1439220623.git.somlo@cmu.edu>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <cover.1439220623.git.somlo@cmu.edu>
In-Reply-To: <cover.1439220623.git.somlo@cmu.edu>
References: <cover.1439220623.git.somlo@cmu.edu>
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
index 3e3a5c3..f9754a0 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -1058,3 +1058,4 @@ EXPORT_SYMBOL(kobject_del);
 
 EXPORT_SYMBOL(kset_register);
 EXPORT_SYMBOL(kset_unregister);
+EXPORT_SYMBOL(kset_find_obj);
-- 
2.4.3
