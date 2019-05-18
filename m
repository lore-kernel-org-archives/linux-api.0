From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date: Sat, 18 May 2019 10:18:54 -0700
Message-ID: <6CDA54A5-56FF-4B42-B6F5-762E72C3FC3B@amacapital.net>
References: <20190518034820.16500-1-felipe@felipegasper.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190518034820.16500-1-felipe@felipegasper.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Felipe Gasper <felipe@felipegasper.com>
Cc: davem@davemloft.net, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org



> On May 17, 2019, at 8:48 PM, Felipe Gasper <felipe@felipegasper.com> wrote=
:
>=20
> Author: Felipe Gasper <felipe@felipegasper.com>
> Date:   Fri May 17 16:54:40 2019 -0500
>=20
>   net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
>=20
>   This adds the ability for Netlink to report a socket=E2=80=99s UID along=
 with the
>   other UNIX diagnostic information that is already available. This will
>   allow diagnostic tools greater insight into which users control which so=
cket.
>=20
>   Signed-off-by: Felipe Gasper <felipe@felipegasper.com>
>=20
> diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_diag=
.h
> index 5c502fd..a198857 100644
> --- a/include/uapi/linux/unix_diag.h
> +++ b/include/uapi/linux/unix_diag.h
> @@ -20,6 +20,7 @@ struct unix_diag_req {
> #define UDIAG_SHOW_ICONS    0x00000008    /* show pending connections */
> #define UDIAG_SHOW_RQLEN    0x00000010    /* show skb receive queue len */=

> #define UDIAG_SHOW_MEMINFO    0x00000020    /* show memory info of a socke=
t */
> +#define UDIAG_SHOW_UID        0x00000040    /* show socket's UID */
>=20
> struct unix_diag_msg {
>    __u8    udiag_family;
> @@ -40,6 +41,7 @@ enum {
>    UNIX_DIAG_RQLEN,
>    UNIX_DIAG_MEMINFO,
>    UNIX_DIAG_SHUTDOWN,
> +    UNIX_DIAG_UID,
>=20
>    __UNIX_DIAG_MAX,
> };
> diff --git a/net/unix/diag.c b/net/unix/diag.c
> index 3183d9b..e40f348 100644
> --- a/net/unix/diag.c
> +++ b/net/unix/diag.c
> @@ -4,9 +4,11 @@
> #include <linux/unix_diag.h>
> #include <linux/skbuff.h>
> #include <linux/module.h>
> +#include <linux/uidgid.h>
> #include <net/netlink.h>
> #include <net/af_unix.h>
> #include <net/tcp_states.h>
> +#include <net/sock.h>
>=20
> static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
> {
> @@ -110,6 +112,12 @@ static int sk_diag_show_rqlen(struct sock *sk, struct=
 sk_buff *nlskb)
>    return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
> }
>=20
> +static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
> +{
> +    uid_t uid =3D from_kuid_munged(sk_user_ns(sk), sock_i_uid(sk));
> +    return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);

This still looks wrong. You=E2=80=99re reporting the uid of the socket as se=
en by that socket.  Presumably you actually want the uid of the socket as se=
en by the *diagnostic* socket. This might be sk_user_ns(nlskb->sk).

You can test this with a command like unshare -U -r nc -l 12345 run as no -r=
oot. Then run you user diagnostic tool to find the uid of the socket. It sho=
uld not be zero. Similarly, if you run unshare -U -r bash and then open a so=
cket and run your diagnostic tool, both from that same session, you should s=
ee 0 as the uid since bash and all its children think they=E2=80=99re uid 0.=


> +}

> +
> static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_=
diag_req *req,
>        u32 portid, u32 seq, u32 flags, int sk_ino)
> {
> @@ -156,6 +164,10 @@ static int sk_diag_fill(struct sock *sk, struct sk_bu=
ff *skb, struct unix_diag_r
>    if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
>        goto out_nlmsg_trim;
>=20
> +    if ((req->udiag_show & UDIAG_SHOW_UID) &&
> +        sk_diag_dump_uid(sk, skb))
> +        goto out_nlmsg_trim;
> +
>    nlmsg_end(skb, nlh);
>    return 0;
>=20
