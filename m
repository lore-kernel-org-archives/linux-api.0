From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V8 11/16] audit: add support for containerid to
 network namespaces
Date: Wed, 5 Feb 2020 17:51:30 -0500
Message-ID: <CAHC9VhT0NELsrEeTmX15GaZ1SE-qZiQmz9-WweRGWRPcGN5EmA@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <2954ed671a7622ddf3abdb8854dbba2ad13e9f33.1577736799.git.rgb@redhat.com>
 <CAHC9VhRw3Fj9-hi+Vj8JJb_GXM4B9N5hRXa9H6aQkuuFqJJ15w@mail.gmail.com> <20200204234258.uwaqk3s3c42fxews@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20200204234258.uwaqk3s3c42fxews@madcap2.tricolour.ca>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, Feb 4, 2020 at 6:43 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:28, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > This also adds support to qualify NETFILTER_PKT records.
> > >
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
> > > Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> > > event standalone records.  Iterate through all potential audit container
> > > identifiers associated with a network namespace.
> > >
> > > Please see the github audit kernel issue for contid net support:
> > >   https://github.com/linux-audit/audit-kernel/issues/92
> > > Please see the github audit testsuiite issue for the test case:
> > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > Please see the github audit wiki for the feature overview:
> > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >  include/linux/audit.h    |  24 +++++++++
> > >  kernel/audit.c           | 132 ++++++++++++++++++++++++++++++++++++++++++++++-
> > >  kernel/nsproxy.c         |   4 ++
> > >  net/netfilter/nft_log.c  |  11 +++-
> > >  net/netfilter/xt_AUDIT.c |  11 +++-
> > >  5 files changed, 176 insertions(+), 6 deletions(-)
> >
> > ...
> >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index 5531d37a4226..ed8d5b74758d 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/ptrace.h>
> > >  #include <uapi/linux/audit.h>
> > > +#include <linux/refcount.h>
> > >
> > >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> > >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > > @@ -121,6 +122,13 @@ struct audit_task_info {
> > >
> > >  extern struct audit_task_info init_struct_audit;
> > >
> > > +struct audit_contobj_netns {
> > > +       struct list_head        list;
> > > +       u64                     id;
> >
> > Since we now track audit container IDs in their own structure, why not
> > link directly to the audit container ID object (and bump the
> > refcount)?
>
> Ok, I've done this but at first I had doubts about the complexity.

Yes, it will be more complex, but it should be much safer.

-- 
paul moore
www.paul-moore.com
