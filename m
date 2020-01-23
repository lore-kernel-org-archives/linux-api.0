From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Date: Thu, 23 Jan 2020 15:04:12 -0500
Message-ID: <20200123200412.j2aucdp3cvk57prw@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
 <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
 <CAHC9VhTusiQoudB8G5jjDFyM9WxBUAjZ6_X35ywJ063Jb75dQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhTusiQoudB8G5jjDFyM9WxBUAjZ6_X35ywJ063Jb75dQA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: nhorman@tuxdriver.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 2020-01-23 12:09, Paul Moore wrote:
> On Thu, Jan 23, 2020 at 11:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-01-22 16:28, Paul Moore wrote:
> > > On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >
> > > > Add audit container identifier support to the action of signalling the
> > > > audit daemon.
> > > >
> > > > Since this would need to add an element to the audit_sig_info struct,
> > > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > > audit_sig_info2 struct.  Corresponding support is required in the
> > > > userspace code to reflect the new record request and reply type.
> > > > An older userspace won't break since it won't know to request this
> > > > record type.
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  include/linux/audit.h       |  7 +++++++
> > > >  include/uapi/linux/audit.h  |  1 +
> > > >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> > > >  kernel/audit.h              |  1 +
> > > >  security/selinux/nlmsgtab.c |  1 +
> > > >  5 files changed, 45 insertions(+)
> > >
> > > ...
> > >
> > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > index 0871c3e5d6df..51159c94041c 100644
> > > > --- a/kernel/audit.c
> > > > +++ b/kernel/audit.c
> > > > @@ -126,6 +126,14 @@ struct auditd_connection {
> > > >  kuid_t         audit_sig_uid = INVALID_UID;
> > > >  pid_t          audit_sig_pid = -1;
> > > >  u32            audit_sig_sid = 0;
> > > > +/* Since the signal information is stored in the record buffer at the
> > > > + * time of the signal, but not retrieved until later, there is a chance
> > > > + * that the last process in the container could terminate before the
> > > > + * signal record is delivered.  In this circumstance, there is a chance
> > > > + * the orchestrator could reuse the audit container identifier, causing
> > > > + * an overlap of audit records that refer to the same audit container
> > > > + * identifier, but a different container instance.  */
> > > > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> > >
> > > I believe we could prevent the case mentioned above by taking an
> > > additional reference to the audit container ID object when the signal
> > > information is collected, dropping it only after the signal
> > > information is collected by userspace or another process signals the
> > > audit daemon.  Yes, it would block that audit container ID from being
> > > reused immediately, but since we are talking about one number out of
> > > 2^64 that seems like a reasonable tradeoff.
> >
> > I had thought that through and should have been more explicit about that
> > situation when I documented it.  We could do that, but then the syscall
> > records would be connected with the call from auditd on shutdown to
> > request that signal information, rather than the exit of that last
> > process that was using that container.  This strikes me as misleading.
> > Is that really what we want?
> 
>  ???
> 
> I think one of us is not understanding the other; maybe it's me, maybe
> it's you, maybe it's both of us.
> 
> Anyway, here is what I was trying to convey with my original comment
> ... When we record the audit container ID in audit_signal_info() we
> take an extra reference to the audit container ID object so that it
> will not disappear (and get reused) until after we respond with an
> AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
> AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took in
> audit_signal_info().  Unless I'm missing some other change you made,
> this *shouldn't* affect the syscall records, all it does is preserve
> the audit container ID object in the kernel's ACID store so it doesn't
> get reused.

This is exactly what I had understood.  I hadn't considered the extra
details below in detail due to my original syscall concern, but they
make sense.

The syscall I refer to is the one connected with the drop of the
audit container identifier by the last process that was in that
container in patch 5/16.  The production of this record is contingent on
the last ref in a contobj being dropped.  So if it is due to that ref
being maintained by audit_signal_info() until the AUDIT_SIGNAL_INFO2
record it fetched, then it will appear that the fetch action closed the
container rather than the last process in the container to exit.

Does this make sense?

> (We do need to do some extra housekeeping in audit_signal_info() to
> deal with the case where nobody asks for AUDIT_SIGNAL_INFO2 -
> basically if audit_sig_cid is not NULL we should drop a reference
> before assigning it a new object pointer, and of course we would need
> to set audit_sig_cid to NULL in audit_receive_msg() after sending it
> up to userspace and dropping the extra ref.)
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
