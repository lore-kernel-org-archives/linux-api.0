From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Date: Fri, 16 Aug 2019 11:59:54 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com> <20190814005737.4qg6wh4a53vmso2v@ast-mbp> <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com> <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch> <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com> <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
Sender: netdev-owner@vger.kernel.org
To: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 16 Aug 2019, Jordan Glover wrote:
> "systemd --user" service? Trying to do so will fail with:
> "Failed to apply ambient capabilities (before UID change): Operation not permitted"
> 
> I think it's crucial to clear that point to avoid confusion in this discussion
> where people are talking about different things.
> 
> On the other hand running "systemd --system" service with:
> 
> User=nobody
> AmbientCapabilities=CAP_NET_ADMIN
> 
> is perfectly legit and clears some security concerns as only privileged user
> can start such service.

While we are at it, can we please stop looking at this from a systemd only
perspective. There is a world outside of systemd.

Thanks,

	tglx
