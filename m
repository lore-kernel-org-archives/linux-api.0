From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] nbd: add support for DISCARD
Date: Wed,  7 Sep 2011 16:41:40 +0200
Message-ID: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch series adds support for a DISCARD command in the nbd
protocol.  qemu-nbd will be the first user of the feature.

Please consider this for 3.2.

Thanks!

Cc: Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Paolo Bonzini (3):
  nbd: remove unused flags fields
  nbd: add support for feature negotiation
  nbd: map DISCARD requests to a new nbd request type

 drivers/block/nbd.c |   28 ++++++++++++++++++++--------
 include/linux/nbd.h |   32 ++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 22 deletions(-)

-- 
1.7.6
