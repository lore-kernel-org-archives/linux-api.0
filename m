From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 14/21] audit: contid check descendancy and
 nesting
Date: Thu, 24 Oct 2019 18:08:14 -0400
Message-ID: <20191024220814.pid5ql6kvyr4ianb@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <16abf1b2aafeb5f1b8dae20b9a4836e54f959ca5.1568834524.git.rgb@redhat.com>
 <CAHC9VhSRmn46DcazH4Q35vOSxVoEu8PsX79aurkHkFymRoMwag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhSRmn46DcazH4Q35vOSxVoEu8PsX79aurkHkFymRoMwag@mail.gmail.com>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2019-10-10 20:40, Paul Moore wrote:
> On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote=
:
> > ?fixup! audit: convert to contid list to check for orch/engine ownershi=
p
>=20
> ?
>=20
> > Require the target task to be a descendant of the container
> > orchestrator/engine.
> >
> > You would only change the audit container ID from one set or inherited
> > value to another if you were nesting containers.
> >
> > If changing the contid, the container orchestrator/engine must be a
> > descendant and not same orchestrator as the one that set it so it is no=
t
> > possible to change the contid of another orchestrator's container.
>=20
> Did you mean to say that the container orchestrator must be an
> ancestor of the target, and the same orchestrator as the one that set
> the target process' audit container ID?

Not quite, the first half yes, but the second half: if it was already
set by that orchestrator, it can't be set again.  If it is a different
orchestrator that is a descendant of the orchestrator that set it, then
allow the action.

> Or maybe I'm missing something about what you are trying to do?

Does that help clarify it?

> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+-------
> >  1 file changed, 62 insertions(+), 8 deletions(-)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 9ce7a1ec7a92..69fe1e9af7cb 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2560,6 +2560,39 @@ static struct task_struct *audit_cont_owner(stru=
ct task_struct *tsk)
> >  }
> >
> >  /*
> > + * task_is_descendant - walk up a process family tree looking for a ma=
tch
> > + * @parent: the process to compare against while walking up from child
> > + * @child: the process to start from while looking upwards for parent
> > + *
> > + * Returns 1 if child is a descendant of parent, 0 if not.
> > + */
> > +static int task_is_descendant(struct task_struct *parent,
> > +                             struct task_struct *child)
> > +{
> > +       int rc =3D 0;
> > +       struct task_struct *walker =3D child;
> > +
> > +       if (!parent || !child)
> > +               return 0;
> > +
> > +       rcu_read_lock();
> > +       if (!thread_group_leader(parent))
> > +               parent =3D rcu_dereference(parent->group_leader);
> > +       while (walker->pid > 0) {
> > +               if (!thread_group_leader(walker))
> > +                       walker =3D rcu_dereference(walker->group_leader=
);
> > +               if (walker =3D=3D parent) {
> > +                       rc =3D 1;
> > +                       break;
> > +               }
> > +               walker =3D rcu_dereference(walker->real_parent);
> > +       }
> > +       rcu_read_unlock();
> > +
> > +       return rc;
> > +}
> > +
> > +/*
> >   * audit_set_contid - set current task's audit contid
> >   * @task: target task
> >   * @contid: contid value
> > @@ -2587,22 +2620,43 @@ int audit_set_contid(struct task_struct *task, =
u64 contid)
> >         oldcontid =3D audit_get_contid(task);
> >         read_lock(&tasklist_lock);
> >         /* Don't allow the contid to be unset */
> > -       if (!audit_contid_valid(contid))
> > +       if (!audit_contid_valid(contid)) {
> >                 rc =3D -EINVAL;
> > +               goto unlock;
> > +       }
> >         /* Don't allow the contid to be set to the same value again */
> > -       else if (contid =3D=3D oldcontid) {
> > +       if (contid =3D=3D oldcontid) {
> >                 rc =3D -EADDRINUSE;
> > +               goto unlock;
> > +       }
> >         /* if we don't have caps, reject */
> > -       else if (!capable(CAP_AUDIT_CONTROL))
> > +       if (!capable(CAP_AUDIT_CONTROL)) {
> >                 rc =3D -EPERM;
> > -       /* if task has children or is not single-threaded, deny */
> > -       else if (!list_empty(&task->children))
> > +               goto unlock;
> > +       }
> > +       /* if task has children, deny */
> > +       if (!list_empty(&task->children)) {
> >                 rc =3D -EBUSY;
> > -       else if (!(thread_group_leader(task) && thread_group_empty(task=
)))
> > +               goto unlock;
> > +       }
> > +       /* if task is not single-threaded, deny */
> > +       if (!(thread_group_leader(task) && thread_group_empty(task))) {
> >                 rc =3D -EALREADY;
> > -       /* if contid is already set, deny */
> > -       else if (audit_contid_set(task))
> > +               goto unlock;
> > +       }
> > +       /* if task is not descendant, block */
> > +       if (task =3D=3D current) {
> > +               rc =3D -EBADSLT;
> > +               goto unlock;
> > +       }
> > +       if (!task_is_descendant(current, task)) {
> > +               rc =3D -EXDEV;
> > +               goto unlock;
> > +       }
> > +       /* only allow contid setting again if nesting */
> > +       if (audit_contid_set(task) && current =3D=3D audit_cont_owner(t=
ask))
> >                 rc =3D -ECHILD;
> > +unlock:
> >         read_unlock(&tasklist_lock);
> >         if (!rc) {
> >                 struct audit_cont *oldcont =3D audit_cont(task);
>=20
> --
> paul moore
> www.paul-moore.com

- RGB
