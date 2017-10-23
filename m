From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v6 1/2] staging: ion: simplify ioctl args checking function
Date: Mon, 23 Oct 2017 17:55:36 +0200
Message-ID: <1508774137-13835-2-git-send-email-benjamin.gaignard@linaro.org>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: labbott@redhat.com, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-api@vger.kernel.org

Make arguments checking more easy to read.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Acked-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/ion-ioctl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index d9f8b14..e26b786 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -27,19 +27,18 @@ union ion_ioctl_arg {
 
 static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
 {
-	int ret = 0;
-
 	switch (cmd) {
 	case ION_IOC_HEAP_QUERY:
-		ret = arg->query.reserved0 != 0;
-		ret |= arg->query.reserved1 != 0;
-		ret |= arg->query.reserved2 != 0;
+		if (arg->query.reserved0 ||
+		    arg->query.reserved1 ||
+		    arg->query.reserved2 )
+			return -EINVAL;
 		break;
 	default:
 		break;
 	}
 
-	return ret ? -EINVAL : 0;
+	return 0;
 }
 
 /* fix up the cases where the ioctl direction bits are incorrect */
-- 
2.7.4
