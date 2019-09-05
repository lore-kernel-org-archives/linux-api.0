From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 5 Sep 2019 16:08:44 +0000
Message-ID: <A0BD5C17-3118-4C90-825F-23CE187209EA@fb.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
 <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
 <E342EC2A-24F6-4581-BFDC-119B5E02B560@fb.com>
 <20190905031518.behyq7olkh6fjsoe@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190905031518.behyq7olkh6fjsoe@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Content-ID: <4A33147E45FBAE45A2DA4C175F6E64EE@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S . Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Sep 4, 2019, at 8:15 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Sep 05, 2019 at 02:51:51AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Sep 4, 2019, at 6:32 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
>>>>=20
>>>>=20
>>>>> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrot=
e:
>>>>>=20
>>>>> Implement permissions as stated in uapi/linux/capability.h
>>>>>=20
>>>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>>>=20
>>>>=20
>>>> [...]
>>>>=20
>>>>> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr=
, union bpf_attr __user *uattr)
>>>>> 	is_gpl =3D license_is_gpl_compatible(license);
>>>>>=20
>>>>> 	if (attr->insn_cnt =3D=3D 0 ||
>>>>> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT=
_INSNS : BPF_MAXINSNS))
>>>>> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : =
BPF_MAXINSNS))
>>>>> 		return -E2BIG;
>>>>> 	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
>>>>> 	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
>>>>> -	    !capable(CAP_SYS_ADMIN))
>>>>> +	    !capable_bpf())
>>>>> 		return -EPERM;
>>>>=20
>>>> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_=
SKB
>>>> without CAP_BPF? If so, maybe highlight in the header?
>>>=20
>>> of course. there is no change in behavior.
>>> 'highlight in the header'?
>>> you mean in commit log?
>>> I think it's a bit weird to describe things in commit that patch
>>> is _not_ changing vs things that patch does actually change.
>>> This type of comment would be great in a doc though.
>>> The doc will be coming separately in the follow up assuming
>>> the whole thing lands. I'll remember to note that bit.
>>=20
>> I meant capability.h:
>>=20
>> + * CAP_BPF allows the following BPF operations:
>> + * - Loading all types of BPF programs
>>=20
>> But CAP_BPF is not required to load all types of programs.=20
>=20
> yes, but above statement is still correct, right?
>=20
> And right below it says:
> * CAP_BPF allows the following BPF operations:
> * - Loading all types of BPF programs
> * - Creating all types of BPF maps except:
> *    - stackmap that needs CAP_TRACING
> *    - devmap that needs CAP_NET_ADMIN
> *    - cpumap that needs CAP_SYS_ADMIN
> which is also correct, but CAP_BPF is not required
> for array, hash, prog_array, percpu, map-in-map ...
> except their lru variants...
> and except if they contain bpf_spin_lock...
> and if they need BTF it currently can be loaded with cap_sys_admin only..=
.
>=20
> If we say something about socket_filter, cg_skb progs in capability.h
> we should clarify maps as well, but then it will become too big for .h
> The comments in capability.h already look too long to me.
> All that info and a lot more belongs in the doc.

Agreed. We cannot put all these details in capability.h. Doc/wikipages=20
would be better fit for these information.=20

Thanks,
Song
