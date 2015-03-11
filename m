From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 04/21] Drivers: hv: fcopy: process deferred messages
 when we complete the transaction
Date: Wed, 11 Mar 2015 14:29:17 +0100
Message-ID: <1426080574-9011-5-git-send-email-vkuznets@redhat.com>
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

In theory, the host is not supposed to issue any requests before be reply to
the previous one. In KVP we, however, support the following scenarios:
1) A message was received before userspace daemon registered;
2) A message was received while the previous one is still being processed.
In FCOPY we support only the former. Add support for the later, use
hv_poll_channel() to do the job.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_fcopy.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index cd453e4..8bdf752 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -98,6 +98,8 @@ static void fcopy_work_func(struct work_struct *dummy)
 	if (down_trylock(&fcopy_transaction.read_sema))
 		;
 
+	hv_poll_channel(fcopy_transaction.fcopy_context,
+			hv_fcopy_onchannelcallback);
 }
 
 static int fcopy_handle_handshake(u32 version)
@@ -117,8 +119,8 @@ static int fcopy_handle_handshake(u32 version)
 	pr_info("FCP: user-mode registering done. Daemon version: %d\n",
 		version);
 	fcopy_transaction.active = false;
-	if (fcopy_transaction.fcopy_context)
-		hv_fcopy_onchannelcallback(fcopy_transaction.fcopy_context);
+	hv_poll_channel(fcopy_transaction.fcopy_context,
+			hv_fcopy_onchannelcallback);
 	in_hand_shake = false;
 	return 0;
 }
@@ -226,6 +228,7 @@ void hv_fcopy_onchannelcallback(void *context)
 		fcopy_transaction.fcopy_context = context;
 		return;
 	}
+	fcopy_transaction.fcopy_context = NULL;
 
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
 			 &requestid);
@@ -333,8 +336,11 @@ static ssize_t fcopy_write(struct file *file, const char __user *buf,
 	 * Complete the transaction by forwarding the result
 	 * to the host. But first, cancel the timeout.
 	 */
-	if (cancel_delayed_work_sync(&fcopy_work))
+	if (cancel_delayed_work_sync(&fcopy_work)) {
 		fcopy_respond_to_host(response);
+		hv_poll_channel(fcopy_transaction.fcopy_context,
+				hv_fcopy_onchannelcallback);
+	}
 
 	return sizeof(int);
 }
-- 
1.9.3
