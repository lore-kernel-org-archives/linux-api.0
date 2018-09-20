From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via
 USER_NOTIF
Date: Thu, 20 Sep 2018 17:42:40 -0600
Message-ID: <20180920234240.GR4672@cisco>
References: <20180906152859.7810-1-tycho@tycho.ws>
 <20180906152859.7810-5-tycho@tycho.ws>
 <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
 <20180919095536.GM4672@cisco>
 <C1406292-7496-459F-A76A-20C9EFBB12D6@amacapital.net>
 <20180919143842.GN4672@cisco>
 <CALCETrVuP0nQ5B01-iWrcQ87hisz7=jA08-Uisqud_r+zc74NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVuP0nQ5B01-iWrcQ87hisz7=jA08-Uisqud_r+zc74NQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 19, 2018 at 12:58:20PM -0700, Andy Lutomirski wrote:
> On Wed, Sep 19, 2018 at 7:38 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > On Wed, Sep 19, 2018 at 07:19:56AM -0700, Andy Lutomirski wrote:
> >>
> >>
> >> > On Sep 19, 2018, at 2:55 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> >> >
> >> >> On Wed, Sep 12, 2018 at 04:52:38PM -0700, Andy Lutomirski wrote:
> >> >>> On Thu, Sep 6, 2018 at 8:28 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> >> >>> The idea here is that the userspace handler should be able to pass an fd
> >> >>> back to the trapped task, for example so it can be returned from socket().
> >> >>>
> >> >>> I've proposed one API here, but I'm open to other options. In particular,
> >> >>> this only lets you return an fd from a syscall, which may not be enough in
> >> >>> all cases. For example, if an fd is written to an output parameter instead
> >> >>> of returned, the current API can't handle this. Another case is that
> >> >>> netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
> >> >>> ever decides to install an fd and output it, we wouldn't be able to handle
> >> >>> this either.
> >> >>
> >> >> An alternative could be to have an API (an ioctl on the listener,
> >> >> perhaps) that just copies an fd into the tracee.  There would be the
> >> >> obvious set of options: do we replace an existing fd or allocate a new
> >> >> one, and is it CLOEXEC.  Then the tracer could add an fd and then
> >> >> return it just like it's a regular number.
> >> >>
> >> >> I feel like this would be more flexible and conceptually simpler, but
> >> >> maybe a little slower for the common cases.  What do you think?
> >> >
> >> > I'm just implementing this now, and there's one question: when do we
> >> > actually do the fd install? Should we do it when the user calls
> >> > SECCOMP_NOTIF_PUT_FD, or when the actual response is sent? It feels
> >> > like we should do it when the response is sent, instead of doing it
> >> > right when SECCOMP_NOTIF_PUT_FD is called, since if there's a
> >> > subsequent signal and the tracer decides to discard the response,
> >> > we'll have to implement some delete mechanism to delete the fd, but it
> >> > would have already been visible to the process, etc. So I'll go
> >> > forward with this unless there are strong objections, but I thought
> >> > I'd point it out just to avoid another round trip.
> >> >
> >> >
> >>
> >> Can you do that non-racily?  That is, you need to commit to an fd *number* right away, but what if another thread uses the number before you actually install the fd?
> >
> > I was thinking we could just do an __alloc_fd() and then do the
> > fd_install() when the response is sent or clean up the case that the
> > listener or task dies. I haven't actually tried to run the code yet,
> > so it's possible the locking won't work :)
> 
> I would be very surprised if the locking works.  How can you run a
> thread in a process when another thread has allocated but not
> installed an fd and is blocked for an arbitrarily long time?

I think the trick is that there's no actual locking required (except
for a brief locking of task->files). I've run the patch below and it
seems to work. But perhaps that's abusing __alloc_fd a little too
hard, I don't really know.

> >
> >> Do we really allow non-“kill” signals to interrupt the whole process?  It might be the case that we don’t really need to clean up from signals if there’s a guarantee that the thread dies.
> >
> > Yes, we do, because of this: https://lkml.org/lkml/2018/3/15/1122
> >
> 
> I'm still not sure I see the problem.  Suppose I'm implementing a user
> notifier for a nasty syscall like recvmsg().  If I'm the tracer, by
> the time I decide to install an fd, I've committed to returning
> something other than -EINTR, even if a non-fatal signal is sent before
> I finish.  No rollback should be necessary.

I don't understand why this is true. Surely you could stop a handler
on receipt of a new signal, and have it do something else entirely?

> In the (unlikely?) event that some tracer needs to be able to rollback
> an fd installation to return -EINTR, a SECCOMP_NOTIF_CLOSE_FD
> operation should be good enough, I think.  Or maybe PUT_FD can put -1
> to delete an fd.

Yes, I think even with something like what I did below we'd need some
sort of REMOVE_FD option, because otherwise there's no way to change
your mind and send -EINTR without the fd you just PUT_FD'd.

Tycho


>From bfca7337cb53791aca74b595eb45e9afa3babac2 Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@tycho.ws>
Date: Thu, 20 Sep 2018 06:49:49 -0600
Subject: [PATCH] implement SECCOMP_NOTIF_PUT_FD ioctl

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 include/uapi/linux/seccomp.h                  |  8 ++
 kernel/seccomp.c                              | 74 ++++++++++++-------
 tools/testing/selftests/seccomp/seccomp_bpf.c | 24 +++++-
 3 files changed, 77 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 8fb2c024c0a1..62e474c372d4 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -80,6 +80,12 @@ struct seccomp_notif_resp {
 	__u32 fd_flags;
 };
 
+struct seccomp_notif_put_fd {
+	__u64 id;
+	__s32 fd;
+	__u32 fd_flags;
+};
+
 #define SECCOMP_IOC_MAGIC		0xF7
 
 /* Flags for seccomp notification fd ioctl. */
@@ -89,5 +95,7 @@ struct seccomp_notif_resp {
 					struct seccomp_notif_resp)
 #define SECCOMP_NOTIF_ID_VALID	_IOR(SECCOMP_IOC_MAGIC, 2,	\
 					__u64)
+#define SECCOMP_NOTIF_PUT_FD	_IOR(SECCOMP_IOC_MAGIC, 3,	\
+					struct seccomp_notif_put_fd)
 
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 21b24cc07237..6bdf413863ca 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -41,6 +41,7 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
+#include <linux/fdtable.h>
 #include <net/cls_cgroup.h>
 
 enum notify_state {
@@ -51,6 +52,7 @@ enum notify_state {
 
 struct seccomp_knotif {
 	/* The struct pid of the task whose filter triggered the notification */
+	struct task_struct *task;
 	struct pid *pid;
 
 	/* The "cookie" for this request; this is unique for this filter. */
@@ -80,7 +82,7 @@ struct seccomp_knotif {
 	int error;
 	long val;
 	struct file *file;
-	unsigned int flags;
+	int fd;
 
 	/* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
 	struct completion ready;
@@ -748,9 +750,11 @@ static void seccomp_do_user_notification(int this_syscall,
 	if (!match->notif)
 		goto out;
 
+	n.task = current;
 	n.pid = task_pid(current);
 	n.state = SECCOMP_NOTIFY_INIT;
 	n.data = sd;
+	n.fd = -1;
 	n.id = seccomp_next_notify_id(match);
 	init_completion(&n.ready);
 
@@ -786,16 +790,8 @@ static void seccomp_do_user_notification(int this_syscall,
 	}
 
 	if (n.file) {
-		int fd;
 		struct socket *sock;
 
-		fd = get_unused_fd_flags(n.flags);
-		if (fd < 0) {
-			err = fd;
-			ret = -1;
-			goto remove_list;
-		}
-
 		/*
 		 * Similar to what SCM_RIGHTS does, let's re-set the cgroup
 		 * data to point ot the tracee's cgroups instead of the
@@ -807,21 +803,20 @@ static void seccomp_do_user_notification(int this_syscall,
 			sock_update_classid(&sock->sk->sk_cgrp_data);
 		}
 
-		ret = fd;
-		err = 0;
-
-		fd_install(fd, n.file);
+		fd_install(n.fd, n.file);
 		/* Don't fput, since fd has a reference now */
 		n.file = NULL;
-	} else {
-		ret = n.val;
-		err = n.error;
+		n.fd = -1;
 	}
 
+	ret = n.val;
+	err = n.error;
 
 remove_list:
 	if (n.file)
 		fput(n.file);
+	if (n.fd >= 0)
+		put_unused_fd(n.fd);
 
 	list_del(&n.list);
 out:
@@ -1683,15 +1678,6 @@ static long seccomp_notify_send(struct seccomp_filter *filter,
 		goto out;
 	}
 
-	if (resp.return_fd) {
-		knotif->flags = resp.fd_flags;
-		knotif->file = fget(resp.fd);
-		if (!knotif->file) {
-			ret = -EBADF;
-			goto out;
-		}
-	}
-
 	ret = size;
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = resp.error;
@@ -1731,6 +1717,42 @@ static long seccomp_notify_id_valid(struct seccomp_filter *filter,
 	return ret;
 }
 
+static long seccomp_notify_put_fd(struct seccomp_filter *filter,
+				  unsigned long arg)
+{
+	struct seccomp_notif_put_fd req;
+	void __user *buf = (void __user *)arg;
+	struct seccomp_knotif *knotif = NULL;
+	long ret;
+
+	if (copy_from_user(&req, buf, sizeof(req)))
+		return -EFAULT;
+
+	ret = mutex_lock_interruptible(&filter->notify_lock);
+	if (ret < 0)
+		return ret;
+
+	ret = -ENOENT;
+	list_for_each_entry(knotif, &filter->notif->notifications, list) {
+		unsigned long max_files;
+
+		if (knotif->id != req.id)
+			continue;
+
+		max_files = task_rlimit(knotif->task, RLIMIT_NOFILE);
+
+		knotif->file = fget(req.fd);
+		knotif->fd = __alloc_fd(knotif->task->files, 0, max_files,
+					req.fd_flags);
+
+		ret = knotif->fd;
+		break;
+	}
+
+	mutex_unlock(&filter->notify_lock);
+	return ret;
+}
+
 static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -1743,6 +1765,8 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 		return seccomp_notify_send(filter, arg);
 	case SECCOMP_NOTIF_ID_VALID:
 		return seccomp_notify_id_valid(filter, arg);
+	case SECCOMP_NOTIF_PUT_FD:
+		return seccomp_notify_put_fd(filter, arg);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 3dec856717a7..ae8daf992231 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -169,6 +169,9 @@ struct seccomp_metadata {
 					struct seccomp_notif_resp)
 #define SECCOMP_NOTIF_ID_VALID	_IOR(SECCOMP_IOC_MAGIC, 2,	\
 					__u64)
+#define SECCOMP_NOTIF_PUT_FD	_IOR(SECCOMP_IOC_MAGIC, 3,	\
+					struct seccomp_notif_put_fd)
+
 struct seccomp_notif {
 	__u16 len;
 	__u64 id;
@@ -186,6 +189,12 @@ struct seccomp_notif_resp {
 	__u32 fd;
 	__u32 fd_flags;
 };
+
+struct seccomp_notif_put_fd {
+	__u64 id;
+	__s32 fd;
+	__u32 fd_flags;
+};
 #endif
 
 #ifndef seccomp
@@ -3239,11 +3248,12 @@ TEST(get_user_notification_ptrace)
 TEST(user_notification_pass_fd)
 {
 	pid_t pid;
-	int status, listener;
+	int status, listener, fd;
 	int sk_pair[2];
 	char c;
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
+	struct seccomp_notif_put_fd putfd = {};
 	long ret;
 
 	ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
@@ -3295,9 +3305,15 @@ TEST(user_notification_pass_fd)
 
 	resp.len = sizeof(resp);
 	resp.id = req.id;
-	resp.return_fd = 1;
-	resp.fd = sk_pair[1];
-	resp.fd_flags = 0;
+
+	putfd.id = req.id;
+	putfd.fd = sk_pair[1];
+	putfd.fd_flags = 0;
+
+	fd = ioctl(listener, SECCOMP_NOTIF_PUT_FD, &putfd);
+	EXPECT_GE(fd, 0);
+	resp.val = fd;
+
 	EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_SEND, &resp), sizeof(resp));
 	close(sk_pair[1]);
 
-- 
2.17.1
