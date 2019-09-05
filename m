From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 5 Sep 2019 02:51:51 +0000
Message-ID: <E342EC2A-24F6-4581-BFDC-119B5E02B560@fb.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
 <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Content-ID: <1DB836E0E5592C479D9DA2D528334C1A@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S . Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Sep 4, 2019, at 6:32 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>>>=20
>>> Implement permissions as stated in uapi/linux/capability.h
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>=20
>>=20
>> [...]
>>=20
>>> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, =
union bpf_attr __user *uattr)
>>> 	is_gpl =3D license_is_gpl_compatible(license);
>>>=20
>>> 	if (attr->insn_cnt =3D=3D 0 ||
>>> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_I=
NSNS : BPF_MAXINSNS))
>>> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BP=
F_MAXINSNS))
>>> 		return -E2BIG;
>>> 	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
>>> 	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
>>> -	    !capable(CAP_SYS_ADMIN))
>>> +	    !capable_bpf())
>>> 		return -EPERM;
>>=20
>> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SK=
B
>> without CAP_BPF? If so, maybe highlight in the header?
>=20
> of course. there is no change in behavior.
> 'highlight in the header'?
> you mean in commit log?
> I think it's a bit weird to describe things in commit that patch
> is _not_ changing vs things that patch does actually change.
> This type of comment would be great in a doc though.
> The doc will be coming separately in the follow up assuming
> the whole thing lands. I'll remember to note that bit.

I meant capability.h:

+ * CAP_BPF allows the following BPF operations:
+ * - Loading all types of BPF programs

But CAP_BPF is not required to load all types of programs.=20

On a second thought, I am not sure whether we will keep capability.h
up to date with all features. So this is probably OK.=20

Thanks,
Song
