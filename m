From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 0/3] bpf: allow zero-initialising hash map seed
Date: Mon,  8 Oct 2018 11:32:18 +0100
Message-ID: <20181008103221.13468-1-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001104509.24211-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Allow forcing the seed of a hash table to zero, for deterministic
execution during benchmarking and testing.

Comments adressed from v1:
* Add comment to discourage production use to linux/bpf.h
* Require CAP_SYS_ADMIN

Lorenz Bauer (3):
  bpf: allow zero-initializing hash map seed
  tools: sync linux/bpf.h
  tools: add selftest for BPF_F_ZERO_SEED

 include/uapi/linux/bpf.h                |  2 +
 kernel/bpf/hashtab.c                    | 13 ++++-
 tools/include/uapi/linux/bpf.h          |  2 +
 tools/testing/selftests/bpf/test_maps.c | 68 +++++++++++++++++++++----
 4 files changed, 72 insertions(+), 13 deletions(-)

-- 
2.17.1
