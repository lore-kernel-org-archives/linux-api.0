From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC 5/8] kdbus: use LSM hooks in kdbus code
Date: Wed, 08 Jul 2015 13:06:00 +0200
Message-ID: <1436353560.2331.1.camel@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-6-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1436351110-5902-6-git-send-email-p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On =C5=9Bro, 2015-07-08 at 12:25 +0200, Paul Osmialowski wrote:
> Originates from:
>=20
> https://github.com/lmctl/kdbus.git (branch: kdbus-lsm-v4.for-systemd
> -v212)
> commit: aa0885489d19be92fa41c6f0a71df28763228a40
>=20
> Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  ipc/kdbus/bus.c        | 12 ++++++++++-
>  ipc/kdbus/bus.h        |  3 +++
>  ipc/kdbus/connection.c | 54=20
> ++++++++++++++++++++++++++++++++++++++++++++++++++
>  ipc/kdbus/connection.h |  4 ++++
>  ipc/kdbus/domain.c     |  9 ++++++++-
>  ipc/kdbus/domain.h     |  2 ++
>  ipc/kdbus/endpoint.c   | 11 ++++++++++
>  ipc/kdbus/names.c      | 11 ++++++++++
>  ipc/kdbus/queue.c      | 30 ++++++++++++++++++----------
>  9 files changed, 124 insertions(+), 12 deletions(-)
>=20
> diff --git a/ipc/kdbus/bus.c b/ipc/kdbus/bus.c
> index bbdf0f2..9894895 100644
> --- a/ipc/kdbus/bus.c
> +++ b/ipc/kdbus/bus.c
> @@ -22,6 +22,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/uio.h>
> +#include <linux/security.h>
> =20
>  #include "bus.h"
>  #include "notify.h"
> @@ -51,6 +52,7 @@ static void kdbus_bus_free(struct kdbus_node *node)
>  	kdbus_domain_unref(bus->domain);
>  	kdbus_policy_db_clear(&bus->policy_db);
>  	kdbus_meta_proc_unref(bus->creator_meta);
> +	security_kdbus_bus_free(bus);
>  	kfree(bus);
>  }
> =20
> @@ -161,6 +163,12 @@ static struct kdbus_bus *kdbus_bus_new(struct=20
> kdbus_domain *domain,
>  		goto exit_unref;
>  	}
> =20
> +	ret =3D security_kdbus_bus_alloc(b);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit_unref;
> +	}
> +
>  	/*
>  	 * Bus-limits of the creator are accounted on its real UID,=20
> just like
>  	 * all other per-user limits.
> @@ -169,11 +177,13 @@ static struct kdbus_bus *kdbus_bus_new(struct=20
> kdbus_domain *domain,
>  	if (IS_ERR(b->creator)) {
>  		ret =3D PTR_ERR(b->creator);
>  		b->creator =3D NULL;
> -		goto exit_unref;
> +		goto exit_free_security;
>  	}
> =20
>  	return b;
> =20
> +exit_free_security:
> +	security_kdbus_bus_free(b);
>  exit_unref:
>  	kdbus_node_deactivate(&b->node);
>  	kdbus_node_unref(&b->node);
> diff --git a/ipc/kdbus/bus.h b/ipc/kdbus/bus.h
> index 5bea5ef..03e4a54 100644
> --- a/ipc/kdbus/bus.h
> +++ b/ipc/kdbus/bus.h
> @@ -53,6 +53,7 @@ struct kdbus_user;
>   * @notify_list:	List of pending kernel-generated messages
>   * @notify_lock:	Notification list lock
>   * @notify_flush_lock:	Notification flushing lock
> + * @security:		LSM security blob
>   */
>  struct kdbus_bus {
>  	struct kdbus_node node;
> @@ -81,6 +82,8 @@ struct kdbus_bus {
>  	struct list_head notify_list;
>  	spinlock_t notify_lock;
>  	struct mutex notify_flush_lock;
> +
> +	void *security;

Security blobs are usually inside #ifdef CONFIG_SECURITY

>  };
> =20
>  struct kdbus_bus *kdbus_bus_ref(struct kdbus_bus *bus);
> diff --git a/ipc/kdbus/connection.c b/ipc/kdbus/connection.c
> index 9993753..b85cdc7 100644
> --- a/ipc/kdbus/connection.c
> +++ b/ipc/kdbus/connection.c
> @@ -31,6 +31,7 @@
>  #include <linux/slab.h>
>  #include <linux/syscalls.h>
>  #include <linux/uio.h>
> +#include <linux/security.h>
> =20
>  #include "bus.h"
>  #include "connection.h"
> @@ -73,6 +74,8 @@ static struct kdbus_conn *kdbus_conn_new(struct=20
> kdbus_ep *ep, bool privileged,
>  	bool is_activator;
>  	bool is_monitor;
>  	struct kvec kvec;
> +	u32 sid, len;
> +	char *label;
>  	int ret;
> =20
>  	struct {
> @@ -222,6 +225,14 @@ static struct kdbus_conn *kdbus_conn_new(struct=20
> kdbus_ep *ep, bool privileged,
>  		}
>  	}
> =20
> +	security_task_getsecid(current, &sid);
> +	security_secid_to_secctx(sid, &label, &len);
> +	ret =3D security_kdbus_connect(conn, label, len);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit_unref;
> +	}
> +
>  	if (atomic_inc_return(&conn->user->connections) >=20
> KDBUS_USER_MAX_CONN) {
>  		/* decremented by destructor as conn->user is valid=20
> */
>  		ret =3D -EMFILE;
> @@ -276,6 +287,7 @@ static void __kdbus_conn_free(struct kref *kref)
>  	kdbus_pool_free(conn->pool);
>  	kdbus_ep_unref(conn->ep);
>  	put_cred(conn->cred);
> +	security_kdbus_conn_free(conn);
>  	kfree(conn->description);
>  	kfree(conn->quota);
>  	kfree(conn);
> @@ -1107,6 +1119,12 @@ static int kdbus_conn_reply(struct kdbus_conn=20
> *src, struct kdbus_kmsg *kmsg)
>  	if (ret < 0)
>  		goto exit;
> =20
> +	ret =3D security_kdbus_talk(src, dst);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit;
> +	}
> +
>  	mutex_lock(&dst->lock);
>  	reply =3D kdbus_reply_find(src, dst, kmsg->msg.cookie_reply);
>  	if (reply) {
> @@ -1187,6 +1205,12 @@ static struct kdbus_reply=20
> *kdbus_conn_call(struct kdbus_conn *src,
>  	if (ret < 0)
>  		goto exit;
> =20
> +	ret =3D security_kdbus_talk(src, dst);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit;
> +	}
> +
>  	if (!kdbus_conn_policy_talk(src, current_cred(), dst)) {
>  		ret =3D -EPERM;
>  		goto exit;
> @@ -1248,6 +1272,12 @@ static int kdbus_conn_unicast(struct=20
> kdbus_conn *src, struct kdbus_kmsg *kmsg)
>  	if (ret < 0)
>  		goto exit;
> =20
> +	ret =3D security_kdbus_talk(src, dst);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit;
> +	}
> +
>  	if (is_signal) {
>  		/* like broadcasts we eavesdrop even if the msg is=20
> dropped */
>  		kdbus_bus_eavesdrop(bus, src, kmsg);
> @@ -1639,6 +1669,12 @@ struct kdbus_conn *kdbus_cmd_hello(struct=20
> kdbus_ep *ep, bool privileged,
>  		if (ret < 0)
>  			goto exit;
> =20
> +		ret =3D security_kdbus_ep_setpolicy(c->ep->bus);
> +		if (ret) {
> +			ret =3D -EPERM;
> +			goto exit;
> +		}
> +
>  		ret =3D kdbus_policy_set(&c->ep->bus->policy_db,=20
> args.items,
>  				       args.items_size, 1,
>  				     =20
>  kdbus_conn_is_policy_holder(c), c);
> @@ -1732,6 +1768,10 @@ int kdbus_cmd_conn_info(struct kdbus_conn=20
> *conn, void __user *argp)
>  	if (ret !=3D 0)
>  		return ret;
> =20
> +	ret =3D security_kdbus_conn_info(conn);
> +	if (ret)
> +		return -EPERM;
> +
>  	/* registry must be held throughout lookup *and* collecting=20
> data */
>  	down_read(&bus->name_registry->rwlock);
> =20
> @@ -1905,6 +1945,12 @@ int kdbus_cmd_update(struct kdbus_conn *conn,=20
> void __user *argp)
>  	/* now that we verified the input, update the connection */
> =20
>  	if (item_policy) {
> +		ret =3D security_kdbus_ep_setpolicy(conn->ep->bus);
> +		if (ret) {
> +			ret =3D -EPERM;
> +			goto exit;
> +		}
> +
>  		ret =3D kdbus_policy_set(&conn->ep->bus->policy_db,=20
> cmd->items,
>  				       KDBUS_ITEMS_SIZE(cmd, items),
>  				       1, true, conn);
> @@ -1948,6 +1994,10 @@ int kdbus_cmd_send(struct kdbus_conn *conn,=20
> struct file *f, void __user *argp)
>  		.argc =3D ARRAY_SIZE(argv),
>  	};
> =20
> +	ret =3D security_kdbus_send(conn, conn->ep->bus);
> +	if (ret)
> +		return -EPERM;
> +
>  	if (!kdbus_conn_is_ordinary(conn))
>  		return -EOPNOTSUPP;
> =20
> @@ -2044,6 +2094,10 @@ int kdbus_cmd_recv(struct kdbus_conn *conn,=20
> void __user *argp)
>  		.argc =3D ARRAY_SIZE(argv),
>  	};
> =20
> +	ret =3D security_kdbus_recv(conn, conn->ep->bus);
> +	if (ret)
> +		return -EPERM;
> +
>  	if (!kdbus_conn_is_ordinary(conn) &&
>  	    !kdbus_conn_is_monitor(conn) &&
>  	    !kdbus_conn_is_activator(conn))
> diff --git a/ipc/kdbus/connection.h b/ipc/kdbus/connection.h
> index d1ffe90..1f91d39 100644
> --- a/ipc/kdbus/connection.h
> +++ b/ipc/kdbus/connection.h
> @@ -19,6 +19,7 @@
>  #include <linux/kref.h>
>  #include <linux/lockdep.h>
>  #include <linux/path.h>
> +#include <uapi/linux/kdbus.h>
> =20
>  #include "limits.h"
>  #include "metadata.h"
> @@ -73,6 +74,7 @@ struct kdbus_kmsg;
>   * @names_queue_list:	Well-known names this connection waits for
>   * @privileged:		Whether this connection is=20
> privileged on the bus
>   * @faked_meta:		Whether the metadata was faked on=20
> HELLO
> + * @security:		LSM security blob
>   */
>  struct kdbus_conn {
>  	struct kref kref;
> @@ -113,6 +115,8 @@ struct kdbus_conn {
> =20
>  	bool privileged:1;
>  	bool faked_meta:1;
> +
> +	void *security;
>  };
> =20
>  struct kdbus_conn *kdbus_conn_ref(struct kdbus_conn *conn);
> diff --git a/ipc/kdbus/domain.c b/ipc/kdbus/domain.c
> index ac9f760..da9cdab 100644
> --- a/ipc/kdbus/domain.c
> +++ b/ipc/kdbus/domain.c
> @@ -20,6 +20,7 @@
>  #include <linux/sizes.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/security.h>
> =20
>  #include "bus.h"
>  #include "domain.h"
> @@ -73,6 +74,7 @@ static void kdbus_domain_free(struct kdbus_node=20
> *node)
>  	put_user_ns(domain->user_namespace);
>  	ida_destroy(&domain->user_ida);
>  	idr_destroy(&domain->user_idr);
> +	security_kdbus_domain_free(domain);
>  	kfree(domain);
>  }
> =20
> @@ -104,6 +106,10 @@ struct kdbus_domain *kdbus_domain_new(unsigned=20
> int access)
>  	idr_init(&d->user_idr);
>  	ida_init(&d->user_ida);
> =20
> +	ret =3D security_kdbus_domain_alloc(d);
> +	if (ret)
> +		return ERR_PTR(-EPERM);
> +
>  	/* Pin user namespace so we can guarantee domain-unique bus=20
> * names. */
>  	d->user_namespace =3D get_user_ns(current_user_ns());
> =20
> @@ -116,6 +122,7 @@ struct kdbus_domain *kdbus_domain_new(unsigned=20
> int access)
>  exit_unref:
>  	kdbus_node_deactivate(&d->node);
>  	kdbus_node_unref(&d->node);
> +	security_kdbus_domain_free(d);
>  	return ERR_PTR(ret);
>  }
> =20
> @@ -264,7 +271,7 @@ static void __kdbus_user_free(struct kref *kref)
>  	if (uid_valid(user->uid))
>  		idr_remove(&user->domain->user_idr, __kuid_val(user
> ->uid));
>  	mutex_unlock(&user->domain->lock);
> -
> +	security_kdbus_domain_free(user->domain);
>  	kdbus_domain_unref(user->domain);
>  	kfree(user);
>  }
> diff --git a/ipc/kdbus/domain.h b/ipc/kdbus/domain.h
> index 447a2bd..3db06d8 100644
> --- a/ipc/kdbus/domain.h
> +++ b/ipc/kdbus/domain.h
> @@ -31,6 +31,7 @@
>   * @user_ida:		Set of all users to compute small indices
>   * @user_namespace:	User namespace, pinned at creation time
>   * @dentry:		Root dentry of VFS mount (don't use outside=20
> of kdbusfs)
> + * @security:		LSM security blob
>   */
>  struct kdbus_domain {
>  	struct kdbus_node node;
> @@ -40,6 +41,7 @@ struct kdbus_domain {
>  	struct ida user_ida;
>  	struct user_namespace *user_namespace;
>  	struct dentry *dentry;
> +	void *security;
>  };
> =20
>  /**
> diff --git a/ipc/kdbus/endpoint.c b/ipc/kdbus/endpoint.c
> index 9a95a5e..380228f 100644
> --- a/ipc/kdbus/endpoint.c
> +++ b/ipc/kdbus/endpoint.c
> @@ -21,6 +21,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/uio.h>
> +#include <linux/security.h>
> =20
>  #include "bus.h"
>  #include "connection.h"
> @@ -122,6 +123,12 @@ struct kdbus_ep *kdbus_ep_new(struct kdbus_bus=20
> *bus, const char *name,
>  	kdbus_policy_db_init(&e->policy_db);
>  	e->bus =3D kdbus_bus_ref(bus);
> =20
> +	ret =3D security_kdbus_ep_create(bus);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit_unref;
> +	}
> +
>  	ret =3D kdbus_node_link(&e->node, &bus->node, name);
>  	if (ret < 0)
>  		goto exit_unref;
> @@ -265,6 +272,10 @@ int kdbus_cmd_ep_update(struct kdbus_ep *ep,=20
> void __user *argp)
>  		.argc =3D ARRAY_SIZE(argv),
>  	};
> =20
> +	ret =3D security_kdbus_ep_setpolicy(ep->bus);
> +	if (ret)
> +		return -EPERM;
> +
>  	ret =3D kdbus_args_parse(&args, argp, &cmd);
>  	if (ret !=3D 0)
>  		return ret;
> diff --git a/ipc/kdbus/names.c b/ipc/kdbus/names.c
> index d77ee08..dd20bea 100644
> --- a/ipc/kdbus/names.c
> +++ b/ipc/kdbus/names.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/uio.h>
> +#include <linux/security.h>
> =20
>  #include "bus.h"
>  #include "connection.h"
> @@ -503,6 +504,12 @@ int kdbus_cmd_name_acquire(struct kdbus_conn=20
> *conn, void __user *argp)
>  		goto exit;
>  	}
> =20
> +	ret =3D security_kdbus_name_acquire(conn, item_name);
> +	if (ret) {
> +		ret =3D -EPERM;
> +		goto exit;
> +	}
> +
>  	/*
>  	 * Do atomic_inc_return here to reserve our slot, then=20
> decrement
>  	 * it before returning.
> @@ -724,6 +731,10 @@ int kdbus_cmd_list(struct kdbus_conn *conn, void=
=20
> __user *argp)
>  	if (ret !=3D 0)
>  		return ret;
> =20
> +	ret =3D security_kdbus_name_list(conn->ep->bus);
> +	if (ret)
> +		return -EPERM;
> +
>  	/* lock order: domain -> bus -> ep -> names -> conn */
>  	down_read(&reg->rwlock);
>  	down_read(&conn->ep->bus->conn_rwlock);
> diff --git a/ipc/kdbus/queue.c b/ipc/kdbus/queue.c
> index 25bb3ad..9872fb4 100644
> --- a/ipc/kdbus/queue.c
> +++ b/ipc/kdbus/queue.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  #include <linux/syscalls.h>
>  #include <linux/uio.h>
> +#include <linux/security.h>
> =20
>  #include "util.h"
>  #include "domain.h"
> @@ -514,12 +515,17 @@ int kdbus_queue_entry_install(struct=20
> kdbus_queue_entry *entry,
> =20
>  		for (i =3D 0; i < res->fds_count; i++) {
>  			if (install_fds) {
> -				fds[i] =3D=20
> get_unused_fd_flags(O_CLOEXEC);
> -				if (fds[i] >=3D 0)
> -					fd_install(fds[i],
> -						   get_file(res
> ->fds[i]));
> -				else
> +				if (security_file_receive(res
> ->fds[i])) {
> +					fds[i] =3D -1;
>  					incomplete_fds =3D true;
> +				} else {
> +					fds[i] =3D=20
> get_unused_fd_flags(O_CLOEXEC);
> +					if (fds[i] >=3D 0)
> +						fd_install(fds[i],
> +							get_file(res
> ->fds[i]));
> +					else
> +						incomplete_fds =3D=20
> true;
> +				}
>  			} else {
>  				fds[i] =3D -1;
>  			}
> @@ -557,13 +563,17 @@ int kdbus_queue_entry_install(struct=20
> kdbus_queue_entry *entry,
>  		m.fd =3D -1;
> =20
>  		if (install_fds) {
> -			m.fd =3D get_unused_fd_flags(O_CLOEXEC);
> -			if (m.fd < 0) {
> -				m.fd =3D -1;
> +			if (security_file_receive(d->memfd.file)) {
>  				incomplete_fds =3D true;
>  			} else {
> -				fd_install(m.fd,
> -					   get_file(d->memfd.file));
> +				m.fd =3D=20
> get_unused_fd_flags(O_CLOEXEC);
> +				if (m.fd < 0) {
> +					m.fd =3D -1;
> +					incomplete_fds =3D true;
> +				} else {
> +					fd_install(m.fd,
> +						get_file(d
> ->memfd.file));
> +				}
>  			}
>  		}
> =20
--=20
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics
