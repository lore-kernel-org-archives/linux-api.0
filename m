From: mark yao <mark.yao@rock-chips.com>
Subject: [PATCH 0/9] Add drm driver for Rockchip Socs
Date: Mon,  4 Aug 2014 12:41:14 +0800
Message-ID: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com, mark yao <yzq@rock-chips.com>
List-Id: linux-api@vger.kernel.org

From: mark yao <yzq@rock-chips.com>

This a series of patches is a DRM Driver for Rockchip Socs, driver provides
an abstraction for the graphics hardware, as lcd controller and
connector interface.

add rk3288 lcd controller.
add rk3288 lvds and rk3288 edp connector.

Tested on rk3288 sdk board, use lvds or edp connector, boot and display OK

mark yao (9):
  drm: Add drm driver for Rockchip Socs
  Add devicetree bindings for panels used by the Rockchip DRM
  drm: add driver for panels used by the Rockchip DRM
  Add devicetree bindings for Rockchip lcd controller
  drm: add Rockchip rk3288 lcd controller driver
  Add devicetree bindings for Rockchip Soc LVDS
  drm: add Rockchip Soc rk3288 lvds connector
  Add devicetree bindings for Rockchip Soc EDP
  drm: add Rockchip Soc rk3288 edp connector


-- 
1.7.9.5


