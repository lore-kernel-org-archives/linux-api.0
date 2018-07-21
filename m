From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 09/10] debug audit: read
	container ID of a process
Date: Sat, 21 Jul 2018 15:21:47 -0400
Message-ID: <20180721192147.vmeq3u2pqheo3trf@madcap2.tricolour.ca>
References: <cover.1528304203.git.rgb@redhat.com>
	<b1eff0b849cc472f10dee8bd4f2eeb3567f0a459.1528304204.git.rgb@redhat.com>
	<CAHC9VhRhHJV87g+4b2BMxnrpgPvNYMBa1RUQzK3xrK1yugBYzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRhHJV87g+4b2BMxnrpgPvNYMBa1RUQzK3xrK1yugBYzQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>
Cc: simo@redhat.com, jlayton@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, dhowells@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, serge@hallyn.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2018-07-20 18:15, Paul Moore wrote:
> On Wed, Jun 6, 2018 at 1:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Add support for reading the audit container identifier from the proc
> > filesystem.
> >
> > This is a read from the proc entry of the form
> > /proc/PID/audit_containerid where PID is the process ID of the task
> > whose audit container identifier is sought.
> >
> > The read expects up to a u64 value (unset: 18446744073709551615).
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  fs/proc/base.c | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 318dff4..ca8bfe2 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -1303,6 +1303,21 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
> >         .llseek         = generic_file_llseek,
> >  };
> >
> > +static ssize_t proc_contid_read(struct file *file, char __user *buf,
> > +                                 size_t count, loff_t *ppos)
> > +{
> > +       struct inode *inode = file_inode(file);
> > +       struct task_struct *task = get_proc_task(inode);
> > +       ssize_t length;
> > +       char tmpbuf[TMPBUFLEN*2];
> > +
> > +       if (!task)
> > +               return -ESRCH;
> > +       length = scnprintf(tmpbuf, TMPBUFLEN*2, "%llu", audit_get_contid(task));
> > +       put_task_struct(task);
> > +       return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> > +}
> 
> While I still remain very nervous about opening the audit container ID
> up for abuse by making it accessible, I understand that this would
> make things a lot easier us (e.g. testing) and perhaps the container
> engines as well.  In order to limit the potential for abuse, what do
> you think about restricting read access to those processes which have
> CAP_AUDIT_CONTROL, similar to what we do for setting the audit
> container ID?

That seems like a reasonable restriction.

> >  static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> >                                    size_t count, loff_t *ppos)
> >  {
> > @@ -1333,6 +1348,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> >  }
> >
> >  static const struct file_operations proc_contid_operations = {
> > +       .read           = proc_contid_read,
> >         .write          = proc_contid_write,
> >         .llseek         = generic_file_llseek,
> >  };
> > @@ -3030,7 +3046,7 @@ static int proc_pid_patch_state(struct seq_file *m, struct pid_namespace *ns,
> >  #ifdef CONFIG_AUDITSYSCALL
> >         REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
> >         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> > -       REG("audit_containerid", S_IWUSR, proc_contid_operations),
> > +       REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> >  #endif
> >  #ifdef CONFIG_FAULT_INJECTION
> >         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > @@ -3422,7 +3438,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
> >  #ifdef CONFIG_AUDITSYSCALL
> >         REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
> >         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> > -       REG("audit_containerid", S_IWUSR, proc_contid_operations),
> > +       REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> >  #endif
> >  #ifdef CONFIG_FAULT_INJECTION
> >         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> 
> --
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
