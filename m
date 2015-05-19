From: Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by vt
Date: Tue, 19 May 2015 14:15:41 -0700
Message-ID: <CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA@mail.gmail.com>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
	<alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
	<20150225094946.GA24627@amd>
	<alpine.LNX.2.11.1502252319330.276@localhost>
	<20150226220243.GC9935@amd>
	<alpine.LNX.2.11.1502271905580.4212@localhost>
	<alpine.LNX.2.11.1502271911380.4248@localhost>
	<20150325111949.GA24230@kroah.com>
	<alpine.DEB.2.11.1503261341260.2164@local>
	<alpine.DEB.2.11.1503261354550.2411@local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1503261354550.2411@local>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 6:56 AM, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org> wrote:
> vt now provides a cursor blink interval via vc_data. Use this
> interval instead of the currently hardcoded 200 msecs. Store it in
> fbcon_ops to avoid locking the console in cursor_timer_handler().
>
> Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
> Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>

This patch hit next-20150519 in the form of commit 27a4c827c34a
(fbcon: use the cursor blink interval provided by vt) and has caused
boot failure on a handful of ARM platforms when booting a MMC root
filesystem.  This error was spotted by the kernelci.org bot on
exynos5800-peach-pi[1] and Thierry and Daniel (Cc'd) have seen it on
some tegra platforms too.

Thierry spotted this commit as a potential cause, and both Daniel and
I have reverted and boot tested on exynos5 and tegra respectively and
the boot panics disappear.

Kevin

[1] http://storage.kernelci.org/next/next-20150519/arm-exynos_defconfig/lab-khilman/boot-exynos5800-peach-pi_rootfs:mmc.html
