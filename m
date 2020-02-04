From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ghak90 V8 05/16] audit: log drop of contid on exit of
 last task
Date: Tue, 4 Feb 2020 18:02:35 -0500
Message-ID: <20200204230235.dwunh76dum4kkssp@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <b3725abab452beaba740ac58f76144e6c3bda2fa.1577736799.git.rgb@redhat.com>
 <CAHC9VhQ=+4P6Rr1S1-sNb2X-CbYYKMQMJDGP=bBr8GG3xLD8qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ=+4P6Rr1S1-sNb2X-CbYYKMQMJDGP=bBr8GG3xLD8qQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, omosnace-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Dan Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2020-01-22 16:28, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Since we are tracking the life of each audit container indentifier, we
> > can match the creation event with the destruction event.  Log the
> > destruction of the audit container identifier when the last process in
> > that container exits.
> >
> > Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  kernel/audit.c   | 17 +++++++++++++++++
> >  kernel/audit.h   |  2 ++
> >  kernel/auditsc.c |  2 ++
> >  3 files changed, 21 insertions(+)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 4bab20f5f781..fa8f1aa3a605 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2502,6 +2502,23 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >         return rc;
> >  }
> >
> > +void audit_log_container_drop(void)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (!current->audit || !current->audit->cont ||
> > +           refcount_read(&current->audit->cont->refcount) > 1)
> > +               return;
> > +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> > +       if (!ab)
> > +               return;
> > +
> > +       audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=%llu",
> > +                        task_tgid_nr(current), audit_get_contid(current),
> > +                        audit_get_contid(current));
> > +       audit_log_end(ab);
> > +}
> 
> Assumine we are careful about where we call it in audit_free(...), you
> are confident we can't do this as part of _audit_contobj_put(...),
> yes?

We need audit_log_container_drop in audit_free_syscall() due to needing
context, which gets freed in audit_free_syscall() called from
audit_free().

We need audit_log_container_drop in audit_log_exit() due to having that
record included before the EOE record at the end of audit_log_exit().

We could put in _contobj_put() if we drop context and any attempt to
connect it with a syscall record, which I strongly discourage.

The syscall record contains info about subject, container_id record only
contains info about container object other than subj pid.

> >  /**
> >   * audit_log_end - end one audit record
> >   * @ab: the audit_buffer
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index e4a31aa92dfe..162de8366b32 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -255,6 +255,8 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
> >  extern struct tty_struct *audit_get_tty(void);
> >  extern void audit_put_tty(struct tty_struct *tty);
> >
> > +extern void audit_log_container_drop(void);
> > +
> >  /* audit watch/mark/tree functions */
> >  #ifdef CONFIG_AUDITSYSCALL
> >  extern unsigned int audit_serial(void);
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 0e2d50533959..bd855794ad26 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1568,6 +1568,8 @@ static void audit_log_exit(void)
> >
> >         audit_log_proctitle();
> >
> > +       audit_log_container_drop();
> > +
> >         /* Send end of event record to help user space know we are finished */
> >         ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
> >         if (ab)
> > --
> > 1.8.3.1
> >
> 
> --
> paul moore
> www.paul-moore.com
> 

- RGB
