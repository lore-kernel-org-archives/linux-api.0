From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH 0/3] bpf: allow zero-initialising hash map seed
Date: Fri, 5 Oct 2018 15:27:10 +0100
Message-ID: <CACAyw99h58NX6tE1KrgoNEWwX4U8WW3JaRnJGJ0EGXEoeqeMDw@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <59ef80ab-4f28-5c75-c394-55fcfd9bc8ca@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <59ef80ab-4f28-5c75-c394-55fcfd9bc8ca@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 1 Oct 2018 at 20:12, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/01/2018 12:45 PM, Lorenz Bauer wrote:
> > This patch set adds a new flag BPF_F_ZERO_SEED, which allows
> > forcing the seed used by hash maps to zero. This makes
> > it possible to write deterministic tests.
> >
> > Based on an off-list conversation with Alexei Starovoitov and
> > Daniel Borkmann.
> >
> > Lorenz Bauer (3):
> >   bpf: allow zero-initializing hash map seed
> >   tools: sync linux/bpf.h
> >   tools: add selftest for BPF_F_ZERO_SEED
> >
> >  include/uapi/linux/bpf.h                |  2 +
> >  kernel/bpf/hashtab.c                    |  8 ++-
> >  tools/include/uapi/linux/bpf.h          |  2 +
> >  tools/testing/selftests/bpf/test_maps.c | 67 +++++++++++++++++++++----
> >  4 files changed, 66 insertions(+), 13 deletions(-)
> >
>
> Please respin with proper SoB for each patch and non-empty commit
> description.

What does SoB mean? Point taken about the empty commit message.

> I think patch 1 should also have a more elaborate
> commit description on the use case for BPF_F_ZERO_SEED, and I

This came out of the off-list discussion we had about map hash functions,
where Alexei expressed concern that your change to randomise the seed
might catch users off-guard. I personally don't have a use case, but decided
to tackle it since it seemed a simple-ish fix to get acquainted with
the code base.

Maybe this isn't needed after all?

> think also a better comment in the uapi header that this is only
> meant for testing and not production use.

Will do, if you decide that this is worth having in the first place.

>
> Thanks,
> Daniel

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
