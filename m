From: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH 0/5] Enhancements to twl4030 phy to support better charging
 - V2
Date: Mon, 23 Mar 2015 09:35:23 +1100
Message-ID: <20150322223307.21765.62974.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Cc: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kishon,
 I wonder if you could queue the following for the next merge window.
 They allow the twl4030 phy to provide more information to the
 twl4030 battery charger.
 There are only minimal changes since the first version, particularly
 documentation has been improved.

Thanks,
NeilBrown


---

NeilBrown (5):
      usb: phy: twl4030: make runtime pm more reliable.
      usb: phy: twl4030: allow charger to see usb current draw limits.
      usb: phy: twl4030: add ABI documentation
      usb: phy: twl4030: add support for reading restore on ID pin.
      usb: phy: twl4030: test ID resistance to see if charger is present.


 .../ABI/testing/sysfs-platform-twl4030-usb         |   30 ++++
 drivers/phy/phy-twl4030-usb.c                      |  147 ++++++++++++++++++--
 2 files changed, 162 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-twl4030-usb

--
Signature
