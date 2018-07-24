From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 08/10] audit: NETFILTER_PKT:
	record each container ID associated with a netNS
Date: Tue, 24 Jul 2018 16:55:42 -0400
Message-ID: <20180724205542.j36vxlbgzsoot6wn@madcap2.tricolour.ca>
References: <cover.1528304203.git.rgb@redhat.com>
	<c6b64f6540e2e531636142ced36d51f0744d0e1f.1528304204.git.rgb@redhat.com>
	<CAHC9VhQCxdOzcYHFtJ8eTLkNQxwvdAnuLOEguqHT_zU4V9d0OA@mail.gmail.com>
	<1748819.SHaROlQLoH@x2>
	<CAHC9VhRiqp5ttCfh1EttLgbpPowr5P_B7nC6sP4pq=XBfEYqJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRiqp5ttCfh1EttLgbpPowr5P_B7nC6sP4pq=XBfEYqJg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>
Cc: cgroups@vger.kernel.org, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, dhowells@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 2018-07-24 16:22, Paul Moore wrote:
> On Tue, Jul 24, 2018 at 3:48 PM Steve Grubb <sgrubb@redhat.com> wrote:
> > On Friday, July 20, 2018 6:15:00 PM EDT Paul Moore wrote:
> > > On Wed, Jun 6, 2018 at 1:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> > > > event standalone records.  Iterate through all potential audit container
> > > > identifiers associated with a network namespace.
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > > include/linux/audit.h    |  5 +++++
> > > > kernel/audit.c           | 20 +++++++++++++++++++-
> > > > kernel/auditsc.c         |  2 ++
> > > > net/netfilter/xt_AUDIT.c | 12 ++++++++++--
> > > > 4 files changed, 36 insertions(+), 3 deletions(-)
> > >
> > > ...
> > >
> > > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > > index 7e2e51c..4560a4e 100644
> > > > --- a/include/linux/audit.h
> > > > +++ b/include/linux/audit.h
> > > > @@ -167,6 +167,8 @@ extern int audit_log_contid(struct audit_context
> > > > *context, extern void audit_contid_add(struct net *net, u64 contid);
> > > > extern void audit_contid_del(struct net *net, u64 contid);
> > > > extern void audit_switch_task_namespaces(struct nsproxy *ns, struct
> > > > task_struct *p); +extern void audit_log_contid_list(struct net *net,
> > > > +                                struct audit_context *context);
> > >
> > > See my comment in previous patches about changing the function name to
> > > better indicate it's dedicate use for network namespaces.
> > >
> > > > extern int                 audit_update_lsm_rules(void);
> > > >
> > > > @@ -231,6 +233,9 @@ static inline void audit_contid_del(struct net *net,
> > > > u64 contid) { }
> > > > static inline void audit_switch_task_namespaces(struct nsproxy *ns,
> > > > struct task_struct *p) { }
> > > > +static inline void audit_log_contid_list(struct net *net,
> > > > +                                       struct audit_context *context)
> > > > +{ }
> > > >
> > > > #define audit_enabled 0
> > > > #endif /* CONFIG_AUDIT */
> > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > index ecd2de4..8cca41a 100644
> > > > --- a/kernel/audit.c
> > > > +++ b/kernel/audit.c
> > > > @@ -382,6 +382,20 @@ void audit_switch_task_namespaces(struct nsproxy
> > > > *ns, struct task_struct *p) audit_contid_add(new->net_ns, contid);
> > > > }
> > > >
> > > > +void audit_log_contid_list(struct net *net, struct audit_context
> > > > *context) +{
> > > > +       struct audit_contid *cont;
> > > > +       int i = 0;
> > > > +
> > > > +       list_for_each_entry(cont, audit_get_contid_list(net), list) {
> > > > +               char buf[14];
> > > > +
> > > > +               sprintf(buf, "net%u", i++);
> > > > +               audit_log_contid(context, buf, cont->id);
> > >
> > > Hmm.  It looks like this will generate multiple audit container ID
> > > records with "op=netX contid=Y" (X=netns number, Y=audit container
> > > ID), is that what we want?  I've mentioned my concern around the "op"
> > > values in these records earlier in the patchset, that still applies
> > > here, but now I'm also concerned about the multiple records.  I'm
> > > thinking we might be better served with a single record with either
> > > multiple "contid" fields, or a single "contid" field with a set of
> > > comma separated values (or some other delimiter that Steve's tools
> > > will tolerate).
> > >
> > > Steve, thoughts?
> >
> > A single record is best. Maybe pattern this after the args listed in an
> > execve record.
> 
> I'm concerned that an execve-like approach might not scale very well
> as would could potentially have a lot of containers sharing a single
> network namespace ("a%d=%d" vs ",%d").  Further, with execve we log
> the argument position in addition to the argument itself, that isn't
> something we need to worry about with the audit container IDs.

I think a comma-separated list would be most efficient, but could
potentially overload one record.  The "netX" labels are pretty
meaningless unless they are that netNS' inode number (with qualifying
dev, of course), but that would be elsewhere in another record.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
