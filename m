From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 01/10] audit: collect audit task
 parameters
Date: Thu, 24 Jan 2019 15:36:37 -0500
Message-ID: <20190124203637.2gve6epwwd4kdgbm@madcap2.tricolour.ca>
References: <cover.1533065887.git.rgb@redhat.com>
 <8e617ab568df28a66dfbe3284452de186b42fb0f.1533065887.git.rgb@redhat.com>
 <CAHC9VhQFqs1SyvximK+8XJG5Fk3p9WsWhEV5sY6kksN9tc6eKw@mail.gmail.com>
 <20181101220724.ggkqyf5kjv7lhabx@madcap2.tricolour.ca>
 <CAHC9VhRU-Qss41CnV3mE32tXmZ3FQpy++t4yPUkh9CjuAzxYCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRU-Qss41CnV3mE32tXmZ3FQpy++t4yPUkh9CjuAzxYCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 2019-01-03 15:10, Paul Moore wrote:
> On Thu, Nov 1, 2018 at 6:07 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2018-10-19 19:15, Paul Moore wrote:
> > > On Sun, Aug 5, 2018 at 4:32 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > The audit-related parameters in struct task_struct should ideally be
> > > > collected together and accessed through a standard audit API.
> > > >
> > > > Collect the existing loginuid, sessionid and audit_context together in a
> > > > new struct audit_task_info called "audit" in struct task_struct.
> > > >
> > > > Use kmem_cache to manage this pool of memory.
> > > > Un-inline audit_free() to be able to always recover that memory.
> > > >
> > > > See: https://github.com/linux-audit/audit-kernel/issues/81
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  include/linux/audit.h | 34 ++++++++++++++++++++++++----------
> > > >  include/linux/sched.h |  5 +----
> > > >  init/init_task.c      |  3 +--
> > > >  init/main.c           |  2 ++
> > > >  kernel/auditsc.c      | 51 ++++++++++++++++++++++++++++++++++++++++++---------
> > > >  kernel/fork.c         |  4 +++-
> > > >  6 files changed, 73 insertions(+), 26 deletions(-)
> > >
> > > ...
> > >
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index 87bf02d..e117272 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -873,10 +872,8 @@ struct task_struct {
> > > >
> > > >         struct callback_head            *task_works;
> > > >
> > > > -       struct audit_context            *audit_context;
> > > >  #ifdef CONFIG_AUDITSYSCALL
> > > > -       kuid_t                          loginuid;
> > > > -       unsigned int                    sessionid;
> > > > +       struct audit_task_info          *audit;
> > > >  #endif
> > > >         struct seccomp                  seccomp;
> > >
> > > Prior to this patch audit_context was available regardless of
> > > CONFIG_AUDITSYSCALL, after this patch the corresponding audit_context
> > > is only available when CONFIG_AUDITSYSCALL is defined.
> >
> > This was intentional since audit_context is not used when AUDITSYSCALL is
> > disabled.  audit_alloc() was stubbed in that case to return 0.  audit_context()
> > returned NULL.
> >
> > The fact that audit_context was still present in struct task_struct was an
> > oversight in the two patches already accepted:
> >         ("audit: use inline function to get audit context")
> >         ("audit: use inline function to get audit context")
> > that failed to hide or remove it from struct task_struct when it was no longer
> > relevant.
> 
> Okay, in that case let's pull this out and fix this separately from
> the audit container ID patchset.

Ok, that should be addressed by ghak104.

> > On further digging, loginuid and sessionid (and audit_log_session_info) should
> > be part of CONFIG_AUDIT scope and not CONFIG_AUDITSYSCALL since it is used in
> > CONFIG_CHANGE, ANOM_LINK, FEATURE_CHANGE(, INTEGRITY_RULE), none of which are
> > otherwise dependent on AUDITSYSCALL.
> 
> This looks like something else we should fix independently from this patchset.

Ok, this should be addressed by ghak105.

> > Looking ahead, contid should be treated like loginuid and sessionid, which are
> > currently only available when syscall auditting is.
> 
> That seems reasonable.  Eventually it would be great if we got rid of
> CONFIG_AUDITSYSCALL, but that is a separate issue, and something that
> is going to require work from the different arch/ABI folks to ensure
> everything is working properly.

So I'll plan to rebase on ghak104 and ghak105 once they are upstreamed.
I'll address the locking issues in the netns list and audit_sig_cid...

> > Converting records from standalone to syscall and checking audit_dummy_context
> > changes the nature of CONFIG_AUDIT/!CONFIG_AUDITSYSCALL separation.
> > eg: ANOM_LINK accompanied by PATH record (which needed CWD addition to be
> > complete anyways)

This has been addressed in ghak105, moving ANOM_LINK to auditsc.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
