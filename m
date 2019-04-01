From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V5 06/10] audit: add support for non-syscall
 auxiliary records
Date: Mon, 1 Apr 2019 14:57:39 -0400
Message-ID: <CAHC9VhTL=zSQ2tO440w+vvX3TPsGtwqL6dWwUHVe0WnHVKqVpA@mail.gmail.com>
References: <cover.1552665316.git.rgb@redhat.com> <700e4313571f86cc0cdcb7310fbe060f02c7c2db.1552665316.git.rgb@redhat.com>
 <CAHC9VhRWUvG6DwiPn4o+vt=fgGfY+JmG8m78M8CeyGYxF2yRXQ@mail.gmail.com> <20190401174432.fjnvotpvdrfujoy7@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190401174432.fjnvotpvdrfujoy7@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 1:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-04-01 10:49, Paul Moore wrote:
> > On Fri, Mar 15, 2019 at 2:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Standalone audit records have the timestamp and serial number generated
> > > on the fly and as such are unique, making them standalone.  This new
> > > function audit_alloc_local() generates a local audit context that will
> > > be used only for a standalone record and its auxiliary record(s).  The
> > > context is discarded immediately after the local associated records are
> > > produced.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > ---
> > >  include/linux/audit.h |  8 ++++++++
> > >  kernel/audit.h        |  1 +
> > >  kernel/auditsc.c      | 35 ++++++++++++++++++++++++++++++-----
> > >  3 files changed, 39 insertions(+), 5 deletions(-)
> >
> > ...
> >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index ebd6625ca80e..6db5aba7cc01 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -285,6 +285,8 @@ static inline void audit_log_contid(struct audit_context *context, u64 contid)
> > >
> > >  /* These are defined in auditsc.c */
> > >                                 /* Public API */
> > > +extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
> > > +extern void audit_free_context(struct audit_context *context);
> > >  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
> > >                                   unsigned long a2, unsigned long a3);
> > >  extern void __audit_syscall_exit(int ret_success, long ret_value);
> > > @@ -512,6 +514,12 @@ static inline void audit_fanotify(unsigned int response)
> > >  extern int audit_n_rules;
> > >  extern int audit_signals;
> > >  #else /* CONFIG_AUDITSYSCALL */
> > > +static inline struct audit_context *audit_alloc_local(gfp_t gfpflags)
> > > +{
> > > +       return NULL;
> > > +}
> > > +static inline void audit_free_context(struct audit_context *context)
> > > +{ }
> > >  static inline void audit_syscall_entry(int major, unsigned long a0,
> > >                                        unsigned long a1, unsigned long a2,
> > >                                        unsigned long a3)
> > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > index c5ac6436317e..2a1a8b8a8019 100644
> > > --- a/kernel/audit.h
> > > +++ b/kernel/audit.h
> > > @@ -111,6 +111,7 @@ struct audit_proctitle {
> > >  struct audit_context {
> > >         int                 dummy;      /* must be the first element */
> > >         int                 in_syscall; /* 1 if task is in a syscall */
> > > +       bool                local;      /* local context needed */
> >
> > It's very possible I've missed it, but "local" never gets used in any
> > meaningful way in this patchset does it?
>
> It is used in audit_alloc_local() to signal to audit_get_stamp() that in
> absence of a syscall flag, check for a local flag to continue rather
> than return.

I'm guessing you meant auditsc_get_stamp()?  If so, okay.

-- 
paul moore
www.paul-moore.com
