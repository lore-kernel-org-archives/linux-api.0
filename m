From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
 avoid DoS
Date: Fri, 25 Oct 2019 16:15:39 -0400
Message-ID: <20191025201539.5nvjg3x7zshoqjwl@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
 <20190927125142.GA25764@hmswarspite.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190927125142.GA25764@hmswarspite.think-freely.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, dwalsh@redhat.com, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2019-09-27 08:51, Neil Horman wrote:
> On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > Set an arbitrary limit on the number of audit container identifiers to
> > limit abuse.
> >=20
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c | 8 ++++++++
> >  kernel/audit.h | 4 ++++
> >  2 files changed, 12 insertions(+)
> >=20
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 53d13d638c63..329916534dd2 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -139,6 +139,7 @@ struct audit_net {
> >  struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
> >  /* Hash for contid-based rules */
> >  struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> > +int audit_contid_count =3D 0;
> > =20
> >  static struct kmem_cache *audit_buffer_cache;
> > =20
> > @@ -2384,6 +2385,7 @@ void audit_cont_put(struct audit_cont *cont)
> >  =09=09put_task_struct(cont->owner);
> >  =09=09list_del_rcu(&cont->list);
> >  =09=09kfree_rcu(cont, rcu);
> > +=09=09audit_contid_count--;
> >  =09}
> >  }
> > =20
> > @@ -2456,6 +2458,11 @@ int audit_set_contid(struct task_struct *task, u=
64 contid)
> >  =09=09=09=09=09goto conterror;
> >  =09=09=09=09}
> >  =09=09=09}
> > +=09=09/* Set max contids */
> > +=09=09if (audit_contid_count > AUDIT_CONTID_COUNT) {
> > +=09=09=09rc =3D -ENOSPC;
> > +=09=09=09goto conterror;
> > +=09=09}
> You should check for audit_contid_count =3D=3D AUDIT_CONTID_COUNT here, n=
o?
> or at least >=3D, since you increment it below.  Otherwise its possible
> that you will exceed it by one in the full condition.

Yes, agreed.

> >  =09=09if (!newcont) {
> >  =09=09=09newcont =3D kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
> >  =09=09=09if (newcont) {
> > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, u6=
4 contid)
> >  =09=09=09=09newcont->owner =3D current;
> >  =09=09=09=09refcount_set(&newcont->refcount, 1);
> >  =09=09=09=09list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > +=09=09=09=09audit_contid_count++;
> >  =09=09=09} else {
> >  =09=09=09=09rc =3D -ENOMEM;
> >  =09=09=09=09goto conterror;
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index 162de8366b32..543f1334ba47 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
> >  =09return (contid & (AUDIT_CONTID_BUCKETS-1));
> >  }
> > =20
> > +extern int audit_contid_count;
> > +
> > +#define AUDIT_CONTID_COUNT=091 << 16
> > +
> Just to ask the question, since it wasn't clear in the changelog, what
> abuse are you avoiding here?  Ostensibly you should be able to create as
> many container ids as you have space for, and the simple creation of
> container ids doesn't seem like the resource strain I would be concerned
> about here, given that an orchestrator can still create as many
> containers as the system will otherwise allow, which will consume
> significantly more ram/disk/etc.

Agreed.  I'm not a huge fan of this, but included it as an optional
patch to address resource abuse concerns of Eric Beiderman.  I'll push
it to the end of the patchset and make it clear it is optional unless I
hear a compelling reason to keep it.

A similar argument was used to make the audit queue length tunable
parameter unlimited.

> >  /* Indicates that audit should log the full pathname. */
> >  #define AUDIT_NAME_FULL -1
> > =20
> > --=20
> > 1.8.3.1

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
