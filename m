From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH V1 01/12] audit: add container id
Date: Thu, 15 Mar 2018 23:58:37 -0400
Message-ID: <20180316035837.ddnqvbyrbp3fdk7e@madcap2.tricolour.ca>
References: <cover.1519930146.git.rgb@redhat.com>
 <2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
 <216d1ab1-531b-9185-2e31-34f162f08aad@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <216d1ab1-531b-9185-2e31-34f162f08aad@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, mszeredi@redhat.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, trondmy@primarydata.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com
List-Id: linux-api@vger.kernel.org

On 2018-03-15 16:27, Stefan Berger wrote:
> On 03/01/2018 02:41 PM, Richard Guy Briggs wrote:
> > Implement the proc fs write to set the audit container ID of a process,
> > emitting an AUDIT_CONTAINER record to document the event.
> > 
> > This is a write from the container orchestrator task to a proc entry of
> > the form /proc/PID/containerid where PID is the process ID of the newly
> > created task that is to become the first task in a container, or an
> > additional task added to a container.
> > 
> > The write expects up to a u64 value (unset: 18446744073709551615).
> > 
> > This will produce a record such as this:
> > type=UNKNOWN[1333] msg=audit(1519903238.968:261): op=set pid=596 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=1 opid=596 old-contid=18446744073709551615 contid=123455 res=0
> > 
> > The "op" field indicates an initial set.  The "pid" to "ses" fields are
> > the orchestrator while the "opid" field is the object's PID, the process
> > being "contained".  Old and new container ID values are given in the
> > "contid" fields, while res indicates its success.
> > 
> > It is not permitted to self-set, unset or re-set the container ID.  A
> > child inherits its parent's container ID, but then can be set only once
> > after.
> > 
> > See: https://github.com/linux-audit/audit-kernel/issues/32
> > 
> > 
> >   /* audit_rule_data supports filter rules with both integer and string
> >    * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 4e0a4ac..0ee1e59 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2073,6 +2073,92 @@ int audit_set_loginuid(kuid_t loginuid)
> >   	return rc;
> >   }
> > 
> > +static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
> > +{
> > +	struct task_struct *parent;
> > +	u64 pcontainerid, ccontainerid;
> > +	pid_t ppid;
> > +
> > +	/* Don't allow to set our own containerid */
> > +	if (current == task)
> > +		return -EPERM;
> > +	/* Don't allow the containerid to be unset */
> > +	if (!cid_valid(containerid))
> > +		return -EINVAL;
> > +	/* if we don't have caps, reject */
> > +	if (!capable(CAP_AUDIT_CONTROL))
> > +		return -EPERM;
> > +	/* if containerid is unset, allow */
> > +	if (!audit_containerid_set(task))
> > +		return 0;
> 
> I am wondering whether there should be a check for the target process that
> will receive the containerid to not have CAP_SYS_ADMIN that would otherwise
> allow it to arbitrarily unshare()/clone() and leave the set of namespaces
> that may make up the container whose containerid we assign here?

This is a reasonable question.  This has been debated and I understood
the conclusion was that without a clear definition of a "container", the
task still remains in that container that just now has more
sub-namespaces (in the case of hierarchical namespaces), we don't want
to restrict it in such a way and that allows it to create nested
containers.  I see setns being more problematic if it could switch to
another existing namespace that was set up by the orchestrator for a
different container.  The coming v2 patchset acknowledges this situation
with the network namespace being potentially shared by multiple
containers.

This is the motivation for the code below that allows to set the
containerid even if it is already inherited from its parent.

> > +	/* it is already set, and not inherited from the parent, reject */
> > +	ccontainerid = audit_get_containerid(task);
> > +	rcu_read_lock();
> > +	parent = rcu_dereference(task->real_parent);
> > +	rcu_read_unlock();
> > +	task_lock(parent);
> > +	pcontainerid = audit_get_containerid(parent);
> > +	ppid = task_tgid_nr(parent);
>
> ppid not needed...

Thanks for catching this.  It was the vestige of a failed devel
experiment that didn't flush that useless appendage.  :-)

> > +	task_unlock(parent);
> > +	if (ccontainerid != pcontainerid)
> > +		return -EPERM;
> > +	return 0;
> > +}
> > +
> > +static void audit_log_set_containerid(struct task_struct *task, u64 oldcontainerid,
> > +				      u64 containerid, int rc)
> > +{
> > +	struct audit_buffer *ab;
> > +	uid_t uid;
> > +	struct tty_struct *tty;
> > +
> > +	if (!audit_enabled)
> > +		return;
> > +
> > +	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONTAINER);
> > +	if (!ab)
> > +		return;
> > +
> > +	uid = from_kuid(&init_user_ns, task_uid(current));
> > +	tty = audit_get_tty(current);
> > +
> > +	audit_log_format(ab, "op=set pid=%d uid=%u", task_tgid_nr(current), uid);
> > +	audit_log_task_context(ab);
> > +	audit_log_format(ab, " auid=%u tty=%s ses=%u opid=%d old-contid=%llu contid=%llu res=%d",
> > +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> > +			 tty ? tty_name(tty) : "(none)", audit_get_sessionid(current),
> > +			 task_tgid_nr(task), oldcontainerid, containerid, !rc);
> > +
> > +	audit_put_tty(tty);
> > +	audit_log_end(ab);
> > +}
> > +
> > +/**
> > + * audit_set_containerid - set current task's audit_context containerid
> > + * @containerid: containerid value
> > + *
> > + * Returns 0 on success, -EPERM on permission failure.
> > + *
> > + * Called (set) from fs/proc/base.c::proc_containerid_write().
> > + */
> > +int audit_set_containerid(struct task_struct *task, u64 containerid)
> > +{
> > +	u64 oldcontainerid;
> > +	int rc;
> > +
> > +	oldcontainerid = audit_get_containerid(task);
> > +
> > +	rc = audit_set_containerid_perm(task, containerid);
> > +	if (!rc) {
> > +		task_lock(task);
> > +		task->containerid = containerid;
> > +		task_unlock(task);
> > +	}
> > +
> > +	audit_log_set_containerid(task, oldcontainerid, containerid, rc);
> > +	return rc;
> > +}
> > +
> >   /**
> >    * __audit_mq_open - record audit data for a POSIX MQ open
> >    * @oflag: open flag
> 
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
