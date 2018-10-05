From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 0/3] bpf: allow zero-initialising hash map seed
Date: Fri, 5 Oct 2018 16:29:21 +0200
Message-ID: <CAG48ez3g3dipfd2fMqGVVhT0ZZscOkCei_YxXVoNaiG0wGgtPA@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <59ef80ab-4f28-5c75-c394-55fcfd9bc8ca@iogearbox.net>
 <CACAyw99h58NX6tE1KrgoNEWwX4U8WW3JaRnJGJ0EGXEoeqeMDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw99h58NX6tE1KrgoNEWwX4U8WW3JaRnJGJ0EGXEoeqeMDw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 5, 2018 at 4:27 PM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Mon, 1 Oct 2018 at 20:12, Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 10/01/2018 12:45 PM, Lorenz Bauer wrote:
> > > This patch set adds a new flag BPF_F_ZERO_SEED, which allows
> > > forcing the seed used by hash maps to zero. This makes
> > > it possible to write deterministic tests.
> > >
> > > Based on an off-list conversation with Alexei Starovoitov and
> > > Daniel Borkmann.
> > >
> > > Lorenz Bauer (3):
> > >   bpf: allow zero-initializing hash map seed
> > >   tools: sync linux/bpf.h
> > >   tools: add selftest for BPF_F_ZERO_SEED
> > >
> > >  include/uapi/linux/bpf.h                |  2 +
> > >  kernel/bpf/hashtab.c                    |  8 ++-
> > >  tools/include/uapi/linux/bpf.h          |  2 +
> > >  tools/testing/selftests/bpf/test_maps.c | 67 +++++++++++++++++++++----
> > >  4 files changed, 66 insertions(+), 13 deletions(-)
> > >
> >
> > Please respin with proper SoB for each patch and non-empty commit
> > description.
>
> What does SoB mean? Point taken about the empty commit message.

SoB is the Signed-off-by line. See
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
.
