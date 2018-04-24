From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Mon, 23 Apr 2018 22:02:00 -0400
Message-ID: <20180424020200.imonhbkwtb73luxl@madcap2.tricolour.ca>
References: <cover.1521179281.git.rgb@redhat.com>
 <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
 <CAHC9VhTyvxxj2e2Gn+iyW6iLLeYB7hp8a+JvfeMmJ2nUPqtEaw@mail.gmail.com>
 <20180421143443.faaput5g2rn6ul7p@madcap2.tricolour.ca>
 <CAHC9VhQkJBU-f-AuEnGF1BA2QW6nCJ_yr_EqBR02-1y9+XQZ5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQkJBU-f-AuEnGF1BA2QW6nCJ_yr_EqBR02-1y9+XQZ5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 2018-04-23 19:15, Paul Moore wrote:
> On Sat, Apr 21, 2018 at 10:34 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2018-04-18 19:47, Paul Moore wrote:
> >> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > Implement the proc fs write to set the audit container ID of a process,
> >> > emitting an AUDIT_CONTAINER record to document the event.
> >> >
> >> > This is a write from the container orchestrator task to a proc entry of
> >> > the form /proc/PID/containerid where PID is the process ID of the newly
> >> > created task that is to become the first task in a container, or an
> >> > additional task added to a container.
> >> >
> >> > The write expects up to a u64 value (unset: 18446744073709551615).
> >> >
> >> > This will produce a record such as this:
> >> > type=CONTAINER msg=audit(1519903238.968:261): op=set pid=596 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=1 opid=596 old-contid=18446744073709551615 contid=123455 res=0
> >> >
> >> > The "op" field indicates an initial set.  The "pid" to "ses" fields are
> >> > the orchestrator while the "opid" field is the object's PID, the process
> >> > being "contained".  Old and new container ID values are given in the
> >> > "contid" fields, while res indicates its success.
> >> >
> >> > It is not permitted to self-set, unset or re-set the container ID.  A
> >> > child inherits its parent's container ID, but then can be set only once
> >> > after.
> >> >
> >> > See: https://github.com/linux-audit/audit-kernel/issues/32
> >> >
> >> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >> > ---
> >> >  fs/proc/base.c             | 37 ++++++++++++++++++++
> >> >  include/linux/audit.h      | 16 +++++++++
> >> >  include/linux/init_task.h  |  4 ++-
> >> >  include/linux/sched.h      |  1 +
> >> >  include/uapi/linux/audit.h |  2 ++
> >> >  kernel/auditsc.c           | 84 ++++++++++++++++++++++++++++++++++++++++++++++
> >> >  6 files changed, 143 insertions(+), 1 deletion(-)
> 
> ...
> 
> >> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> > index d258826..1b82191 100644
> >> > --- a/include/linux/sched.h
> >> > +++ b/include/linux/sched.h
> >> > @@ -796,6 +796,7 @@ struct task_struct {
> >> >  #ifdef CONFIG_AUDITSYSCALL
> >> >         kuid_t                          loginuid;
> >> >         unsigned int                    sessionid;
> >> > +       u64                             containerid;
> >>
> >> This one line addition to the task_struct scares me the most of
> >> anything in this patchset.  Why?  It's a field named "containerid" in
> >> a perhaps one of the most widely used core kernel structures; the
> >> possibilities for abuse are endless, and it's foolish to think we
> >> would ever be able to adequately police this.
> >
> > Fair enough.
> >
> >> Unfortunately, we can't add the field to audit_context as things
> >> currently stand because we don't always allocate an audit_context,
> >> it's dependent on the system's configuration, and we need to track the
> >> audit container ID for a given process, regardless of the audit
> >> configuration.  Pretty much the same reason why loginuid and sessionid
> >> are located directly in task_struct now.  As I stressed during the
> >> design phase, I really want to keep this as an *audit* container ID
> >> and not a general purpose kernel wide container ID.  If the kernel
> >> ever grows a general purpose container ID token, I'll be the first in
> >> line to convert the audit code, but I don't want audit to be that
> >> general purpose mechanism ... audit is hated enough as-is ;)
> >
> > When would we need an audit container ID when audit is not enabled
> > enough to have an audit_context?
> 
> I'm thinking of the audit_alloc() case where audit_filter_task()
> returns AUDIT_DISABLED.

Ok, so a task could be marked as filtered but its children would still
be auditable and inheriting its parent containerid (as well at its
loginuid and sessionid)...

> I believe this is the same reason why loginuid and sessionid live
> directly in the task_struct and not in the audit_context; they need to
> persist for the lifetime of the task.

Yes, probably.

> > If it is only used for audit, and audit is the only consumer, and audit
> > can only use it when it is enabled, then we can just return success to
> > any write to the proc filehandle, or not even present it.  Nothing will
> > be able to know that value wasn't used.
> >
> > When are loginuid and sessionid used now when audit is not enabled (or
> > should I say, explicitly disabled)?
> 
> See above.  I think that should answer these questions.

Ok.

> >> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> >> > index 4e61a9e..921a71f 100644
> >> > --- a/include/uapi/linux/audit.h
> >> > +++ b/include/uapi/linux/audit.h
> >> > @@ -71,6 +71,7 @@
> >> >  #define AUDIT_TTY_SET          1017    /* Set TTY auditing status */
> >> >  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
> >> >  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> >> > +#define AUDIT_CONTAINER                1020    /* Define the container id and information */
> >> >
> >> >  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
> >> >  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> >> > @@ -465,6 +466,7 @@ struct audit_tty_status {
> >> >  };
> >> >
> >> >  #define AUDIT_UID_UNSET (unsigned int)-1
> >> > +#define AUDIT_CID_UNSET ((u64)-1)
> >>
> >> I think we need to decide if we want to distinguish between the "host"
> >> (e.g. init ns) and "unset".  Looking at this patch (I've only quickly
> >> skimmed the others so far) it would appear that you don't think we
> >> need to worry about this distinction; that's fine, but let's make it
> >> explicit with a comment in the code that AUDIT_CID_UNSET means "unset"
> >> as well as "host".
> >
> > I don't see any reason to distinguish between "host" and "unset".  Since
> > a container doesn't have a concrete definition based in namespaces, the
> > initial namespace set is meaningless here.
> 
> Okay, that sounds reasonable.
> 
> > Is there value in having a container orchestrator process have a
> > reserved container ID that has a policy distinct from any other
> > container?
> 
> I'm open to arguments for this idea, but I don't see a point to it right now.
> 
> > If so, then I could see the value in making the distinction.
> > For example, I've heard of interest in systemd acting as a container
> > orchestrator, so if it took on that role as PID 1, then every process in
> > the system would inherit that ID and none would be unset.
> >
> > I can't picture how having seperate "host" and "unset" values helps us.
> 
> I don't have a strong feeling either way, I just wanted to ask the question.
> 
> >> >  /* audit_rule_data supports filter rules with both integer and string
> >> >   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> >> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> >> > index 4e0a4ac..29c8482 100644
> >> > --- a/kernel/auditsc.c
> >> > +++ b/kernel/auditsc.c
> >> > @@ -2073,6 +2073,90 @@ int audit_set_loginuid(kuid_t loginuid)
> >> >         return rc;
> >> >  }
> >> >
> >> > +static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
> >> > +{
> >> > +       struct task_struct *parent;
> >> > +       u64 pcontainerid, ccontainerid;
> >> > +
> >> > +       /* Don't allow to set our own containerid */
> >> > +       if (current == task)
> >> > +               return -EPERM;
> >>
> >> Why not?  Is there some obvious security concern that I missing?
> >
> > We then lose the distinction in the AUDIT_CONTAINER record between the
> > initiating PID and the target PID.  This was outlined in the proposal.
> 
> I just went back and reread the v3 proposal and I still don't see a
> good explanation of this.  Why is this bad?  What's the security
> concern?

I don't remember, specifically.  Maybe this has been addressed by the
check for children/threads or identical parent container ID.  So, I'm
reluctantly willing to remove that check for now.

> > Having said that, I'm still not sure we have protected sufficiently from
> > a child turning around and setting it's parent's as yet unset or
> > inherited audit container ID.
> 
> Yes, I believe we only want to let a task set the audit container for
> it's children (or itself/threads if we decide to allow that, see
> above).  There *has* to be a function to check to see if a task if a
> child of a given task ... right? ... although this is likely to be a
> pointer traversal and locking nightmare ... hmmm.

Isn't that just (struct task_struct)parent == (struct
task_struct)child->parent (or ->real_parent)?

And now that I say that, it is covered by the following patch's child
check, so as long as we keep that, we should be fine.

> >> I ask because I suppose it might be possible for some container
> >> runtime to do a fork, setup some of the environment and them exec the
> >> container (before you answer the obvious "namespaces!" please remember
> >> we're not trying to define containers).
> >
> > I don't think namespaces have any bearing on this concern since none are
> > required.
> >
> >> > +       /* Don't allow the containerid to be unset */
> >> > +       if (!cid_valid(containerid))
> >> > +               return -EINVAL;
> >> > +       /* if we don't have caps, reject */
> >> > +       if (!capable(CAP_AUDIT_CONTROL))
> >> > +               return -EPERM;
> >> > +       /* if containerid is unset, allow */
> >> > +       if (!audit_containerid_set(task))
> >> > +               return 0;
> >> > +       /* it is already set, and not inherited from the parent, reject */
> >> > +       ccontainerid = audit_get_containerid(task);
> >> > +       rcu_read_lock();
> >> > +       parent = rcu_dereference(task->real_parent);
> >> > +       rcu_read_unlock();
> >> > +       task_lock(parent);
> >> > +       pcontainerid = audit_get_containerid(parent);
> >> > +       task_unlock(parent);
> >> > +       if (ccontainerid != pcontainerid)
> >> > +               return -EPERM;
> >> > +       return 0;
> >> > +}
> >> > +
> >> > +static void audit_log_set_containerid(struct task_struct *task, u64 oldcontainerid,
> >> > +                                     u64 containerid, int rc)
> >> > +{
> >> > +       struct audit_buffer *ab;
> >> > +       uid_t uid;
> >> > +       struct tty_struct *tty;
> >> > +
> >> > +       if (!audit_enabled)
> >> > +               return;
> >> > +
> >> > +       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONTAINER);
> >> > +       if (!ab)
> >> > +               return;
> >> > +
> >> > +       uid = from_kuid(&init_user_ns, task_uid(current));
> >> > +       tty = audit_get_tty(current);
> >> > +
> >> > +       audit_log_format(ab, "op=set pid=%d uid=%u", task_tgid_nr(current), uid);
> >> > +       audit_log_task_context(ab);
> >> > +       audit_log_format(ab, " auid=%u tty=%s ses=%u opid=%d old-contid=%llu contid=%llu res=%d",
> >> > +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
> >> > +                        tty ? tty_name(tty) : "(none)", audit_get_sessionid(current),
> >> > +                        task_tgid_nr(task), oldcontainerid, containerid, !rc);
> >> > +
> >> > +       audit_put_tty(tty);
> >> > +       audit_log_end(ab);
> >> > +}
> >> > +
> >> > +/**
> >> > + * audit_set_containerid - set current task's audit_context containerid
> >> > + * @containerid: containerid value
> >> > + *
> >> > + * Returns 0 on success, -EPERM on permission failure.
> >> > + *
> >> > + * Called (set) from fs/proc/base.c::proc_containerid_write().
> >> > + */
> >> > +int audit_set_containerid(struct task_struct *task, u64 containerid)
> >> > +{
> >> > +       u64 oldcontainerid;
> >> > +       int rc;
> >> > +
> >> > +       oldcontainerid = audit_get_containerid(task);
> >> > +
> >> > +       rc = audit_set_containerid_perm(task, containerid);
> >> > +       if (!rc) {
> >> > +               task_lock(task);
> >> > +               task->containerid = containerid;
> >> > +               task_unlock(task);
> >> > +       }
> >> > +
> >> > +       audit_log_set_containerid(task, oldcontainerid, containerid, rc);
> >> > +       return rc;
> >>
> >> Why are audit_set_containerid_perm() and audit_log_containerid()
> >> separate functions?
> >
> > (I assume you mean audit_log_set_containerid()?)
> 
> Yep.  My fingers got tired typing in that function name and decided a
> shortcut was necessary.
> 
> > It seemed clearer that all the permission checking was in one function
> > and its return code could be used to report the outcome when logging the
> > (attempted) action.  This is the same structure as audit_set_loginuid()
> > and it made sense.
> 
> When possible I really like it when the permission checks are in the
> same function as the code which does the work; it's less likely to get
> abused that way (you have to willfully bypass the access checks).  The
> exceptions might be if you wanted to reuse the access control code, or
> insert a modular access mechanism (e.g. LSMs).

I don't follow how it could be abused.  The return code from the perm
check gates setting the value and is used in the success field in the
log.

> I'm less concerned about audit_log_set_containerid(), but the usual
> idea of avoiding single-use function within the same scope applies
> here.
> 
> > This would be the time to connect it to a syscall if that seems like a
> > good idea and remove pid, uid, auid, tty, ses fields.
> 
> Ah yes, I missed that.  You know my stance on connecting records by
> now (hint: yes, connect them) so I think that would be a good thing to
> do for the next round.

Ok...

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
