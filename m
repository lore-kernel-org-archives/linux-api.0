From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
Date: Sun, 16 Nov 2014 07:42:30 -0800
Message-ID: <CALCETrUPsH_So2Mgk38Fe_pjp5Y+cgjzCUe7fzFcnsFzivHeNA@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org> <87vbmfq1uw.fsf@x220.int.ebiederm.org>
 <20141116133230.GA32030@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141116133230.GA32030-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 16, 2014 at 5:32 AM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Sat, Nov 15, 2014 at 09:08:07PM -0600, Eric W. Biederman wrote:
>>
>> That may be a bug with the user namespace permission check.  Perhaps we
>> shouldn't allow dropping groups that aren't mapped in the user
>> namespace.
>
> I'm not saying that we can't change the behavior of whether or not a
> user can drop a group permission.  I'm just saying that we need to do
> so consciously.  The setgroups()/getgroups() ABI isn't part of
> POSIX/SuSv3 so we wouldn't be breaking POSIX compatibility, for those
> people who care about that.

It may make sense to reach out to some place like oss-security.

FWIW, I think we should ask, at the same time, about:

 - Dropping supplementary groups.
 - Switching gid/egid/sgid to a supplementary group.
 - Denying ptrace of a process with supplementary groups that the
tracer doesn't have.

Also, I much prefer a sysctl to a boot option.  Boot options are nasty
to configure in many distributions.

--Andy

>
> The bigger deal is that it's very different from how BSD 4.x has
> handled things, which means there is two decades of history that we're
> looking at here.  And there are times when taking away permissions in
> an expected fashion can cause security problems.  (As a silly example;
> some architect at Digital wrote a spec that said that setuid must
> return EINVAL for values greater than 32k --- back in the days when
> uid's were a signed short.  The junior programmer who implemented this
> for Ultrix made the check for 32,000 decimal.  Guess what happened
> when /bin/login got a failure with setuid when it wasn't expecting one
> --- since root could never get an error with that system call, right?
> And MIT Project Athena started ran out of lower numbered uid's and
> froshlings started getting assigned uid's > 32,000....)
>
> In this particular case, the change is probably a little less likely
> to cause serious problems, although the fact that sudo does allow
> negative group assignments is an example of another potential
> breakage.
>
> OTOH, I'm aware of how this could cause major problems to the concept
> of allowing an untrusted user to set up their own containers to
> constrain what program with a possibly untrusted provinance might be
> able to do.  I can see times when I might want to run in a container
> where the user didn't have access to groups that I have access to by
> default --- including groups such as disk, sudo, lpadmin, etc.
>
> If we do want to make such a change, my suggestion is to keep things
> *very* simple.  Let it be a boot-time option whether or not users are
> allowed to drop group permissions, and let it affect all possible ways
> that users can drop groups.  And we can create a shell script that
> will search for the obvious ways that a user could get screwed by
> enabling this, which we can encourage distributions to package up for
> their end users.  And then we document the heck out of the fact that
> this option exists, and when/if we want to make it the default, so
> it's perfectly clear and transparent to all what is happening.
>
> One of the things that scare me about the addition of the forced
> capability "setuid" binary was that the feature was just silently slid
> in, and we didn't do a good job reaching out to the tripwire and
> rootkit and other such programs out there, such that several years
> after we enabled capability support, most sysadmins and security
> scanning programs are still apparently obivious to the this very
> convenient feature that we gave to rootkit and malware authors.  Now
> we can say that we're just adding new features, and we owe no debt
> other parts of the ecosystem --- this is the attitude used by upower
> and other freedesktop.org components when they made incompatible
> changes made available by new features provided by systemd[1].
>
> [1] http://m.memegen.com/u7o1tk.jpg
>
> But as kernel developers, who pride ourselves on not breaking
> userspace, I think we should try for a higher standard than this.  And
> perhaps this change with allowing groups to be dropped --- which is
> admittedly a useful thing to be able to allow --- is a good place to
> start trying to model a better way of doing things.  We should try to
> be responsible about how we add new features, and think of all of the
> potential downstream consequences to the _all_ of the ecosystem.
>
>                                          - Ted
>
> P.S.  And we really should try reaching out to the security scanners
> about capabilities, too....



-- 
Andy Lutomirski
AMA Capital Management, LLC
