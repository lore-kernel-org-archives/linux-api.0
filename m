From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 03/10] audit: log container info of syscalls
Date: Wed, 24 Oct 2018 16:55:38 -0400
Message-ID: <CAHC9VhRF1vsxM-k0Lw-9NqS9b9rgXRRBu0tq4ajdFpMqUxiH4A@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <34017c395d03a213d6b0d49b9964429bd32b283d.1533065887.git.rgb@redhat.com>
 <CAHC9VhSv4hWGHiaaOfuBrRQKdp2YG5RtqXQbFXg7j7LNEhO2XQ@mail.gmail.com> <20181024151439.lavhanabsyxdrdvo@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181024151439.lavhanabsyxdrdvo@madcap2.tricolour.ca>
Sender: netdev-owner@vger.kernel.org
To: rgb@redhat.com
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 24, 2018 at 11:15 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-10-19 19:16, Paul Moore wrote:
> > On Sun, Aug 5, 2018 at 4:32 AM Richard Guy Briggs <rgb@redhat.com> wrot=
e:
> > > Create a new audit record AUDIT_CONTAINER to document the audit
> > > container identifier of a process if it is present.
> > >
> > > Called from audit_log_exit(), syscalls are covered.
> > >
> > > A sample raw event:
> > > type=3DSYSCALL msg=3Daudit(1519924845.499:257): arch=3Dc000003e sysca=
ll=3D257 success=3Dyes exit=3D3 a0=3Dffffff9c a1=3D56374e1cef30 a2=3D241 a3=
=3D1b6 items=3D2 ppid=3D606 pid=3D635 auid=3D0 uid=3D0 gid=3D0 euid=3D0 sui=
d=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D3 comm=3D"bash=
" exe=3D"/usr/bin/bash" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0=
:c0.c1023 key=3D"tmpcontainerid"
> > > type=3DCWD msg=3Daudit(1519924845.499:257): cwd=3D"/root"
> > > type=3DPATH msg=3Daudit(1519924845.499:257): item=3D0 name=3D"/tmp/" =
inode=3D13863 dev=3D00:27 mode=3D041777 ouid=3D0 ogid=3D0 rdev=3D00:00 obj=
=3Dsystem_u:object_r:tmp_t:s0 nametype=3D PARENT cap_fp=3D0000000000000000 =
cap_fi=3D0000000000000000 cap_fe=3D0 cap_fver=3D0
> > > type=3DPATH msg=3Daudit(1519924845.499:257): item=3D1 name=3D"/tmp/tm=
pcontainerid" inode=3D17729 dev=3D00:27 mode=3D0100644 ouid=3D0 ogid=3D0 rd=
ev=3D00:00 obj=3Dunconfined_u:object_r:user_tmp_t:s0 nametype=3DCREATE cap_=
fp=3D0000000000000000 cap_fi=3D0000000000000000 cap_fe=3D0 cap_fver=3D0
> > > type=3DPROCTITLE msg=3Daudit(1519924845.499:257): proctitle=3D6261736=
8002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E74=
61696E65726964
> > > type=3DCONTAINER msg=3Daudit(1519924845.499:257): op=3Dtask contid=3D=
123458
> > >
> > > See: https://github.com/linux-audit/audit-kernel/issues/90
> > > See: https://github.com/linux-audit/audit-userspace/issues/51
> > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Conta=
iner-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > Acked-by: Steve Grubb <sgrubb@redhat.com>
> > > ---
> > >  include/linux/audit.h      |  7 +++++++
> > >  include/uapi/linux/audit.h |  1 +
> > >  kernel/audit.c             | 24 ++++++++++++++++++++++++
> > >  kernel/auditsc.c           |  3 +++
> > >  4 files changed, 35 insertions(+)
> >
> > ...
> >
> > > @@ -2045,6 +2045,30 @@ void audit_log_session_info(struct audit_buffe=
r *ab)
> > >         audit_log_format(ab, " auid=3D%u ses=3D%u", auid, sessionid);
> > >  }
> > >
> > > +/*
> > > + * audit_log_contid - report container info
> > > + * @tsk: task to be recorded
> > > + * @context: task or local context for record
> > > + * @op: contid string description
> > > + */
> > > +int audit_log_contid(struct task_struct *tsk,
> > > +                            struct audit_context *context, char *op)
> > > +{
> > > +       struct audit_buffer *ab;
> > > +
> > > +       if (!audit_contid_set(tsk))
> > > +               return 0;
> > > +       /* Generate AUDIT_CONTAINER record with container ID */
> > > +       ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
> > > +       if (!ab)
> > > +               return -ENOMEM;
> > > +       audit_log_format(ab, "op=3D%s contid=3D%llu",
> > > +                        op, audit_get_contid(tsk));
> > > +       audit_log_end(ab);
> > > +       return 0;
> > > +}
> > > +EXPORT_SYMBOL(audit_log_contid);
> >
> > As discussed in the previous iteration of the patch, I prefer
> > AUDIT_CONTAINER_ID here over AUDIT_CONTAINER.  If you feel strongly
> > about keeping it as-is with AUDIT_CONTAINER I suppose I could live
> > with that, but it is isn't my first choice.
>
> I don't have a strong opinion on this one, mildly preferring the shorter
> one only because it is shorter.

We already have multiple AUDIT_CONTAINER* record types, so it seems as
though we should use "AUDIT_CONTAINER" as a prefix of sorts, rather
than a type itself.

> > However, I do care about the "op" field in this record.  It just
> > doesn't make any sense; the way you are using it it is more of a
> > context field than an operations field, and even then why is the
> > context important from a logging and/or security perspective?  Drop it
> > please.
>
> I'll rename it to whatever you like.  I'd suggest "ref=3D".  The reason I
> think it is important is there are multiple sources that aren't always
> obvious from the other records to which it is associated.  In the case
> of ptrace and signals, there can be many target tasks listed (OBJ_PID)
> with no other way to distinguish the matching audit container identifier
> records all for one event.  This is in addition to the default syscall
> container identifier record.  I'm not currently happy with the text
> content to link the two, but that should be solvable (most obvious is
> taret PID).  Throwing away this information seems shortsighted.

It would be helpful if you could generate real audit events
demonstrating the problems you are describing, as well as a more
standard syscall event, so we can discuss some possible solutions.

--=20
paul moore
www.paul-moore.com
