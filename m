From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 02/10] audit: log container
 info of syscalls
Date: Mon, 23 Jul 2018 09:16:25 -0400
Message-ID: <CAHC9VhSUhSDaXzD9fpxm-oK=U4MieekKwY-pypzT=RA1HBw6+Q@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <b839dc7fb29aae226b2a4602e7ef3c2a406ee90a.1528304203.git.rgb@redhat.com>
 <CAHC9VhS0-4XSEFFPLrOvAiSYv-XDLG-yGyB4ULRGz=AnwE6diQ@mail.gmail.com> <20180721202930.a7rypxc5rxi3hyiv@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180721202930.a7rypxc5rxi3hyiv@madcap2.tricolour.ca>
Sender: netdev-owner@vger.kernel.org
To: rgb@redhat.com
Cc: sgrubb@redhat.com, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Sat, Jul 21, 2018 at 4:32 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-07-20 18:13, Paul Moore wrote:
> > On Wed, Jun 6, 2018 at 1:00 PM Richard Guy Briggs <rgb@redhat.com> wrot=
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
> > > ---
> > >  include/linux/audit.h      |  7 +++++++
> > >  include/uapi/linux/audit.h |  1 +
> > >  kernel/audit.c             | 23 +++++++++++++++++++++++
> > >  kernel/auditsc.c           |  3 +++
> > >  4 files changed, 34 insertions(+)
> >
> > ...
> >
> > > --- a/include/uapi/linux/audit.h
> > > +++ b/include/uapi/linux/audit.h
> > > @@ -115,6 +115,7 @@
> > >  #define AUDIT_REPLACE          1329    /* Replace auditd if this pac=
ket unanswerd */
> > >  #define AUDIT_KERN_MODULE      1330    /* Kernel Module events */
> > >  #define AUDIT_FANOTIFY         1331    /* Fanotify access decision *=
/
> > > +#define AUDIT_CONTAINER                1332    /* Container ID */
> >
> > I'm not sure I'm completely sold on the AUDIT_CONTAINER_ID and
> > AUDIT_CONTAINER record type names.  From what I can tell
> > AUDIT_CONTAINER_ID seems to be used for audit container ID management
> > operations, e.g. setting the ID, whereas the AUDIT_CONTAINER is used
> > to tag events with the corresponding audit container ID.  Assuming
> > that is correct, it seems like AUDIT_CONTAINER might be better served
> > if it was named AUDIT_CONTAINER_ID and if we could change
> > AUDIT_CONTAINER_ID to AUDIT_CONTAINER_OP/MGMT/etc.  Thoughts?
>
> Please see discussion at:
>         https://www.redhat.com/archives/linux-audit/2018-May/msg00101.htm=
l
>
> I'm fine with changing AUDIT_CONTAINER_ID to AUDIT_CONTAINER_OP/MGMT/etc.

Noted, and while I'm generally a big fan of consistency for things
like this, I think these things are different enough (the loginuid is
recorded as a field, the audit container ID is recorded in a dedicated
record) that we don't need to be bound by LOGINUID's naming
convention.

> > >  #define AUDIT_AVC              1400    /* SE Linux avc denial or gra=
nt */
> > >  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors *=
/
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index e7478cb..5e150c6 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -2048,6 +2048,29 @@ void audit_log_session_info(struct audit_buffe=
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
> >
> > Can you explain your reason for including an "op" field in this record
> > type?  I've been looking at the rest of the patches in this patchset
> > and it seems to be used more as an indicator of the record's
> > generating context rather than any sort of audit container ID
> > operation.
>
> "action" might work, but that's netfilter and numeric... "kind"?
> Nothing else really seems to fit from a field name, type or lack of
> searchability perspective.

My concern isn't so much the name of the "op" field, although that
does seem wrong, but rather the existence of the field in the first
place.  This audit container ID record (whatever we end up calling it)
exists to attach an audit container ID to an audit event, that's it;
an audit event should have other records which provide the context
(granted, the exact number of records depends on the event and the
system's configuration).  If we are relying on this record to provide
critical information about the audit event other than the audit
container ID, I believe this is a strong indicator that the existing
audit records are lacking and should be augmented.

--=20
paul moore
www.paul-moore.com
