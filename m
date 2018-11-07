From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH v2 1/3] bpf: allow zero-initializing hash map seed
Date: Tue, 6 Nov 2018 16:39:14 -0800
Message-ID: <CAPhsuW5WW6RQG5F3O2a9YwLAue5Ng1gPmtMuqzG9n5pB=D3xsQ@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181008103221.13468-1-lmb@cloudflare.com>
 <20181008103221.13468-2-lmb@cloudflare.com> <CAPhsuW5_1LRw=tjaNWfgrPKaS_Rs12BYAHPOjmXwEs8C9YSy1Q@mail.gmail.com>
 <CACAyw98RnRZtqMYcS5GZxhf-F-z=sW+Ki+_PBADG+V_qZiuA1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACAyw98RnRZtqMYcS5GZxhf-F-z=sW+Ki+_PBADG+V_qZiuA1Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Networking <netdev@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 25, 2018 at 8:12 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 9 Oct 2018 at 01:08, Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -253,6 +253,8 @@ enum bpf_attach_type {
> > >  #define BPF_F_NO_COMMON_LRU    (1U << 1)
> > >  /* Specify numa node during map creation */
> > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > > +/* Zero-initialize hash function seed. This should only be used for testing. */
> > > +#define BPF_F_ZERO_SEED                (1U << 6)
> >
> > Please add this line after
> > #define BPF_F_STACK_BUILD_ID    (1U << 5)
>
> I wanted to keep the flags for BPF_MAP_CREATE grouped together.
> Maybe the correct value is (1U << 3)? It seemed like the other flags
> were allocated to avoid
> overlap between different BPF commands, however, so I tried to follow suit.

I think it should be (1U << 6). We probably should move BPF_F_QUERY_EFFECTIVE
to after BPF_F_STACK_BUILD_ID (and BPF_F_ZERO_SEED).

Also, please rebase against the latest bpf-next tree and resubmit the set.

Thanks,
Song
