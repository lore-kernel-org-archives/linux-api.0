From: Madars Vitolins <m@silodev.com>
Subject: Re: [PATCH] epoll: restrict EPOLLEXCLUSIVE to POLLIN and POLLOUT
Date: Thu, 04 Feb 2016 23:44:05 +0200
Message-ID: <00ac7df620d4d0500b18af4a30034815@silodev.com>
References: <1454600344-23655-1-git-send-email-jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454600344-23655-1-git-send-email-jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Jason,


Just run off the original tests with this patch (eventpoll.c from=20
4.5-rc2 + patch bellow). Got the same good results, no regression.

$ time ./bankcl
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 1359856158.04 USD
Account balance is: 101528948.40 USD

real	0m41.826s
user	0m29.513s
sys	0m6.490s


Test case:=20
https://mvitolin.wordpress.com/2015/12/05/endurox-testing-epollexclusiv=
e-flag/

PS,

Original cases 0m24.953s vs 0m41.826s now probably is related with my p=
c=20
setup. As I just now re-run test with original patch, got the same ~41=20
sec.

So I am fine with this patch!

Thanks,
Madars


Jason Baron @ 2016-02-04 17:39 rakst=C4=ABja:
> In the current implementation of the EPOLLEXCLUSIVE flag (added for=20
> 4.5-rc1),
> if epoll waiters create different POLL* sets and register them as=20
> exclusive
> against the same target fd, the current implementation will stop waki=
ng=20
> any
> further waiters once it finds the first idle waiter. This means that=20
> waiters
> could miss wakeups in certain cases.
>=20
> For example, when we wake up a pipe for reading we do:
> wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
> So if one epoll set or epfd is added to pipe p with POLLIN and a seco=
nd=20
> set
> epfd2 is added to pipe p with POLLRDNORM, only epfd may receive the=20
> wakeup
> since the current implementation will stop after it finds any=20
> intersection
> of events with a waiter that is blocked in epoll_wait().
>=20
> We could potentially address this by requiring all epoll waiters that=
=20
> are
> added to p be required to pass the same set of POLL* events. IE the=20
> first
> EPOLL_CTL_ADD that passes EPOLLEXCLUSIVE establishes the set POLL*=20
> flags to
> be used by any other epfds that are added as EPOLLEXCLUSIVE. However,=
 I=20
> think
> it might be somewhat confusing interface as we would have to referenc=
e=20
> count
> the number of users for that set, and so userspace would have to keep=
=20
> track
> of that count, or we would need a more involved interface. It also ad=
ds=20
> some
> shared state that we'd have store somewhere. I don't think anybody wi=
ll=20
> want
> to bloat __wait_queue_head for this.
>=20
> I think what we could do instead, is to simply restrict EPOLLEXCLUSIV=
E=20
> such
> that it can only be specified with EPOLLIN and/or EPOLLOUT. So that w=
ay=20
> if
> the wakeup includes 'POLLIN' and not 'POLLOUT', we can stop once we h=
it=20
> the
> first idle waiter that specifies the EPOLLIN bit, since any remaining=
=20
> waiters
> that only have 'POLLOUT' set wouldn't need to be woken. Likewise, we=20
> can do
> the same thing if 'POLLOUT' is in the wakeup bit set and not 'POLLIN'=
=2E=20
> If both
> 'POLLOUT' and 'POLLIN' are set in the wake bit set (there is at least=
=20
> one
> example of this I saw in fs/pipe.c), then we just wake the entire=20
> exclusive
> list. Having both 'POLLOUT' and 'POLLIN' both set should not be on an=
y
> performance critical path, so I think that's ok (in fs/pipe.c its in
> pipe_release()). We also continue to include EPOLLERR and EPOLLHUP by=
=20
> default
> in any exclusive set. Thus, the user can specify EPOLLERR and/or=20
> EPOLLHUP but
> is not required to do so.
>=20
> Since epoll waiters may be interested in other events as well besides=
=20
> EPOLLIN,
> EPOLLOUT, EPOLLERR and EPOLLHUP, these can still be added by doing a=20
> 'dup' call
> on the target fd and adding that as one normally would with=20
> EPOLL_CTL_ADD. Since
> I think that the POLLIN and POLLOUT events are what we are interest i=
n
> balancing,
> I think that the 'dup' thing could perhaps be added to only one of th=
e=20
> waiter
> threads. However, I think that EPOLLIN, EPOLLOUT, EPOLLERR and EPOLLH=
UP=20
> should
> be sufficient for the majority of use-cases.
>=20
> Since EPOLLEXCLUSIVE is intended to be used with a target fd shared=20
> among
> multiple epfds, where between 1 and n of the epfds may receive an=20
> event, it
> does not satisfy the semantics of EPOLLONESHOT where only 1 epfd woul=
d=20
> get an
> event. Thus, it is not allowed to be specified in conjunction with
> EPOLLEXCLUSIVE.
>=20
> EPOLL_CTL_MOD is also not allowed if the fd was previously added as
> EPOLLEXCLUSIVE. It seems with the limited number of flags to not be a=
s
> interesting, but this could be relaxed at some further point.
>=20
> Signed-off-by: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/eventpoll.c | 38 ++++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index ae1dbcf..cde6074 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -94,6 +94,11 @@
>  /* Epoll private bits inside the event mask */
>  #define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET |=20
> EPOLLEXCLUSIVE)
>=20
> +#define EPOLLINOUT_BITS (POLLIN | POLLOUT)
> +
> +#define EPOLLEXCLUSIVE_OK_BITS (EPOLLINOUT_BITS | POLLERR | POLLHUP =
|=20
> \
> +				EPOLLWAKEUP | EPOLLET | EPOLLEXCLUSIVE)
> +
>  /* Maximum number of nesting allowed inside epoll sets */
>  #define EP_MAX_NESTS 4
>=20
> @@ -1068,7 +1073,22 @@ static int ep_poll_callback(wait_queue_t *wait=
,
> unsigned mode, int sync, void *k
>  	 * wait list.
>  	 */
>  	if (waitqueue_active(&ep->wq)) {
> -		ewake =3D 1;
> +		if ((epi->event.events & EPOLLEXCLUSIVE) &&
> +					!((unsigned long)key & POLLFREE)) {
> +			switch ((unsigned long)key & EPOLLINOUT_BITS) {
> +			case POLLIN:
> +				if (epi->event.events & POLLIN)
> +					ewake =3D 1;
> +				break;
> +			case POLLOUT:
> +				if (epi->event.events & POLLOUT)
> +					ewake =3D 1;
> +				break;
> +			case 0:
> +				ewake =3D 1;
> +				break;
> +			}
> +		}
>  		wake_up_locked(&ep->wq);
>  	}
>  	if (waitqueue_active(&ep->poll_wait))
> @@ -1875,9 +1895,13 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op,=
=20
> int, fd,
>  	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
>  	 * Also, we do not currently supported nested exclusive wakeups.
>  	 */
> -	if ((epds.events & EPOLLEXCLUSIVE) && (op =3D=3D EPOLL_CTL_MOD ||
> -		(op =3D=3D EPOLL_CTL_ADD && is_file_epoll(tf.file))))
> -		goto error_tgt_fput;
> +	if (epds.events & EPOLLEXCLUSIVE) {
> +		if (op =3D=3D EPOLL_CTL_MOD)
> +			goto error_tgt_fput;
> +		if (op =3D=3D EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
> +				(epds.events & ~EPOLLEXCLUSIVE_OK_BITS)))
> +			goto error_tgt_fput;
> +	}
>=20
>  	/*
>  	 * At this point it is safe to assume that the "private_data"=20
> contains
> @@ -1950,8 +1974,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op,=
=20
> int, fd,
>  		break;
>  	case EPOLL_CTL_MOD:
>  		if (epi) {
> -			epds.events |=3D POLLERR | POLLHUP;
> -			error =3D ep_modify(ep, epi, &epds);
> +			if (!(epi->event.events & EPOLLEXCLUSIVE)) {
> +				epds.events |=3D POLLERR | POLLHUP;
> +				error =3D ep_modify(ep, epi, &epds);
> +			}
>  		} else
>  			error =3D -ENOENT;
>  		break;
