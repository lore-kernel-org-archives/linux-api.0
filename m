From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 12/21] Drivers: hv: fcopy: set .owner reference for file
 operations
Date: Thu,  9 Apr 2015 10:38:41 +0200
Message-ID: <1428568730-6030-13-git-send-email-vkuznets@redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

... otherwise a crash is observed when hv_utils module is being unloaded while
fcopy daemon is still running. .owner gives us an additional reference when
someone holds a descriptor for the device.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_fcopy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index a501301..d1475e6 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -360,12 +360,9 @@ static int fcopy_open(struct inode *inode, struct file *f)
 }
 
 /* XXX: there are still some tricky corner cases, e.g.,
- * 1) In a SMP guest, when fcopy_release() runs between
+ * In an SMP guest, when fcopy_release() runs between
  * schedule_delayed_work() and fcopy_send_data(), there is
  * still a chance an obsolete message will be queued.
- *
- * 2) When the fcopy daemon is running, if we unload the driver,
- * we'll notice a kernel oops when we kill the daemon later.
  */
 static int fcopy_release(struct inode *inode, struct file *f)
 {
@@ -385,6 +382,7 @@ static int fcopy_release(struct inode *inode, struct file *f)
 
 
 static const struct file_operations fcopy_fops = {
+	.owner          = THIS_MODULE,
 	.read           = fcopy_read,
 	.write          = fcopy_write,
 	.release	= fcopy_release,
-- 
1.9.3
