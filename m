From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 0/3] bpf: allow zero-initialising hash map seed
Date: Mon,  1 Oct 2018 11:45:06 +0100
Message-ID: <20181001104509.24211-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

This patch set adds a new flag BPF_F_ZERO_SEED, which allows
forcing the seed used by hash maps to zero. This makes
it possible to write deterministic tests.

Based on an off-list conversation with Alexei Starovoitov and
Daniel Borkmann.

Lorenz Bauer (3):
  bpf: allow zero-initializing hash map seed
  tools: sync linux/bpf.h
  tools: add selftest for BPF_F_ZERO_SEED

 include/uapi/linux/bpf.h                |  2 +
 kernel/bpf/hashtab.c                    |  8 ++-
 tools/include/uapi/linux/bpf.h          |  2 +
 tools/testing/selftests/bpf/test_maps.c | 67 +++++++++++++++++++++----
 4 files changed, 66 insertions(+), 13 deletions(-)

-- 
2.17.1
