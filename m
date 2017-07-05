From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 13:07:24 -0400
Message-ID: <20170705130724.66637518@gandalf.local.home>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
        <20170703123025.7479702e@gandalf.local.home>
        <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
        <20170705084528.67499f8c@gandalf.local.home>
        <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
        <20170705092757.63dc2328@gandalf.local.home>
        <20170705140607.GA30187@kroah.com>
        <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
        <20170705112707.54d7f345@gandalf.local.home>
        <1499269015.3668.25.camel@HansenPartnership.com>
        <20170705120459.41e81f7b@gandalf.local.home>
        <1499273908.3668.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499273908.3668.30.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 05 Jul 2017 09:58:28 -0700
James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

> On Wed, 2017-07-05 at 12:04 -0400, Steven Rostedt wrote:
> > On Wed, 05 Jul 2017 08:36:55 -0700
> > James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> >   
> > >   
> > > > 
> > > > Are we tracking regressions or just simply bugs?    
> > > 
> > > A lot of device driver regressions are bugs that previously existed
> > > in the code but which didn't manifest until something else
> > > happened.  A huge number of locking and timing issues are like
> > > this.  The irony is that a lot of them go from race always being
> > > won (so bug never noticed) to race being lost often enough to make
> > > something unusable.  To a user that ends up being a kernel
> > > regression because it's a bug in the current kernel which they
> > > didn't see previously which makes it unusable for them.
> > > 
> > > I've got to vote with my users here: that's a regression not a
> > > "feature".  
> > 
> > Let's take a step back. What exactly is the problem?  
> 
> You mean what question was I answering?  It was your "is your problem a
> regression?" one.

No that's not what I meant. I mean that we are going off tangent to the
original topic.

> 
> > The regressions that we want to track? Why are they not fixed? Is it
> > because they are hard to reproduce? If so, how do we know they are a
> > regression or just some hard to hit bug? If it's hard to hit, how do
> > we know we fixed it?  
> 
> Usually for the exposed races we develop a theoretical model which
> tells us what the problem is and also the solution.

I think the problem is that the regressions that are not being fixed
happen to be where we have no model to create, as the problem may be
too hard to hit, and it could just be a "works for me" issue.

> 
> > What exactly are the questions we want solved.  
> 
> In the context of this subthread?  Tracking and fixing of regressions
> meaning behaviour that damages or destroys usability of version k+1
> that wasn't present in version k.

Agreed with this part. And I believe this is also in the context of the
entire thread.

> 
> > Granted, I used this thread to push more use of kselftests, and I
> > don't see any SCSI tests there at all!  
> 
> It would be an interesting question for another thread to consider
> whether that's a problem or not.

It's not a problem for me, but it begs the question of whether it would
be useful or not. But I agree, that's for another thread.

-- Steve
