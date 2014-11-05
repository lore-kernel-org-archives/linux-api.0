From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Early comments on kdbus v2 (Re: [PATCH 00/12] Add kdbus implementation)
Date: Wed, 5 Nov 2014 09:13:43 -0800
Message-ID: <CALCETrW8b0LrBOYGgpMD4rRHAoamgAHfn4hymTZazpWpi7XZUQ@mail.gmail.com>
References: <CALCETrVJHFzyjOjUhAjzsknm1VVnUcDU2i=Ymhpmy8q1Pef8PQ@mail.gmail.com>
 <545A581D.9040706@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545A581D.9040706-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 5, 2014 at 9:02 AM, Simon McVittie
<simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org> wrote:
> On 05/11/14 15:56, Andy Lutomirski wrote:
>>  - I tend to think that pid and tid should be separate.  They're
>> really their own thing, and, as noted in all the perfectly valid
>> dislike directed at SO_PEERCRED, they have extremely limited value.
>
> Traditional D-Bus has GetConnectionUnixProcessID(), which is used by
> several applications:
> <http://codesearch.debian.net/search?q=GetConnectionUnixProcessID>,
> <http://codesearch.debian.net/search?q=servicePid> (the latter is the Qt
> binding).
>
> I don't know what those applications use it for, or whether they're
> doing it safely. CVE-2013-4288, CVE-2014-5033 seem potentially relevant.
>
> In the same way that kernel people don't want to break userland, I don't
> want to break existing D-Bus users; it would be a shame if kdbus omits
> things that would let it replace traditional D-Bus.

That's why I suggested separating it, not removing it.  If it were
separate, then short-lived processes (like dbus-send, perhaps, in a
mode where it doesn't wait for a reply) would just skip sending it,
because the recipient can't use it in a reliable manner.

Although, TBH, it might be better to just return -1 from
GetConnectionUnixProcessID when kdbus is being used, since anything
that breaks might be breaking because it's vulnerable...

>
>>  - starttime should have a justification or be removed.
>
> I think its justification is "detect pid reuse", although AIUI it
> doesn't detect pid "reuse" via exec().

Ugh.  I really don't think the kernel should add a new feature to make
a broken, racy concept slightly less racy.  I'm fully in favor of
making it completely non-racy, but this isn't the way to do it.
(Also, anything that actually relies on this is unlikely to survive
checkpoint/restore.)

>
>>  - KDBUS_ATTACH_AUXGROUPS: I'm not sure what to think about this.  I
>> feel like it's only useful for implementing strange types of policies.
>
> I think the intention is that it enables things like "processes with
> group netdev may tell NetworkManager to reconfigure networking".
> Traditional D-Bus half-supports this, but interacts poorly with things
> like pam_groups that assign groups to processes, not uids.

That's what I guessed, too.  I'm not sure whether I like it.

>
>>  - KDBUS_ATTACH_SECLABEL: The docs talk about selinux.  What does this
>> even mean on a non-selinux system?
>
> As far as I understand it, sockets have a generic mechanism for storing
> one arbitrary security label alongside the uid, and the active LSM gets
> to define its syntax and what it means. This is the equivalent of that.

The UNIX socket credential mechanism is not a good role model, and
"something else does this too" is not a sufficient justification for
new code.  I want to make sure that someone actually understands what
this thing does and whether it's a good idea.

Unfortunately, I suspect that most or all kdbus developers either
don't use LSMs at all or use selinux, which means that may not be
anyone who has considered the big picture here.

[...]

>
>> Otherwise we'll end up with two
>> separate selinux policy databases -- the normal one and whatever dbus
>> tries to do
>
> Traditional D-Bus already has this problem: dbus-daemon has to work out
> "what would SELinux do?" in userland, including the decision whether to
> enforce or just complain, and do the same. My understanding is that one
> of the more minor upsides of doing (this part of) D-Bus in the kernel is
> that it would remove that intermediary, moving the security decisions to
> a location where LSMs can allow/deny things directly.

I absolutely agree.  It seems that the logical conclusion is that the
security label should *not* be passed to userspace, then -- once LSMs
can make decisions directly, userspace should let them make those
decisions and consider only the result of the decision, not the labels
that influenced the decision.

--Andy
