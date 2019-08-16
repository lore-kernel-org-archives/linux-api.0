From: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Fri, 16 Aug 2019 11:33:57 +0000
Message-ID: <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
 <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
Sender: netdev-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Friday, August 16, 2019 9:59 AM, Thomas Gleixner <tglx@linutronix.de> wr=
ote:

> On Fri, 16 Aug 2019, Jordan Glover wrote:
>
> > "systemd --user" service? Trying to do so will fail with:
> > "Failed to apply ambient capabilities (before UID change): Operation no=
t permitted"
> > I think it's crucial to clear that point to avoid confusion in this dis=
cussion
> > where people are talking about different things.
> > On the other hand running "systemd --system" service with:
> > User=3Dnobody
> > AmbientCapabilities=3DCAP_NET_ADMIN
> > is perfectly legit and clears some security concerns as only privileged=
 user
> > can start such service.
>
> While we are at it, can we please stop looking at this from a systemd onl=
y
> perspective. There is a world outside of systemd.
>
> Thanks,
>
> tglx

If you define:

"systemd --user" =3D=3D unprivileged process started by unprivileged user
"systemd --system" =3D=3D process started by privileged user but run as ano=
ther
user which keeps some of parent user privileges and drops others

you can get rid of "systemd" from the equation.

"systemd --user" was the example provided by Alexei when asked about the us=
ecase
but his description didn't match what it does so it's not obvious what the =
real
usecase is. I'm sure there can be many more examples and systemd isn't impo=
rtant
here in particular beside to understand this specific example.

Jordan
