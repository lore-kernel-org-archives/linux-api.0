From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Date: Mon, 30 Jun 2014 23:43:54 +0400
Message-ID: <20140630194354.GB2305@moon>
References: <20140623185431.396309193@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140623185431.396309193@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrey Vagin <avagin@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 23, 2014 at 10:54:31PM +0400, Cyrill Gorcunov wrote:
>
> Hi guys, here is an updated version of c/r support for timerfd files. The main change
> is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
> with CONFIG because I still think that while there is only one ioctl designated
> solely for c/r needs no need to build it all the time until explicitly requested.
> Please take a look once time permit. Comments are highly appreciated.
> Also note the last patch is for man-page git repo, not for kernel.

Gentlemen, could you please point me if there something preventing the
series from being picked up? Or there some way to improve the series?
