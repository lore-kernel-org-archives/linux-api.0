From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Sat, 17 Aug 2019 08:44:52 -0700
Message-ID: <959BAF9B-F2A2-4187-A2A7-C64D675F537B@amacapital.net>
References: <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com> <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch> <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com> <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com> <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com> <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch> <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de> <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch> <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com> <alpine.DEB.2.21.1908162211270.
 1923@nanos.tec.linutronix.de> <20190817150245.xxzxqjpvgqsxmloe@ast-mbp>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190817150245.xxzxqjpvgqsxmloe@ast-mbp>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jordan Glover <Golden_Miller83@protonmail.ch>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 17, 2019, at 8:02 AM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:

>=20
> Can any of the mechanisms 1/2/3 address the concern in mds.rst?
>=20

seccomp() can. It=E2=80=99s straightforward to use seccomp to disable bpf() o=
utright for a process tree.  In this regard, bpf() isn=E2=80=99t particularl=
y unique =E2=80=94 it=E2=80=99s a system call that exposes some attack surfa=
ce and that isn=E2=80=99t required by most programs for basic functionality.=


At LPC this year, there will be a discussion about seccomp improvements that=
 will, among other things, offer fiber-grained control. It=E2=80=99s quite l=
ikely, for example, that seccomp will soon be able to enable and disable spe=
cific map types or attach types.  The exact mechanism isn=E2=80=99t decided y=
et,  but I think everyone expects that this is mostly a design problem, not a=
n implementation problem.

This is off topic for the current thread, but it could be useful to allow bp=
f programs to be loaded from files directly (i.e. pass an fd to a file into b=
pf() to load the program), which would enable LSMs to check that the file is=
 appropriately labeled. This would dramatically raise the bar for exploitati=
on of verifier bugs or speculation attacks, since anyone trying to exploit i=
t would need to get the bpf payload through LSM policy first.

> I believe Andy wants to expand the attack surface when
> kernel.unprivileged_bpf_disabled=3D0
> Before that happens I'd like the community to work on addressing the text a=
bove.
>=20

Not by much. BPF maps are already largely exposed to unprivileged code (when=
 unprivileged_bpf_disabled=3D0).  The attack surface is there, and they=E2=80=
=99re arguably even more exposed than they should be.  My patch 1 earlier wa=
s about locking these interfaces down.

Similarly, my suggestions about reworking cgroup attach and program load don=
=E2=80=99t actually allow fully unprivileged users to run arbitrary bpf() pr=
ograms [0] =E2=80=94 under my proposal, to attach a bpf cgroup program, you n=
eed a delegated cgroup. The mechanism could be extended by a requirement tha=
t a privileged cgroup manager explicitly enable certain attach types for a d=
elegated subtree.

A cgroup knob to turn unprivileged bpf on and off for tasks in the cgroup mi=
ght actually be quite useful.

[0] on some thought, the test run mechanism should probably remain root-only=
.
