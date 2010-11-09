From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH v2 04/23] netconsole: Call netpoll_cleanup() in process
 context
Date: Tue, 9 Nov 2010 07:07:52 -0500
Message-ID: <20101109120752.GA18269@hmsreliant.think-freely.org>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203159.22479.48774.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101108203159.22479.48774.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 08, 2010 at 12:32:00PM -0800, Mike Waychison wrote:
> The netconsole driver currently deadlocks if a NETDEV_UNREGISTER event
> is received while netconsole is in use, which in turn causes it to pin a
> reference to the network device.  The first deadlock was dealt with in
> 3b410a31 so that we wouldn't recursively grab RTNL, but even calling
> __netpoll_cleanup isn't safe to do considering that we are in atomic
> context.  __netpoll_cleanup assumes it can sleep and has several
> sleeping calls, such as synchronize_rcu_bh and
> cancel_rearming_delayed_work.
> 
> Fix this by deferring netpoll_cleanup using scheduling work that
> operates in process context.  We have to grab a reference to the
> config_item in this case as we need to pin the item in place until it is
> operated on.
> 
> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/net/netconsole.c |   55 ++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 288a025..02ba5c4 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -106,6 +106,7 @@ struct netconsole_target {
>  #endif
>  	int			np_state;
>  	struct netpoll		np;
> +	struct work_struct	cleanup_work;
>  };
>  
>  #ifdef	CONFIG_NETCONSOLE_DYNAMIC
> @@ -166,6 +167,22 @@ static void netconsole_target_put(struct netconsole_target *nt)
>  
>  #endif	/* CONFIG_NETCONSOLE_DYNAMIC */
>  
> +static void deferred_netpoll_cleanup(struct work_struct *work)
> +{
> +	struct netconsole_target *nt;
> +	unsigned long flags;
> +
> +	nt = container_of(work, struct netconsole_target, cleanup_work);
> +	netpoll_cleanup(&nt->np);
> +
> +	spin_lock_irqsave(&target_list_lock, flags);
> +	BUG_ON(nt->np_state != NETPOLL_CLEANING);
> +	nt->np_state = NETPOLL_DISABLED;
> +	spin_unlock_irqrestore(&target_list_lock, flags);
> +
> +	netconsole_target_put(nt);
> +}
> +
Where is the synchronization on the new work queue when the module is getting
removed? The target get/put code does nothing to the module refcount, and
cleanup_netconsole just deletes targets, it doesn't block or fail on netconsole
refcounts, so you could run this work after the module has been removed and oops
the system.

Neil
 
