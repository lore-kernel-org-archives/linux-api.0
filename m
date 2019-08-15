From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Thu, 15 Aug 2019 11:36:43 -0700
Message-ID: <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp> <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp> <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 15, 2019 at 10:29 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Aug 15, 2019 at 11:24:54AM +0000, Jordan Glover wrote:
> > systemd --user processes aren't "less privileged". The are COMPLETELY unprivileged.
> > Granting them cap_bpf is the same as granting it to every other unprivileged user
> > process. Also unprivileged user process can start systemd --user process with any
> > command they like.
>
> systemd itself is trusted. It's the same binary whether it runs as pid=1
> or as pid=123. One of the use cases is to make IPAddressDeny= work with --user.
> Subset of that feature already works with AmbientCapabilities=CAP_NET_ADMIN.
> CAP_BPF is a natural step in the same direction.
>

I have the feeling that we're somehow speaking different languages.
What, precisely, do you mean when you say "systemd itself is trusted"?
 Do you mean "the administrator trusts that the /lib/systemd/systemd
binary is not malicious"?  Do you mean "the administrator trusts that
the running systemd process is not malicious"?

On a regular Linux desktop or server box, passing CAP_NET_ADMIN, your
envisioned CAP_BPF, or /dev/bpf as in this patchset through to a
systemd --user binary would be a gaping security hole.  You are
welcome to do it on your own systemd, but if a distro did it, it would
be a major error.

If you want IPAddressDeny= to work in a user systemd unit (i.e.
/etc/systemd/user/*), then I think you have two choices.  You could
have an API by which systemd --user can ask a privileged helper to
assist (which has all the challenges you mentioned but is definitely
*possible*) or the kernel bpf() interfaces need to be designed so
that, in the absence of kernel bugs, they are safe to use from an
unprivileged process.  By "safe", I mean "would not expose the system
to attack if the kernel's implementation of the bpf() ABI were
perfect".

My suggestions upthread for incrementally making bpf() depend less on
privilege would accomplish this goal.  It would be entirely reasonable
to say that, even with those changes, bpf() is still a large attack
surface and access to it should be restricted, and having a capability
or other mechanism to explicitly grant access to the
hopefully-secure-but-plausibly-buggy parts of bpf() would make sense.
But you rejected that idea and said you "realized that [changing all
the capable() checks is] perfect as-is" without much explanation,
which makes it hard to understand where you're coming from.
