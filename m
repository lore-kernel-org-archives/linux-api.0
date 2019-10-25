From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 05/21] audit: log drop of contid on exit of
 last task
Date: Fri, 25 Oct 2019 15:43:56 -0400
Message-ID: <20191025194356.skqebldthpokwd2m@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <71b75f54342f32f176c2b6d94584f2a666964e68.1568834524.git.rgb@redhat.com>
 <CAHC9VhQYVzGKRx48dgX1j3CJOe1N0widkhWb=_-3ohnOdZHhUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhQYVzGKRx48dgX1j3CJOe1N0widkhWb=_-3ohnOdZHhUw@mail.gmail.com>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2019-10-10 20:38, Paul Moore wrote:
> On Wed, Sep 18, 2019 at 9:24 PM Richard Guy Briggs <rgb@redhat.com> wrote=
:
> > Since we are tracking the life of each audit container indentifier, we
> > can match the creation event with the destruction event.  Log the
> > destruction of the audit container identifier when the last process in
> > that container exits.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c   | 32 ++++++++++++++++++++++++++++++++
> >  kernel/audit.h   |  2 ++
> >  kernel/auditsc.c |  2 ++
> >  3 files changed, 36 insertions(+)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index ea0899130cc1..53d13d638c63 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2503,6 +2503,38 @@ int audit_set_contid(struct task_struct *task, u=
64 contid)
> >         return rc;
> >  }
> >
> > +void audit_log_container_drop(void)
> > +{
> > +       struct audit_buffer *ab;
> > +       uid_t uid;
> > +       struct tty_struct *tty;
> > +       char comm[sizeof(current->comm)];
> > +
> > +       if (!current->audit || !current->audit->cont ||
> > +           refcount_read(&current->audit->cont->refcount) > 1)
> > +               return;
> > +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTA=
INER_OP);
> > +       if (!ab)
> > +               return;
> > +
> > +       uid =3D from_kuid(&init_user_ns, task_uid(current));
> > +       tty =3D audit_get_tty();
> > +       audit_log_format(ab,
> > +                        "op=3Ddrop opid=3D%d contid=3D%llu old-contid=
=3D%llu pid=3D%d uid=3D%u auid=3D%u tty=3D%s ses=3D%u",
> > +                        task_tgid_nr(current), audit_get_contid(curren=
t),
> > +                        audit_get_contid(current), task_tgid_nr(curren=
t), uid,
> > +                        from_kuid(&init_user_ns, audit_get_loginuid(cu=
rrent)),
> > +                        tty ? tty_name(tty) : "(none)",
> > +                                audit_get_sessionid(current));
> > +       audit_put_tty(tty);
> > +       audit_log_task_context(ab);
> > +       audit_log_format(ab, " comm=3D");
> > +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > +       audit_log_d_path_exe(ab, current->mm);
> > +       audit_log_format(ab, " res=3D1");
> > +       audit_log_end(ab);
> > +}
>=20
> Why can't we just do this in audit_cont_put()?  Is it because we call
> audit_cont_put() in the new audit_free() function?  What if we were to
> do it in __audit_free()/audit_free_syscall()?

The intent was to put this before the EOE record of a syscall so we
could fill out all the fields similarly to op=3Dset, but this could stand
alone dropping or nulling a bunch of fields.

It would also never get printed if we left it before the EOE and had the
audit signal info record keep a reference to it.

Hmmm...

> paul moore

- RGB
