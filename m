From: Martin Lau <kafai@fb.com>
Subject: Re: [PATCH 1/3] bpf: add helper to check for a valid SYN cookie
Date: Thu, 28 Feb 2019 17:37:40 +0000
Message-ID: <20190228173738.squ62xmpkjuvjwmd@kafai-mbp.dhcp.thefacebook.com>
References: <20190222095057.9442-1-lmb@cloudflare.com>
 <20190222095057.9442-2-lmb@cloudflare.com>
 <20190223004431.osqrn3u3lp7a6zww@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw9_smq+c8rUt3ONk+J28CzPefuEOgs8at3q9_5s3zN0_1w@mail.gmail.com>
 <20190226053751.flbhnbp4gkocfh7a@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw9_JXEtqOMQGWwTngX2xfMERrpqQiqiFyYfyrx1-=k2MJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw9_JXEtqOMQGWwTngX2xfMERrpqQiqiFyYfyrx1-=k2MJQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <7856B39E2E87184C98E43AD9D7DA897A@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 28, 2019 at 03:11:09PM +0000, Lorenz Bauer wrote:

> I've started working on this, and I've hit a snag with the reference
> tracking behaviour
> of bpf_tcp_sock. From what I can tell, the assumption is that a PTR_TO_TC=
P_SOCK
> doesn't need reference tracking, because its either skb->sk or a TCP list=
ener.
> In the former case, the socket is refcounted via the sk_buff, in the
> latter we don't need
> to worry since the eBPF is called with the RCU read lock held.
>=20
> However, non-listening sockets returned by bpf_sk_lookup_tcp, can be
> freed before the
> end of the eBPF program. Doing bpf_sk_lookup_tcp, bpf_tcp_sock,
> bpf_sk_release allows
> eBPF to gain a (read-only) reference to a freed socket. I've attached
> a patch with a testcase
> which illustrates this issue.
>=20
> Is this the intended behaviour? If not, maybe it would be the easiest
> to make bpf_tcp_sock
> increase the refcount if !SOCK_RCU_FREE and require a corresponding
> bpf_sk_release?
Increase the refcount at runtime may be a too big hammer for this.
Let me think if it can be resolved within the verifier.

> That would simplify my work to add RET_PTR_TO_SOCK_COMMON as wel..
>=20
> ---
>  tools/testing/selftests/bpf/verifier/sock.c | 23 +++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/tools/testing/selftests/bpf/verifier/sock.c
> b/tools/testing/selftests/bpf/verifier/sock.c
> index 0ddfdf76aba5..3307cca6bdd5 100644
> --- a/tools/testing/selftests/bpf/verifier/sock.c
> +++ b/tools/testing/selftests/bpf/verifier/sock.c
> @@ -382,3 +382,26 @@
>         .result =3D REJECT,
>         .errstr =3D "type=3Dtcp_sock expected=3Dsock",
>  },
> +{
> +       "use bpf_tcp_sock after bpf_sk_release",
> +       .insns =3D {
> +       BPF_SK_LOOKUP,
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +       BPF_EMIT_CALL(BPF_FUNC_tcp_sock),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 3),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_EMIT_CALL(BPF_FUNC_sk_release),
> +       BPF_EXIT_INSN(),
> +       BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_EMIT_CALL(BPF_FUNC_sk_release),
> +       BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, offsetof(struct
> bpf_tcp_sock, snd_cwnd)),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> +       .result =3D REJECT,
> +       .errstr =3D "bogus",
> +},
> --
> 2.19.1
