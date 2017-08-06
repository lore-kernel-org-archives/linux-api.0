From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 31/36] uapi linux/patchkey.h: change #error
	to #warning if file included directly
Date: Sun,  6 Aug 2017 18:44:22 +0200
Message-ID: <20170806164428.2273-32-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, alsa-devel@alsa-project.org, Andrew Veliath <andrewtv@usa.net>, Riccardo Facchetti <fizban@tin.it>
List-Id: linux-api@vger.kernel.org

Would be nice to be able to compile all userspace header files also alone.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: alsa-devel@alsa-project.org
Cc: Andrew Veliath <andrewtv@usa.net>
Cc: Riccardo Facchetti <fizban@tin.it>
---
 include/uapi/linux/patchkey.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/patchkey.h b/include/uapi/linux/patchkey.h
index 1bda0e56bc5e..cee195d6d826 100644
--- a/include/uapi/linux/patchkey.h
+++ b/include/uapi/linux/patchkey.h
@@ -11,7 +11,7 @@
  */
 
 #ifndef _LINUX_PATCHKEY_H_INDIRECT
-#error "patchkey.h included directly"
+#warning "patchkey.h included directly"
 #endif
 
 #ifndef _UAPI_LINUX_PATCHKEY_H
-- 
2.13.3
