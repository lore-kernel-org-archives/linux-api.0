From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/3] bpf: allow zero-initializing hash map seed
Date: Fri, 5 Oct 2018 16:12:27 +0200
Message-ID: <CAG48ez3wwGgc40uAg5nq9dnC3qsAD04jQZTWtPi7jg_VDws-fg@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181001104509.24211-2-lmb@cloudflare.com>
 <CAG48ez0_BtXQ2KCgpRicQ8yfeNqV2mN8RKCA3nn8DXFTmsj6UA@mail.gmail.com> <CACAyw99ar0Wokyg4jx8FPyr1Z=7Cf+=WVgF6sLL1FK9JtHROjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw99ar0Wokyg4jx8FPyr1Z=7Cf+=WVgF6sLL1FK9JtHROjw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 5, 2018 at 9:42 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> On Tue, 2 Oct 2018 at 21:00, Jann Horn <jannh@google.com> wrote:
> >
> > If this is for testing only, you can slap a capable(CAP_SYS_ADMIN)
> > check in here, right? I doubt it matters, but I don't really like
> > seeing something like this exposed to unprivileged userspace just
> > because you need it for kernel testing.
>
> That would mean all tests have to run as root / with CAP_SYS_ADMIN
> which isn't ideal.

This patch basically means that it becomes easier for a local user to
construct a BPF hash table that has all of its values stuffed into a
single hash bucket, correct? Which makes it easier to create a BPF
program that generates unusually large RCU stalls by performing ~40000
BPF map lookups, each of which has to walk through the entire linked
list of the hash map bucket? I dislike exposing something like that to
unprivileged userspace.

And if you want to run the whole BPF test suite with all its tests,
don't you already need root privileges? Or is this a different test
suite?
