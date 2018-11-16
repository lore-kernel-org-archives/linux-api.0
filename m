From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 0/4] bpf: allow zero-initialising hash map seed
Date: Fri, 16 Nov 2018 11:41:07 +0000
Message-ID: <20181116114111.31177-1-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001104509.24211-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, songliubraving@fb.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Allow forcing the seed of a hash table to zero, for deterministic
execution during benchmarking and testing.

Changes from v2:
* Change ordering of BPF_F_ZERO_SEED in linux/bpf.h

Comments adressed from v1:
* Add comment to discourage production use to linux/bpf.h
* Require CAP_SYS_ADMIN

Lorenz Bauer (4):
  bpf: allow zero-initializing hash map seed
  bpf: move BPF_F_QUERY_EFFECTIVE after map flags
  tools: sync linux/bpf.h
  tools: add selftest for BPF_F_ZERO_SEED

 include/uapi/linux/bpf.h                |  9 ++--
 kernel/bpf/hashtab.c                    | 13 ++++-
 tools/include/uapi/linux/bpf.h          | 13 +++--
 tools/testing/selftests/bpf/test_maps.c | 68 +++++++++++++++++++++----
 4 files changed, 84 insertions(+), 19 deletions(-)

-- 
2.17.1
