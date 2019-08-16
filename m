From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Thu, 15 Aug 2019 17:54:59 -0700
Message-ID: <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
References: <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com> <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com> <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com> <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com> <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com> <20190813215823.3sfbakzzjjykyng2@ast-mbp> <201908151203.FE87970@keescook> <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Song Liu <songliubraving@fb.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 15, 2019, at 4:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:


>>=20
>> I'm not sure why you draw the line for VMs -- they're just as buggy
>> as anything else. Regardless, I reject this line of thinking: yes,
>> all software is buggy, but that isn't a reason to give up.
>=20
> hmm. are you saying you want kernel community to work towards
> making containers (namespaces) being able to run arbitrary code
> downloaded from the internet?

Yes.

As an example, Sandstorm uses a combination of namespaces (user, network, mo=
unt, ipc) and a moderately permissive seccomp policy to run arbitrary code. N=
ot just little snippets, either =E2=80=94 node.js, Mongo, MySQL, Meteor, and=
 other fairly heavyweight stacks can all run under Sandstorm, with the whole=
 stack (database engine binaries, etc) supplied by entirely untrusted custom=
ers.  During the time Sandstorm was under active development, I can recall *=
one* bug that would have allowed a sandbox escape. That=E2=80=99s a pretty g=
ood track record.  (Also, Meltdown and Spectre, sigh.)

To be clear, Sandstorm did not allow creation of a userns by the untrusted c=
ode, and Sandstorm would have heavily restricted bpf(), but that should only=
 be necessary because of the possibility of kernel bugs, not because of the o=
verall design.

Alexei, I=E2=80=99m trying to encourage you to aim for something even better=
 than you have now. Right now, if you grant a user various very strong capab=
ilities, that user=E2=80=99s systemd can use bpf network filters.  Your prop=
osal would allow this with a different, but still very strong, set of capabi=
lities. There=E2=80=99s nothing wrong with this per se, but I think you can a=
im much higher:

CAP_NET_ADMIN and your CAP_BPF both effectively allow the holder to take ove=
r the system, *by design*.  I=E2=80=99m suggesting that you engage the secur=
ity community (Kees, myself, Aleksa, Jann, Serge, Christian, etc) to aim for=
 something better: make it so that a normal Linux distro would be willing to=
 relax its settings enough so that normal users can use bpf filtering in the=
 systemd units and maybe eventually use even more bpf() capabilities. And le=
t=E2=80=99s make is to that mainstream container managers (that use userns!)=
 will be willing (as an option) to delegate bpf() to their containers. We=E2=
=80=99re happy to help design, review, and even write code, but we need you t=
o be willing to work with us to make a design that seems like it will work a=
nd then to wait long enough to merge it for us to think about it, try to pok=
e holes in it, and convince ourselves and each other that it has a good chan=
ce of being sound.

Obviously there will be many cases where an unprivileged program should *not=
* be able to use bpf() IP filtering, but let=E2=80=99s make it so that enabl=
ing these advanced features does not automatically give away the keys to the=
 kingdom.

(Sandstorm still exists but is no longer as actively developed, sadly.)=
