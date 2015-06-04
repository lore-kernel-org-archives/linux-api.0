From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as
	bind mounts (take 2)
Date: Thu, 04 Jun 2015 02:34:47 -0500
Message-ID: <8738283p0o.fsf@x220.int.ebiederm.org>
References: <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
	<20150528140839.GD28842@ubuntumail>
	<87lhg8pwvz.fsf@x220.int.ebiederm.org>
	<CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
	<CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com>
	<87fv6gikfn.fsf@x220.int.ebiederm.org>
	<CALCETrXO21Y7PR=pKqaqJb1YZArNyjAv7Z-J44O53FcfLM_0Tw@mail.gmail.com>
	<87fv6g80g7.fsf@x220.int.ebiederm.org>
	<CALCETrVEA0Ug+3aj5rjupqZub-1tPLw+szzbs4kTyEyVvNs7qg@mail.gmail.com>
	<87k2vkebri.fsf@x220.int.ebiederm.org>
	<20150604051958.GA21049@kroah.com>
	<87h9qo6la9.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87h9qo6la9.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Thu, 04 Jun 2015 01:27:10 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:
>
>> On Wed, Jun 03, 2015 at 04:13:21PM -0500, Eric W. Biederman wrote:
>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>> 
>>> > One option would be to break the nosuid, nodev, and noexec parts into
>>> > their own patch and then avoid tagging that patch for -stable if at
>>> > all possible.  It would be nice to avoid another -stable ABI break if
>>> > at all possible.
>>> 
>>> So I don't think we actually have anything that could be called an ABI
>>> break in the whole mess, but it is definitely a behavioral change that
>>> is a regression for lxc and libvirt-lxc that prevents them from starting.
>>> 
>>> nodev does not actually matter because of the implicit silliness that
>>> is being added right now.
>>> 
>>> We do want those programs fixed and after those programs are fixed we
>>> can safely begin failing mount when those attributes are being cleared
>>> in a fresh mount.
>>> 
>>> So it looks to me like the best thing to do is to print a warning
>>> whenever lxc or libvirt-lxc gets it wrong, which should ensure the
>>> authors are sufficiently pestered that in a kernel release or 3 we can
>>> begin enforcing those attributes.  Especially as the discussion on the
>>> fix for those applications has already begun.
>>
>> "pestering" never works, look at some of the SCSI drivers for examples
>> of how a distro will just patch out the "warning this driver is using an
>> old api and needs to be fixed" messages.
>
>> You can't break stuff like this, people will get upset :(
>
> A) To the best of my knowledge there are two programs on the face of the
>    planet where this matters. (lxc and libvirt-lxc)
>
> B) The code in those two programs is buggy.  That is the code in those
>    two programs does not do what the authors intended.  That is fixing
>    those programs is something that should be done regardless of what
>    I do in the kernel.  I have already reached out to the developers of
>    those programs.  The pestering in the kernel is a form of reminder,
>    not the primary source of communication.
>
> C) These bugs really are security holes.  Currently they do not appear
>    exploitable (thank goodness) but they are security holes.
>
>    Since they are not currently exploitable it does make sense
>    to give people a little time to get their act together.
>
>    The bugs are larger then the case that is being hit here,
>    this is just where they are noticed.
>
> D) Letting people know that there is a problem as part of a larger
>    effort has actually worked for me.  Distro's have stopped enabling
>    the sysctl system call.
>
> E) Given that I have not audited sysfs and proc closely in recent years
>    I may actually be wrong.  Those bugs may actually be exploitable.
>    All it takes is chmod to be supported on one file that can be made
>    executable.  That bug has existed in the past and I don't doubt
>    someone will overlook something and we will see the bug again in the
>    future.
>
> So it is my best judgment that I disable the code that stops
> containers from starting and just making it a warning (for now).
> Then in a release or so I start failing these operations instead of
> warning.
>
> This is the most fair and reasonable I can see to be.
>
> The only other choice I can see is to say I don't care it is a security
> issue I am breaking your sloopy insecure code.
>
> Am I being too nice with these security bugs?

Thinking about it a little more.  There is a possibility that sometime
in the future that someone will deliberately add a suid executable as a
file in proc or sysfs and have a good reason for doing so.

Some sysadmin or sandbox builder with special requirements may then
disable suid and exec on proc because in their sandbox (not linux in
general) having access to that executable is a bad thing.  At which
we have an exploitable security issue if nosuid and noexec are not
enforced.

Or in other words I am not smarter than the bad guys.  This is a
security issue.  I can not ignore nosuid and noexec indefinitely.
I have to make those cases fail at some point.  At that point
current unfixed versions of lxc and libvirt-lxc will break.

A warning is the nicest I can imagine being.

Eric
