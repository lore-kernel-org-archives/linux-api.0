From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
 avoid DoS
Date: Thu, 24 Oct 2019 17:23:35 -0400
Message-ID: <20191024212335.y4ou7g4tsxnotvnk@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
 <20190927125142.GA25764@hmswarspite.think-freely.org>
 <CAHC9VhRbSUCB0OZorC4+y+5uJDR5uMXdRn2LOTYGu2gcFJSrcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhRbSUCB0OZorC4+y+5uJDR5uMXdRn2LOTYGu2gcFJSrcA@mail.gmail.com>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2019-10-10 20:38, Paul Moore wrote:
> On Fri, Sep 27, 2019 at 8:52 AM Neil Horman <nhorman@tuxdriver.com> wrote=
:
> > On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > > Set an arbitrary limit on the number of audit container identifiers t=
o
> > > limit abuse.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  kernel/audit.c | 8 ++++++++
> > >  kernel/audit.h | 4 ++++
> > >  2 files changed, 12 insertions(+)
> > >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 53d13d638c63..329916534dd2 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
>=20
> ...
>=20
> > > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, =
u64 contid)
> > >                               newcont->owner =3D current;
> > >                               refcount_set(&newcont->refcount, 1);
> > >                               list_add_rcu(&newcont->list, &audit_con=
tid_hash[h]);
> > > +                             audit_contid_count++;
> > >                       } else {
> > >                               rc =3D -ENOMEM;
> > >                               goto conterror;
> > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > index 162de8366b32..543f1334ba47 100644
> > > --- a/kernel/audit.h
> > > +++ b/kernel/audit.h
> > > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
> > >       return (contid & (AUDIT_CONTID_BUCKETS-1));
> > >  }
> > >
> > > +extern int audit_contid_count;
> > > +
> > > +#define AUDIT_CONTID_COUNT   1 << 16
> > > +
> >
> > Just to ask the question, since it wasn't clear in the changelog, what
> > abuse are you avoiding here?  Ostensibly you should be able to create a=
s
> > many container ids as you have space for, and the simple creation of
> > container ids doesn't seem like the resource strain I would be concerne=
d
> > about here, given that an orchestrator can still create as many
> > containers as the system will otherwise allow, which will consume
> > significantly more ram/disk/etc.
>=20
> I've got a similar question.  Up to this point in the patchset, there
> is a potential issue of hash bucket chain lengths and traversing them
> with a spinlock held, but it seems like we shouldn't be putting an
> arbitrary limit on audit container IDs unless we have a good reason
> for it.  If for some reason we do want to enforce a limit, it should
> probably be a tunable value like a sysctl, or similar.

Can you separate and clarify the concerns here?

I plan to move this patch to the end of the patchset and make it
optional, possibly adding a tuning mechanism.  Like the migration from
/proc to netlink for loginuid/sessionid/contid/capcontid, this was Eric
Biederman's concern and suggested mitigation.

As for the first issue of the bucket chain length traversal while
holding the list spin-lock, would you prefer to use the rcu lock to
traverse the list and then only hold the spin-lock when modifying the
list, and possibly even make the spin-lock more fine-grained per list?

> paul moore

- RGB
