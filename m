From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V8 16/16] audit: add capcontid to set contid
 outside init_user_ns
Date: Wed, 5 Feb 2020 17:56:48 -0500
Message-ID: <CAHC9VhSsfBbfYmqLoR=QBgF5_VwbA8Dqqz97MjqwwJ6Jq6fHwA@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <5941671b6b6b5de28ab2cc80e72f288cf83291d5.1577736799.git.rgb@redhat.com>
 <CAHC9VhQYXQp+C0EHwLuW50yUenfH4KF1xKQdS=bn_OzHfnFmmg@mail.gmail.com> <20200205003930.2efpm4tvrisgmj4t@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200205003930.2efpm4tvrisgmj4t@madcap2.tricolour.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, Feb 4, 2020 at 7:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:29, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > process in a non-init user namespace the capability to set audit
> > > container identifiers.
> > >
> > > Provide /proc/$PID/audit_capcontid interface to capcontid.
> > > Valid values are: 1==enabled, 0==disabled
> >
> > It would be good to be more explicit about "enabled" and "disabled" in
> > the commit description.  For example, which setting allows the target
> > task to set audit container IDs of it's children processes?
>
> Ok...
>
> > > Report this action in message type AUDIT_SET_CAPCONTID 1022 with fields
> > > opid= capcontid= old-capcontid=
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  fs/proc/base.c             | 55 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/audit.h      | 14 ++++++++++++
> > >  include/uapi/linux/audit.h |  1 +
> > >  kernel/audit.c             | 35 +++++++++++++++++++++++++++++
> > >  4 files changed, 105 insertions(+)

...

> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 1287f0b63757..1c22dd084ae8 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -2698,6 +2698,41 @@ static bool audit_contid_isowner(struct task_struct *tsk)
> > >         return false;
> > >  }
> > >
> > > +int audit_set_capcontid(struct task_struct *task, u32 enable)
> > > +{
> > > +       u32 oldcapcontid;
> > > +       int rc = 0;
> > > +       struct audit_buffer *ab;
> > > +
> > > +       if (!task->audit)
> > > +               return -ENOPROTOOPT;
> > > +       oldcapcontid = audit_get_capcontid(task);
> > > +       /* if task is not descendant, block */
> > > +       if (task == current)
> > > +               rc = -EBADSLT;
> > > +       else if (!task_is_descendant(current, task))
> > > +               rc = -EXDEV;
> >
> > See my previous comments about error code sanity.
>
> I'll go with EXDEV.
>
> > > +       else if (current_user_ns() == &init_user_ns) {
> > > +               if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> > > +                       rc = -EPERM;
> >
> > I think we just want to use ns_capable() in the context of the current
> > userns to check CAP_AUDIT_CONTROL, yes?  Something like this ...
>
> I thought we had firmly established in previous discussion that
> CAP_AUDIT_CONTROL in anything other than init_user_ns was completely irrelevant
> and untrustable.

In the case of a container with multiple users, and multiple
applications, one being a nested orchestrator, it seems relevant to
allow that container to control which of it's processes are able to
exercise CAP_AUDIT_CONTROL.  Granted, we still want to control it
within the overall host, e.g. the container in question must be
allowed to run a nested orchestrator, but allowing the container
itself to provide it's own granularity seems like the right thing to
do.

> >   if (current_user_ns() != &init_user_ns) {
> >     if (!ns_capable(CAP_AUDIT_CONTROL) || !audit_get_capcontid())
> >       rc = -EPERM;
> >   } else if (!capable(CAP_AUDIT_CONTROL))
> >     rc = -EPERM;
> >

-- 
paul moore
www.paul-moore.com
