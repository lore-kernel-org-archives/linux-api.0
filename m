From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Date: Wed, 30 Oct 2019 18:03:20 -0400
Message-ID: <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca>
 <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca>
 <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca>
 <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
 <20191024210010.owwgc3bqbvtdsqws@madcap2.tricolour.ca>
 <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On 2019-10-30 16:27, Paul Moore wrote:
> On Thu, Oct 24, 2019 at 5:00 PM Richard Guy Briggs <rgb@redhat.com> wrote=
:
> > Here's the note I had from that meeting:
> >
> > - Eric raised the issue that using /proc is likely to get more and more
> >   hoary due to mount namespaces and suggested that we use a netlink
> > audit message (or a new syscall) to set the audit container identifier
> > and since the loginuid is a similar type of operation, that it should b=
e
> > migrated over to a similar mechanism to get it away from /proc.  Get
> > could be done with a netlink audit message that triggers an audit log
> > message to deliver the information.  I'm reluctant to further pollute
> > the syscall space if we can find another method.  The netlink audit
> > message makes sense since any audit-enabled service is likely to alread=
y
> > have an audit socket open.
>=20
> Thanks for the background info on the off-list meeting.  I would
> encourage you to have discussions like this on-list in the future; if
> that isn't possible, hosting a public call would okay-ish, but a
> distant second.

I'm still trying to get Eric's attention to get him to weigh in here and
provide a more eloquent representation of his ideas and concerns.  Some
of it was related to CRIU(sp?) issues which we've already of which we've
already seen similar concerns in namespace identifiers including the
device identity to qualify it.

> At this point in time I'm not overly concerned about /proc completely
> going away in namespaces/containers that are full featured enough to
> host a container orchestrator.  If/when reliance on procfs becomes an
> issue, we can look at alternate APIs, but given the importance of
> /proc to userspace (including to audit) I suspect we are going to see
> it persist for some time.  I would prefer to see you to drop the audit
> container ID netlink API portions of this patchset and focus on the
> procfs API.

I've already refactored the code to put the netlink bits at the end as
completely optional pieces for completeness so they won't get in the way
of the real substance of this patchset.  The nesting depth and total
number of containers checks have also been punted to the end of the
patchset to get them out of the way of discussion.

> Also, for the record, removing the audit loginuid from procfs is not
> something to take lightly, if at all; like it or not, it's part of the
> kernel API.

Oh, I'm quite aware of how important this change is and it was discussed
with Steve Grubb who saw the concern and value of considering such a
disruptive change.  Removing proc support for auid/ses would be a
long-term deprecation if accepted.

Really, I should have labelled the v7 patchset as RFC since there were
so many new and disruptive ideas presented in it.

> paul moore
> www.paul-moore.com

- RGB
