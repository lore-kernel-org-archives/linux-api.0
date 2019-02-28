From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 1/3] bpf: add helper to check for a valid SYN cookie
Date: Thu, 28 Feb 2019 15:11:09 +0000
Message-ID: <CACAyw9_JXEtqOMQGWwTngX2xfMERrpqQiqiFyYfyrx1-=k2MJQ@mail.gmail.com>
References: <20190222095057.9442-1-lmb@cloudflare.com> <20190222095057.9442-2-lmb@cloudflare.com>
 <20190223004431.osqrn3u3lp7a6zww@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw9_smq+c8rUt3ONk+J28CzPefuEOgs8at3q9_5s3zN0_1w@mail.gmail.com> <20190226053751.flbhnbp4gkocfh7a@kafai-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190226053751.flbhnbp4gkocfh7a@kafai-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Martin Lau <kafai@fb.com>
Cc: "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 26 Feb 2019 at 05:38, Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Feb 25, 2019 at 06:26:42PM +0000, Lorenz Bauer wrote:
> > On Sat, 23 Feb 2019 at 00:44, Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Fri, Feb 22, 2019 at 09:50:55AM +0000, Lorenz Bauer wrote:
> > > > Using bpf_sk_lookup_tcp it's possible to ascertain whether a packet belongs
> > > > to a known connection. However, there is one corner case: no sockets are
> > > > created if SYN cookies are active. This means that the final ACK in the
> > > > 3WHS is misclassified.
> > > >
> > > > Using the helper, we can look up the listening socket via bpf_sk_lookup_tcp
> > > > and then check whether a packet is a valid SYN cookie ACK.
> > > >
> > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > ---
> > > >  include/uapi/linux/bpf.h | 18 ++++++++++-
> > > >  net/core/filter.c        | 68 ++++++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 85 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index bcdd2474eee7..bc2af87e9621 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -2359,6 +2359,21 @@ union bpf_attr {
> > > >   *   Return
> > > >   *           A **struct bpf_tcp_sock** pointer on success, or NULL in
> > > >   *           case of failure.
> > > > + *
> > > > + * int bpf_sk_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
> > > > + *   Description
> > > > + *           Check whether iph and th contain a valid SYN cookie ACK for
> > > > + *           the listening socket in sk.
> > > > + *
> > > > + *           iph points to the start of the IPv4 or IPv6 header, while
> > > > + *           iph_len contains sizeof(struct iphdr) or sizeof(struct ip6hdr).
> > > > + *
> > > > + *           th points to the start of the TCP header, while th_len contains
> > > > + *           sizeof(struct tcphdr).
> > > > + *
> > > > + *   Return
> > > > + *           0 if iph and th are a valid SYN cookie ACK, or a negative error
> > > > + *           otherwise.
> > > >   */
> > > >  #define __BPF_FUNC_MAPPER(FN)                \
> > > >       FN(unspec),                     \
> > > > @@ -2457,7 +2472,8 @@ union bpf_attr {
> > > >       FN(spin_lock),                  \
> > > >       FN(spin_unlock),                \
> > > >       FN(sk_fullsock),                \
> > > > -     FN(tcp_sock),
> > > > +     FN(tcp_sock),                   \
> > > > +     FN(sk_check_syncookie),
> > > >
> > > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > >   * function eBPF program intends to call
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 85749f6ec789..9e68897cc7ed 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -5426,6 +5426,70 @@ static const struct bpf_func_proto bpf_tcp_sock_proto = {
> > > >       .arg1_type      = ARG_PTR_TO_SOCK_COMMON,
> > > >  };
> > > >
> > > > +BPF_CALL_5(bpf_sk_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> > > s/bpf_sk_check_syncookie/bpf_tcp_check_syncookie/>
> > >
> > > > +        struct tcphdr *, th, u32, th_len)
> > > > +{
> > > > +#if IS_ENABLED(CONFIG_SYN_COOKIES)
> > > nit. "#ifdef CONFIG_SYN_COOKIES" such that it is clear it is a bool kconfig.
> > >
> > > > +     u32 cookie;
> > > > +     int ret;
> > > > +
> > > > +     if (unlikely(th_len < sizeof(*th)))
> > > > +             return -EINVAL;
> > > > +
> > > > +     /* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
> > > > +     if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> > > From the test program in patch 3, the "sk" here is obtained from
> > > bpf_sk_lookup_tcp() which does a sk_to_full_sk() before returning.
> > > AFAICT, meaning bpf_sk_lookup_tcp() will return the listening sk
> > > even if there is a request_sock.  Does it make sense to check
> > > syncookie if there is already a request_sock?
> >
> > No, that doesn't make a lot of sense. I hadn't realised that
> > sk_lookup_tcp only returns full sockets.
> > This means we need a way to detect that there is a request sock for a
> > given tuple.
> >
> > * adding a reqsk_exists(tuple) helper means we have to pay the lookup cost twice
> > * drop the sk argument and do the necessary lookups in the helper
> > itself, but that also
> >   wastes a call to __inet_lookup_listener
> > * skip sk_to_full_sk() in a helper and return RET_PTR_TO_SOCK_COMMON,
> >   but that violates a bunch of assumptions (e.g. calling bpf_sk_release on them)
> How about creating a new lookup helper, bpf_sk"c"_lookup_tcp,
> that does not call sk_to_full_sk() before returning.
> Its ".ret_type" will be RET_PTR_TO_SOCK_COMMON_OR_NULL which its
> reference(-counting) state has to be tracked in the verifier also.
> Mainly in check_helper_call(), iirc.
>
> The bpf_prog can then check bpf_sock->state for TCP_LISTEN,
> call bpf_tcp_sock() to get the TCP listener sock and pass to
> the bpf_tcp_check_syncookie()

I've started working on this, and I've hit a snag with the reference
tracking behaviour
of bpf_tcp_sock. From what I can tell, the assumption is that a PTR_TO_TCP_SOCK
doesn't need reference tracking, because its either skb->sk or a TCP listener.
In the former case, the socket is refcounted via the sk_buff, in the
latter we don't need
to worry since the eBPF is called with the RCU read lock held.

However, non-listening sockets returned by bpf_sk_lookup_tcp, can be
freed before the
end of the eBPF program. Doing bpf_sk_lookup_tcp, bpf_tcp_sock,
bpf_sk_release allows
eBPF to gain a (read-only) reference to a freed socket. I've attached
a patch with a testcase
which illustrates this issue.

Is this the intended behaviour? If not, maybe it would be the easiest
to make bpf_tcp_sock
increase the refcount if !SOCK_RCU_FREE and require a corresponding
bpf_sk_release?
That would simplify my work to add RET_PTR_TO_SOCK_COMMON as wel..

>
> >
> > For context: ultimately we want use this to answer the question: does
> > this (encapsulated)
> > packet contain a payload destined to a local socket? Amongst the edge
> > cases we need to
> > handle are ICMP Packet Too Big messages and SYN cookies. A solution
> > would be to hide
> > all this in an "uber" helper that takes pointers to the L3 / L4
> > headers and returns a verdict,
> > but that seems a bit gross.
> Please include this use case in the commit message.
> It is useful.
>
> >
> > >
> > > > +             return -EINVAL;
> > > > +
> > > > +     if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> > > Should tcp_synq_no_recent_overflow(tp) be checked also?
> > >
> >
> > Yes, not sure how that slipped out.
> >
> > > > +             return -EINVAL;
> > > > +
> > > > +     if (!th->ack || th->rst)
> > > How about th->syn?
> > >
> >
> > Yes, I missed the fact that the callers in tcp_ipv{4,6}.c check this.
> >
> > > > +             return -ENOENT;
> > > > +
> > > > +     cookie = ntohl(th->ack_seq) - 1;
> > > > +
> > > > +     switch (sk->sk_family) {
> > > > +     case AF_INET:
> > > > +             if (unlikely(iph_len < sizeof(struct iphdr)))
> > > > +                     return -EINVAL;
> > > > +
> > > > +             ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
> > > > +             break;
> > > > +
> > > > +#if IS_ENABLED(CONFIG_IPV6)
> > > > +     case AF_INET6:
> > > > +             if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> > > > +                     return -EINVAL;
> > > > +
> > > > +             ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
> > > > +             break;
> > > > +#endif /* CONFIG_IPV6 */
> > > > +
> > > > +     default:
> > > > +             return -EPROTONOSUPPORT;
> > > > +     }
> > > > +
> > > > +     if (ret > 0)
> > > > +             return 0;
> > > > +
> > > > +     return -ENOENT;
> > > > +#else
> > > > +     return -ENOTSUP;
> > > > +#endif
> > > > +}
> > > > +
> > > > +static const struct bpf_func_proto bpf_sk_check_syncookie_proto = {
> > > > +     .func           = bpf_sk_check_syncookie,
> > > > +     .gpl_only       = true,
> > > > +     .pkt_access     = true,
> > > > +     .ret_type       = RET_INTEGER,
> > > > +     .arg1_type      = ARG_PTR_TO_SOCKET,
> > > I think it should be ARG_PTR_TO_TCP_SOCK
> > >
> > > > +     .arg2_type      = ARG_PTR_TO_MEM,
> > > > +     .arg3_type      = ARG_CONST_SIZE,
> > > > +     .arg4_type      = ARG_PTR_TO_MEM,
> > > > +     .arg5_type      = ARG_CONST_SIZE,
> > > > +};
> > > > +
> > > >  #endif /* CONFIG_INET */
> >
> >
> >
> > --
> > Lorenz Bauer  |  Systems Engineer
> > 25 Lavington St., London SE1 0NZ
> >
> > https://urldefense.proofpoint.com/v2/url?u=http-3A__www.cloudflare.com&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=xhDwvX3iD-mbqSrx-L8XQNaZiYFZzMWNo_2Y38Z9j34&s=I4Ag3HflabFppFv7UtMp8WnMVSqCDW0W28ziWIvuwDE&e=

---
 tools/testing/selftests/bpf/verifier/sock.c | 23 +++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/sock.c
b/tools/testing/selftests/bpf/verifier/sock.c
index 0ddfdf76aba5..3307cca6bdd5 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -382,3 +382,26 @@
        .result = REJECT,
        .errstr = "type=tcp_sock expected=sock",
 },
+{
+       "use bpf_tcp_sock after bpf_sk_release",
+       .insns = {
+       BPF_SK_LOOKUP,
+       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+       BPF_EXIT_INSN(),
+       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+       BPF_EMIT_CALL(BPF_FUNC_tcp_sock),
+       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 3),
+       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+       BPF_EMIT_CALL(BPF_FUNC_sk_release),
+       BPF_EXIT_INSN(),
+       BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+       BPF_EMIT_CALL(BPF_FUNC_sk_release),
+       BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, offsetof(struct
bpf_tcp_sock, snd_cwnd)),
+       BPF_EXIT_INSN(),
+       },
+       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
+       .result = REJECT,
+       .errstr = "bogus",
+},
