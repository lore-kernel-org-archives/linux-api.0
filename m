From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Date: Tue, 22 Oct 2019 10:34:54 -0400
Message-ID: <CAHC9VhQwXzyZzrN3fcc=OOqJPu+=CrkWUWGWjKNzP5OPVT_0_g@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca> <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca> <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca> <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
 <20191022142716.sgxcmc27w4uaqh3u@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191022142716.sgxcmc27w4uaqh3u@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, Oct 22, 2019 at 10:27 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> I'd like your perspective on how the capcontid feature was implemented
> (aside from the proc/netlink api issue which was intended to be
> consistent across loginuid/sessionid/contid/capcontid).  Do you see this
> feature as potentially solving the nested container issue in child user
> namespaces?

The patchset is a bit messy at this point in the stack due to the
"fixup!" confusion and a few other things which I already mentioned so
I don't really want to comment too much on that until I can see
everything in a reasonable patch stack.  Let's leave that for the next
draft.

-- 
paul moore
www.paul-moore.com
