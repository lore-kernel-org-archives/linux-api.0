From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Tue, 24 Apr 2018 15:01:17 -0400
Message-ID: <CAHC9VhSZd7V9avx6K5g6CQ7mkj1T8ti7Nqq=OoWVwPznkesD1w@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com> <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
 <CAHC9VhTyvxxj2e2Gn+iyW6iLLeYB7hp8a+JvfeMmJ2nUPqtEaw@mail.gmail.com>
 <20180421143443.faaput5g2rn6ul7p@madcap2.tricolour.ca> <CAHC9VhQkJBU-f-AuEnGF1BA2QW6nCJ_yr_EqBR02-1y9+XQZ5A@mail.gmail.com>
 <20180424020200.imonhbkwtb73luxl@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180424020200.imonhbkwtb73luxl@madcap2.tricolour.ca>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Mon, Apr 23, 2018 at 10:02 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-04-23 19:15, Paul Moore wrote:
>> On Sat, Apr 21, 2018 at 10:34 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2018-04-18 19:47, Paul Moore wrote:
>> >> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> >> > Implement the proc fs write to set the audit container ID of a process,
>> >> > emitting an AUDIT_CONTAINER record to document the event.
>> >> >
>> >> > This is a write from the container orchestrator task to a proc entry of
>> >> > the form /proc/PID/containerid where PID is the process ID of the newly
>> >> > created task that is to become the first task in a container, or an
>> >> > additional task added to a container.
>> >> >
>> >> > The write expects up to a u64 value (unset: 18446744073709551615).
>> >> >
>> >> > This will produce a record such as this:
>> >> > type=CONTAINER msg=audit(1519903238.968:261): op=set pid=596 uid=0 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 auid=0 tty=pts0 ses=1 opid=596 old-contid=18446744073709551615 contid=123455 res=0
>> >> >
>> >> > The "op" field indicates an initial set.  The "pid" to "ses" fields are
>> >> > the orchestrator while the "opid" field is the object's PID, the process
>> >> > being "contained".  Old and new container ID values are given in the
>> >> > "contid" fields, while res indicates its success.
>> >> >
>> >> > It is not permitted to self-set, unset or re-set the container ID.  A
>> >> > child inherits its parent's container ID, but then can be set only once
>> >> > after.
>> >> >
>> >> > See: https://github.com/linux-audit/audit-kernel/issues/32
>> >> >
>> >> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> >> > ---
>> >> >  fs/proc/base.c             | 37 ++++++++++++++++++++
>> >> >  include/linux/audit.h      | 16 +++++++++
>> >> >  include/linux/init_task.h  |  4 ++-
>> >> >  include/linux/sched.h      |  1 +
>> >> >  include/uapi/linux/audit.h |  2 ++
>> >> >  kernel/auditsc.c           | 84 ++++++++++++++++++++++++++++++++++++++++++++++
>> >> >  6 files changed, 143 insertions(+), 1 deletion(-)

...

>> >> >  /* audit_rule_data supports filter rules with both integer and string
>> >> >   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
>> >> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> >> > index 4e0a4ac..29c8482 100644
>> >> > --- a/kernel/auditsc.c
>> >> > +++ b/kernel/auditsc.c
>> >> > @@ -2073,6 +2073,90 @@ int audit_set_loginuid(kuid_t loginuid)
>> >> >         return rc;
>> >> >  }
>> >> >
>> >> > +static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
>> >> > +{
>> >> > +       struct task_struct *parent;
>> >> > +       u64 pcontainerid, ccontainerid;
>> >> > +
>> >> > +       /* Don't allow to set our own containerid */
>> >> > +       if (current == task)
>> >> > +               return -EPERM;
>> >>
>> >> Why not?  Is there some obvious security concern that I missing?
>> >
>> > We then lose the distinction in the AUDIT_CONTAINER record between the
>> > initiating PID and the target PID.  This was outlined in the proposal.
>>
>> I just went back and reread the v3 proposal and I still don't see a
>> good explanation of this.  Why is this bad?  What's the security
>> concern?
>
> I don't remember, specifically.  Maybe this has been addressed by the
> check for children/threads or identical parent container ID.  So, I'm
> reluctantly willing to remove that check for now.

Okay.  For the record, if someone can explain to me why this
restriction saves us from some terrible situation I'm all for leaving
it.  I'm just opposed to restrictions without solid reasoning behind
them.

>> > Having said that, I'm still not sure we have protected sufficiently from
>> > a child turning around and setting it's parent's as yet unset or
>> > inherited audit container ID.
>>
>> Yes, I believe we only want to let a task set the audit container for
>> it's children (or itself/threads if we decide to allow that, see
>> above).  There *has* to be a function to check to see if a task if a
>> child of a given task ... right? ... although this is likely to be a
>> pointer traversal and locking nightmare ... hmmm.
>
> Isn't that just (struct task_struct)parent == (struct
> task_struct)child->parent (or ->real_parent)?
>
> And now that I say that, it is covered by the following patch's child
> check, so as long as we keep that, we should be fine.

I was thinking of checking not just current's immediate children, but
any of it's descendants as I believe that is what we want to limit,
yes?  I just worry that it isn't really practical to perform that
check.

>> >> I ask because I suppose it might be possible for some container
>> >> runtime to do a fork, setup some of the environment and them exec the
>> >> container (before you answer the obvious "namespaces!" please remember
>> >> we're not trying to define containers).
>> >
>> > I don't think namespaces have any bearing on this concern since none are
>> > required.
>> >
>> >> > +       /* Don't allow the containerid to be unset */
>> >> > +       if (!cid_valid(containerid))
>> >> > +               return -EINVAL;
>> >> > +       /* if we don't have caps, reject */
>> >> > +       if (!capable(CAP_AUDIT_CONTROL))
>> >> > +               return -EPERM;
>> >> > +       /* if containerid is unset, allow */
>> >> > +       if (!audit_containerid_set(task))
>> >> > +               return 0;
>> >> > +       /* it is already set, and not inherited from the parent, reject */
>> >> > +       ccontainerid = audit_get_containerid(task);
>> >> > +       rcu_read_lock();
>> >> > +       parent = rcu_dereference(task->real_parent);
>> >> > +       rcu_read_unlock();
>> >> > +       task_lock(parent);
>> >> > +       pcontainerid = audit_get_containerid(parent);
>> >> > +       task_unlock(parent);
>> >> > +       if (ccontainerid != pcontainerid)
>> >> > +               return -EPERM;
>> >> > +       return 0;

I'm looking at the parent checks again and I wonder if the logic above
is what we really want.  Maybe it is, but I'm not sure.

Things I'm wondering about:

* "ccontainerid" and "containerid" are too close in name, I kept
confusing myself when looking at this code.  Please change one.  Bonus
points if it is shorter.

* What if the orchestrator wants to move the task to a new container?
Right now it looks like you can only do that once, then then the
task's audit container ID will no longer be the same as real_parent
... or does the orchestrator change that?  *Can* the orchestrator
change real_parent (I suspect the answer is "no")?

* I think the key is the relationship between current and task, not
between task and task->real_parent.  I believe what we really care
about is that task is a descendant of current.  We might also want to
allow current to change the audit container ID if it holds
CAP_AUDIT_CONTROL, regardless of it's relationship with task.

>> >> > +static void audit_log_set_containerid(struct task_struct *task, u64 oldcontainerid,
>> >> > +                                     u64 containerid, int rc)
>> >> > +{
>> >> > +       struct audit_buffer *ab;
>> >> > +       uid_t uid;
>> >> > +       struct tty_struct *tty;
>> >> > +
>> >> > +       if (!audit_enabled)
>> >> > +               return;
>> >> > +
>> >> > +       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONTAINER);
>> >> > +       if (!ab)
>> >> > +               return;
>> >> > +
>> >> > +       uid = from_kuid(&init_user_ns, task_uid(current));
>> >> > +       tty = audit_get_tty(current);
>> >> > +
>> >> > +       audit_log_format(ab, "op=set pid=%d uid=%u", task_tgid_nr(current), uid);
>> >> > +       audit_log_task_context(ab);
>> >> > +       audit_log_format(ab, " auid=%u tty=%s ses=%u opid=%d old-contid=%llu contid=%llu res=%d",
>> >> > +                        from_kuid(&init_user_ns, audit_get_loginuid(current)),
>> >> > +                        tty ? tty_name(tty) : "(none)", audit_get_sessionid(current),
>> >> > +                        task_tgid_nr(task), oldcontainerid, containerid, !rc);
>> >> > +
>> >> > +       audit_put_tty(tty);
>> >> > +       audit_log_end(ab);
>> >> > +}
>> >> > +
>> >> > +/**
>> >> > + * audit_set_containerid - set current task's audit_context containerid
>> >> > + * @containerid: containerid value
>> >> > + *
>> >> > + * Returns 0 on success, -EPERM on permission failure.
>> >> > + *
>> >> > + * Called (set) from fs/proc/base.c::proc_containerid_write().
>> >> > + */
>> >> > +int audit_set_containerid(struct task_struct *task, u64 containerid)
>> >> > +{
>> >> > +       u64 oldcontainerid;
>> >> > +       int rc;
>> >> > +
>> >> > +       oldcontainerid = audit_get_containerid(task);
>> >> > +
>> >> > +       rc = audit_set_containerid_perm(task, containerid);
>> >> > +       if (!rc) {
>> >> > +               task_lock(task);
>> >> > +               task->containerid = containerid;
>> >> > +               task_unlock(task);
>> >> > +       }
>> >> > +
>> >> > +       audit_log_set_containerid(task, oldcontainerid, containerid, rc);
>> >> > +       return rc;
>> >>
>> >> Why are audit_set_containerid_perm() and audit_log_containerid()
>> >> separate functions?
>> >
>> > (I assume you mean audit_log_set_containerid()?)
>>
>> Yep.  My fingers got tired typing in that function name and decided a
>> shortcut was necessary.
>>
>> > It seemed clearer that all the permission checking was in one function
>> > and its return code could be used to report the outcome when logging the
>> > (attempted) action.  This is the same structure as audit_set_loginuid()
>> > and it made sense.
>>
>> When possible I really like it when the permission checks are in the
>> same function as the code which does the work; it's less likely to get
>> abused that way (you have to willfully bypass the access checks).  The
>> exceptions might be if you wanted to reuse the access control code, or
>> insert a modular access mechanism (e.g. LSMs).
>
> I don't follow how it could be abused.  The return code from the perm
> check gates setting the value and is used in the success field in the
> log.

If the permission checks are in the same function body as the code
which does the work you have to either split the function, or rewrite
it, if you want to bypass the permission checks.  It may be more of a
style issue than an actual safety issue, but the comments about
single-use functions in the same scope is the tie breaker.

-- 
paul moore
www.paul-moore.com
