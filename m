From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
	avoid DoS
Date: Tue, 17 Dec 2019 14:56:31 -0500
Message-ID: <20191217195631.3obqll4nf5poe7cz@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
	<CAHC9VhTrKVQNvTPoX5xdx-TUX_ukpMv2tNFFqLa2Njs17GuQMg@mail.gmail.com>
	<20191217184541.tagssqt4zujbanf6@madcap2.tricolour.ca>
	<2318345.msVmMTmnKu@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <2318345.msVmMTmnKu@x2>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
Content-Disposition: inline
To: Steve Grubb <sgrubb@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On 2019-12-17 14:25, Steve Grubb wrote:
> On Tuesday, December 17, 2019 1:45:41 PM EST Richard Guy Briggs wrote:
> > On 2019-11-08 12:49, Paul Moore wrote:
> > > On Thu, Oct 24, 2019 at 5:23 PM Richard Guy Briggs <rgb@redhat.com> 
> wrote:
> > > > On 2019-10-10 20:38, Paul Moore wrote:
> > > > > On Fri, Sep 27, 2019 at 8:52 AM Neil Horman <nhorman@tuxdriver.com> 
> wrote:
> > > > > > On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > > > > > > Set an arbitrary limit on the number of audit container
> > > > > > > identifiers to
> > > > > > > limit abuse.
> > > > > > > 
> > > > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > > > ---
> > > > > > > kernel/audit.c | 8 ++++++++
> > > > > > > kernel/audit.h | 4 ++++
> > > > > > > 2 files changed, 12 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > > index 53d13d638c63..329916534dd2 100644
> > > > > > > --- a/kernel/audit.c
> > > > > > > +++ b/kernel/audit.c
> > > > > 
> > > > > ...
> > > > > 
> > > > > > > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct
> > > > > > > *task, u64 contid) newcont->owner = current;
> > > > > > > refcount_set(&newcont->refcount, 1);
> > > > > > > list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > > > > > > +                             audit_contid_count++;
> > > > > > > } else {
> > > > > > > rc = -ENOMEM;
> > > > > > > goto conterror;
> > > > > > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > > > > > index 162de8366b32..543f1334ba47 100644
> > > > > > > --- a/kernel/audit.h
> > > > > > > +++ b/kernel/audit.h
> > > > > > > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64
> > > > > > > contid)
> > > > > > > return (contid & (AUDIT_CONTID_BUCKETS-1));
> > > > > > > }
> > > > > > > 
> > > > > > > +extern int audit_contid_count;
> > > > > > > +
> > > > > > > +#define AUDIT_CONTID_COUNT   1 << 16
> > > > > > > +
> > > > > > 
> > > > > > Just to ask the question, since it wasn't clear in the changelog,
> > > > > > what
> > > > > > abuse are you avoiding here?  Ostensibly you should be able to
> > > > > > create as
> > > > > > many container ids as you have space for, and the simple creation
> > > > > > of
> > > > > > container ids doesn't seem like the resource strain I would be
> > > > > > concerned
> > > > > > about here, given that an orchestrator can still create as many
> > > > > > containers as the system will otherwise allow, which will consume
> > > > > > significantly more ram/disk/etc.
> > > > > 
> > > > > I've got a similar question.  Up to this point in the patchset, there
> > > > > is a potential issue of hash bucket chain lengths and traversing them
> > > > > with a spinlock held, but it seems like we shouldn't be putting an
> > > > > arbitrary limit on audit container IDs unless we have a good reason
> > > > > for it.  If for some reason we do want to enforce a limit, it should
> > > > > probably be a tunable value like a sysctl, or similar.
> > > > 
> > > > Can you separate and clarify the concerns here?
> > > 
> > > "Why are you doing this?" is about as simple as I can pose the question.
> > 
> > It was more of a concern for total system resources, primarily memory,
> > but this is self-limiting and an arbitrary concern.
> > 
> > The other limit of depth of nesting has different concerns that arise
> > depending on how reporting is done.
> 
> Well, there is a limit on the audit record size. So, whatever is being sent 
> in the record plus the size of the timestamp deducted from 
> MAX_AUDIT_MESSAGE_LENGTH (8970) is the limit. That can be divided by however 
> many ID's fit in that space and you have the real limit.

This will be addressed in the v8 patch set.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
