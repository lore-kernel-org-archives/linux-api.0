From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v3 0/2] Expose task pid_ns_for_children to userspace
Date: Wed, 3 May 2017 13:32:14 +0300
Message-ID: <149380742825.3812.2073418607639032138.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
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

v3: Check child_reaper without tasklist_lock as we are only interested
in the fact it's not zero, and not in a specific value.

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
 kernel/pid_namespace.c  |   28 ++++++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

--
Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
