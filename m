From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 20:00:56 -0700
Message-ID: <20160708030055.GC10512@outlook.office365.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
	<CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
	<1467919055.2322.36.camel@HansenPartnership.com>
	<20160708021617.GB10512@outlook.office365.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160708021617.GB10512-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline

On Thu, Jul 07, 2016 at 07:16:18PM -0700, Andrew Vagin wrote:
> On Thu, Jul 07, 2016 at 12:17:35PM -0700, James Bottomley wrote:
> > On Thu, 2016-07-07 at 20:21 +0200, Michael Kerrisk (man-pages) wrote:
> > > On 7 July 2016 at 17:01, James Bottomley
> > > <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > [Serge already answered the parenting issue]
> > > > On Thu, 2016-07-07 at 08:36 -0500, Serge E. Hallyn wrote:
> > > > > Hm.  Probably best-effort based on the process hierarchy.  So 
> > > > > yeah you could probably get a tree into a state that would be 
> > > > > wrongly recreated. Create a new netns, bind mount it, exit;  Have 
> > > > > another task create a new user_ns, bind mount it, exit;  Third 
> > > > > task setns()s first to the new netns then to the new user_ns.  I 
> > > > > suspect criu will recreate that wrongly.
> > > > 
> > > > This is a bit pathological, and you have to be root to do it: so 
> > > > root can set up a nesting hierarchy, bind it and destroy the pids 
> > > > but I know of no current orchestration system which does this.
> > > > 
> > > > Actually, I have to back pedal a bit: the way I currently set up
> > > > architecture emulation containers does precisely this: I set up the
> > > > namespaces unprivileged with child mount namespaces, but then I ask
> > > > root to bind the userns and kill the process that created it so I 
> > > > have a permanent handle to enter the namespace by, so I suspect 
> > > > that when our current orchestration systems get more sophisticated, 
> > > > they might eventually want to do something like this as well.
> > > > 
> > > > In theory, we could get nsfs to show this information as an option
> > > > (just add a show_options entry to the superblock ops), but the 
> > > > problem is that although each namespace has a parent user_ns, 
> > > > there's no way to get it without digging in the namespace specific 
> > > > structure.  Probably we should restructure to move it into 
> > > > ns_common, then we could display it (and enforce all namespaces 
> > > > having owning user_ns) but it would be a
> > > 
> > > I'm missing something here. Is it not already the case that all
> > > namespaces have an owning user_ns?
> > 
> > Um, yes, I don't believe I said they don't.  The problem I thought you
> > were having is that there's no way of seeing what it is.
> > 
> > nsfs is the Namespace fileystem where bound namespaces appear to a cat
> > of /proc/self/mounts.  It can display any information that's in
> > ns_common (the common core of namespaces) but the owning user_ns
> > pointer currently isn't in this structure.  Every user namespace has a
> > pointer to it, but they're all privately embedded in the individual
> > namespace specific structures.  What I was proposing was that since
> > every current namespace has a pointer somewhere to the owning user
> > namespace, we could abstract this out into ns_common so it's now
> > accessible to be displayed by nsfs, probably as a mount option.
> 
> James, I am not sure that I understood you correctly. We have one
> file system for all namespace files, how we can show per-file properties
> in mount options. I think we can show all required information in
> fdinfo. We open a namespaces file (/proc/pid/ns/N) and then read
> /proc/pid/fdinfo/X for it.

Here is a proof-of-concept patch.

How it works:

In [1]: import os

In [2]: fd = os.open("/proc/self/ns/pid", os.O_RDONLY)

In [3]: print open("/proc/self/fdinfo/%d" % fd).read()
pos:	0
flags:	0100000
mnt_id:	2
userns: 4026531837

In [4]: print "/proc/self/ns/user -> %s" % os.readlink("/proc/self/ns/user")
/proc/self/ns/user -> user:[4026531837]

> 
> > 
> > James
> > 
> > 
> > _______________________________________________
> > CRIU mailing list
> > CRIU-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
> > https://lists.openvz.org/mailman/listinfo/criu
> _______________________________________________
> CRIU mailing list
> CRIU-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
> https://lists.openvz.org/mailman/listinfo/criu

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: attachment; filename="patch"

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8f20d60..bfd5bde 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -8,8 +8,20 @@
 
 static struct vfsmount *nsfs_mnt;
 
+static void show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct dentry *dentry = f->f_path.dentry;
+	struct inode *inode = d_inode(dentry);
+	const struct proc_ns_operations *ns_ops = dentry->d_fsdata;
+	struct ns_common *ns = inode->i_private;
+
+	if (ns_ops->show_fdinfo)
+		ns_ops->show_fdinfo(m, ns);
+}
+
 static const struct file_operations ns_file_operations = {
 	.llseek		= no_llseek,
+	.show_fdinfo	= show_fdinfo,
 };
 
 static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index de0e771..fed276b 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -18,6 +18,7 @@ struct proc_ns_operations {
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
+	void (*show_fdinfo)(struct seq_file *m, struct ns_common *ns);
 };
 
 extern const struct proc_ns_operations netns_operations;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a65ba13..910b388 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -388,12 +388,20 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static void pidns_fdinfo(struct seq_file *m, struct ns_common *ns)
+{
+	struct pid_namespace *pidns = to_pid_ns(ns);
+
+	seq_printf(m, "userns: %u\n", pidns->user_ns->ns.inum);
+}
+
 const struct proc_ns_operations pidns_operations = {
 	.name		= "pid",
 	.type		= CLONE_NEWPID,
 	.get		= pidns_get,
 	.put		= pidns_put,
 	.install	= pidns_install,
+	.show_fdinfo	= pidns_fdinfo,
 };
 
 static __init int pid_namespaces_init(void)

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--3MwIy2ne0vdjdPXF--
