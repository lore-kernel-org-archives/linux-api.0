From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 04/10] audit: add support for
 non-syscall auxiliary records
Date: Tue, 24 Jul 2018 17:57:02 -0400
Message-ID: <CAHC9VhTX99Gqnv5SQbm1_3KON7g2R83qSt=bM3KJibDnORBXzQ@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <dcd3d6e27c4beb8aec11805faeb4de7013132bd7.1528304204.git.rgb@redhat.com>
 <CAHC9VhRkH+UaZXfbsmfMsuCO7rQ48R5cBPU__00eG=pyO7AyCw@mail.gmail.com> <20180724193725.k27la4ubg2g2n4qm@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724193725.k27la4ubg2g2n4qm@madcap2.tricolour.ca>
Sender: netdev-owner@vger.kernel.org
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Tue, Jul 24, 2018 at 3:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-07-20 18:14, Paul Moore wrote:
> > On Wed, Jun 6, 2018 at 1:01 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Standalone audit records have the timestamp and serial number generated
> > > on the fly and as such are unique, making them standalone.  This new
> > > function audit_alloc_local() generates a local audit context that will
> > > be used only for a standalone record and its auxiliary record(s).  The
> > > context is discarded immediately after the local associated records are
> > > produced.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h |  8 ++++++++
> > >  kernel/auditsc.c      | 25 +++++++++++++++++++++++--
> > >  2 files changed, 31 insertions(+), 2 deletions(-)

...

> > > +       struct audit_context *context;
> > > +
> > > +       if (!audit_ever_enabled)
> > > +               return NULL; /* Return if not auditing. */
> > > +
> > > +       context = audit_alloc_context(AUDIT_RECORD_CONTEXT);
> > > +       if (!context)
> > > +               return NULL;
> > > +       context->serial = audit_serial();
> > > +       context->ctime = current_kernel_time64();
> > > +       context->in_syscall = 1;
> >
> > Setting in_syscall is both interesting and a bit troubling, if for no
> > other reason than I expect most (all?) callers to be in an interrupt
> > context when audit_alloc_local() is called.  Setting in_syscall would
> > appear to be conceptually in this case.  Can you help explain why this
> > is the right thing to do, or necessary to ensure things are handled
> > correctly?
>
> I'll admit this is cheating a bit, but seemed harmless.  It is needed so
> that auditsc_get_stamp() from audit_get_stamp() from audit_log_start()
> doesn't bail on me without giving me its already assigned time and
> serial values rather than generating a new one.  I did look to see if
> there were any other undesireable side effects and found none, so I'm
> tmepted to rename the ->in_syscall to something a bit more helpful.  I
> could add a new audit_context structure member to make
> auditsc_get_stamp() co-operative, but this seems wasteful and
> unnecessary.

That's what I suspected.

Let's look into renaming the "in_syscall" field, it borderline
confusing now, and hijacking it for something which is very obviously
not "in syscall" is A Very Bad Thing.

-- 
paul moore
www.paul-moore.com
