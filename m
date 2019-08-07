From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Wed, 7 Aug 2019 06:52:36 -0700
Message-ID: <945BCF23-839C-418C-9FBF-46889AE84CA4@amacapital.net>
References: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com> <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com> <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com> <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com> <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com> <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com> <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com> <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com> <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com> <CACAyw9_fVZFW_x4uyTAiRfeH6oq1KHv0uB2wO84u5JZyD+Unaw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw9_fVZFW_x4uyTAiRfeH6oq1KHv0uB2wO84u5JZyD+Unaw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


> On Aug 7, 2019, at 2:03 AM, Lorenz Bauer <lmb@cloudflare.com> wrote:
>=20
>> On Wed, 7 Aug 2019 at 06:24, Andy Lutomirski <luto@kernel.org> wrote:
>> a) Those that, by design, control privileged operations.  This
>> includes most attach calls, but it also includes allow_ptr_leaks,
>> bpf_probe_read(), and quite a few other things.  It also includes all
>> of the by_id calls, I think, unless some clever modification to the
>> way they worked would isolate different users' objects.  I think that
>> persistent objects can do pretty much everything that by_id users
>> would need, so this isn't a big deal.
>=20
> Slightly OT, since this is an implementation question: GET_MAP_FD_BY_ID
> is useful to iterate a nested map. This isn't covered by rights to
> persistent objects,
> so it would need some thought.
>=20
>=20

A call to get an fd to a map referenced by a map to which you already have a=
n fd seems reasonable to me. The new fd would inherit the old fd=E2=80=99s a=
ccess mode.=
