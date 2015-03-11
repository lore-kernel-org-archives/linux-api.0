From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 07/21] Drivers: hv: fcopy: rename fcopy_work ->
 fcopy_timeout_work
Date: Wed, 11 Mar 2015 14:29:20 +0100
Message-ID: <1426080574-9011-8-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
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

'fcopy_work' (and fcopy_work_func) is a misnomer as it sounds like we expect
this useful work to happen and in reality it is just an emergency escape when
timeout happens.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_fcopy.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 8bdf752..c14f0f4 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -75,11 +75,11 @@ static bool opened; /* currently device opened */
 static bool in_hand_shake = true;
 static void fcopy_send_data(void);
 static void fcopy_respond_to_host(int error);
-static void fcopy_work_func(struct work_struct *dummy);
-static DECLARE_DELAYED_WORK(fcopy_work, fcopy_work_func);
+static void fcopy_timeout_func(struct work_struct *dummy);
+static DECLARE_DELAYED_WORK(fcopy_timeout_work, fcopy_timeout_func);
 static u8 *recv_buffer;
 
-static void fcopy_work_func(struct work_struct *dummy)
+static void fcopy_timeout_func(struct work_struct *dummy)
 {
 	/*
 	 * If the timer fires, the user-mode component has not responded;
@@ -261,7 +261,7 @@ void hv_fcopy_onchannelcallback(void *context)
 		/*
 		 * Send the information to the user-level daemon.
 		 */
-		schedule_delayed_work(&fcopy_work, 5*HZ);
+		schedule_delayed_work(&fcopy_timeout_work, 5*HZ);
 		fcopy_send_data();
 		return;
 	}
@@ -336,7 +336,7 @@ static ssize_t fcopy_write(struct file *file, const char __user *buf,
 	 * Complete the transaction by forwarding the result
 	 * to the host. But first, cancel the timeout.
 	 */
-	if (cancel_delayed_work_sync(&fcopy_work)) {
+	if (cancel_delayed_work_sync(&fcopy_timeout_work))
 		fcopy_respond_to_host(response);
 		hv_poll_channel(fcopy_transaction.fcopy_context,
 				hv_fcopy_onchannelcallback);
@@ -378,7 +378,7 @@ static int fcopy_release(struct inode *inode, struct file *f)
 	in_hand_shake = true;
 	opened = false;
 
-	if (cancel_delayed_work_sync(&fcopy_work)) {
+	if (cancel_delayed_work_sync(&fcopy_timeout_work)) {
 		/* We haven't up()-ed the semaphore(very rare)? */
 		if (down_trylock(&fcopy_transaction.read_sema))
 			;
@@ -442,6 +442,6 @@ int hv_fcopy_init(struct hv_util_service *srv)
 
 void hv_fcopy_deinit(void)
 {
-	cancel_delayed_work_sync(&fcopy_work);
+	cancel_delayed_work_sync(&fcopy_timeout_work);
 	fcopy_dev_deinit();
 }
-- 
1.9.3
