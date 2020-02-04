From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Date: Tue, 4 Feb 2020 08:19:44 -0500
Message-ID: <20200204131944.esnzcqvnecfnqgbi@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
 <5238532.OiMyN8JqPO@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5238532.OiMyN8JqPO@x2>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2020-01-31 09:50, Steve Grubb wrote:
> On Wednesday, January 22, 2020 4:29:12 PM EST Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Track the parent container of a container to be able to filter and
> > > report nesting.
> > > 
> > > Now that we have a way to track and check the parent container of a
> > > container, modify the contid field format to be able to report that
> > > nesting using a carrat ("^") separator to indicate nesting.  The
> > > original field format was "contid=<contid>" for task-associated records
> > > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > > records.  The new field format is
> > > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> > 
> > Let's make sure we always use a comma as a separator, even when
> > recording the parent information, for example:
> > "contid=<contid>[,^<contid>[...]][,<contid>[...]]"
> > 
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > 
> > >  include/linux/audit.h |  1 +
> > >  kernel/audit.c        | 53
> > >  +++++++++++++++++++++++++++++++++++++++++++-------- kernel/audit.h     
> > >    |  1 +
> > >  kernel/auditfilter.c  | 17 ++++++++++++++++-
> > >  kernel/auditsc.c      |  2 +-
> > >  5 files changed, 64 insertions(+), 10 deletions(-)
> > 
> > ...
> > 
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index ef8e07524c46..68be59d1a89b 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > 
> > > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns,
> > > struct task_struct *p)> 
> > >                 audit_netns_contid_add(new->net_ns, contid);
> > >  
> > >  }
> > > 
> > > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> > 
> > If we need a forward declaration, might as well just move it up near
> > the top of the file with the rest of the declarations.
> > 
> > > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > > +{
> > > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > > +       int h;
> > 
> > It seems safer to pass the audit container ID object and not the u64.
> > 
> > > +       if (!audit_contid_valid(contid)) {
> > > +               audit_log_format(ab, "%llu", contid);
> > 
> > Do we really want to print (u64)-1 here?  Since this is a known
> > invalid number, would "?" be a better choice?
> 
> The established pattern is that we print -1 when its unset and "?" when its 
> totalling missing. So, how could this be invalid? It should be set or not. 
> That is unless its totally missing just like when we do not run with selinux 
> enabled and a context just doesn't exist.

Ok, so in this case it is clearly unset, so should be -1, which will be a
20-digit number when represented as an unsigned long long int.

Thank you for that clarification Steve.

> -Steve
> 
> > > +               return;
> > > +       }
> > > +       h = audit_hash_contid(contid);
> > > +       rcu_read_lock();
> > > +       list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > > +               if (cont->id == contid) {
> > > +                       prcont = cont;
> > 
> > Why not just pull the code below into the body of this if statement?
> > It all needs to be done under the RCU read lock anyway and the code
> > would read much better this way.
> > 
> > > +                       break;
> > > +               }
> > > +       if (!prcont) {
> > > +               audit_log_format(ab, "%llu", contid);
> > > +               goto out;
> > > +       }
> > > +       while (prcont) {
> > > +               audit_log_format(ab, "%llu", prcont->id);
> > > +               prcont = prcont->parent;
> > > +               if (prcont)
> > > +                       audit_log_format(ab, "^");
> > 
> > In the interest of limiting the number of calls to audit_log_format(),
> > how about something like the following:
> > 
> >   audit_log_format("%llu", cont);
> >   iter = cont->parent;
> >   while (iter) {
> >     if (iter->parent)
> >       audit_log_format("^%llu,", iter);
> >     else
> >       audit_log_format("^%llu", iter);
> >     iter = iter->parent;
> >   }
> > 
> > > +       }
> > > +out:
> > > +       rcu_read_unlock();
> > > +}
> > > +
> > > 
> > >  /*
> > >  
> > >   * audit_log_container_id - report container info
> > >   * @context: task or local context for record
> > 
> > ...
> > 
> > > @@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64
> > > contid)> 
> > >         if (!ab)
> > >         
> > >                 return rc;
> > > 
> > > -       audit_log_format(ab,
> > > -                        "op=set opid=%d contid=%llu old-contid=%llu",
> > > -                        task_tgid_nr(task), contid, oldcontid);
> > > +       audit_log_format(ab, "op=set opid=%d contid=",
> > > task_tgid_nr(task)); +       audit_log_contid(ab, contid);
> > > +       audit_log_format(ab, " old-contid=");
> > > +       audit_log_contid(ab, oldcontid);
> > 
> > This is an interesting case where contid and old-contid are going to
> > be largely the same, only the first (current) ID is going to be
> > different; do we want to duplicate all of those IDs?
> > 
> > >         audit_log_end(ab);
> > >         return rc;
> > >  
> > >  }
> > > 
> > > @@ -2723,9 +2760,9 @@ void audit_log_container_drop(void)
> > 
> > paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
