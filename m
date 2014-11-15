From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
Date: Sat, 15 Nov 2014 12:06:20 -0800
Message-ID: <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141115192924.GB19060@thin>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 15, 2014 at 11:29 AM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Sat, Nov 15, 2014 at 09:37:27AM -0600, Eric W. Biederman wrote:
>> Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> writes:
>>
>> > Currently, unprivileged processes (without CAP_SETGID) cannot call
>> > setgroups at all.  In particular, processes with a set of supplementary
>> > groups cannot further drop permissions without obtaining elevated
>> > permissions first.
>> >
>> > Allow unprivileged processes to call setgroups with a subset of their
>> > current groups; only require CAP_SETGID to add a group the process does
>> > not currently have.
>>
>> A couple of questions.
>> - Is there precedence in other unix flavors for this?
>
> I found a few references to now-nonexistent pages at MIT about a system
> with this property, but other than that no.
>
> I've also found more than a few references to people wanting this
> functionality.
>
>> - What motiviates this change?
>
> I have a series of patches planned to add more ways to drop elevated
> privileges without requiring a transition through root to do so.  That
> would improve the ability for unprivileged users to run programs
> sandboxed with even *less* privileges.  (Among other things, that would
> also allow programs running with no_new_privs to further *reduce* their
> privileges, which they can't currently do in this case.)
>
>> - Have you looked to see if anything might for bug compatibilty
>>   require applications not to be able to drop supplementary groups?
>
> I haven't found any such case; that doesn't mean such a case does not
> exist.  Feedback welcome.
>
> The only case I can think of (and I don't know of any examples of such a
> system): some kind of quota system that limits the members of a group to
> a certain amount of storage, but places no such limit on non-members.
>
> However, the idea of *holding* a credential (a supplementary group ID)
> giving *less* privileges, and *dropping* a credential giving *more*
> privileges, would completely invert normal security models.  (The sane
> way to design such a system would be to have a privileged group for
> "users who can exceed the quota".)

Agreed.  And, if you want to bypass quotas by dropping a supplementary
group, you already can by unsharing your user namespace.

However, sudoers seems to allow negative group matches.  So maybe
allowing this only with no_new_privs already set would make sense.

--Andy
