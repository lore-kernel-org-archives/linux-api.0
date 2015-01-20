From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 20 Jan 2015 18:00:28 +0100
Message-ID: <CANq1E4Q9m7JRXNYFY4okh3brM-kHVoVGOdF_SWjNoNURX930HQ@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
	<54BE5DC8.70706@gmail.com>
	<CANq1E4SjfZOKqTsdkt519vKc1Poeah5McVJBb_spdHjbKv4=7g@mail.gmail.com>
	<CA+5PVA46wVa-L9K1zgHzt=Fwn6YFBYhxJUjiozSH4XBY03WMVw@mail.gmail.com>
	<20150120145353.GA8124@dztty>
	<20150120160842.GA9474@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150120160842.GA9474-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Tue, Jan 20, 2015 at 5:08 PM, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org> wrote:
> However, let me repeat and rephrase my previous questions:
> Is there a noticable or measurable improvement from using kdbus?
> IOW, is the added complexity of kdbus worth the result?
>
> I have stated my believe that current usage of D-Bus is not
> performance sensitive and the number of messages exchanged
> is low.  I would love it if you would prove me wrong.
> Or if you could show that any D-Bus related bug in Gnome3
> is fixed by kdbus.

DBus is not used for performance sensitive applications because DBus
is slow. We want to make it fast so we can finally use it for
low-latency, high-throughput applications. A simple DBus
method-call+reply takes 200us here, with kdbus it takes 8us (with UDS
about 2us). If I increase the packet size from 8k to 128k, kdbus even
tops UDS thanks to single-copy transfers.
The fact that there is no performance-critical application using DBus
is, imho, an argument *pro* kdbus. People haven't been capable of
making classic dbus1 fast enough for low-latency audio, thus, we
present kdbus.

Starting up 'gdm' sends ~5k dbus messages on my machine. It takes >1s
to transmit the messages alone. Each dbus1 message has to be copied 4
times for each direction. With kdbus, each message is copied only once
for each transmission (or not at all, if you use memfds, though that
doesn't mean it's necessarily faster). No intermediate context-switch
is needed. This makes kdbus capable to transmit low-latency audio data
*inline*.

DBus marshaling is the de-facto standard in all major(!) linux desktop
systems. It is well established and accepted by many DEs. It also
solves many other problems, including: policy,
authentication/authorization, well-known name registry, efficient
broadcasts/multicasts, peer discovery, bus discovery, metadata
transmission, and more.
It is a shame that we cannot use this well-established protocol for
low-latency applications. We, effectively, have to duplicate all this
code on custom UDS and other transports just because DBus is too slow.

kdbus tries to unify those efforts, so that we don't need multiple
policy implementations, name registries and peer discovery mechanisms.
Furthermore, kdbus implements comprehensive, yet optional, metadata
transmission that allows to identify and authenticate peers in a
race-free manner (which is *not* possible with UDS).
Also, kdbus provides a single transport bus with sequential message
numbering. If you use multiple channels, you cannot give any ordering
guarantees across peers (for instance, regarding parallel
name-registry changes).


Given these theoretical advantages, here're some examples:

*) The Tizen developers have been complaining about the high latency
of DBus for polkit'ish policy queries. That's why their authentication
framework uses custom UDS sockets (called 'Cynara'). If a
UI-interaction needs multiple authentication-queries, you don't want
it to take multiple milliseconds, given that you usually want to
render the result in the same frame.

*) PulseAudio doesn't use DBus for data transmission. They had to
implement their own marshaling code, transport layer and so on, just
because DBus1-latency is horrible. With kdbus, we can basically drop
this code-duplication and unify the IPC layer. Same is true for
Wayland, btw.

*) By moving broadcast-transmission into the kernel, we can use the
time-slices of the sender to perform heavy operations. This is also
true for policy decisions, etc. With a userspace daemon, we cannot
perform operations in a time-slice of the caller. This makes DoS
attacks much harder.

*) With priority-inheritance, we can do synchronous calls into trusted
peers and let them optionally use our time-slice to perform the
action. This allows syscall-like/binder-like method-calls into other
processes. Without priority-inheritance, this is not possible in a
secure manner (see 'priority-inheritance').

*) Logging-daemons often want to attach metadata to log-messages so
debugging/filtering gets easier. If short-lived programs send
log-messages, the destination peer might not be able to read such
metadata from /proc, as the process might no longer be available at
that time. Same is true for policy-decisions like polkit does. You
cannot send off method-calls and exit. You have to wait for a reply,
even though you might not even care for it. If you don't wait, the
other side might not be able to verify your identity and as such
reject the request.

*) Even though the dbus traffic on idle-systems might be low, this
doesn't mean it's not significant at boot-times or under high-load. If
you run a dbus-monitor of your choice, you will see there is an
significant number of messages exchanged during VT-switches, startup,
shutdown, suspend, wakeup, hotplugging and similar situations where
lots of control-messages are exchanged. We don't want to spend
hundreds of ms just to transmit those messages.

*) dbus-daemon is not available during early-boot or shutdown.


These are just examples off the top of my head, but I think they're
already pretty convincing.
David
