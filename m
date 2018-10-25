From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH v2 1/3] bpf: allow zero-initializing hash map seed
Date: Thu, 25 Oct 2018 17:12:24 +0200
Message-ID: <CACAyw98RnRZtqMYcS5GZxhf-F-z=sW+Ki+_PBADG+V_qZiuA1Q@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181008103221.13468-1-lmb@cloudflare.com>
 <20181008103221.13468-2-lmb@cloudflare.com> <CAPhsuW5_1LRw=tjaNWfgrPKaS_Rs12BYAHPOjmXwEs8C9YSy1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW5_1LRw=tjaNWfgrPKaS_Rs12BYAHPOjmXwEs8C9YSy1Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: liu.song.a23@gmail.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 9 Oct 2018 at 01:08, Song Liu <liu.song.a23@gmail.com> wrote:
>
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -253,6 +253,8 @@ enum bpf_attach_type {
> >  #define BPF_F_NO_COMMON_LRU    (1U << 1)
> >  /* Specify numa node during map creation */
> >  #define BPF_F_NUMA_NODE                (1U << 2)
> > +/* Zero-initialize hash function seed. This should only be used for testing. */
> > +#define BPF_F_ZERO_SEED                (1U << 6)
>
> Please add this line after
> #define BPF_F_STACK_BUILD_ID    (1U << 5)

I wanted to keep the flags for BPF_MAP_CREATE grouped together.
Maybe the correct value is (1U << 3)? It seemed like the other flags
were allocated to avoid
overlap between different BPF commands, however, so I tried to follow suit.

-- 
Lorenz Bauer  |  Systems Engineer
25 Lavington St., London SE1 0NZ

www.cloudflare.com
