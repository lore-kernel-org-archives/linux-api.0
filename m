From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V8 12/16] audit: contid check descendancy and nesting
Date: Thu, 23 Jan 2020 16:47:38 -0500
Message-ID: <CAHC9VhQtAfW-+sK3Gb6y=jPYOkyXnopO94k+u_6UKAAaACg44Q@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <cfbb80a08fc770dd0dcf6dac6ff307a80d877c3f.1577736799.git.rgb@redhat.com>
 <CAHC9VhT1+mx_tVzyXD=UBqagqYgAFjZ=X1A6oBiMvjVCn8=V-w@mail.gmail.com> <20200123210240.sq64tptjm3ds7xss@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200123210240.sq64tptjm3ds7xss@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Thu, Jan 23, 2020 at 4:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:29, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Require the target task to be a descendant of the container
> > > orchestrator/engine.
> > >
> > > You would only change the audit container ID from one set or inherited
> > > value to another if you were nesting containers.
> > >
> > > If changing the contid, the container orchestrator/engine must be a
> > > descendant and not same orchestrator as the one that set it so it is not
> > > possible to change the contid of another orchestrator's container.
> > >
> > > Since the task_is_descendant() function is used in YAMA and in audit,
> > > remove the duplication and pull the function into kernel/core/sched.c
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/sched.h    |  3 +++
> > >  kernel/audit.c           | 44 ++++++++++++++++++++++++++++++++++++--------
> > >  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
> > >  security/yama/yama_lsm.c | 33 ---------------------------------
> > >  4 files changed, 72 insertions(+), 41 deletions(-)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index f7a8d3288ca0..ef8e07524c46 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -2603,22 +2610,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >         oldcontid = audit_get_contid(task);
> > >         read_lock(&tasklist_lock);
> > >         /* Don't allow the contid to be unset */
> > > -       if (!audit_contid_valid(contid))
> > > +       if (!audit_contid_valid(contid)) {
> > >                 rc = -EINVAL;
> > > +               goto unlock;
> > > +       }
> > >         /* Don't allow the contid to be set to the same value again */
> > > -       else if (contid == oldcontid) {
> > > +       if (contid == oldcontid) {
> > >                 rc = -EADDRINUSE;
> > > +               goto unlock;
> > > +       }
> > >         /* if we don't have caps, reject */
> > > -       else if (!capable(CAP_AUDIT_CONTROL))
> > > +       if (!capable(CAP_AUDIT_CONTROL)) {
> > >                 rc = -EPERM;
> > > -       /* if task has children or is not single-threaded, deny */
> > > -       else if (!list_empty(&task->children))
> > > +               goto unlock;
> > > +       }
> > > +       /* if task has children, deny */
> > > +       if (!list_empty(&task->children)) {
> > >                 rc = -EBUSY;
> > > -       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > +               goto unlock;
> > > +       }
> > > +       /* if task is not single-threaded, deny */
> > > +       if (!(thread_group_leader(task) && thread_group_empty(task))) {
> > >                 rc = -EALREADY;
> > > -       /* if contid is already set, deny */
> > > -       else if (audit_contid_set(task))
> > > +               goto unlock;
> > > +       }
> >
> > It seems like the if/else-if conversion above should be part of an
> > earlier patchset.
>
> I had considered that, but it wasn't obvious where that conversion
> should happen since it wasn't necessary earlier and is now.  I can move
> it earlier if you feel strongly about it.

Not particularly.

-- 
paul moore
www.paul-moore.com
