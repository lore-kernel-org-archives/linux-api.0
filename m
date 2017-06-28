From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Enable namespaced file capabilities
Date: Wed, 28 Jun 2017 09:28:50 -0500
Message-ID: <20170628142850.GA24489@mail.hallyn.com>
References: <1498157989-11814-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <CAOQ4uxj=_Riih1K+QOYasZU8vZKCSrsg393f=17mJ2O-909e=Q@mail.gmail.com>
 <20170628054138.GA15939@mail.hallyn.com>
 <CAOQ4uxhiSHEXzWN7=g-nmu=ebpv7hkXszW03JZ4UJkcjTeH+oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhiSHEXzWN7=g-nmu=ebpv7hkXszW03JZ4UJkcjTeH+oQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkp-JC7UmRfGjtg@public.gmane.org, xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, christian.brauner-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Amir Goldstein (amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> On Wed, Jun 28, 2017 at 8:41 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi Amir,
> >
> > I was liking the prefix at first, but I'm actually not sure it's worth
> > it.  THe main advantage would be so that checking for namespace or other
> > tags could be done always at the same offset simplifying the parser.
> > But since we will want to only handle namespacing for some tags, and
> > potentially differently for each task, it won't actually be simpler, I
> > don't think.
> >
> > On the other hand we do want to make sure that the syntax we use is
> > generally usable, so I think simply specifying that >1 tags can each
> > be separate by '@' should suffice.  So for now we'd only have
> 
> Serge,
> 
> I am not sure I am parsing what you are saying correctly (pun intended).
> Can you give some examples of xattr names with several @.
> 
> >
> >         security.capability@uid=100000
> >
> > soon we'd hopefully have
> >
> >         security.ima@uid=100000
> >
> 
> IIUC, the xattr names above should be parsed as:
> 
>         security.(([ima|capability])@(uid=100000)

not sure what you mean by the parentheses.  Point in these two
examples being that only uid= would be accepted as 'tags', and
only ima and capability would support the tag.  As we'd discussed
we might support uid= (with no number) as indicating any namespace
not mapping kuid 0 would work.

> > and eventually trusted.blarb@foo=bar
> >
> 
> But the trusted xattr name should be parsed as:
> 
>         (trusted.blarb)@(uid=100000)

Sorry, my point there wasn't trusted, I had meant to put in more
tags, which was the point:

	security.capability@uid=100000@smack=container_x

We don't yet know what smack= would mean, but we do know that at
some point there may be > 1 tags.

Importantly, in order to not limit our future behavior, for now
we would refuse writing >1 tags.  (That way we don't risk the problem,
in the future, that someone can boot an older kernel andw rite a xattr
without all the privileges which the new kernel requires.)

> Otherwise it won't be able to pass the xattr_is_trusted() test
> which looks only at the trusted prefix.
> 
> So we can write it like this, if it makes sense for the parser:
>         trusted@uid=100000.blarb

That's actually specifically what I'm arguing against.  I'm arguing
that the full xattr should come first, as we should not bother
checking for tags until we've verified that the xattr supports them.

> But I don't think that trusted.foo should have a different
> userns behavior than trusted.bar down the road.

Perhaps not for trusted, but perhaps it will.  And for security.*
it definately does.  Selinux does not support namespace tags.
Smack one day may, but perhaps with different behavior than ima.

> Admittedly, I am not so much of a security developer myself,
> so I prefer to let Casey be the spokesman for the '.ns' prefix.
> Casey's proposal seems right to me:
> 
>         security.ns@uid=1000@@.capability

Right I was going to reply to his email, but yours seemed to come
earlier so I picked it :)  I wasn't trying to pick on you :)

> We can also stick to a more conventional syntax of a perfect
> new namespace 'security.ns', which encapsulates the unprivileged

If we were going this route I definately would have preferred
security.ns@uid=1000@@.capability.

I've cc:d linux-api at this point as it seems the right thing to
do :)

thanks,
-serge
