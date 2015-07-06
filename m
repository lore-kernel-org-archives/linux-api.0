From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 22/24] Documentation: add documentation for task_diag
Date: Mon,  6 Jul 2015 11:47:23 +0300
Message-ID: <1436172445-6979-23-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 Documentation/accounting/task_diag.txt | 53 ++++++++++++++++++++++++++=
++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/accounting/task_diag.txt

diff --git a/Documentation/accounting/task_diag.txt b/Documentation/acc=
ounting/task_diag.txt
new file mode 100644
index 0000000..635b322
--- /dev/null
+++ b/Documentation/accounting/task_diag.txt
@@ -0,0 +1,53 @@
+Taskdiag is a netlink interface for getting task properties. Compared =
to procfs,
+it is faster, more flexible and provides data in a binary format. Task=
diag was
+created using the basic idea of socket_diag.
+
+Interface
+---------
+
+The user-kernel interface is encapsulated in include/uapi/linux/task_d=
iag.h
+
+Request
+-------
+
+A request is described by the task_diag_pid structure.
+
+struct task_diag_pid {
+	__u64	show_flags;	/* TASK_DIAG_SHOW_* */
+	__u64	dump_stratagy;	/* TASK_DIAG_DUMP_* */
+
+	__u32	pid;
+};
+
+dump_stratagy specifies a group of processes:
+/* per-process strategies */
+TASK_DIAG_DUMP_CHILDREN	- all children
+TASK_DIAG_DUMP_THREAD	- all threads
+TASK_DIAG_DUMP_ONE	- one process
+/* system wide strategies (the pid fiel is ignored) */
+TASK_DIAG_DUMP_ALL	  - all processes
+TASK_DIAG_DUMP_ALL_THREAD - all threads
+
+show_flags specifies which information are required.  If we set the
+TASK_DIAG_SHOW_BASE flag, the response message will contain the TASK_D=
IAG_BASE
+attribute which is described by the task_diag_base structure.
+
+In future, it can be extended by optional attributes. The request desc=
ribes
+which task properties are required and for which processes they are re=
quired
+for.
+
+Response
+--------
+
+A response can be divided into a few netlink packets if the NETLINK_DU=
MP has
+been set in a request. Each task is described by a message. Each messa=
ge
+contains the TASK_DIAG_PID attribute and optional attributes which hav=
e been
+requested. A message can be divided into a few parts if it doesn=E2=80=
=99t fit into a
+current netlink packet. In this case, the first message in the next pa=
cket
+contains the same PID and attributes which doesn=E2=80=99t =C2=A0fit i=
nto the previous
+message.
+
+Examples
+--------
+
+A few examples can be found in tools/testing/selftests/task_diag/
--=20
2.1.0
