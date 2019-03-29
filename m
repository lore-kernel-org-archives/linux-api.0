From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Date: Fri, 29 Mar 2019 10:49:27 -0400
Message-ID: <20190328112100.GA11558@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAFqZXNskwTub5Bm_HZqr02VPB4s79CcgAVX8VE2vQYP07-qssg@mail.gmail.com>
 <20190328011202.6raixwzdimn5b4zk@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190328011202.6raixwzdimn5b4zk@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, Simo Sorce <simo@redhat.com>, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 09:12:02PM -0400, Richard Guy Briggs wrote:
> On 2019-03-27 23:42, Ondrej Mosnacek wrote:
> > On Fri, Mar 15, 2019 at 7:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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
> > >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index fa19fa408931..70255c2dfb9f 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -27,6 +27,7 @@
> > >  #include <linux/ptrace.h>
> > >  #include <linux/namei.h>  /* LOOKUP_* */
> > >  #include <uapi/linux/audit.h>
> > > +#include <linux/refcount.h>
> > >
> > >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> > >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > > @@ -99,6 +100,13 @@ struct audit_task_info {
> > >
> > >  extern struct audit_task_info init_struct_audit;
> > >
> > > +struct audit_contid {
> > > +       struct list_head        list;
> > > +       u64                     id;
> > > +       refcount_t              refcount;
> > 
> > Hm, since we only ever touch the refcount under a spinlock, I wonder
> > if we could just make it a regular unsigned int (we don't need the
> > atomicity guarantees). OTOH, refcount_t comes with some extra overflow
> > checking, so it's probably better to leave it as is...
> 
> Since the update is done using rcu-safe methods, do we even need the
> spin_lock?  Neil?  Paul?
> 
Yes, we do.  Rcu-safe methods only apply to read side operations, we still need
traditional mutual exclusion on the write side of the operation.  That is to say
we need to protect the list against multiple writers at the same time, and for
that we need a spin lock.

Neil
