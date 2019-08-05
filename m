From: Andy Lutomirski <luto@kernel.org>
Subject: [WIP 0/4] bpf: A bit of progress toward unprivileged use
Date: Mon,  5 Aug 2019 14:29:01 -0700
Message-ID: <cover.1565040372.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

Other than the mknod() patch, this is not ready for prime time.  These
patches try to make progress toward making bpf() more useful without
privilege

Andy Lutomirski (4):
  bpf: Respect persistent map and prog access modes
  bpf: Don't require mknod() permission to pin an object
  bpf: Add a way to mark functions as requiring privilege
  bpf: Allow creating all program types without privilege

 include/linux/bpf.h          | 30 +++++++++++++++-----
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/arraymap.c        |  8 +++++-
 kernel/bpf/cgroup.c          |  6 +++-
 kernel/bpf/inode.c           | 29 +++++++++++--------
 kernel/bpf/syscall.c         | 54 +++++++++++++++++++++++++-----------
 kernel/bpf/verifier.c        |  8 ++++++
 kernel/events/core.c         |  5 ++--
 kernel/trace/bpf_trace.c     |  1 +
 net/core/dev.c               |  4 ++-
 net/core/filter.c            |  8 ++++--
 net/netfilter/xt_bpf.c       |  5 ++--
 net/packet/af_packet.c       |  2 +-
 13 files changed, 115 insertions(+), 46 deletions(-)

-- 
2.21.0
