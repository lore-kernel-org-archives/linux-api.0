From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 21:20:23 -0700
Message-ID: <87bnourxx4.fsf@x220.int.ebiederm.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
	<20141029222729.GB8129@kroah.com>
	<CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Wed, 29 Oct 2014 19:27:54 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


The userspace API breaks userspace in an unfixable way.

Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Problem the first.
- Using global names for containers makes it impossible to create
  unprivileged containers.

  This is a back to the drawing board problem, and makes device
  nodes fundamentally unsuited to what you are doing.

  There is no way that I can see to make it safe for an unprivileged
  user to create arbitrary named busses.  Especially in the presence
  of allowing unprivileged checkpoint/restart.

  This is particularly bad as kdbus explicitly allows unprivielged
  creation of new kdbus instances.

  This problem is a userspace regression.

Problem the second.
- The security checks in the code are not based on who opens the
  file descriptors but instead based on who is used the file
  descriptors at any give moment.

  That pattern has been shown to be exploitable.

  I expect the policy database makes this poor choice of permission
  checks even worse.  Pass a more privileged user a kdbus file
  descriptor and all of sudden things that were not possible on
  that file descriptor become possible.

Problem the third.
- You are using device numbers for things created by unprivileged
  users.  That breaks checkpoint/restart.  Aka CRIU.

  We can not migrate a container to a new machine and preserve the
  device numbers.  

  We can not migrate a container to a new machine and have any hope
  of preserving the container patsh under /dev/kdbus/...

  Both of which look like fundamental show stoppers for
  checkpoint/restart.

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Wed, Oct 29, 2014 at 3:27 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
>>> (reply 1/2 -- I'm replying twice to keep the threading sane)
>>>
>>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>>> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>>> > kdbus is a kernel-level IPC implementation that aims for resemblance to
>>> > the the protocol layer with the existing userspace D-Bus daemon while
>>> > enabling some features that couldn't be implemented before in userspace.
>>> >
>>>
>>> >  * Support for multiple domains, completely separated from each other,
>>> >    allowing multiple virtualized instances to be used at the same time.
>>>
>>> Given that there is no such thing as a device namespace, how does this work?
>>
>> See the document for the details.
>
> They seem insufficient to me, so I tried to dig in to the code.  My
> understanding is:
>
> The parent container has /dev mounted.  It sends an IOCTL (which
> requires global capabilities).  In response, kdbus creates a whole
> bunch of devices that get put (by udev or devtmpfs, I presume) in a
> subdirectory.  Then the parent container mounts that subdirectory in
> the new container.
>
> This is IMO rather problematic.
>
> First, it enforces the existence of a kdbus domain hierarchy where
> none should be needed.
>
> Second, it's incompatible with nested user namespaces.  The middle
> namespace can't issue the ioctl.
>
> Third, it requires a devtmpfs submount in the child container.  This
> scares me, especially since there are no device namespaces.  Also, the
> child container appears to be dependent on the host udev to arbitrate
> everything, which seems totally wrong to me.  (Also, now we're exposed
> to attacks where the child container creates busses or endpoints or
> whatever with malicious names to try to trick the host into screwing
> up.)
>
> ISTM this should be solved either with device namespaces (which is
> well known to be a giant can of worms) or by abandoning the concept of
> kdbus using device nodes entirely.
>
> What if kdbus were kdbusfs?  If you want to use it in a container, you
> mount a brand-new kdbusfs there.  No weird domain hierarchy, no global
> privilege, no need to name containers, obvious migration semantics, no
> dependence on udev/devtmpfs at all, etc.
>
> Eric, any thoughts here?

I think a kdbusfs modeled on devpts with newinstance at
mount time would solve the naming problems.

That would break one of the current kdbus use cases that allows an
unprivileged user to create a bus.

Eric

p.s.  Please excuse my brevity I have am in the middle of packing up my
possessions (including my main machine), as I move this week.
