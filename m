From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Date: Tue, 2 Apr 2019 09:31:49 -0400
Message-ID: <CAHC9VhRW86NamkX9FcsHEYg_DJehCCAnANUqB8+gv=dxpBkd6w@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com> <20190402113150.GA17593@hmswarspite.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402113150.GA17593@hmswarspite.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Tue, Apr 2, 2019 at 7:32 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Apr 01, 2019 at 10:50:03AM -0400, Paul Moore wrote:
> > On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Audit events could happen in a network namespace outside of a task
> > > context due to packets received from the net that trigger an auditing
> > > rule prior to being associated with a running task.  The network
> > > namespace could be in use by multiple containers by association to the
> > > tasks in that network namespace.  We still want a way to attribute
> > > these events to any potential containers.  Keep a list per network
> > > namespace to track these audit container identifiiers.
> > >
> > > Add/increment the audit container identifier on:
> > > - initial setting of the audit container identifier via /proc
> > > - clone/fork call that inherits an audit container identifier
> > > - unshare call that inherits an audit container identifier
> > > - setns call that inherits an audit container identifier
> > > Delete/decrement the audit container identifier on:
> > > - an inherited audit container identifier dropped when child set
> > > - process exit
> > > - unshare call that drops a net namespace
> > > - setns call that drops a net namespace
> > >
> > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h | 19 ++++++++++++
> > >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  kernel/nsproxy.c      |  4 +++
> > >  3 files changed, 106 insertions(+), 3 deletions(-)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index cf448599ef34..7fa3194f5342 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -72,6 +72,7 @@
> > >  #include <linux/freezer.h>
> > >  #include <linux/pid_namespace.h>
> > >  #include <net/netns/generic.h>
> > > +#include <net/net_namespace.h>
> > >
> > >  #include "audit.h"
> > >
> > > @@ -99,9 +100,13 @@
> > >  /**
> > >   * struct audit_net - audit private network namespace data
> > >   * @sk: communication socket
> > > + * @contid_list: audit container identifier list
> > > + * @contid_list_lock audit container identifier list lock
> > >   */
> > >  struct audit_net {
> > >         struct sock *sk;
> > > +       struct list_head contid_list;
> > > +       spinlock_t contid_list_lock;
> > >  };
> > >
> > >  /**
> > > @@ -275,8 +280,11 @@ struct audit_task_info init_struct_audit = {
> > >  void audit_free(struct task_struct *tsk)
> > >  {
> > >         struct audit_task_info *info = tsk->audit;
> > > +       struct nsproxy *ns = tsk->nsproxy;
> > >
> > >         audit_free_syscall(tsk);
> > > +       if (ns)
> > > +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
> > >         /* Freeing the audit_task_info struct must be performed after
> > >          * audit_log_exit() due to need for loginuid and sessionid.
> > >          */
> > > @@ -376,6 +384,73 @@ static struct sock *audit_get_sk(const struct net *net)
> > >         return aunet->sk;
> > >  }
> > >
> > > +void audit_netns_contid_add(struct net *net, u64 contid)
> > > +{
> > > +       struct audit_net *aunet = net_generic(net, audit_net_id);
> > > +       struct list_head *contid_list = &aunet->contid_list;
> > > +       struct audit_contid *cont;
> > > +
> > > +       if (!audit_contid_valid(contid))
> > > +               return;
> > > +       if (!aunet)
> > > +               return;
> >
> > We should move the contid_list assignment below this check, or decide
> > that aunet is always going to valid (?) and get rid of this check
> > completely.
> >
> I'm not sure why that would be needed.  Finding the net_id list is an operation
> of a map relating net namespaces to lists, not contids to lists.  We could do
> it, sure, but since they're unrelated operations, I don't think we experience
> any slowdowns from doing it this way.

In the first line of the function, when aunet is declared, it is also
assigned a value using net_generic():

  struct audit_net *aunet = net_generic(net, audit_net_id);

Later in the function there is check to see if aunet is NULL, yet on
the second line of the function (before the NULL check), there is this
line of code:

  struct list_head *contid_list = &aunet->contid_list;

... which could result in the dereference of a NULL pointer if aunet
is NULL.  My suggestion was either to move this assignment below the
aunet-NULL check or decide that aunet was always going to be valid
(e.g. non-NULL) and do away with the aunet-NULL check completely.
Richard has since replied that the aunet-NULL check has been
demonstrated to be necessary so the proper thing to do would be to
move the assignment.  I believe that is what Richard is planning on
doing.

> > > +       if (cont) {
> > > +               INIT_LIST_HEAD(&cont->list);
> >
> > Unless there is some guidance that INIT_LIST_HEAD() should be used
> > regardless, you shouldn't need to call this here since list_add_rcu()
> > will take care of any list.h related initialization.
>
> There is a corner case that needs it.  list_add_rcu has a check that gets
> called, __list_add_valid.  Its a noop in the regular case, but if
> CONFIG_DEBUG_LIST is defined, its a check to ensure that the next and prev
> pointers getting passed in aren't set to detectable corrupt values.  If we pass
> in garbage, we can get transient false positives on that check, so we need to
> set the list pointers to known good values before hand, either by using kzalloc,
> or INIT_LIST_HEAD, as has been done here.  Given that we expressly set every
> field of this structure, I think this is the right approach, as it uses the list
> macro to expressly set the list values to their proper state.

Good to know, thanks.

-- 
paul moore
www.paul-moore.com
