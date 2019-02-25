From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 1/3] bpf: add helper to check for a valid SYN cookie
Date: Mon, 25 Feb 2019 18:26:42 +0000
Message-ID: <CACAyw9_smq+c8rUt3ONk+J28CzPefuEOgs8at3q9_5s3zN0_1w@mail.gmail.com>
References: <20190222095057.9442-1-lmb@cloudflare.com> <20190222095057.9442-2-lmb@cloudflare.com>
 <20190223004431.osqrn3u3lp7a6zww@kafai-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190223004431.osqrn3u3lp7a6zww@kafai-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Martin Lau <kafai@fb.com>
Cc: "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, 23 Feb 2019 at 00:44, Martin Lau <kafai@fb.com> wrote:
>
> On Fri, Feb 22, 2019 at 09:50:55AM +0000, Lorenz Bauer wrote:
> > Using bpf_sk_lookup_tcp it's possible to ascertain whether a packet belongs
> > to a known connection. However, there is one corner case: no sockets are
> > created if SYN cookies are active. This means that the final ACK in the
> > 3WHS is misclassified.
> >
> > Using the helper, we can look up the listening socket via bpf_sk_lookup_tcp
> > and then check whether a packet is a valid SYN cookie ACK.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  include/uapi/linux/bpf.h | 18 ++++++++++-
> >  net/core/filter.c        | 68 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 85 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index bcdd2474eee7..bc2af87e9621 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2359,6 +2359,21 @@ union bpf_attr {
> >   *   Return
> >   *           A **struct bpf_tcp_sock** pointer on success, or NULL in
> >   *           case of failure.
> > + *
> > + * int bpf_sk_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
> > + *   Description
> > + *           Check whether iph and th contain a valid SYN cookie ACK for
> > + *           the listening socket in sk.
> > + *
> > + *           iph points to the start of the IPv4 or IPv6 header, while
> > + *           iph_len contains sizeof(struct iphdr) or sizeof(struct ip6hdr).
> > + *
> > + *           th points to the start of the TCP header, while th_len contains
> > + *           sizeof(struct tcphdr).
> > + *
> > + *   Return
> > + *           0 if iph and th are a valid SYN cookie ACK, or a negative error
> > + *           otherwise.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)                \
> >       FN(unspec),                     \
> > @@ -2457,7 +2472,8 @@ union bpf_attr {
> >       FN(spin_lock),                  \
> >       FN(spin_unlock),                \
> >       FN(sk_fullsock),                \
> > -     FN(tcp_sock),
> > +     FN(tcp_sock),                   \
> > +     FN(sk_check_syncookie),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 85749f6ec789..9e68897cc7ed 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5426,6 +5426,70 @@ static const struct bpf_func_proto bpf_tcp_sock_proto = {
> >       .arg1_type      = ARG_PTR_TO_SOCK_COMMON,
> >  };
> >
> > +BPF_CALL_5(bpf_sk_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> s/bpf_sk_check_syncookie/bpf_tcp_check_syncookie/>
>
> > +        struct tcphdr *, th, u32, th_len)
> > +{
> > +#if IS_ENABLED(CONFIG_SYN_COOKIES)
> nit. "#ifdef CONFIG_SYN_COOKIES" such that it is clear it is a bool kconfig.
>
> > +     u32 cookie;
> > +     int ret;
> > +
> > +     if (unlikely(th_len < sizeof(*th)))
> > +             return -EINVAL;
> > +
> > +     /* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
> > +     if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> From the test program in patch 3, the "sk" here is obtained from
> bpf_sk_lookup_tcp() which does a sk_to_full_sk() before returning.
> AFAICT, meaning bpf_sk_lookup_tcp() will return the listening sk
> even if there is a request_sock.  Does it make sense to check
> syncookie if there is already a request_sock?

No, that doesn't make a lot of sense. I hadn't realised that
sk_lookup_tcp only returns full sockets.
This means we need a way to detect that there is a request sock for a
given tuple.

* adding a reqsk_exists(tuple) helper means we have to pay the lookup cost twice
* drop the sk argument and do the necessary lookups in the helper
itself, but that also
  wastes a call to __inet_lookup_listener
* skip sk_to_full_sk() in a helper and return RET_PTR_TO_SOCK_COMMON,
  but that violates a bunch of assumptions (e.g. calling bpf_sk_release on them)

For context: ultimately we want use this to answer the question: does
this (encapsulated)
packet contain a payload destined to a local socket? Amongst the edge
cases we need to
handle are ICMP Packet Too Big messages and SYN cookies. A solution
would be to hide
all this in an "uber" helper that takes pointers to the L3 / L4
headers and returns a verdict,
but that seems a bit gross.

>
> > +             return -EINVAL;
> > +
> > +     if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> Should tcp_synq_no_recent_overflow(tp) be checked also?
>

Yes, not sure how that slipped out.

> > +             return -EINVAL;
> > +
> > +     if (!th->ack || th->rst)
> How about th->syn?
>

Yes, I missed the fact that the callers in tcp_ipv{4,6}.c check this.

> > +             return -ENOENT;
> > +
> > +     cookie = ntohl(th->ack_seq) - 1;
> > +
> > +     switch (sk->sk_family) {
> > +     case AF_INET:
> > +             if (unlikely(iph_len < sizeof(struct iphdr)))
> > +                     return -EINVAL;
> > +
> > +             ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
> > +             break;
> > +
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +     case AF_INET6:
> > +             if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> > +                     return -EINVAL;
> > +
> > +             ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
> > +             break;
> > +#endif /* CONFIG_IPV6 */
> > +
> > +     default:
> > +             return -EPROTONOSUPPORT;
> > +     }
> > +
> > +     if (ret > 0)
> > +             return 0;
> > +
> > +     return -ENOENT;
> > +#else
> > +     return -ENOTSUP;
> > +#endif
> > +}
> > +
> > +static const struct bpf_func_proto bpf_sk_check_syncookie_proto = {
> > +     .func           = bpf_sk_check_syncookie,
> > +     .gpl_only       = true,
> > +     .pkt_access     = true,
> > +     .ret_type       = RET_INTEGER,
> > +     .arg1_type      = ARG_PTR_TO_SOCKET,
> I think it should be ARG_PTR_TO_TCP_SOCK
>
> > +     .arg2_type      = ARG_PTR_TO_MEM,
> > +     .arg3_type      = ARG_CONST_SIZE,
> > +     .arg4_type      = ARG_PTR_TO_MEM,
> > +     .arg5_type      = ARG_CONST_SIZE,
> > +};
> > +
> >  #endif /* CONFIG_INET */



-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
