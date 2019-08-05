From: Andy Lutomirski <luto@kernel.org>
Subject: [WIP 4/4] bpf: Allow creating all program types without privilege
Date: Mon,  5 Aug 2019 14:29:05 -0700
Message-ID: <9e77ae06243555a96a3fd5e854f61d24823110c9.1565040372.git.luto@kernel.org>
References: <cover.1565040372.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1565040372.git.luto@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

This doesn't let you *run* the programs except in test mode, so it should
be safe.  Famous last words.

This assumes that the check-privilege-to-call-privileged-functions
patch actually catches all the cases and that there's nothing else
that should need privilege lurking in the type-specific verifiers.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/bpf/syscall.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 23f8f89d2a86..730afa2be786 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1649,8 +1649,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
 		return -E2BIG;
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
-	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
+	    type != BPF_PROG_TYPE_CGROUP_SKB)
 		return -EPERM;
 
 	bpf_prog_load_fixup_attach_type(attr);
-- 
2.21.0
