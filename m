From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Date: Wed, 30 Oct 2019 16:27:35 -0400
Message-ID: <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca> <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca> <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca> <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
 <20191024210010.owwgc3bqbvtdsqws@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191024210010.owwgc3bqbvtdsqws@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Thu, Oct 24, 2019 at 5:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Here's the note I had from that meeting:
>
> - Eric raised the issue that using /proc is likely to get more and more
>   hoary due to mount namespaces and suggested that we use a netlink
> audit message (or a new syscall) to set the audit container identifier
> and since the loginuid is a similar type of operation, that it should be
> migrated over to a similar mechanism to get it away from /proc.  Get
> could be done with a netlink audit message that triggers an audit log
> message to deliver the information.  I'm reluctant to further pollute
> the syscall space if we can find another method.  The netlink audit
> message makes sense since any audit-enabled service is likely to already
> have an audit socket open.

Thanks for the background info on the off-list meeting.  I would
encourage you to have discussions like this on-list in the future; if
that isn't possible, hosting a public call would okay-ish, but a
distant second.

At this point in time I'm not overly concerned about /proc completely
going away in namespaces/containers that are full featured enough to
host a container orchestrator.  If/when reliance on procfs becomes an
issue, we can look at alternate APIs, but given the importance of
/proc to userspace (including to audit) I suspect we are going to see
it persist for some time.  I would prefer to see you to drop the audit
container ID netlink API portions of this patchset and focus on the
procfs API.

Also, for the record, removing the audit loginuid from procfs is not
something to take lightly, if at all; like it or not, it's part of the
kernel API.

-- 
paul moore
www.paul-moore.com
