From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: kdbus namespaces etc
Date: Sun, 2 Nov 2014 09:13:27 -0800
Message-ID: <CALCETrVHMW892aO3h2OxVKf3ucPVtus46KGTDrtQqVq8BsDF2w@mail.gmail.com>
References: <CALCETrVAUNKrF8TW=ZhwTB0QSJzJbT_o5gOxg5K6sSrr-gG3Ug@mail.gmail.com>
 <CAG-2HqWwbU7pkmOhpYTyh6gT1iZXxougZQcLEQMk6r7_b+UWpA@mail.gmail.com>
 <545340C2.5070304@zonque.org> <CALCETrW78cr8XuMvDuFGqieWQ7ao6-QGZ0i++kv06cn0ybRR9w@mail.gmail.com>
 <5454B29B.2000103@zonque.org> <20141102165122.GA23921@gardel-login>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141102165122.GA23921@gardel-login>
Sender: linux-kernel-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
Cc: Daniel Mack <daniel@zonque.org>, Tom Gundersen <teg@jklm.no>, Greg KH <gregkh@linuxfoundation.org>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

[adding lkml and linux-api because this is quite helpful]

On Sun, Nov 2, 2014 at 8:51 AM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Sat, 01.11.14 11:14, Daniel Mack (daniel@zonque.org) wrote:
>
>> On 10/31/2014 04:07 PM, Andy Lutomirski wrote:
>> > There are two major issues, I think.
>> >
>> > The easy one is the metadata thing.  I think that just using the
>> > standard in-kernel APIs and translating when metadata is sent back to
>> > userspace will work.  So, if you store kuid_t, struct pid *, etc, and
>> > remove ns_eq, everything should just work (with the caveat that, in
>> > some circumstances, certain metadata items may be untranslatable).
>> >
>> > The much harder one is kdbus domains.  The basic model for namespaces
>> > is that you can unshare a user namespace (if you want) and then
>> > unshare everything else and set up whatever lives in your container.
>> > So there really should be some way to make that work with kdbus,
>> > especially since Bastien Nocera has kdbus on his wish list as a thing
>> > to make containers work better.
>
> Note that we are working with Bastien all the time, we try to keep him
> in the loop of things anyway, his wishes shouldn't be too far off from
> what we are working on with kdbus.
>
>> > That means that it should be possible to create a kdbus domain from
>> > inside a userns, which means you can't check any global privilege.
>> > This could be done by adding syscalls for kdbus, by creating a
>> > kdbusfs, or possibly even keeping the current device node based
>> > system.  The latter seems likely to be a mess, though, and you'd need
>> > to come up with some sensible semantics for how everything will fit
>> > together, and you'll be up against the weird consideration that using
>> > device nodes more or less enforces a hierarchy of domains when there
>> > really doesn't seem to be anything hierarchical about them.
>
> A couple of things to point out regarding
> namespaces/conainers/sandboxing and kbdus:
>
> a) kdbus is not a generic IPC to use between multiple OS
>    containers. Instead there's just a "system bus" for the OS plus a
>    number of "user busses", one for each user. The system bus is where
>    unprivileged programs talk to system services, possibly requesting
>    priviliged operations that way. The user bus is where unpriviliged
>    user programs talk to user services of the same user. And that's
>    really it. It's not a protocol to talk between OS containers or
>    anything like that. It has a very well defined focus, and that's
>    what we develop it for (now, we can of course extend the scope one
>    day, but for now, let's keep in focus the existing usecase. I mean,
>    there's a reason we didn't call it "kbus", but "kdbus", because we
>    actually focus on the classic dbus usecase, and not something
>    that'd be more generic than that.)
>
> b) To allow multiple OS containers to run in parallel we devised the
>    kdbus "domains" concept: each OS conainer gets its own set of
>    device nodes for its busses, completely isolated from the other
>    domains. While the naming scheme is hierarchial, the "domains" are
>    otherwise completely disconnected, and there's no effective
>    hierarchal structure between them, because there's no structure at
>    all between them, except for the naming. The domain concept is
>    simple: whenever you create a new domain, you get a subdir in your
>    /dev/kdbus which you then mount over the containers /dev/kdbus and
>    so on.
>
> c) To allow sandbox-like filtering containers, where a service runs on
>    a host but only sees a smaller "namespace" of user and system
>    services we came up with the "custom endpoint" concept: a sandboxed
>    app or service gets its own "alias" device nodes for the
>    user/system busses, that have some additional policy applied, which
>    can hide services or make them inaccessible.

I'll try to find the docs for this.  It sounds potentially quite helpful.

>
> We currently have not played around with userns stuff to allow
> creation of unpriviliged domains, but opening this up is not too hard,
> it simply requires us to weaken the permission checks and enforcing
> some minimal naming rules to avoid domain name clashes.

This is IMO not correct.  Linux namespaces have survived this long
without having names, for good reason: it avoids ever dealing with how
to name them.

And just loosening the permissions allows anyone to pollute their
kdbus domain hierarchy, and, possibly worse, make those names visible
outside their new domain.  This is done for the questionable gain of
using device nodes.

>
> Translating credentials is not a priority for us really, as kdbus is
> not an IPC to use between completely different OS containers that have
> different user lists and process lists. Again, we can widen the scope
> one day, but for now we decided to go the safe route: we will suppress
> the creds if we they cannot be mapped. If one day we want to allow
> inter-namespace communication with properly translated creds then we
> can revisit this of course, but for now, simply suppressing them is
> good enough.

But it *is* intended to be used between app containers.  Given that
this is an explicit design goal, I think that someone should really
clarify how the design is compatible with the goal.  "Systemd can do
it" may or may not be a true statement, but it isn't a useful
statement for reviewers.

>
> Note that kdbus is explicitly *not* just an IPC primitive like AF_UNIX
> sockets are. While you use AF_UNIX to build all kinds of communication
> schemes, kdbus comes with a very clear usage scheme: the system and
> the user busses, and nothing else. Hence, because AF_UNIX as IPC
> primitive is so much more generic, covering the namespace translation
> logic for AF_UNIX from day 1 was essential, but this is different for
> kdbus, which is strictly used in one way so far, and intra-container
> communication is not it.
>
> Note that with suppressing the metadata for now for intra-container
> communication we leave a nice avenue open to later on turn this on,

You don't have this avenue to open it up later.  Someone will,
correctly, rely on this suppression to provide anonymity, and, when
you turn it off, you will introduce security holes.

> as we can always add new stuff later on without breaking compat. It
> would be much harder if we let the bits through, but in a broken way
> or in a way that we'd have to change later on.
>
> Also note that the current kdbus client code in systemd already makes
> use of both "domains" and "custom end points" for
> containerization/sandboxing purposes. systemd's "nspawn" tool (which
> implements a minimal LXC-like container manager, that "just works",
> and needs no configuration) already implicitly sets up kdbus domains,
> so that we can make sure the domains concept works nicely and can
> later-on be adopted by LXC, libvirt-lxc, docker, ... too.

nspawn is a great development tool.  It's not such a good test bed for
more complicated use cases, especially since it appears to completely
lack user namespace support.

> In fact, we
> even tested systemd-nspawn recursively, in order to make sure that
> kdbus domains can be corretcly stacked, and do the right thing
> then). Also, systemd's service logic is already able to lock arbitrary
> services into kdbus sandboxes, enforcing much stricter access rights
> on specific services than the usual generic user-id based policy.

How does that work?  What is systemd doing to prevent containerized
things from seeing the full view of kdbus?

>
> Making the whole credential passing stuff opt-in-by-reciever rather
> than opt-in-by-sender is btw also the right thing, because we know
> exactly what dbus is used for, we have a very clear usecase, since
> dbus is already so well established. And for the usecases it has
> (system bus as place where apps talk to system services plus user bus
> as place where apps talk to user services owned by the same user), we
> hence know that it really should be the receiver which decides, since
> it needs to make auth decisions, needs to generate log and audit
> records, and so on.

My media player does not need to generate audit records.  Nor does my
screensaver, and, for that matter, nor do most genuine system
services.

--Andy

(quoting continued below)

>
> To summarize the above: the container usecases were a priority for us
> since day 1. With the "domains" and "custom end points" we think we
> found really convincing concepts to match the common usecases of the
> kernel's PID/UID/... namespacing functionality. We also have
> implementions of usercode ready for them to make sure things work that
> way. kdbus has a much stricter focus than AF_UNIX, as it only is used
> for system + user busses, and for that translating the metadata is not
> a priority.
>
> Anyway, so much about the background why kdbus looks the way it looks
> like. I can understand that it would be great to adapt kdbus to more
> usecases later on (for example, by making it useful for
> intra-namespace communication by doing proper translation of
> credentials, but that would probably would open entirely new cans of
> worms, since then we'd have to establish a third kind of bus really,
> the "all-container" bus that multiple containers can use to
> communicate, but that requires a ton more thinkign), but we'd really
> like to stay focuses on the immediate usecase of the current dbus.
>
> Hope this makes sense,
>
> Lennart
>
> --
> Lennart Poettering, Red Hat
