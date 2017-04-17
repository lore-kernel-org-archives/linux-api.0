From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH 0/2] nsfs: Introduce ioctl to set vector of ns_last_pid's on
 pid ns hierarhy
Date: Mon, 17 Apr 2017 20:34:37 +0300
Message-ID: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: serge@hallyn.com, ebiederm@xmission.com, agruenba@redhat.com, linux-api@vger.kernel.org, oleg@redhat.com, linux-kernel@vger.kernel.org, paul@paul-moore.com, ktkhai@virtuozzo.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

On implementing of nested pid namespaces support in CRIU
(checkpoint-restore in userspace tool) we run into
the situation, that it's impossible to create a task with
specific NSpid effectively. After commit 49f4d8b93ccf
"pidns: Capture the user namespace and filter ns_last_pid"
it is impossible to set ns_last_pid on any pid namespace,
except task's active pid_ns (before the commit it was possible
to set it for pid_ns_for_children). Thus, if a restored task
in a container has more than one pid_ns levels, the restorer
code must have a task helper for every pid namespace
of the task's pid_ns hierarhy.

This is a big problem, because of communication with
a helper for every pid_ns in the hierarchy is not cheap
and not performance-good. It implies many wakeups of helpers
to create a single task (independently, how you communicate
with the helpers). So, this patchset tries to decide the problem.

It introduces a namespaces-specific ioctls and implements the
realization for pid_ns, which allows to write a vector of last
pids on pid_ns hierarchy.

The vector is passed as a ":"-delimited string with pids,
written in reverse order. The first number corresponds to
the opened namespace ns_last_pid, the second is to its parent, etc.
If you have the pid namespaces hierarchy like:

pid_ns1 (grand father)
  |
  v
pid_ns2 (father)
  |
  v
pid_ns3 (child)

and the ns of task's of pid_ns3 is open, then the corresponding
vector will be "last_ns_pid3:last_ns_pid2:last_ns_pid1". This
vector may be short and it may contain less levels, for example,
"last_ns_pid3:last_ns_pid2" or even "last_ns_pid3", in dependence
of which levels you want to populate. Numbers last_ns_pidX are
just numbers written in decimal form.

---

Kirill Tkhai (2):
      nsfs: Add namespace-specific ioctl (NS_SPECIFIC_IOC)
      pid_ns: Introduce ioctl to set vector of ns_last_pid's on ns hierarhy


 fs/nsfs.c                 |    4 ++
 include/linux/proc_ns.h   |    1 +
 include/uapi/linux/nsfs.h |   11 ++++++
 kernel/pid_namespace.c    |   88 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
