From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC 3/8] lsm: kdbus security hooks
Date: Wed, 08 Jul 2015 13:00:58 +0200
Message-ID: <1436353258.2331.0.camel@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-4-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1436351110-5902-4-git-send-email-p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On =C5=9Bro, 2015-07-08 at 12:25 +0200, Paul Osmialowski wrote:
> This is combination of the work by Karol Lewandowski and Paul Moore
> on LSM hooks for kdbus.
>=20
> Originates from:
>=20
> git://git.infradead.org/users/pcmoore/selinux (branch: working-kdbus)
> commit: 7050f206a79564886938d0edc4e1e9da5972c72d
>=20
> https://github.com/lmctl/linux.git (branch: kdbus-lsm-v4.for-systemd
> -v212)
> commit: a9fe4c33b6e5ab25a243e0590df406aabb6add12
>=20
> Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  include/linux/lsm_hooks.h |  67 ++++++++++++++++++++++++++
>  include/linux/security.h  |  99=20
> +++++++++++++++++++++++++++++++++++++++
>  security/security.c       | 117=20
> ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 283 insertions(+)
>=20
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 9429f05..2a8d8fc 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1297,6 +1297,36 @@
>   *	@inode we wish to get the security context of.
>   *	@ctx is a pointer in which to place the allocated security=20
> context.
>   *	@ctxlen points to the place to put the length of @ctx.
> + *
> + * @kdbus_domain_alloc:
> + *	Allocate kdbus domain.
> + * @kdbus_domain_free:
> + *	Deallocate kdbus domain.
> + * @kdbus_bus_alloc:
> + *	Allocate kdbus bus.
> + * @kdbus_bus_free:
> + *	Deallocate kdbus bus.
> + * @kdbus_send:
> + *	Send message.
> + * @kdbus_recv:
> + *	Receive message.
> + * @kdbus_name_acquire:
> + *	Request a well-known bus name to associate with the=20
> connection.
> + * @kdbus_name_list:
> + *	Retrieve the list of all currently registered well-known and=20
> unique
> + *	names.
> + * @kdbus_ep_create:
> + *	Endpoint create
> + * @kdbus_connect:
> + *	Connect
> + * @kdbus_conn_free:
> + *	Deallocate connection
> + * @kdbus_conn_info:
> + *	Retrieve credentials and properties of the initial creator=20
> of the
> + *	connection.
> + * @kdbus_talk:
> + *	Talk to a given peer.
> + *
>   * This is the main security structure.
>   */
> =20
> @@ -1520,6 +1550,29 @@ union security_list_options {
>  	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32=20
> ctxlen);
>  	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32=20
> *ctxlen);
> =20
> +	int (*kdbus_domain_alloc)(struct kdbus_domain *domain);
> +	void (*kdbus_domain_free)(struct kdbus_domain *domain);

Shouldn't all of this be inside some #ifdef CONFIG_KDBUS (or whatever
the CONFIG for kdbus is)?

> +
> +	int (*kdbus_bus_alloc)(struct kdbus_bus *bus);
> +	void (*kdbus_bus_free)(struct kdbus_bus *bus);
> +	int (*kdbus_send)(const struct kdbus_conn *conn,
> +			  const struct kdbus_bus *bus);
> +	int (*kdbus_recv)(const struct kdbus_conn *conn,
> +			  const struct kdbus_bus *bus);
> +	int (*kdbus_name_acquire)(const struct kdbus_conn *conn,
> +			  const char *name);
> +	int (*kdbus_name_list)(const struct kdbus_bus *bus);
> +
> +	int (*kdbus_ep_create)(const struct kdbus_bus *bus);
> +	int (*kdbus_ep_setpolicy)(const struct kdbus_bus *bus);
> +
> +	int (*kdbus_connect)(struct kdbus_conn *conn,
> +			     const char *secctx, u32 seclen);
> +	void (*kdbus_conn_free)(struct kdbus_conn *conn);
> +	int (*kdbus_conn_info)(const struct kdbus_conn *conn);
> +	int (*kdbus_talk)(const struct kdbus_conn *src,
> +			  const struct kdbus_conn *dst);
> +
>  #ifdef CONFIG_SECURITY_NETWORK
>  	int (*unix_stream_connect)(struct sock *sock, struct sock=20
> *other,
>  					struct sock *newsk);
> @@ -1760,6 +1813,20 @@ struct security_hook_heads {
>  	struct list_head inode_notifysecctx;
>  	struct list_head inode_setsecctx;
>  	struct list_head inode_getsecctx;
> +	struct list_head kdbus_domain_alloc;
> +	struct list_head kdbus_domain_free;
> +	struct list_head kdbus_bus_alloc;
> +	struct list_head kdbus_bus_free;
> +	struct list_head kdbus_send;
> +	struct list_head kdbus_recv;
> +	struct list_head kdbus_name_acquire;
> +	struct list_head kdbus_name_list;
> +	struct list_head kdbus_ep_create;
> +	struct list_head kdbus_ep_setpolicy;
> +	struct list_head kdbus_connect;
> +	struct list_head kdbus_conn_free;
> +	struct list_head kdbus_conn_info;
> +	struct list_head kdbus_talk;
>  #ifdef CONFIG_SECURITY_NETWORK
>  	struct list_head unix_stream_connect;
>  	struct list_head unix_may_send;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 79d85dd..5f257b9 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -53,6 +53,10 @@ struct msg_queue;
>  struct xattr;
>  struct xfrm_sec_ctx;
>  struct mm_struct;
> +struct kdbus_ep;
> +struct kdbus_bus;
> +struct kdbus_conn;
> +struct kdbus_domain;
> =20
>  /* If capable should audit the security request */
>  #define SECURITY_CAP_NOAUDIT 0
> @@ -356,6 +360,28 @@ void security_release_secctx(char *secdata, u32=20
> seclen);
>  int security_inode_notifysecctx(struct inode *inode, void *ctx, u32=20
> ctxlen);
>  int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32=20
> ctxlen);
>  int security_inode_getsecctx(struct inode *inode, void **ctx, u32=20
> *ctxlen);
> +
> +int security_kdbus_domain_alloc(struct kdbus_domain *domain);
> +void security_kdbus_domain_free(struct kdbus_domain *domain);
> +
> +int security_kdbus_bus_alloc(struct kdbus_bus *bus);
> +void security_kdbus_bus_free(struct kdbus_bus *bus);
> +int security_kdbus_send(const struct kdbus_conn *conn,
> +			const struct kdbus_bus *bus);
> +int security_kdbus_recv(const struct kdbus_conn *conn,
> +			const struct kdbus_bus *bus);
> +int security_kdbus_name_acquire(const struct kdbus_conn *conn,
> +				const char *name);
> +int security_kdbus_name_list(const struct kdbus_bus *bus);
> +int security_kdbus_ep_create(struct kdbus_bus *bus);
> +int security_kdbus_ep_setpolicy(struct kdbus_bus *bus);
> +int security_kdbus_connect(struct kdbus_conn *conn,
> +			   const char *secctx, u32 seclen);
> +void security_kdbus_conn_free(struct kdbus_conn *conn);
> +int security_kdbus_conn_info(const struct kdbus_conn *conn);
> +int security_kdbus_talk(const struct kdbus_conn *src,
> +			const struct kdbus_conn *dst);
> +
>  #else /* CONFIG_SECURITY */
>  struct security_mnt_opts {
>  };
> @@ -1105,6 +1131,79 @@ static inline int=20
> security_inode_getsecctx(struct inode *inode, void **ctx, u32
>  {
>  	return -EOPNOTSUPP;
>  }
> +
> +static inline int security_kdbus_domain_alloc(struct kdbus_domain=20
> *domain)
> +{
> +	return 0;
> +}
> +
> +static inline void security_kdbus_domain_free(struct kdbus_domain=20
> *domain)
> +{
> +}
> +
> +static inline int security_kdbus_bus_alloc(struct kdbus_bus *bus)
> +{
> +	return 0;
> +}
> +
> +static inline void security_kdbus_bus_free(struct kdbus_bus *bus)
> +{
> +}
> +
> +static inline int security_kdbus_send(const struct kdbus_conn *conn,
> +				      const struct kdbus_bus *bus)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_recv(const struct kdbus_conn *conn,
> +				      const struct kdbus_bus *bus)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_name_acquire(const struct=20
> kdbus_conn *conn,
> +					      const char *name)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_name_list(const struct kdbus_bus=20
> *bus)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_ep_create(const struct kdbus_bus=20
> *bus)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_ep_setpolicy(const struct kdbus_bus=
=20
> *bus)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_connect(struct kdbus_conn *conn,
> +					 const char *secctx, u32=20
> seclen)
> +{
> +	return 0;
> +}
> +
> +static inline void security_kdbus_conn_free(struct kdbus_conn *conn)
> +{
> +}
> +
> +static inline int security_kdbus_conn_info(const struct kdbus_conn=20
> *conn)
> +{
> +	return 0;
> +}
> +
> +static inline int security_kdbus_talk(const struct kdbus_conn *src,
> +				      const struct kdbus_conn *dst)
> +{
> +	return 0;
> +}
> +
>  #endif	/* CONFIG_SECURITY */
> =20
>  #ifdef CONFIG_SECURITY_NETWORK
> diff --git a/security/security.c b/security/security.c
> index b1e935b..7fb46d1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1185,6 +1185,95 @@ int security_inode_getsecctx(struct inode=20
> *inode, void **ctx, u32 *ctxlen)
>  }
>  EXPORT_SYMBOL(security_inode_getsecctx);
> =20
> +int security_kdbus_domain_alloc(struct kdbus_domain *domain)
> +{
> +	return call_int_hook(kdbus_domain_alloc, 0, domain);
> +}
> +EXPORT_SYMBOL(security_kdbus_domain_alloc);
> +
> +void security_kdbus_domain_free(struct kdbus_domain *domain)
> +{
> +	call_void_hook(kdbus_domain_free, domain);
> +}
> +EXPORT_SYMBOL(security_kdbus_domain_free);
> +
> +int security_kdbus_bus_alloc(struct kdbus_bus *bus)
> +{
> +	return call_int_hook(kdbus_bus_alloc, 0, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_bus_alloc);
> +
> +void security_kdbus_bus_free(struct kdbus_bus *bus)
> +{
> +	call_void_hook(kdbus_bus_free, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_bus_free);
> +
> +int security_kdbus_send(const struct kdbus_conn *conn,
> +			const struct kdbus_bus *bus)
> +{
> +	return call_int_hook(kdbus_send, 0, conn, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_send);
> +
> +int security_kdbus_recv(const struct kdbus_conn *conn,
> +			const struct kdbus_bus *bus)
> +{
> +	return call_int_hook(kdbus_recv, 0, conn, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_recv);
> +
> +int security_kdbus_name_acquire(const struct kdbus_conn *conn,
> +				const char *name)
> +{
> +	return call_int_hook(kdbus_name_acquire, 0, conn, name);
> +}
> +EXPORT_SYMBOL(security_kdbus_name_acquire);
> +
> +int security_kdbus_name_list(const struct kdbus_bus *bus)
> +{
> +	return call_int_hook(kdbus_name_list, 0, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_name_list);
> +
> +int security_kdbus_ep_create(struct kdbus_bus *bus)
> +{
> +	return call_int_hook(kdbus_ep_create, 0, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_ep_create);
> +
> +int security_kdbus_ep_setpolicy(struct kdbus_bus *bus)
> +{
> +	return call_int_hook(kdbus_ep_setpolicy, 0, bus);
> +}
> +EXPORT_SYMBOL(security_kdbus_ep_setpolicy);
> +
> +int security_kdbus_connect(struct kdbus_conn *conn,
> +			   const char *secctx, u32 seclen)
> +{
> +	return call_int_hook(kdbus_connect, 0, conn, secctx,=20
> seclen);
> +}
> +EXPORT_SYMBOL(security_kdbus_connect);
> +
> +void security_kdbus_conn_free(struct kdbus_conn *conn)
> +{
> +	call_void_hook(kdbus_conn_free, conn);
> +}
> +EXPORT_SYMBOL(security_kdbus_conn_free);
> +
> +int security_kdbus_conn_info(const struct kdbus_conn *conn)
> +{
> +	return call_int_hook(kdbus_conn_info, 0, conn);
> +}
> +EXPORT_SYMBOL(security_kdbus_conn_info);
> +
> +int security_kdbus_talk(const struct kdbus_conn *src,
> +			const struct kdbus_conn *dst)
> +{
> +	return call_int_hook(kdbus_talk, 0, src, dst);
> +}
> +EXPORT_SYMBOL(security_kdbus_talk);
> +
>  #ifdef CONFIG_SECURITY_NETWORK
> =20
>  int security_unix_stream_connect(struct sock *sock, struct sock=20
> *other, struct sock *newsk)
> @@ -1774,6 +1863,34 @@ struct security_hook_heads security_hook_heads=
=20
> =3D {
>  		LIST_HEAD_INIT(security_hook_heads.inode_setsecctx),
>  	.inode_getsecctx =3D
>  		LIST_HEAD_INIT(security_hook_heads.inode_getsecctx),
> +	.kdbus_domain_alloc =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_domain_allo
> c),
> +	.kdbus_domain_free =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_domain_free
> ),
> +	.kdbus_bus_alloc =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_bus_alloc),
> +	.kdbus_bus_free =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_bus_free),
> +	.kdbus_send =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_send),
> +	.kdbus_recv =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_recv),
> +	.kdbus_name_acquire =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_name_acquir
> e),
> +	.kdbus_name_list =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_name_list),
> +	.kdbus_ep_create =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_ep_create),
> +	.kdbus_ep_setpolicy =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_ep_setpolic
> y),
> +	.kdbus_connect =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_connect),
> +	.kdbus_conn_free =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_conn_free),
> +	.kdbus_conn_info =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_conn_info),
> +	.kdbus_talk =3D
> +		LIST_HEAD_INIT(security_hook_heads.kdbus_talk),
>  #ifdef CONFIG_SECURITY_NETWORK
>  	.unix_stream_connect =3D
>  		LIST_HEAD_INIT(security_hook_heads.unix_stream_conne
> ct),
--=20
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics
