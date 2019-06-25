From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v9 02/10] bpf: Add eBPF program subtype and
 is_valid_subtype() verifier
Date: Tue, 25 Jun 2019 16:02:57 -0700
Message-ID: <CAADnVQ+Twio22VSi21RR5TY1Zm-1xRTGmREcXLSs5Jv-KWGTiw@mail.gmail.com>
References: <20190625215239.11136-1-mic@digikod.net> <20190625215239.11136-3-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190625215239.11136-3-mic@digikod.net>
Sender: netdev-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.g>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 25, 2019 at 3:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> The goal of the program subtype is to be able to have different static
> fine-grained verifications for a unique program type.
>
> The struct bpf_verifier_ops gets a new optional function:
> is_valid_subtype(). This new verifier is called at the beginning of the
> eBPF program verification to check if the (optional) program subtype is
> valid.
>
> The new helper bpf_load_program_xattr() enables to verify a program with
> subtypes.
>
> For now, only Landlock eBPF programs are using a program subtype (see
> next commits) but this could be used by other program types in the
> future.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Link: https://lkml.kernel.org/r/20160827205559.GA43880@ast-mbp.thefaceboo=
k.com
> ---
>
> Changes since v8:
> * use bpf_load_program_xattr() instead of bpf_load_program() and add
>   bpf_verify_program_xattr() to deal with subtypes
> * remove put_extra() since there is no more "previous" field (for now)
>
> Changes since v7:
> * rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
> * move subtype in bpf_prog_aux and use only one bit for has_subtype
>   (suggested by Alexei Starovoitov)

sorry to say, but I don't think the landlock will ever land,
since posting huge patches once a year is missing a lot of development
that is happening during that time.
This 2/10 patch is an example.
subtype concept was useful 2 years ago when v6 was posted.
Since then bpf developers faced very similar problem in other parts
and it was solved with 'expected_attach_type' field.
See commit 5e43f899b03a ("bpf: Check attach type at prog load time")
dated March 2018.
