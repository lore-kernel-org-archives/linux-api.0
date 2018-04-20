From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH ghak32 V2 06/13] audit: add support for non-syscall
	auxiliary records
Date: Thu, 19 Apr 2018 21:23:46 -0400
Message-ID: <20180420012346.udnga5pfdjoazcfc@madcap2.tricolour.ca>
References: <cover.1521179281.git.rgb@redhat.com>
	<ee2a945fb09a939b3c214f45e49dab6a770d83e6.1521179281.git.rgb@redhat.com>
	<CAHC9VhQbPbnrbxCD1fyTSxWgrXXXYnZw_=nbOhfMCO5Q5eSsWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQbPbnrbxCD1fyTSxWgrXXXYnZw_=nbOhfMCO5Q5eSsWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2018-04-18 20:39, Paul Moore wrote:
> On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Standalone audit records have the timestamp and serial number generated
> > on the fly and as such are unique, making them standalone.  This new
> > function audit_alloc_local() generates a local audit context that will
> > be used only for a standalone record and its auxiliary record(s).  The
> > context is discarded immediately after the local associated records are
> > produced.
> >
> > Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/linux/audit.h |  8 ++++++++
> >  kernel/auditsc.c      | 20 +++++++++++++++++++-
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index ed16bb6..c0b83cb 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -227,7 +227,9 @@ static inline int audit_log_container_info(struct audit_context *context,
> >  /* These are defined in auditsc.c */
> >                                 /* Public API */
> >  extern int  audit_alloc(struct task_struct *task);
> > +extern struct audit_context *audit_alloc_local(void);
> >  extern void __audit_free(struct task_struct *task);
> > +extern void audit_free_context(struct audit_context *context);
> >  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
> >                                   unsigned long a2, unsigned long a3);
> >  extern void __audit_syscall_exit(int ret_success, long ret_value);
> > @@ -472,6 +474,12 @@ static inline int audit_alloc(struct task_struct *task)
> >  {
> >         return 0;
> >  }
> > +static inline struct audit_context *audit_alloc_local(void)
> > +{
> > +       return NULL;
> > +}
> > +static inline void audit_free_context(struct audit_context *context)
> > +{ }
> >  static inline void audit_free(struct task_struct *task)
> >  { }
> >  static inline void audit_syscall_entry(int major, unsigned long a0,
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 2932ef1..7103d23 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -959,8 +959,26 @@ int audit_alloc(struct task_struct *tsk)
> >         return 0;
> >  }
> >
> > -static inline void audit_free_context(struct audit_context *context)
> > +struct audit_context *audit_alloc_local(void)
> >  {
> > +       struct audit_context *context;
> > +
> > +       if (!audit_ever_enabled)
> > +               return NULL; /* Return if not auditing. */
> > +
> > +       context = audit_alloc_context(AUDIT_RECORD_CONTEXT);
> > +       if (!context)
> > +               return NULL;
> > +       context->serial = audit_serial();
> > +       context->ctime = current_kernel_time64();
> > +       context->in_syscall = 1;
> > +       return context;
> > +}
> > +
> > +inline void audit_free_context(struct audit_context *context)
> > +{
> > +       if (!context)
> > +               return;
> >         audit_free_names(context);
> >         unroll_tree_refs(context, NULL, 0);
> >         free_tree_refs(context);
> 
> I'm reserving the option to comment on this idea further as I make my
> way through the patchset, but audit_free_context() definitely
> shouldn't be declared as an inline function.

Ok, I think I follow.  When it wasn't exported, inline was fine, but now
that it has been exported, it should no longer be inlined, or should use
an intermediate function name to export so that local uses of it can
remain inline.

> paul moore

- RGB

--
Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
