From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 07/10] audit: add support for
 containerid to network namespaces
Date: Thu, 26 Jul 2018 09:33:08 -0400
Message-ID: <20180726133308.cb7x7yvdxek23eb3@madcap2.tricolour.ca>
References: <cover.1528304203.git.rgb@redhat.com>
 <562cfaf7629b64252aac7cf3cecdd70b471af5b5.1528304204.git.rgb@redhat.com>
 <CAHC9VhStmCOS=o2aM7zHLGUYyfuCu_d1so4Cp4T-qetGnJpUUg@mail.gmail.com>
 <20180724140309.i6o2yjdoif5krxtw@madcap2.tricolour.ca>
 <CAHC9VhSuczaFi49-3SrVM9vND=vT=U1Aj0G6kOyJ3rAFnvi6VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHC9VhSuczaFi49-3SrVM9vND=vT=U1Aj0G6kOyJ3rAFnvi6VA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 2018-07-24 16:33, Paul Moore wrote:
> On Tue, Jul 24, 2018 at 10:06 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2018-07-20 18:14, Paul Moore wrote:
> > > On Wed, Jun 6, 2018 at 1:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Audit events could happen in a network namespace outside of a task
> > > > context due to packets received from the net that trigger an auditing
> > > > rule prior to being associated with a running task.  The network
> > > > namespace could in use by multiple containers by association to the
> > > > tasks in that network namespace.  We still want a way to attribute
> > > > these events to any potential containers.  Keep a list per network
> > > > namespace to track these audit container identifiiers.
> > > >
> > > > Add/increment the audit container identifier on:
> > > > - initial setting of the audit container identifier via /proc
> > > > - clone/fork call that inherits an audit container identifier
> > > > - unshare call that inherits an audit container identifier
> > > > - setns call that inherits an audit container identifier
> > > > Delete/decrement the audit container identifier on:
> > > > - an inherited audit container identifier dropped when child set
> > > > - process exit
> > > > - unshare call that drops a net namespace
> > > > - setns call that drops a net namespace
> > > >
> > > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  include/linux/audit.h | 23 ++++++++++++++++
> > > >  kernel/audit.c        | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  kernel/auditsc.c      |  5 ++++
> > > >  kernel/nsproxy.c      |  4 +++
> > > >  4 files changed, 104 insertions(+)
> 
> ...
> 
> > > > +                       }
> > > > +       if (!found)
> > > > +               return;
> > > > +       list_del(&cont->list);
> > > > +       if (refcount_dec_and_test(&cont->refcount))
> > > > +               kfree(cont);
> > >
> > > Don't you want to dec_and_test first and only remove it from the list
> > > if there are no other references?
> >
> > I don't think so.  Let me try to describe it in prose to see if I
> > understood this properly and see if this makes more sense: I want to
> > remove this audit_contid list member from this net's audit_contid list
> > and decrement unconditionally this member's refcount so it knows there
> > is one less thing pointing at it and when there is no longer anything
> > pointing at it, free it.
> 
> Yep, sorry, my mistake, I was thinking the other way around (netns
> going away) ... which actually, this patchset doesn't handle that does
> it (I don't see any new code in audit_net_exit())?  Is is in a later
> patch?  If so, it really should be in the same patch as this code to
> prevent bisect nasties.

I don't think any code is needed in audit_net_exit() other than a WARN()
that the contid list is empty, since if a netns is going away, all its
tasks would have exited (removing its contid from the list) or moved to
a new nstns (moving its contid from this list to another netns).
At worst, this is a memory leak and not a bad pointer dereference.

> paul moore

- RGB
