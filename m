From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v2 0/2] Expose task pid_ns_for_children to userspace
Date: Wed, 12 Apr 2017 18:33:12 +0300
Message-ID: <149201102204.6007.8628824763325355297.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: serge@hallyn.com, ebiederm@xmission.com, agruenba@redhat.com, linux-api@vger.kernel.org, oleg@redhat.com, linux-kernel@vger.kernel.org, paul@paul-moore.com, ktkhai@virtuozzo.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

pid_ns_for_children set by a task is known only to the task itself,
and it's impossible to identify it from outside.

It's a big problem for checkpoint/restore software like CRIU,
because it can't correctly handle tasks, that do setns(CLONE_NEWPID)
in proccess of their work. If they have a custom pid_ns_for_children
before dump, they must have the same ns after restore. Otherwise,
restored task bumped into enviroment it does not expect.

This patchset solves the problem. It exposes pid_ns_for_children
to ns directory in standard way with the name "pid_for_children":

~# ls /proc/5531/ns -l | grep pid
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]

v2: Do not allow to take a pid namespace, if there is no child reaper
created. This prevents race between creation of the child reaper and
other tasks.
---

Kirill Tkhai (2):
      ns: Allow ns_entries to have custom symlink content
      pidns: Expose task pid_ns_for_children to userspace


 fs/nsfs.c               |    4 +++-
 fs/proc/namespaces.c    |    1 +
 include/linux/proc_ns.h |    2 ++
 kernel/pid_namespace.c  |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
