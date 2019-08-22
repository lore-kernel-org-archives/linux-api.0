From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Thu, 22 Aug 2019 15:48:29 -0700
Message-ID: <20190822224826.xbovlykhpk4p4ww4@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andy Lutomirski <luto@kernel.org>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Chenbo Feng <chenbofeng.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 22, 2019 at 04:17:43PM +0200, Daniel Borkmann wrote:
> 
> > > Hence unprivileged bpf is actually something that can be deprecated.
> 
> There is actually a publicly known use-case on unprivileged bpf wrt
> socket filters, see the SO_ATTACH_BPF on sockets section as an example:
> 
>   https://blog.cloudflare.com/cloudflare-architecture-and-how-bpf-eats-the-world/
> 
> If I'd have to take a good guess, I'd think it's major use-case is in
> SO_ATTACH_REUSEPORT_EBPF in the wild, I don't think the sysctl can be
> outright flipped or deprecated w/o breaking existing applications unless
> it's cleanly modeled into some sort of customizable CAP_BPF* type policy
> (more below) where this would be the lowest common denominator.

The cloudflare use case is the perfect example that a lot of program types
are used together.
Do people use SO_ATTACH_BPF ? Of course.
All program types are used by somebody. Before accepting them we had long
conversations with authors to understand that the use cases are real.
Some progs are probably used less than others by now.
Like cls_bpf without exts_integrated is probably not used at all.
We still have to support it, of course.
That cloudflare example demonstrates that kernel.unprivileged_bpf_disabled=1
is a reality. Companies that care about security already switched it on.
Different bits in cloudflare setup need different level of capabilities.
Some (like SO_ATTACH_BPF) need unpriv. Another need CAP_NET_ADMIN.
But common demoninator for them all is still CAP_SYS_ADMIN.
And that's why the system as a whole is not as safe as it could have
been with CAP_BPF. The system needs root in many places.
Folks going out of the way to reduce that SYS_ADMIN to something less.
The example with systemd and NET_ADMIN is just one of them.
