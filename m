From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Date: Mon, 21 Oct 2019 15:53:20 -0400
Message-ID: <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Fri, Oct 18, 2019 at 9:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-09-18 21:22, Richard Guy Briggs wrote:
> > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > process in a non-init user namespace the capability to set audit
> > container identifiers.
> >
> > Use audit netlink message types AUDIT_GET_CAPCONTID 1027 and
> > AUDIT_SET_CAPCONTID 1028.  The message format includes the data
> > structure:
> > struct audit_capcontid_status {
> >         pid_t   pid;
> >         u32     enable;
> > };
>
> Paul, can I get a review of the general idea here to see if you're ok
> with this way of effectively extending CAP_AUDIT_CONTROL for the sake of
> setting contid from beyond the init user namespace where capable() can't
> reach and ns_capable() is meaningless for these purposes?

I think my previous comment about having both the procfs and netlink
interfaces apply here.  I don't see why we need two different APIs at
the start; explain to me why procfs isn't sufficient.  If the argument
is simply the desire to avoid mounting procfs in the container, how
many container orchestrators can function today without a valid /proc?

-- 
paul moore
www.paul-moore.com
