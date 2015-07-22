From: Stephen Chandler Paul <cpaul@redhat.com>
Subject: [RFC v3 0/1] userio (originally ps2emu) - virtual serio device module
Date: Wed, 22 Jul 2015 15:52:52 -0400
Message-ID: <1437594773-22274-1-git-send-email-cpaul@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-api@vger.kernel.org

Here's the latest revision of the userio patch with all of the suggested edits
made, along with a couple of extras I picked up on the way.

Cheers,
	Stephen Chandler Paul

Stephen Chandler Paul (1):
  Input: Add userio module

 Documentation/input/userio.txt |  70 +++++++++++
 MAINTAINERS                    |   6 +
 drivers/input/serio/Kconfig    |  11 ++
 drivers/input/serio/Makefile   |   1 +
 drivers/input/serio/userio.c   | 261 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/userio.h    |  42 +++++++
 6 files changed, 391 insertions(+)
 create mode 100644 Documentation/input/userio.txt
 create mode 100644 drivers/input/serio/userio.c
 create mode 100644 include/uapi/linux/userio.h

-- 
2.4.3

