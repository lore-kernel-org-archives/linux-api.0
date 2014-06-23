From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 0/4] timerfd c/r support, v4
Date: Mon, 23 Jun 2014 22:54:31 +0400
Message-ID: <20140623185431.396309193@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Andrey Vagin <avagin@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

Hi guys, here is an updated version of c/r support for timerfd files. The main change
is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
with CONFIG because I still think that while there is only one ioctl designated
solely for c/r needs no need to build it all the time until explicitly requested.
Please take a look once time permit. Comments are highly appreciated.
Also note the last patch is for man-page git repo, not for kernel.

Thanks!
