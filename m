From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Date: Tue, 9 Nov 2010 11:30:24 +0800
Message-ID: <20101109033024.GA5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101108203246.22479.60118.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 08, 2010 at 12:32:47PM -0800, Mike Waychison wrote:
>As preparation for moving netpoll_targets out of netconsole and making
>them available to other clients, introduce new Kconfig options.
>
>CONFIG_NETPOLL_TARGETS
>
>Access to targets APIs.  Only supports parameter based parsing of
>targets (via the kernel command line or module paramters).
>
>CONFIG_NETPOLL_TARGETS_DYNAMIC
>
>Extends the support that netpoll_targets provides by allowing for the
>dynamic creation of targets in configfs on a per client basis.
>
>Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>---
> drivers/net/Kconfig      |   16 +++++++++++++---
> drivers/net/netconsole.c |   10 +++++-----
> 2 files changed, 18 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>index f6668cd..b014cd6 100644
>--- a/drivers/net/Kconfig
>+++ b/drivers/net/Kconfig
>@@ -3367,14 +3367,15 @@ config NET_FC
> 
> config NETCONSOLE
> 	tristate "Network console logging support"
>+	select NETPOLL_TARGETS
> 	---help---
> 	If you want to log kernel messages over the network, enable this.
> 	See <file:Documentation/networking/netconsole.txt> for details.
> 
> config NETCONSOLE_DYNAMIC
> 	bool "Dynamic reconfiguration of logging targets"
>-	depends on NETCONSOLE && SYSFS
>-	select CONFIGFS_FS
>+	depends on NETCONSOLE
>+	select NETPOLL_TARGETS_DYNAMIC
> 	help
> 	  This option enables the ability to dynamically reconfigure target
> 	  parameters (interface, IP addresses, port numbers, MAC addresses)
>@@ -3382,7 +3383,16 @@ config NETCONSOLE_DYNAMIC
> 	  See <file:Documentation/networking/netconsole.txt> for details.
> 
> config NETPOLL
>-	def_bool NETCONSOLE
>+	def_bool false
>+
>+config NETPOLL_TARGETS
>+	bool
>+	select NETPOLL
>+
>+config NETPOLL_TARGETS_DYNAMIC
>+	bool
>+	select CONFIGFS_FS
>+	select NETPOLL_TARGETS
> 

Hey, have you tried CONFIG_CONFIGFS_FS=m? :)

Actually, I tried almost the same thing, but finally failed due to
CONFIG_CONFIGFS_FS=m. NETPOLL can't be a module, and configfs can be,
thus you can't use the API provided by configfs.

So, either we need to de-modulize configfs or replace configfs API
with sysfs API. Personally, I prefer the former one, I don't think
configfs should be a module as long as it can provide API's
for other subsystems, like debugfs.

Thanks.
