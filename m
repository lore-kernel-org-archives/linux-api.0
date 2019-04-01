From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V5 06/10] audit: add support for non-syscall
	auxiliary records
Date: Mon, 1 Apr 2019 16:43:02 -0400
Message-ID: <20190401204302.bgykrqirgnw6xz37@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
	<700e4313571f86cc0cdcb7310fbe060f02c7c2db.1552665316.git.rgb@redhat.com>
	<CAHC9VhRWUvG6DwiPn4o+vt=fgGfY+JmG8m78M8CeyGYxF2yRXQ@mail.gmail.com>
	<20190401174432.fjnvotpvdrfujoy7@madcap2.tricolour.ca>
	<CAHC9VhTL=zSQ2tO440w+vvX3TPsGtwqL6dWwUHVe0WnHVKqVpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhTL=zSQ2tO440w+vvX3TPsGtwqL6dWwUHVe0WnHVKqVpA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>
Cc: nhorman@tuxdriver.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 2019-04-01 14:57, Paul Moore wrote:
> On Mon, Apr 1, 2019 at 1:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2019-04-01 10:49, Paul Moore wrote:
> > > On Fri, Mar 15, 2019 at 2:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Standalone audit records have the timestamp and serial number generated
> > > > on the fly and as such are unique, making them standalone.  This new
> > > > function audit_alloc_local() generates a local audit context that will
> > > > be used only for a standalone record and its auxiliary record(s).  The
> > > > context is discarded immediately after the local associated records are
> > > > produced.
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > > ---
> > > >  include/linux/audit.h |  8 ++++++++
> > > >  kernel/audit.h        |  1 +
> > > >  kernel/auditsc.c      | 35 ++++++++++++++++++++++++++++++-----
> > > >  3 files changed, 39 insertions(+), 5 deletions(-)
> > >
> > > ...
> > >
> > > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > > index ebd6625ca80e..6db5aba7cc01 100644
> > > > --- a/include/linux/audit.h
> > > > +++ b/include/linux/audit.h
> > > > @@ -285,6 +285,8 @@ static inline void audit_log_contid(struct audit_context *context, u64 contid)
> > > >
> > > >  /* These are defined in auditsc.c */
> > > >                                 /* Public API */
> > > > +extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
> > > > +extern void audit_free_context(struct audit_context *context);
> > > >  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
> > > >                                   unsigned long a2, unsigned long a3);
> > > >  extern void __audit_syscall_exit(int ret_success, long ret_value);
> > > > @@ -512,6 +514,12 @@ static inline void audit_fanotify(unsigned int response)
> > > >  extern int audit_n_rules;
> > > >  extern int audit_signals;
> > > >  #else /* CONFIG_AUDITSYSCALL */
> > > > +static inline struct audit_context *audit_alloc_local(gfp_t gfpflags)
> > > > +{
> > > > +       return NULL;
> > > > +}
> > > > +static inline void audit_free_context(struct audit_context *context)
> > > > +{ }
> > > >  static inline void audit_syscall_entry(int major, unsigned long a0,
> > > >                                        unsigned long a1, unsigned long a2,
> > > >                                        unsigned long a3)
> > > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > > index c5ac6436317e..2a1a8b8a8019 100644
> > > > --- a/kernel/audit.h
> > > > +++ b/kernel/audit.h
> > > > @@ -111,6 +111,7 @@ struct audit_proctitle {
> > > >  struct audit_context {
> > > >         int                 dummy;      /* must be the first element */
> > > >         int                 in_syscall; /* 1 if task is in a syscall */
> > > > +       bool                local;      /* local context needed */
> > >
> > > It's very possible I've missed it, but "local" never gets used in any
> > > meaningful way in this patchset does it?
> >
> > It is used in audit_alloc_local() to signal to audit_get_stamp() that in
> > absence of a syscall flag, check for a local flag to continue rather
> > than return.
> 
> I'm guessing you meant auditsc_get_stamp()?  If so, okay.

Yes.  (I thought I remembered typing "auditsc...".)

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
