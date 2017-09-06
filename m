From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 1/1] audit: Record fanotify access control decisions
Date: Wed, 06 Sep 2017 10:48:06 -0400
Message-ID: <5474448.HMVQqEg3DF@x2>
References: <1970763.eSnnJ2BxMO@x2> <20170906091822.GB27916@quack2.suse.cz> <CAOQ4uxjvbUnvZycF+t6=L_zK-hWsXL9VaFnXDV6muLOwBEqWew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjvbUnvZycF+t6=L_zK-hWsXL9VaFnXDV6muLOwBEqWew@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Paul Moore <pmoore@redhat.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wednesday, September 6, 2017 7:11:48 AM EDT Amir Goldstein wrote:
> On Wed, Sep 6, 2017 at 12:18 PM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 05-09-17 14:32:07, Steve Grubb wrote:
> >> The fanotify interface allows user space daemons to make access
> >> 
> >>  control decisions. Under common criteria requirements, we need to
> >>  optionally record decisions based on policy. This patch adds a bit mask,
> >>  FAN_AUDIT, that a user space daemon can 'or' into the response decision
> >>  which will tell the kernel that it made a decision and record it.
> > 
> > [Since this is API change, added linux-api to CC, also added Amir since he
> > works with fanotify]
> > 
> > Hum, probably I'm missing something here but why an application responding
> > to fanotify event should need to know about audit? Or is it that for CC
> > requirements you have to implement some deamon which will arbitrate access
> > using fanotify and you need to have decisions logged using kernel audit
> > interface?
> > 
> > And another design question: If you need all responses by some daemon
> > logged, wouldn't it be more logical to make FAN_AUDIT a property of
> > fanotify instance (i.e., a flag to fanotify_init(2))? Or maybe a property
> > of fanotify mark (i.e., a flag to fanotify_mark(2))?
> 
> Even if the use case is auditing blocklisted files, the change of ABI on the
> response fd should be opt-in by a new flag to fanotify_init(), something
> like FAN_CAN_AUDIT.
> 
> In other words, your new daemon that responds with FAN_AUDIT must
> fail to start when running on an old kernel that doesn't support the
> FAN_AUDIT response, unless it knows how to fall back and call
> fanotify_init() again without
> FAN_CAN_AUDIT and then not respond with FAN_AUDIT.

OK. That's easy enough to add and makes sense. When a daemon tries to audit on 
a kernel that doesn't, the response is rejected and the system eventually 
hangs. Killing the daemon fixes it.

> Other than that, I agree with Jan that setting FAN_AUDIT by default for
> all permission responses at fanotify_init() and maybe fanotify_mark()
> sounds useful.
> IMO, it makes most sense in proximity to defining the notification class,
> e.g.: fanotify_init(FAN_CLASS_CONTENT|FAN_PERM_AUDIT, 0);

Its supposed to be selective. The idea is to not force a blanket policy but 
let the daemon determine by the policy its enforcing whether or not the admin 
wanted the events. So, the design places exact control in the daemon that 
responds. For example, the admin may want events only associated with a 
specific user, directory, file type, file hash, specific file content, etc. 
but not others.

-Steve
