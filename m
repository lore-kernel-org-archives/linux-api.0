From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH v2 2/3] tools: sync linux/bpf.h
Date: Mon, 8 Oct 2018 16:12:20 -0700
Message-ID: <CAPhsuW5fbhQ1SBurL2q6hm=yV0a_Vw-_gjsz8LHJ76QwcqVXsQ@mail.gmail.com>
References: <20181001104509.24211-1-lmb@cloudflare.com> <20181008103221.13468-1-lmb@cloudflare.com>
 <20181008103221.13468-3-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008103221.13468-3-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Networking <netdev@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 8, 2018 at 3:34 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Synchronize changes to linux/bpf.h from
> commit 88db241b34bf ("bpf: allow zero-initializing hash map seed").
I guess we cannot keep this hash during git-am? We probably don't
need this hash anyway, as the two patches will be applied back to back.

>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  tools/include/uapi/linux/bpf.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index f9187b41dff6..2c121f862082 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -253,6 +253,8 @@ enum bpf_attach_type {
>  #define BPF_F_NO_COMMON_LRU    (1U << 1)
>  /* Specify numa node during map creation */
>  #define BPF_F_NUMA_NODE                (1U << 2)
> +/* Zero-initialize hash function seed. This should only be used for testing. */
> +#define BPF_F_ZERO_SEED                (1U << 6)

Same as 01.

>
>  /* flags for BPF_PROG_QUERY */
>  #define BPF_F_QUERY_EFFECTIVE  (1U << 0)
> --
> 2.17.1
>
