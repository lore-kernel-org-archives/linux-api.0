From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH V2 1/1] audit: Record fanotify access control decisions
Date: Mon, 25 Sep 2017 10:19:29 -0400
Message-ID: <12453021.6GDTSQsMtX@x2>
References: <2133863.GPF9YbgjlT@x2> <CAOQ4uxhD1VCN4+a4eVshDo0jSS+dVGAH8BLtiJfv_vrvh+3r9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhD1VCN4+a4eVshDo0jSS+dVGAH8BLtiJfv_vrvh+3r9A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, fsdevel <linux-fsdevel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Paul Moore <pmoore@redhat.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Monday, September 25, 2017 12:43:28 AM EDT Amir Goldstein wrote:
> On Sun, Sep 24, 2017 at 11:25 PM, Steve Grubb <sgrubb@redhat.com> wrote:
> > Hello,
> > 
> > The fanotify interface allows user space daemons to make access
> > control decisions. Under common criteria requirements, we need to
> > optionally record decisions based on policy. This patch adds a bit mask,
> > FAN_AUDIT, that a user space daemon can 'or' into the response decision
> > which will tell the kernel that it made a decision and record it.
> > 
> > It would be used something like this in user space code:
> > 
> > response.response = FAN_DENY | FAN_AUDIT;
> > write(fd, &response, sizeof(struct fanotify_response));
> > 
> > When the syscall ends, the audit system will record the decision as a
> > AUDIT_FANOTIFY auxiliary record to denote that the reason this event
> > occurred is the result of an access control decision from fanotify
> > rather than DAC or MAC policy.
> > 
> > A sample event looks like this:
> > 
> > type=PATH msg=audit(1504310584.332:290): item=0 name="./evil-ls"
> > inode=1319561 dev=fc:03 mode=0100755 ouid=1000 ogid=1000 rdev=00:00
> > obj=unconfined_u:object_r:user_home_t:s0 nametype=NORMAL
> > type=CWD msg=audit(1504310584.332:290): cwd="/home/sgrubb"
> > type=SYSCALL msg=audit(1504310584.332:290): arch=c000003e syscall=2
> > success=no exit=-1 a0=32cb3fca90 a1=0 a2=43 a3=8 items=1 ppid=901
> > pid=959 auid=1000 uid=1000 gid=1000 euid=1000 suid=1000
> > fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts1 ses=3 comm="bash"
> > exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:
> > s0-s0:c0.c1023 key=(null)
> > type=FANOTIFY msg=audit(1504310584.332:290): resp=2
> > 
> > Prior to using the audit flag, the developer needs to call
> > fanotify_init or'ing in FAN_AUDIT_ENABLE to ensure that the kernel
> > supports auditing. The calling process must also have the CAP_AUDIT_WRITE
> > capability.
> > 
> > Signed-off-by: sgrubb <sgrubb@redhat.com>
> 
> Please CC linux-api !!!

Missed that. Will be cc'ed on v3.

> A few small nits below

I have corrected those and will send v3 shortly after I re-verify the patch 
still works.

Thanks,
-Steve
