From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH v2 04/23] netconsole: Call netpoll_cleanup() in process
 context
Date: Tue, 9 Nov 2010 14:33:12 -0500
Message-ID: <20101109193312.GA9990@hmsreliant.think-freely.org>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203159.22479.48774.stgit@crlf.mtv.corp.google.com>
 <20101109120752.GA18269@hmsreliant.think-freely.org>
 <AANLkTi=Dez6st660R3h+0uTqkTUgOppvzBXcbg7QqxDu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=Dez6st660R3h+0uTqkTUgOppvzBXcbg7QqxDu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 09, 2010 at 09:18:57AM -0800, Mike Waychison wrote:
> On Tue, Nov 9, 2010 at 4:07 AM, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org> w=
rote:
> > On Mon, Nov 08, 2010 at 12:32:00PM -0800, Mike Waychison wrote:
> >> +static void deferred_netpoll_cleanup(struct work_struct *work)
> >> +{
> >> + =A0 =A0 struct netconsole_target *nt;
> >> + =A0 =A0 unsigned long flags;
> >> +
> >> + =A0 =A0 nt =3D container_of(work, struct netconsole_target, clea=
nup_work);
> >> + =A0 =A0 netpoll_cleanup(&nt->np);
> >> +
> >> + =A0 =A0 spin_lock_irqsave(&target_list_lock, flags);
> >> + =A0 =A0 BUG_ON(nt->np_state !=3D NETPOLL_CLEANING);
> >> + =A0 =A0 nt->np_state =3D NETPOLL_DISABLED;
> >> + =A0 =A0 spin_unlock_irqrestore(&target_list_lock, flags);
> >> +
> >> + =A0 =A0 netconsole_target_put(nt);
> >> +}
> >> +
> > Where is the synchronization on the new work queue when the module =
is getting
> > removed? The target get/put code does nothing to the module refcoun=
t, and
> > cleanup_netconsole just deletes targets, it doesn't block or fail o=
n netconsole
> > refcounts, so you could run this work after the module has been rem=
oved and oops
> > the system.
> >
>=20
> The synchronization here is actually handled in free_param_target()
> with the call to cancel_work_sync().  After that call is made in the
> exit path, we know a task cannot be rescheduled for cleanup, so we ca=
n
> clean things up directly.
>=20
> The comment/name of free_param_target should probably change.  I used
> to have this cancel_work_sync() call elsewhere, and folded both the
> dynamic and param-based target cleanup into one as they ended up bein=
g
> the same.
>=20
> Removal of the item from configfs however isn't handled.
>=20
> How about something like (no idea if this will get whitespace damage)=
:
>=20
That would seem clearer to me yes.  Thanks!
Neil

>=20
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 02ba5c4..ddd5e4f 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -686,13 +686,16 @@ static void drop_netconsole_target(struct
> config_group *group,
>         spin_unlock_irqrestore(&target_list_lock, flags);
>=20
>         /*
> -        * The target may have never been enabled, or was manually di=
sabled
> -        * before being removed so netpoll may have already been clea=
ned up.
> +        * The target may have never been disabled, or was disabled d=
ue
> +        * to a netdev event, but we haven't had the chance to clean
> +        * things up yet.
>          *
> -        * If it queued for cleanup already, that is fine, as that pa=
th holds a
> -        * reference to the config_item.
> +        * We can't wait for the target to be cleaned up by its
> +        * scheduled work however, as that work doesn't pin this modu=
le
> +        * in place.
>          */
> -       if (nt->np_state =3D=3D NETPOLL_ENABLED)
> +       cancel_work_sync(&nt->cleanup_work);
> +       if (nt->np_state =3D=3D NETPOLL_ENABLED || nt->np-state =3D=3D=
 NETPOLL_CLEANING)
>                 netpoll_cleanup(&nt->np);
>=20
>         config_item_put(&nt->item);
>=20
>=20
>=20
> I can fold this diff snippet into this patch for the next round if yo=
u
> agree it plugs the remaining hole.
>=20
