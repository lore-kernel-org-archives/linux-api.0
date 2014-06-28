From: Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH RFC net-next 04/14] bpf: update MAINTAINERS entry
Date: Fri, 27 Jun 2014 17:05:56 -0700
Message-ID: <1403913966-4927-5-git-send-email-ast@plumgrid.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Daniel Borkmann <dborkman@redhat.com>, Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Arnaldo Carvalho de Melo <acme@infradead.org>, Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 48f4ef44b252..ebd831cd1a25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1881,6 +1881,15 @@ S:	Supported
 F:	drivers/net/bonding/
 F:	include/uapi/linux/if_bonding.h
 
+BPF
+M:	Alexei Starovoitov <ast@plumgrid.com>
+L:	netdev@vger.kernel.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/bpf/
+F:	include/uapi/linux/bpf.h
+F:	include/linux/bpf.h
+
 BROADCOM B44 10/100 ETHERNET DRIVER
 M:	Gary Zambrano <zambrano@broadcom.com>
 L:	netdev@vger.kernel.org
-- 
1.7.9.5
