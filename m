From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 11:15:35 +0100
Message-ID: <CAG-2HqUChohNrRSdXzckSiv8ZUYwFLMvRTc41Uo7-b-qmkSFMQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
	<20141029222729.GB8129@kroah.com>
	<CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
	<87bnourxx4.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87bnourxx4.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On Thu, Oct 30, 2014 at 5:20 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> The userspace API breaks userspace in an unfixable way.
>
> Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>
> Problem the first.
> - Using global names for containers makes it impossible to create
>   unprivileged containers.

I don't follow.

Just so we are on the same page:
  - creating a domain per container is only a convention, and has to
be done manually. I.e., the worst case scenario is that you are able
to create some container which cannot get a corresponding kdbus
domain.
  - domain names are only unique per parent-domain, and domains are
fully recursive. We explicitly tested recursive domains by running
kdbus-enabled containers within kdbus-enabled containers, a number of
iterations deep.

Could you explain the problem you see in more detail? This might just
be a documenation issue, after all.

>   This is a back to the drawing board problem, and makes device
>   nodes fundamentally unsuited to what you are doing.
>
>   There is no way that I can see to make it safe for an unprivileged
>   user to create arbitrary named busses.  Especially in the presence
>   of allowing unprivileged checkpoint/restart.

Note that unprivileged users cannot create arbitrary named busses, the
names must have the format $PID-<arbitrary name>. Do you see a problem
with this?

>   This is particularly bad as kdbus explicitly allows unprivielged
>   creation of new kdbus instances.

What do you mean by kdbus instance? A new domain? This is not allowed
by unprivileged processes. Or do you mean a new bus, in which case see
above.

>   This problem is a userspace regression.

This is all new functionality, how does it affect current code?

> Problem the second.
> - The security checks in the code are not based on who opens the
>   file descriptors but instead based on who is used the file
>   descriptors at any give moment.
>
>   That pattern has been shown to be exploitable.
>
>   I expect the policy database makes this poor choice of permission
>   checks even worse.  Pass a more privileged user a kdbus file
>   descriptor and all of sudden things that were not possible on
>   that file descriptor become possible.

Djalal already commented on this point in another thread. But just to
recap: Please note that we do not do read()/write() at all, only
ioctl's, so the most common exploits do not apply. Moreover, we are
following the same API pattern as used by other similar APIs in the
kernel. With that in mind, could you give some more specific
information about what kind of exploits you imagine?

> Problem the third.
> - You are using device numbers for things created by unprivileged
>   users.  That breaks checkpoint/restart.  Aka CRIU.
>
>   We can not migrate a container to a new machine and preserve the
>   device numbers.

I must admit to not being too familiar with checkpoint/restart. What
precisely is the problem with unprivileged users?

>   We can not migrate a container to a new machine and have any hope
>   of preserving the container patsh under /dev/kdbus/...

You may not be able to preserve the full path, no, but the container
should not know/care about the parent paths anyway.  Note that the
containers only see their own domain subtree mounted to /dev/kdbus,
they see nothing from the parent. Hence when you migrate containers
you can change the naming of the parent freely, but the processes
inside the containers won't see that, they'll have stable paths.   I'm
not seeing the problem here, care to elaborate?

> I think a kdbusfs modeled on devpts with newinstance at
> mount time would solve the naming problems.

Effectively, what we have in place in the current patch set delivers
similar semantics, however without introducing a new file system. You
just create a new domain and get a new subdir in /dev/kdbus/ for it,
and then inside the container you mount that subdir of /dev/kdbus onto
/dev/kdbus itself.

Do I understand you correctly that what you want is unnamed/anonymous
domains? Considering that domain creation is anyway privileged, why is
this necessary?

> That would break one of the current kdbus use cases that allows an
> unprivileged user to create a bus.

That is a fundamental usecase, so I don't think it makes much sense to
do anything that precludes that.

Cheers,

Tom
