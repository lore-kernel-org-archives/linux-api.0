From: Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by vt
Date: Tue, 19 May 2015 14:45:19 -0700
Message-ID: <CAMAWPa88E2pfViKLXjxWHuT4ZkVhzYt_BsXGePzc-70ZrEmJFA@mail.gmail.com>
References: <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
	<20150225094946.GA24627@amd>
	<alpine.LNX.2.11.1502252319330.276@localhost>
	<20150226220243.GC9935@amd>
	<alpine.LNX.2.11.1502271905580.4212@localhost>
	<alpine.LNX.2.11.1502271911380.4248@localhost>
	<20150325111949.GA24230@kroah.com>
	<alpine.DEB.2.11.1503261341260.2164@local>
	<alpine.DEB.2.11.1503261354550.2411@local>
	<CAMAWPa-6ZbE5cDkEZq0XpYa2pHcnf3qweSSVHAXhfhUAUCbKcA@mail.gmail.com>
	<20150519214011.GA27047@ulmo.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519214011.GA27047@ulmo.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Scot Doyle <lkml14@scotdoyle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Jiri Slaby <jslaby@suse.cz>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Pavel Machek <pavel@ucw.cz>, Geert Uytterhoeven <geert@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Tyler Baker <tyler.baker@linaro.org>, Olof Johansson <olof@lixom.net>, Daniel Stone <daniel@fooishbar.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Tue, May 19, 2015 at 2:40 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, May 19, 2015 at 02:15:41PM -0700, Kevin Hilman wrote:
>> On Thu, Mar 26, 2015 at 6:56 AM, Scot Doyle <lkml14@scotdoyle.com> wrote:
>> > vt now provides a cursor blink interval via vc_data. Use this
>> > interval instead of the currently hardcoded 200 msecs. Store it in
>> > fbcon_ops to avoid locking the console in cursor_timer_handler().
>> >
>> > Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
>> > Acked-by: Pavel Machek <pavel@ucw.cz>
>>
>> This patch hit next-20150519 in the form of commit 27a4c827c34a
>> (fbcon: use the cursor blink interval provided by vt) and has caused
>> boot failure on a handful of ARM platforms when booting a MMC root
>> filesystem.  This error was spotted by the kernelci.org bot on
>> exynos5800-peach-pi[1] and Thierry and Daniel (Cc'd) have seen it on
>> some tegra platforms too.
>>
>> Thierry spotted this commit as a potential cause, and both Daniel and
>> I have reverted and boot tested on exynos5 and tegra respectively and
>> the boot panics disappear.
>
> FWIW, if I apply the below on top of next-20150519 things seem to be
> back to normal as well:
>
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index 05b1d1a71ef9..658c34bb9076 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -1310,8 +1310,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
>                 return;
>
>         ops->cur_blink_jiffies = msecs_to_jiffies(vc->vc_cur_blink_ms);
> -       fbcon_del_cursor_timer(info);
> -       if (!(vc->vc_cursor_type & 0x10))
> +       if (vc->vc_cursor_type & 0x10)
> +               fbcon_del_cursor_timer(info);
> +       else
>                 fbcon_add_cursor_timer(info);
>
>         ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;

Applying this on next-20150519 makes my exynos board happily boot again as well.

Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin
