From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Date: Thu, 23 Jan 2020 11:29:18 -0500
Message-ID: <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2020-01-22 16:28, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Add audit container identifier support to the action of signalling the
> > audit daemon.
> >
> > Since this would need to add an element to the audit_sig_info struct,
> > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > audit_sig_info2 struct.  Corresponding support is required in the
> > userspace code to reflect the new record request and reply type.
> > An older userspace won't break since it won't know to request this
> > record type.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h       |  7 +++++++
> >  include/uapi/linux/audit.h  |  1 +
> >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> >  kernel/audit.h              |  1 +
> >  security/selinux/nlmsgtab.c |  1 +
> >  5 files changed, 45 insertions(+)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 0871c3e5d6df..51159c94041c 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -126,6 +126,14 @@ struct auditd_connection {
> >  kuid_t         audit_sig_uid = INVALID_UID;
> >  pid_t          audit_sig_pid = -1;
> >  u32            audit_sig_sid = 0;
> > +/* Since the signal information is stored in the record buffer at the
> > + * time of the signal, but not retrieved until later, there is a chance
> > + * that the last process in the container could terminate before the
> > + * signal record is delivered.  In this circumstance, there is a chance
> > + * the orchestrator could reuse the audit container identifier, causing
> > + * an overlap of audit records that refer to the same audit container
> > + * identifier, but a different container instance.  */
> > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> 
> I believe we could prevent the case mentioned above by taking an
> additional reference to the audit container ID object when the signal
> information is collected, dropping it only after the signal
> information is collected by userspace or another process signals the
> audit daemon.  Yes, it would block that audit container ID from being
> reused immediately, but since we are talking about one number out of
> 2^64 that seems like a reasonable tradeoff.

I had thought that through and should have been more explicit about that
situation when I documented it.  We could do that, but then the syscall
records would be connected with the call from auditd on shutdown to
request that signal information, rather than the exit of that last
process that was using that container.  This strikes me as misleading.
Is that really what we want?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
