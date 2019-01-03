From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 00/10] audit: implement container identifier
Date: Thu, 3 Jan 2019 15:12:27 -0500
Message-ID: <CAHC9VhTzX6dJCqAN_8Vpd5t7JhZamu2gRDRQve1-ubz739GsSg@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <20190103161525.GA6551@roeck-us.net>
 <20190103173613.jb5kukysslozytwg@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190103173613.jb5kukysslozytwg@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>, ebiederm@xmission.com, simo@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, viro@zeniv.linux.org.uk, luto@kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 3, 2019 at 12:36 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-01-03 08:15, Guenter Roeck wrote:
> > Hi,
> >
> > On Tue, Jul 31, 2018 at 04:07:35PM -0400, Richard Guy Briggs wrote:
> > > Implement kernel audit container identifier.
> >
> > I don't see a follow-up submission of this patch series. Has it been abandoned,
> > or do I use the wrong search terms ?
>
> Guenter, thanks for your interest in this patchset.  I haven't
> abandoned it.  I've pushed some updates to my own (ill-publicized)
> public git repo.  This effort has been going on more than 5 years with 8
> previous revisions trying to document task namespaces and deciding that
> was insufficient.
>
> For this patchset I waited 11.5 weeks (80 days, Jules Verne anyone?)
> before the primary intended maintainer did the first review, then I
> responded within 2 weeks with further questions and a followup patch
> proposal and then waited another 8 weeks for any response before adding
> another query for that followup patch proposal review at which point I
> got a rude answer saying I had disappointed and exhausted the
> maintainer's goodwill with some hints at how to proceed just before new
> year's.

For what it is worth, I've found your emails to me to be rather "rude"
as well (to borrow the term), and I responded with what I felt was
appropriate.  Perhaps our interactions may have been seen as overly,
or quickly, harsh but I would remind those that we have several years
of history that extends far beyond the lists which obviously affects
how we interact.  Our expectations for each other are clearly higher
than either of us are delivering, so I'm going to suggest what I've
suggested before, albeit privately: let's stick to the code, that's
where we can find common ground.

There were only a few outstanding threads/questions from your last
posting, you should have responses to those sitting in your inbox now.

> I'd be delighted with other upstream review to get other angles and to
> take some of the load and responsibility off the primary maintainer.
>
> I expect to submit a v5 within a week without having had those questions
> directly answered, but with some ideas of what to check and verify
> before I resubmit.  Most of the changes have been sitting in that branch
> for two months, already rebased one kernel version and will need
> updating again.

-- 
paul moore
www.paul-moore.com
