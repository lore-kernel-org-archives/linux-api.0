From: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Input: Improve handling of ff max_effects
Date: Thu, 17 Sep 2015 19:29:46 +0200
Message-ID: <1442510988-3164-1-git-send-email-elias.vds@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a patch-set to improve the handling of max_effects in
ff-core and uinput.

Elias Vanderstuyft (2):
  Input: Document and check on implicitly defined FF_MAX_EFFECTS
  Input: uinput: Sanity check on ff_effects_max and EV_FF

 drivers/input/ff-core.c     |  5 +++++
 drivers/input/misc/uinput.c | 15 +++++++++++++++
 include/uapi/linux/input.h  |  8 ++++++++
 3 files changed, 28 insertions(+)

-- 
1.9.3
