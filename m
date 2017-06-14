From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 4/4] firmware: send -EINTR on signal abort on fallback mechanism
Date: Wed, 14 Jun 2017 15:20:17 -0700
Message-ID: <20170614222017.14653-5-mcgrof@kernel.org>
References: <20170614222017.14653-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170614222017.14653-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: mfuzzey@parkeon.com, ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, L
List-Id: linux-api@vger.kernel.org

Right now we send -EAGAIN to a syfs write which got interrupted.
Userspace can't tell what happened though, send -EINTR if we
were killed due to a signal so userspace can tell things apart.

This is only applicable to the fallback mechanism.

Reported-by: Martin Fuzzey <mfuzzey@parkeon.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_class.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 70fc42e5e0da..da043cb16e2f 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1089,9 +1089,12 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		mutex_unlock(&fw_lock);
 	}
 
-	if (fw_state_is_aborted(&buf->fw_st))
-		retval = -EAGAIN;
-	else if (buf->is_paged_buf && !buf->data)
+	if (fw_state_is_aborted(&buf->fw_st)) {
+		if (retval == -ERESTARTSYS)
+			retval = -EINTR;
+		else
+			retval = -EAGAIN;
+	} else if (buf->is_paged_buf && !buf->data)
 		retval = -ENOMEM;
 
 	device_del(f_dev);
-- 
2.11.0
