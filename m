From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [REVIEW][PATCH 08/11] ipc/util: Helpers for making the sysvipc
	operations pid namespace aware
Date: Fri, 23 Mar 2018 14:16:11 -0500
Message-ID: <20180323191614.32489-8-ebiederm@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87vadmobdw.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Capture the pid namespace when /proc/sysvipc/msg /proc/sysvipc/shm
and /proc/sysvipc/sem are opened, and make it available through
the new helper ipc_seq_pid_ns.

This makes it possible to report the pids in these files in the
pid namespace of the opener of the files.

Implement ipc_update_pid.  A simple impline helper that will only update
a struct pid pointer if the new value does not equal the old value.  This
removes the need for wordy code sequences like:

	old = object->pid;
	object->pid = new;
	put_pid(old);

and

	old = object->pid;
	if (old != new) {
		object->pid = new;
		put_pid(old);
	}

Allowing the following to be written instead:

	ipc_update_pid(&object->pid, new);

Which is easier to read and ensures that the pid reference count is
not touched the old and the new values are the same.  Not touching
the reference count in this case is important to help avoid issues
like af_unix experienced, where multiple threads of the same
process managed to bounce the struct pid between cpu cache lines,
but updating the pids reference count.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 ipc/util.c |  9 +++++++++
 ipc/util.h | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/ipc/util.c b/ipc/util.c
index 4ed5a17dd06f..3783b7991cc7 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -747,9 +747,16 @@ int ipc_parse_version(int *cmd)
 #ifdef CONFIG_PROC_FS
 struct ipc_proc_iter {
 	struct ipc_namespace *ns;
+	struct pid_namespace *pid_ns;
 	struct ipc_proc_iface *iface;
 };
 
+struct pid_namespace *ipc_seq_pid_ns(struct seq_file *s)
+{
+	struct ipc_proc_iter *iter = s->private;
+	return iter->pid_ns;
+}
+
 /*
  * This routine locks the ipc structure found at least at position pos.
  */
@@ -872,6 +879,7 @@ static int sysvipc_proc_open(struct inode *inode, struct file *file)
 
 	iter->iface = PDE_DATA(inode);
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
+	iter->pid_ns = get_pid_ns(task_active_pid_ns(current));
 
 	return 0;
 }
@@ -881,6 +889,7 @@ static int sysvipc_proc_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct ipc_proc_iter *iter = seq->private;
 	put_ipc_ns(iter->ns);
+	put_pid_ns(iter->pid_ns);
 	return seq_release_private(inode, file);
 }
 
diff --git a/ipc/util.h b/ipc/util.h
index 959c10eb9cc1..e39ed9705f99 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -23,6 +23,7 @@ int msg_init(void);
 void shm_init(void);
 
 struct ipc_namespace;
+struct pid_namespace;
 
 #ifdef CONFIG_POSIX_MQUEUE
 extern void mq_clear_sbinfo(struct ipc_namespace *ns);
@@ -86,6 +87,7 @@ int ipc_init_ids(struct ipc_ids *);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
+struct pid_namespace *ipc_seq_pid_ns(struct seq_file *);
 #else
 #define ipc_init_proc_interface(path, header, ids, show) do {} while (0)
 #endif
@@ -150,6 +152,15 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
 					     struct ipc64_perm *perm, int extra_perm);
 
+static inline void ipc_update_pid(struct pid **pos, struct pid *pid)
+{
+	struct pid *old = *pos;
+	if (old != pid) {
+		*pos = get_pid(pid);
+		put_pid(old);
+	}
+}
+
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
 /* On IA-64, we always use the "64-bit version" of the IPC structures.  */
 # define ipc_parse_version(cmd)	IPC_64
-- 
2.14.1
