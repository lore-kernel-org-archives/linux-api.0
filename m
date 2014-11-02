From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Sat, 1 Nov 2014 18:21:30 -0700
Message-ID: <20141102012130.GA9335@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1410292354480.11562-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 12:00:16AM +0100, Jiri Kosina wrote:
> On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
>=20
> > kdbus is a kernel-level IPC implementation that aims for resemblanc=
e to
> > the the protocol layer with the existing userspace D-Bus daemon whi=
le
> > enabling some features that couldn't be implemented before in users=
pace.
>=20
> I'd be interested in the features that can't be implemented in usersp=
ace=20
> (and therefore would justify existence of kdbus in the kernel). Could=
 you=20
> please point me to such list / documentation?
>=20
> It seems to me that most of the highlight features from the cover let=
ter=20
> can be "easily" (for certain definition of that word, of course)=20
> implemented in userspace (vmsplice(), sending fd through unix socket,=
 user=20
> namespaces, UUID management, etc).

Sorry for the long delay in getting back to this, I'm battling a bad
case of jet-lag at the moment...

Here's some reasons why I feel it is better to have kdbus in the kernel
rather than trying to implement the same thing in a userspace daemon:

- performance: fewer process context switches, fewer copies, fewer
  syscalls, larger memory chunks via memfd.  This is really important
  for a whole class of userspace programs that are ported from other
  operating systems that are run on tiny ARM systems that rely on
  hundreds of thousands of messages passed at boot time, and at
  "critical" times in their user interaction loops.
- security: the peers which communicate do not have to trust each other=
,
  as the only trustworthy compoenent in the game is the kernel which
  adds metadata and ensures that all data passed as payload is either
  copied or sealed, so that the receiver can parse the data without
  having to protect against changing memory while parsing buffers.  Als=
o,
  all the data transfer is controlled by the kernel, so that LSMs can
  track and control what is going on, without involving userspace.
  Because of the LSM issue, security people are much happier with this
  model than the current scheme of having to hook into dbus to mediate
  things.
- more metadata can be attached to messages than in userspace
- semantics for apps with heavy data payloads (media apps, for instance=
)
  with optinal priority message dequeuing, and global message ordering.
  Some "crazy" people are playing with using kdbus for audio data in th=
e
  system.  I'm not saying that this is the best model for this, but
  until now, there wasn't any other way to do this without having to
  create custom "busses", one for each application library.
- being in the kernle closes a lot of races which can't be fixed with
  the current userspace solutions.  For example, with kdbus, there is a
  way a client can disconnect from a bus, but do so only if no further
  messages present in its queue, which is crucial for implementing
  race-free "exit-on-idle" services
- eavesdropping on the kernel level, so privileged users can hook into
  the message stream without hacking support for that into their
  userspace processes
- a number of smaller benefits: for example kdbus learned a way to peek
  full messages without dequeing them, which is really useful for
  logging metadata when handling bus-activation requests.=A0

Of course, some of the bits above could be implemented in userspace
alone, for example with more sophisticated memory management APIs, but
this is usually done by losing out on the other details.  For example,
for many of the memory management APIs, it's hard to not require the
communicating peers to fully trust each other.  And we _really_ don't
want peers to have to trust each other.

Another benefit of having this in the kernel, rather than as a userspac=
e
daemon, is that you can now easily use the bus from the initrd, or up t=
o
the very end when the system shuts down.  On current userspace D-Bus,
this is not really possible, as this requires passing the bus instance
around between initrd and the "real" system.  Such a transition of all
fds also requires keeping full state of what has already been read from
the connection fds.  kdbus makes this much simpler, as we can change th=
e
ownership of the bus, just by passing one fd over from one part to the
other.

Regarding binder: binder and kdbus follow very different design
concepts.  Binder implies the use of thread-pools to dispatch incoming
method calls.  This is a very efficient scheme, and completely natural
in programming languages like Java.  On most Linux programs, however,
there's a much stronger focus on central poll() loops that dispatch all
sources a program cares about.  kdbus is much more usable in such
environments, as it doesn't enforce a threading model, and it is happy
with serialized dispatching.  In fact, this major difference had an
effect on much of the design decisions: binder does not guarantee globa=
l
message ordering due to the parallel dispatching in the thread-pools,
but=A0 kdbus does.  Moreover, there's also a difference in the way mess=
age
handling.  In kdbus, every message is basically taken and dispatched as
one blob, while in binder, continious connections to other peers are
created, which are then used to send messages on.  Hence, the models ar=
e
quite different, and they serve different needs.  I believe that the
D-Bus/kdbus model is more compatible and friendly with how Linux
programs are usually implemented.=A0 I went into the kdbus vs. binder
stuff in a blog post that I linked to earlier in this thread that goes
into more detail here.

Hopefully this helps explain why I feel kdbus should be in the kernel
and not a userspace daemon.  I'll put this information in the cover
letter for the next round of patches that are sent out.

thanks,

greg k-h
