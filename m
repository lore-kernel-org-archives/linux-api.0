From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: [patch v16 1/4] Linux 4.15-rc6
Date: Fri, 12 Jan 2018 18:54:58 +0200
Message-ID: <1515776101-25482-2-git-send-email-oleksandrs@mellanox.com>
References: <1515776101-25482-1-git-send-email-oleksandrs@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515776101-25482-1-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 92b74bc..eb1f597 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 VERSION = 4
 PATCHLEVEL = 15
 SUBLEVEL = 0
-EXTRAVERSION = -rc5
+EXTRAVERSION = -rc6
 NAME = Fearless Coyote
 
 # *DOCUMENTATION*
-- 
1.7.1
