From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Date: Wed, 4 Sep 2019 18:32:46 -0700
Message-ID: <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S . Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
> 
> 
> > On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> > Implement permissions as stated in uapi/linux/capability.h
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > 
> 
> [...]
> 
> > @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
> > 	is_gpl = license_is_gpl_compatible(license);
> > 
> > 	if (attr->insn_cnt == 0 ||
> > -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
> > +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
> > 		return -E2BIG;
> > 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
> > 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
> > -	    !capable(CAP_SYS_ADMIN))
> > +	    !capable_bpf())
> > 		return -EPERM;
> 
> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SKB
> without CAP_BPF? If so, maybe highlight in the header?

of course. there is no change in behavior.
'highlight in the header'?
you mean in commit log?
I think it's a bit weird to describe things in commit that patch
is _not_ changing vs things that patch does actually change.
This type of comment would be great in a doc though.
The doc will be coming separately in the follow up assuming
the whole thing lands. I'll remember to note that bit.
