From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from ptrace
Date: Fri, 12 Oct 2018 22:06:00 +0200
Message-ID: <CAG48ez3o0t6UjtdsuiUck7ijJiA39uy5Jfno28UMMq_Q1d=s8g@mail.gmail.com>
References: <20181008181815.pwnqxngj22mhm2vj@brauner.io> <CAG48ez3PEce4ynRnDk=yfsAOuFGH=YMmuf13CAxEt07Yjk3ZCw@mail.gmail.com>
 <20181009132850.fp6yne2vgmfpi27k@brauner.io> <CAG48ez2EV8Z=Egn7hNpXd86bHdvQhVxStqE1N=U2L2R7sA-gjg@mail.gmail.com>
 <CAHC9VhQfzJgG3i=Q8C+pGY2Lpr+2MRTwxgUWec_heGOecd=xRg@mail.gmail.com>
 <CAG48ez2hTBFwmA65FXv0zJjc0_wpc1S-uOBn1t+X=0vPH25YvQ@mail.gmail.com>
 <16662034750.2781.85c95baa4474aabc7814e68940a78392@paul-moore.com>
 <CAG48ez0=NRRu2FUZFwdDSMmkdWsFi1XSSPTO8bL84YAY=jOzMQ@mail.gmail.com>
 <1666564e4f8.2781.85c95baa4474aabc7814e68940a78392@paul-moore.com>
 <CALCETrV1fWKJe96ow3XGy_kmZoXoehb99e4AZehsO84YGxKjgQ@mail.gmail.com> <20181012200220.GC5530@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012200220.GC5530@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Andy Lutomirski <luto@amacapital.net>, Paul Moore <paul@paul-moore.com>, christian@brauner.io, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, suda.akihiro@lab.ntt.co.jp, Oleg Nesterov <oleg@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 12, 2018 at 10:02 PM Tycho Andersen <tycho@tycho.ws> wrote:
> On Thu, Oct 11, 2018 at 06:02:06PM -0700, Andy Lutomirski wrote:
> > On Thu, Oct 11, 2018 at 4:10 PM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > On October 11, 2018 9:40:06 AM Jann Horn <jannh@google.com> wrote:
> > > > On Thu, Oct 11, 2018 at 9:24 AM Paul Moore <paul@paul-moore.com> wrote:
> > > >> On October 10, 2018 11:34:11 AM Jann Horn <jannh@google.com> wrote:
> > > >>> On Wed, Oct 10, 2018 at 5:32 PM Paul Moore <paul@paul-moore.com> wrote:
> > > >>>> On Tue, Oct 9, 2018 at 9:36 AM Jann Horn <jannh@google.com> wrote:
> > > >>>>> +cc selinux people explicitly, since they probably have opinions on this
> > > >>>>
> > > >>>> I just spent about twenty minutes working my way through this thread,
> > > >>>> and digging through the containers archive trying to get a good
> > > >>>> understanding of what you guys are trying to do, and I'm not quite
> > > >>>> sure I understand it all.  However, from what I have seen, this
> > > >>>> approach looks very ptrace-y to me (I imagine to others as well based
> > > >>>> on the comments) and because of this I think ensuring the usual ptrace
> > > >>>> access controls are evaluated, including the ptrace LSM hooks, is the
> > > >>>> right thing to do.
> > > >>>
> > > >>> Basically the problem is that this new ptrace() API does something
> > > >>> that doesn't just influence the target task, but also every other task
> > > >>> that has the same seccomp filter. So the classic ptrace check doesn't
> > > >>> work here.
> > > >>
> > > >> Due to some rather unfortunate events today I'm suddenly without easy access to the kernel code, but would it be possible to run the LSM ptrace access control checks against all of the affected tasks?  If it is possible, how painful would it be?
> > > >
> > > > There are currently no backlinks from seccomp filters to the tasks
> > > > that use them; the only thing you have is a refcount. If the refcount
> > > > is 1, and the target task uses the filter directly (it is the last
> > > > installed one), you'd be able to infer that the ptrace target is the
> > > > only task with a reference to the filter, and you could just do the
> > > > direct check; but if the refcount is >1, you might end up having to
> > > > take some spinlock and then iterate over all tasks' filters with that
> > > > spinlock held, or something like that.
> > >
> > > That's what I was afraid of.
> > >
> > > Unfortunately, I stand by my previous statements that we still probably want a LSM access check similar to what we currently do for ptrace.
> > >
> >
> > I would argue that once "LSM" enters this conversation, it just means
> > we're on the wrong track.  Let's try to make this work without ptrace
> > if possible :)  The whole seccomp() mechanism is very carefully
> > designed so that it's perfectly safe to install seccomp filters
> > without involving LSM or even involving credentials at all.
>
> In a last ditch effort to save the ptrace() interface: can we just
> only allow it when refcount_read(filter->usage) == 1?

>From a security perspective, I think that would be fine, assuming that
we know that the target task is stopped. (But note that if the target
process e.g. uses the filter on multiple threads, the refcount will be
higher.)
