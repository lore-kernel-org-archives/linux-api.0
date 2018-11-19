From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v3 0/4] bpf: allow zero-initialising hash map seed
Date: Tue, 20 Nov 2018 00:56:09 +0100
Message-ID: <58167241-3a94-f905-e463-1d21a1268655@iogearbox.net>
References: <20181001104509.24211-1-lmb@cloudflare.com>
 <20181116114111.31177-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116114111.31177-1-lmb@cloudflare.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>, ast@kernel.org
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, songliubraving@fb.com
List-Id: linux-api@vger.kernel.org

On 11/16/2018 12:41 PM, Lorenz Bauer wrote:
> Allow forcing the seed of a hash table to zero, for deterministic
> execution during benchmarking and testing.
> 
> Changes from v2:
> * Change ordering of BPF_F_ZERO_SEED in linux/bpf.h
> 
> Comments adressed from v1:
> * Add comment to discourage production use to linux/bpf.h
> * Require CAP_SYS_ADMIN
> 
> Lorenz Bauer (4):
>   bpf: allow zero-initializing hash map seed
>   bpf: move BPF_F_QUERY_EFFECTIVE after map flags
>   tools: sync linux/bpf.h
>   tools: add selftest for BPF_F_ZERO_SEED
> 
>  include/uapi/linux/bpf.h                |  9 ++--
>  kernel/bpf/hashtab.c                    | 13 ++++-
>  tools/include/uapi/linux/bpf.h          | 13 +++--
>  tools/testing/selftests/bpf/test_maps.c | 68 +++++++++++++++++++++----
>  4 files changed, 84 insertions(+), 19 deletions(-)
> 

Applied to bpf-next, thanks!
