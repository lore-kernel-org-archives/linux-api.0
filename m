From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date: Thu, 16 May 2019 21:59:03 -0700
Message-ID: <CALCETrUaTamZ1ZGbWpu+4kDAEFRqyESoa_4tgwpAmMh3NVQ4pQ@mail.gmail.com>
References: <20190517032505.19921-1-felipe@felipegasper.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190517032505.19921-1-felipe@felipegasper.com>
Sender: netdev-owner@vger.kernel.org
To: Felipe <felipe@felipegasper.com>
Cc: "David S. Miller" <davem@davemloft.net>, Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> On May 16, 2019, at 8:25 PM, Felipe <felipe@felipegasper.com> wrote:
>
> Author: Felipe Gasper <felipe@felipegasper.com>
> Date:   Thu May 16 12:16:53 2019 -0500
>
>    Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
>
>    This adds the ability for Netlink to report a socket=E2=80=99s UID alo=
ng with the
>    other UNIX socket diagnostic information that is already available. Th=
is will
>    allow diagnostic tools greater insight into which users control which =
socket.
>
>    Signed-off-by: Felipe Gasper <felipe@felipegasper.com>
>
> diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_dia=
g.h
> index 5c502fd..a198857 100644
> --- a/include/uapi/linux/unix_diag.h
> +++ b/include/uapi/linux/unix_diag.h
> @@ -20,6 +20,7 @@ struct unix_diag_req {
> #define UDIAG_SHOW_ICONS    0x00000008    /* show pending connections */
> #define UDIAG_SHOW_RQLEN    0x00000010    /* show skb receive queue len *=
/
> #define UDIAG_SHOW_MEMINFO    0x00000020    /* show memory info of a sock=
et */
> +#define UDIAG_SHOW_UID        0x00000040    /* show socket's UID */
>
> struct unix_diag_msg {
>    __u8    udiag_family;
> @@ -40,6 +41,7 @@ enum {
>    UNIX_DIAG_RQLEN,
>    UNIX_DIAG_MEMINFO,
>    UNIX_DIAG_SHUTDOWN,
> +    UNIX_DIAG_UID,
>
>    __UNIX_DIAG_MAX,
> };
> diff --git a/net/unix/diag.c b/net/unix/diag.c
> index 3183d9b..011f56c 100644
> --- a/net/unix/diag.c
> +++ b/net/unix/diag.c
> @@ -110,6 +110,11 @@ static int sk_diag_show_rqlen(struct sock *sk, struc=
t sk_buff *nlskb)
>    return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
> }
>
> +static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
> +{
> +    return nla_put(nlskb, UNIX_DIAG_UID, sizeof(kuid_t), &(sk->sk_uid));

That type is called *k* uid_t because it=E2=80=99s internal to the kernel. =
You
probably want from_kuid_munged(), which will fix it up for an
appropriate userns.  Presumably you want sk=E2=80=99s netns=E2=80=99s usern=
s.
