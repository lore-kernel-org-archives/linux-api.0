From: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC(V3): Audit Kernel Container IDs
Date: Mon, 05 Feb 2018 08:47:36 -0500
Message-ID: <1517838456.13097.163.camel@redhat.com>
References: <20180109121620.wi7dq2423ugsraqv@madcap2.tricolour.ca>
         <1515514736.3239.10.camel@redhat.com>
         <20180110070011.l4rcdcwb27witfem@madcap2.tricolour.ca>
         <CAHC9VhQ=hX55e7ftkVQCogTZTcdSm3rm-+YNOgWomabbXV_sKg@mail.gmail.com>
         <1517609946.13097.161.camel@redhat.com>
         <CAHC9VhTg0ocArSek03A-XrbjgR4iGeysxXWaA8HknKBD_5ZRkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhTg0ocArSek03A-XrbjgR4iGeysxXWaA8HknKBD_5ZRkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2018-02-02 at 18:24 -0500, Paul Moore wrote:
> On Fri, Feb 2, 2018 at 5:19 PM, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 2018-02-02 at 16:24 -0500, Paul Moore wrote:
> > > On Wed, Jan 10, 2018 at 2:00 AM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > On 2018-01-09 11:18, Simo Sorce wrote:
> > > > > On Tue, 2018-01-09 at 07:16 -0500, Richard Guy Briggs wrote:
> 
> ...
> 
> > > > Paul, can you justify this somewhat larger inconvenience for some
> > > > relatively minor convenience on our part?
> > > 
> > > Done in direct response to Simo.
> > 
> > Sorry but your response sounds more like waving away then addressing
> > them, the excuse being: we can't please everyone, so we are going to
> > please no one.
> 
> I obviously disagree with the take on my comments but you're free to
> your opinion.

The I misunderstood your comments, I am not interested in putting words
in your mouth.

> I believe saying we are pleasing no one isn't really fair now is it?

Well, of course you are going to please the audit subsystem, I
understand that. I think there is a problem of expectations. Some
people, me included, hoped to have a way to identify a container with
the help of the kernel.

> Is there any type of audit container ID now?  How would you go about
> associating audit events with containers now?

We do not have a good way, there are some dirty tricks like inferring
the container identity via cgroup names, but that is ... eww.
This is why, given audit has the same need of user space, there was
some hope we could agree on an identifier that could be used by both.
It would make correlating audit logs and other cluster-wide events
simpler. That is all.

>  (spoiler alert: it ain't
> pretty, and there are gaps I don't believe you can cover)  This
> proposal provides a mechanism to do this in a way that isn't tied to
> any one particular concept of a container and is manageable inside the
> kernel.

I like the proposal for the most part, we are just discussing on the
nature of the identifier, which is a minor detail in the end.

> If you have a need to track audit events for containers, I find it
> extremely hard to believe that you are not at least partially pleased
> by the solutions presented here.  It may not be everything on your
> wishlist, but when did you ever get *everything* on your wishlist?

It is true, and I am sorry if I came out demanding or abrasive. It was
not my intention. Of course a u64 that has to be mapped is still better
than nothing. It does cause a lot more work in user space, but it is
not impossible to deal with.

> > > But to be clear Richard, we've talked about this a few times, it's not
> > > a "minor convenience" on our part, it's a pretty big convenience once
> > > we starting having to route audit events and make decisions based on
> > > the audit container ID information.  Audit performance is less than
> > > awesome now, I'm working hard to not make it worse.
> > 
> > Sounds like a security vs performance trade off to me.
> 
> Welcome to software development.  It's generally a pretty terrible
> hobby and/or occupation, but we make up for it with long hours and
> endless frustration.

Tell me more about that, not! ;-)

> > > > u64 vs u128 is easy for us to
> > > > accomodate in terms of scalar comparisons.  It doubles the information
> > > > in every container id field we print in audit records.
> > > 
> > > ... and slows down audit container ID checks.
> > 
> > Are you saying a cmp on a u128 is slower than a comparison on a u64 and
> > this is something that will be noticeable ?
> 
> Do you have a 128 bit system?

no, but all 64bit systems have an instruction that allow you to do
atomic 128 compare and swap (IIRC ?).

>   I don't.  I've got a bunch of 64 bit
> systems, and a couple of 32 bit systems too.  People that use audit
> have a tendency to really hammer on it, to the point that we get
> performance complaints on a not infrequent basis.  I don't know the
> exact number of times we are going to need to check the audit
> container ID, but it's reasonable to think that we'll expose it as a
> filter-able field which adds a few checks, we'll use it for record
> routing so that's a few more, and if we're running multiple audit
> daemons we will probably want to include LSM checks which could result
> in a few more audit container ID checks.  If it was one comparison I
> wouldn't be too worried about it, but the point I'm trying to make is
> that we don't know what the implementation is going to look like yet
> and I suspect this ID is going to be leveraged in several places in
> the audit subsystem and I would much rather start small to save
> headaches later.
> 
> We can always expand the ID to a larger integer at a later date, but
> we can't make it smaller.

Well looking through the history of in kernel identifiers I know it is
hard also to increase size, because userspace will end up depending on
a specific size ... and this is the only reason I am really debating
this. If it were really easy to change I wouldn't bother to do it now.

> > > > A c36 is a bigger step.
> > > 
> > > Yeah, we're not doing that, no way.
> > 
> > Ok, I can see your point though I do not agree with it.
> > 
> > I can see why you do not want to have arbitrary length strings, but a
> > u128 sounded like a reasonable compromise to me as it has enough room
> > to be able to have unique cluster-wide IDs which a u64 definitely makes
> > a lot harder to provide w/o tight coordination.
> 
> I originally wanted it to be a 32-bit integer, but Richard managed to
> talk me into 64-bits, that was my compromise :)
> 
> As I said earlier, if you are doing container auditing you're going to
> need coordination with the orchestrator, regardless of the audit
> container ID size.

Ok, I guess that's as good as I can get it for now, thank you for your
patient explanations.

Simo.

-- 
Simo Sorce
Sr. Principal Software Engineer
Red Hat, Inc
