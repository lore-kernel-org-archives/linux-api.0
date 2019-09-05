From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 5 Sep 2019 00:34:36 +0000
Message-ID: <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190904184335.360074-2-ast@kernel.org>
Content-Language: en-US
Content-ID: <4EBF0FA92799CA46BFE7231B56ECE867@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Implement permissions as stated in uapi/linux/capability.h
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20

[...]

> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
> 	is_gpl =3D license_is_gpl_compatible(license);
>=20
> 	if (attr->insn_cnt =3D=3D 0 ||
> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INS=
NS : BPF_MAXINSNS))
> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_=
MAXINSNS))
> 		return -E2BIG;
> 	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
> 	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
> -	    !capable(CAP_SYS_ADMIN))
> +	    !capable_bpf())
> 		return -EPERM;

Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SKB
without CAP_BPF? If so, maybe highlight in the header?

Thanks,
Song
