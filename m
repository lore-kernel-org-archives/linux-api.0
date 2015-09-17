From: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Input: uinput: Sanity check on ff_effects_max and EV_FF
Date: Thu, 17 Sep 2015 19:29:48 +0200
Message-ID: <1442510988-3164-3-git-send-email-elias.vds@gmail.com>
References: <1442510988-3164-1-git-send-email-elias.vds@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442510988-3164-1-git-send-email-elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently the user can specify a non-zero value for ff_effects_max,
without setting the EV_FF bit.
Inversely,
the user can also set ff_effects_max to zero with the EV_FF bit set,
in this case the uninitialized method ff->upload can be dereferenced,
resulting in a kernel oops.

Instead of adding a check in uinput_create_device() and
omitting setup of ff-core infrastructure silently in case the check fails,
perform the check early in uinput_setup_device(),
and print a helpful message and return -EINVAL in case the check fails.

Signed-off-by: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/input/misc/uinput.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 345df9b..3a90a16 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -393,6 +393,21 @@ static int uinput_setup_device(struct uinput_device *udev,
 	if (IS_ERR(user_dev))
 		return PTR_ERR(user_dev);
 
+	if (!!user_dev->ff_effects_max ^ test_bit(EV_FF, dev->evbit)) {
+		if (user_dev->ff_effects_max)
+			printk(KERN_DEBUG
+				"%s: ff_effects_max (%u) should be zero "
+				"when FF_BIT is not set\n",
+				UINPUT_NAME, user_dev->ff_effects_max);
+		else
+			printk(KERN_DEBUG
+				"%s: ff_effects_max should be non-zero "
+				"when FF_BIT is set\n",
+				UINPUT_NAME);
+		retval = -EINVAL;
+		goto exit;
+	}
+
 	udev->ff_effects_max = user_dev->ff_effects_max;
 
 	/* Ensure name is filled in */
-- 
1.9.3
