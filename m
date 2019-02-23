From: Martin Lau <kafai@fb.com>
Subject: Re: [PATCH 1/3] bpf: add helper to check for a valid SYN cookie
Date: Sat, 23 Feb 2019 00:44:34 +0000
Message-ID: <20190223004431.osqrn3u3lp7a6zww@kafai-mbp.dhcp.thefacebook.com>
References: <20190222095057.9442-1-lmb@cloudflare.com>
 <20190222095057.9442-2-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190222095057.9442-2-lmb@cloudflare.com>
Content-Language: en-US
Content-ID: <9CF7E04E313A75459CCC8D131CB08202@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 22, 2019 at 09:50:55AM +0000, Lorenz Bauer wrote:
> Using bpf_sk_lookup_tcp it's possible to ascertain whether a packet belon=
gs
> to a known connection. However, there is one corner case: no sockets are
> created if SYN cookies are active. This means that the final ACK in the
> 3WHS is misclassified.
>=20
> Using the helper, we can look up the listening socket via bpf_sk_lookup_t=
cp
> and then check whether a packet is a valid SYN cookie ACK.
>=20
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/uapi/linux/bpf.h | 18 ++++++++++-
>  net/core/filter.c        | 68 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index bcdd2474eee7..bc2af87e9621 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2359,6 +2359,21 @@ union bpf_attr {
>   *	Return
>   *		A **struct bpf_tcp_sock** pointer on success, or NULL in
>   *		case of failure.
> + *
> + * int bpf_sk_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_le=
n, struct tcphdr *th, u32 th_len)
> + * 	Description
> + * 		Check whether iph and th contain a valid SYN cookie ACK for
> + * 		the listening socket in sk.
> + *
> + * 		iph points to the start of the IPv4 or IPv6 header, while
> + * 		iph_len contains sizeof(struct iphdr) or sizeof(struct ip6hdr).
> + *
> + * 		th points to the start of the TCP header, while th_len contains
> + * 		sizeof(struct tcphdr).
> + *
> + * 	Return
> + * 		0 if iph and th are a valid SYN cookie ACK, or a negative error
> + * 		otherwise.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -2457,7 +2472,8 @@ union bpf_attr {
>  	FN(spin_lock),			\
>  	FN(spin_unlock),		\
>  	FN(sk_fullsock),		\
> -	FN(tcp_sock),
> +	FN(tcp_sock),			\
> +	FN(sk_check_syncookie),
> =20
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>   * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 85749f6ec789..9e68897cc7ed 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5426,6 +5426,70 @@ static const struct bpf_func_proto bpf_tcp_sock_pr=
oto =3D {
>  	.arg1_type	=3D ARG_PTR_TO_SOCK_COMMON,
>  };
> =20
> +BPF_CALL_5(bpf_sk_check_syncookie, struct sock *, sk, void *, iph, u32, =
iph_len,
s/bpf_sk_check_syncookie/bpf_tcp_check_syncookie/

> +	   struct tcphdr *, th, u32, th_len)
> +{
> +#if IS_ENABLED(CONFIG_SYN_COOKIES)
nit. "#ifdef CONFIG_SYN_COOKIES" such that it is clear it is a bool kconfig=
.

> +	u32 cookie;
> +	int ret;
> +
> +	if (unlikely(th_len < sizeof(*th)))
> +		return -EINVAL;
> +
> +	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
> +	if (sk->sk_protocol !=3D IPPROTO_TCP || sk->sk_state !=3D TCP_LISTEN)
>From the test program in patch 3, the "sk" here is obtained from
bpf_sk_lookup_tcp() which does a sk_to_full_sk() before returning.
AFAICT, meaning bpf_sk_lookup_tcp() will return the listening sk
even if there is a request_sock.  Does it make sense to check
syncookie if there is already a request_sock?

> +		return -EINVAL;
> +
> +	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
Should tcp_synq_no_recent_overflow(tp) be checked also?

> +		return -EINVAL;
> +
> +	if (!th->ack || th->rst)
How about th->syn?

> +		return -ENOENT;
> +
> +	cookie =3D ntohl(th->ack_seq) - 1;
> +
> +	switch (sk->sk_family) {
> +	case AF_INET:
> +		if (unlikely(iph_len < sizeof(struct iphdr)))
> +			return -EINVAL;
> +
> +		ret =3D __cookie_v4_check((struct iphdr *)iph, th, cookie);
> +		break;
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> +			return -EINVAL;
> +
> +		ret =3D __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
> +		break;
> +#endif /* CONFIG_IPV6 */
> +
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	if (ret > 0)
> +		return 0;
> +
> +	return -ENOENT;
> +#else
> +	return -ENOTSUP;
> +#endif
> +}
> +
> +static const struct bpf_func_proto bpf_sk_check_syncookie_proto =3D {
> +	.func		=3D bpf_sk_check_syncookie,
> +	.gpl_only	=3D true,
> +	.pkt_access	=3D true,
> +	.ret_type	=3D RET_INTEGER,
> +	.arg1_type	=3D ARG_PTR_TO_SOCKET,
I think it should be ARG_PTR_TO_TCP_SOCK

> +	.arg2_type	=3D ARG_PTR_TO_MEM,
> +	.arg3_type	=3D ARG_CONST_SIZE,
> +	.arg4_type	=3D ARG_PTR_TO_MEM,
> +	.arg5_type	=3D ARG_CONST_SIZE,
> +};
> +
>  #endif /* CONFIG_INET */
