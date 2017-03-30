From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH RESEND 0/2] Expose task pid_ns_for_children to userspace
Date: Thu, 30 Mar 2017 13:27:39 +0300
Message-ID: <149086931397.4388.9604947335273204415.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: agruenba@redhat.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com, paul@paul-moore.com, ebiederm@xmission.com, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, mingo@kernel.org, serge@hallyn.com
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

---

Kirill Tkhai (2):
      ns: Allow ns_entries to have custom symlink content
      pidns: Expose task pid_ns_for_children to userspace


 fs/nsfs.c               |    4 +++-
 fs/proc/namespaces.c    |    1 +
 include/linux/proc_ns.h |    2 ++
 kernel/pid_namespace.c  |   25 +++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 1 deletion(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
