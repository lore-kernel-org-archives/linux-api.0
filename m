From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 29 Aug 2019 10:28:54 -0700
Message-ID: <20190829172852.xhxtd6ruwdnhvvdt@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <B28631A9-BB92-404A-BD58-7A737BCF10C9@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B28631A9-BB92-404A-BD58-7A737BCF10C9@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, "davem@davemloft.net" <davem@davemloft.net>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 06:04:42AM +0000, Song Liu wrote:
> 
> 
> > On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index 44e2d640b088..91a7f25512ca 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -805,10 +805,20 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
> > 	}
> > }
> > 
> > +struct libcap {
> > +	struct __user_cap_header_struct hdr;
> > +	struct __user_cap_data_struct data[2];
> > +};
> > +
> 
> I am confused by struct libcap. Why do we need it? 

because libcap is not compatible with new kernel.
It needs to be recompiled with new capability.h
Otherwise it limits max to CAP_AUDIT_READ
Any value higher it will error during cap_get_flag.
And will silently ignore it during cap_set_flag.
Not a great library decision.

Thankfully this struct above is exactly the kernel api.
One doesn't really need libcap. It's imo easier to do without it.
