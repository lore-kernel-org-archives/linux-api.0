From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 19:27:54 -0700
Message-ID: <CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com> <20141029222729.GB8129@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141029222729.GB8129-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 3:27 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
>> (reply 1/2 -- I'm replying twice to keep the threading sane)
>>
>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> > kdbus is a kernel-level IPC implementation that aims for resemblance to
>> > the the protocol layer with the existing userspace D-Bus daemon while
>> > enabling some features that couldn't be implemented before in userspace.
>> >
>>
>> >  * Support for multiple domains, completely separated from each other,
>> >    allowing multiple virtualized instances to be used at the same time.
>>
>> Given that there is no such thing as a device namespace, how does this work?
>
> See the document for the details.

They seem insufficient to me, so I tried to dig in to the code.  My
understanding is:

The parent container has /dev mounted.  It sends an IOCTL (which
requires global capabilities).  In response, kdbus creates a whole
bunch of devices that get put (by udev or devtmpfs, I presume) in a
subdirectory.  Then the parent container mounts that subdirectory in
the new container.

This is IMO rather problematic.

First, it enforces the existence of a kdbus domain hierarchy where
none should be needed.

Second, it's incompatible with nested user namespaces.  The middle
namespace can't issue the ioctl.

Third, it requires a devtmpfs submount in the child container.  This
scares me, especially since there are no device namespaces.  Also, the
child container appears to be dependent on the host udev to arbitrate
everything, which seems totally wrong to me.  (Also, now we're exposed
to attacks where the child container creates busses or endpoints or
whatever with malicious names to try to trick the host into screwing
up.)

ISTM this should be solved either with device namespaces (which is
well known to be a giant can of worms) or by abandoning the concept of
kdbus using device nodes entirely.

What if kdbus were kdbusfs?  If you want to use it in a container, you
mount a brand-new kdbusfs there.  No weird domain hierarchy, no global
privilege, no need to name containers, obvious migration semantics, no
dependence on udev/devtmpfs at all, etc.

Eric, any thoughts here?

--Andy
