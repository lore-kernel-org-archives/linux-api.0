From: Jon Maloy <jon.maloy@ericsson.com>
Subject: RE: [PATCH 13/32] net/tipc: convert to ->poll_mask
Date: Wed, 10 Jan 2018 19:32:21 +0000
Message-ID: <AM4PR07MB1714F63B2A751F97C3969C179A110@AM4PR07MB1714.eurprd07.prod.outlook.com>
References: <20180110155853.32348-1-hch@lst.de>
 <20180110155853.32348-14-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180110155853.32348-14-hch@lst.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Cc: Avi Kivity <avi@scylladb.com>, "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Acked.
///jon

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Wednesday, January 10, 2018 10:59
> To: viro@zeniv.linux.org.uk
> Cc: Avi Kivity <avi@scylladb.com>; linux-aio@kvack.org; linux-
> fsdevel@vger.kernel.org; netdev@vger.kernel.org; linux-
> api@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 13/32] net/tipc: convert to ->poll_mask
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  net/tipc/socket.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c index
> fcbd6489a8b5..527d113c38b0 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -693,10 +693,9 @@ static int tipc_getname(struct socket *sock, struct
> sockaddr *uaddr,  }
>=20
>  /**
> - * tipc_poll - read and possibly block on pollmask
> + * tipc_poll - read pollmask
>   * @file: file structure associated with the socket
>   * @sock: socket for which to calculate the poll bits
> - * @wait: ???
>   *
>   * Returns pollmask value
>   *
> @@ -710,16 +709,13 @@ static int tipc_getname(struct socket *sock, struct
> sockaddr *uaddr,
>   * imply that the operation will succeed, merely that it should be perfo=
rmed
>   * and will not block.
>   */
> -static __poll_t tipc_poll(struct file *file, struct socket *sock,
> -			      poll_table *wait)
> +static __poll_t tipc_poll_mask(struct socket *sock, __poll_t events)
>  {
>  	struct sock *sk =3D sock->sk;
>  	struct tipc_sock *tsk =3D tipc_sk(sk);
>  	struct tipc_group *grp =3D tsk->group;
>  	__poll_t revents =3D 0;
>=20
> -	sock_poll_wait(file, sk_sleep(sk), wait);
> -
>  	if (sk->sk_shutdown & RCV_SHUTDOWN)
>  		revents |=3D POLLRDHUP | POLLIN | POLLRDNORM;
>  	if (sk->sk_shutdown =3D=3D SHUTDOWN_MASK)
> @@ -3005,7 +3001,7 @@ static const struct proto_ops msg_ops =3D {
>  	.socketpair	=3D tipc_socketpair,
>  	.accept		=3D sock_no_accept,
>  	.getname	=3D tipc_getname,
> -	.poll		=3D tipc_poll,
> +	.poll_mask	=3D tipc_poll_mask,
>  	.ioctl		=3D tipc_ioctl,
>  	.listen		=3D sock_no_listen,
>  	.shutdown	=3D tipc_shutdown,
> @@ -3026,7 +3022,7 @@ static const struct proto_ops packet_ops =3D {
>  	.socketpair	=3D tipc_socketpair,
>  	.accept		=3D tipc_accept,
>  	.getname	=3D tipc_getname,
> -	.poll		=3D tipc_poll,
> +	.poll_mask	=3D tipc_poll_mask,
>  	.ioctl		=3D tipc_ioctl,
>  	.listen		=3D tipc_listen,
>  	.shutdown	=3D tipc_shutdown,
> @@ -3047,7 +3043,7 @@ static const struct proto_ops stream_ops =3D {
>  	.socketpair	=3D tipc_socketpair,
>  	.accept		=3D tipc_accept,
>  	.getname	=3D tipc_getname,
> -	.poll		=3D tipc_poll,
> +	.poll_mask	=3D tipc_poll_mask,
>  	.ioctl		=3D tipc_ioctl,
>  	.listen		=3D tipc_listen,
>  	.shutdown	=3D tipc_shutdown,
> --
> 2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
