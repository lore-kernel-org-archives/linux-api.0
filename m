From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/3] bpf: allow zero-initializing hash map seed
Date: Tue, 2 Oct 2018 21:59:37 +0200
Message-ID: <CAG48ez0_BtXQ2KCgpRicQ8yfeNqV2mN8RKCA3nn8DXFTmsj6UA@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181001104509.24211-2-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001104509.24211-2-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 1, 2018 at 12:47 PM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Add a new flag BPF_F_ZERO_SEED, which forces a hash map
> to initialize the seed to zero.
> ---
>  include/uapi/linux/bpf.h | 2 ++
>  kernel/bpf/hashtab.c     | 8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index aa5ccd2385ed..9d15c8f179ac 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -252,6 +252,8 @@ enum bpf_attach_type {
>  #define BPF_F_NO_COMMON_LRU    (1U << 1)
>  /* Specify numa node during map creation */
>  #define BPF_F_NUMA_NODE                (1U << 2)
> +/* Zero-initialize hash function seed */
> +#define BPF_F_ZERO_SEED                (1U << 6)
>
>  /* flags for BPF_PROG_QUERY */
>  #define BPF_F_QUERY_EFFECTIVE  (1U << 0)
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 2c1790288138..a79e123dae62 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -23,7 +23,7 @@
>
>  #define HTAB_CREATE_FLAG_MASK                                          \
>         (BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |    \
> -        BPF_F_RDONLY | BPF_F_WRONLY)
> +        BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_ZERO_SEED)
>
>  struct bucket {
>         struct hlist_nulls_head head;
> @@ -373,7 +373,11 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>         if (!htab->buckets)
>                 goto free_htab;
>
> -       htab->hashrnd = get_random_int();
> +       if (htab->map.map_flags & BPF_F_ZERO_SEED)
> +               htab->hashrnd = 0;
> +       else
> +               htab->hashrnd = get_random_int();
> +

If this is for testing only, you can slap a capable(CAP_SYS_ADMIN)
check in here, right? I doubt it matters, but I don't really like
seeing something like this exposed to unprivileged userspace just
because you need it for kernel testing.
