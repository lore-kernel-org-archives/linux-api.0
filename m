From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 0/3] bpf: allow zero-initialising hash map seed
Date: Mon, 1 Oct 2018 21:12:48 +0200
Message-ID: <59ef80ab-4f28-5c75-c394-55fcfd9bc8ca@iogearbox.net>
References: <20181001104509.24211-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001104509.24211-1-lmb@cloudflare.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>, ast@kernel.org
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/01/2018 12:45 PM, Lorenz Bauer wrote:
> This patch set adds a new flag BPF_F_ZERO_SEED, which allows
> forcing the seed used by hash maps to zero. This makes
> it possible to write deterministic tests.
> 
> Based on an off-list conversation with Alexei Starovoitov and
> Daniel Borkmann.
> 
> Lorenz Bauer (3):
>   bpf: allow zero-initializing hash map seed
>   tools: sync linux/bpf.h
>   tools: add selftest for BPF_F_ZERO_SEED
> 
>  include/uapi/linux/bpf.h                |  2 +
>  kernel/bpf/hashtab.c                    |  8 ++-
>  tools/include/uapi/linux/bpf.h          |  2 +
>  tools/testing/selftests/bpf/test_maps.c | 67 +++++++++++++++++++++----
>  4 files changed, 66 insertions(+), 13 deletions(-)
> 

Please respin with proper SoB for each patch and non-empty commit
description. I think patch 1 should also have a more elaborate
commit description on the use case for BPF_F_ZERO_SEED, and I
think also a better comment in the uapi header that this is only
meant for testing and not production use.

Thanks,
Daniel
