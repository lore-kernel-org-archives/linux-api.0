From: Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as
	bind mounts (take 2)
Date: Thu, 28 May 2015 11:20:07 -0700
Message-ID: <CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
	<87wq004im1.fsf@x220.int.ebiederm.org>
	<CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
	<20150528140839.GD28842@ubuntumail>
	<87lhg8pwvz.fsf@x220.int.ebiederm.org>
	<CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 28, 2015 at 10:33 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Thu, May 28, 2015 at 8:03 AM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
>>
>>> Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
>>>> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
>>>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>> > I had hoped to get some Tested-By's on that patch series.
>>>>
>>>> Sorry, I've been totally swamped.
>>>>
>>>> I suspect that Sandstorm is okay, but I haven't had a chance to test
>>>> it for real.  Sandstorm makes only limited use of proc and sysfs in
>>>> containers, but I'll see if I can test it for real this weekend.
>>>
>>> Testing this with unprivileged containers, I get
>>>
>>> lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted
>>> - error mounting sysfs on
>>> /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
>>
>> Grr..  I was afraid this would break something. :(
>>
>> Looking at my system I see that sysfs is currently mounted
>> "nosuid,nodev,noexec"
>>
>> Looking at the lxc-start code I don't see it as including any of those
>> mount options.  In practice for sysfs I think those options are
>> meaningless (as there should be no devices and nothing executable in
>> sysfs) but I can understand the past concerns with chmod on virtual
>> filesystems that would incline people to use them, so I think the
>> failure is reporting a legitimate security issue in the lxc userspace
>> code where the the unprivileged code is currently attempting to give
>> greater access to sysfs than was given by the original mount of sysfs.
>>
>> As nosuid,nodev,noexec should not impair the operation of sysfs
>> operation it looks like you can always specify those options and just
>> make this concern go away.
>
> Linus is pretty strict about not breaking the ABI, and this definitely
> counts as breaking the ABI.  There's an exception for security issues,
> but is there really a security issue here?  That is, do we lose
> anything important if we just drop the offending part of the patch
> set?  As you've said, there shouldn't be sensitive device nodes,
> executables, or setuid files in proc or sysfs in the first place.

Speaking as a user of the mount() interfaces, I really think it would
be less confusing overall if mount() simply ignored the requested
flags when the caller doesn't have a choice. That is, in cases where
mount() currently fails with EPERM when not given, say, MS_NOSUID, it
should instead just pretend the caller actually set MS_NOSUID and go
ahead with a nosuid mount. Or put another way, the absence of
MS_NOSUID should not be interpreted as "remove the nosuid bit" but
rather "don't set the nosuid bit if not required".

Consider:

- This approach will actually cause lxc to have the correct behavior,
without any changes to lxc. I suspect that this generalizes: In the
vast majority of cases, when users have failed to set MS_NOSUID, it's
not because they are explicitly requesting that the flag be turned
off, but rather that they didn't know it mattered.

- If a user actually *does* expect not passing MS_NOSUID to remove the
nosuid bit, and they find instead that the nosuid bit is silently
kept, I don't think they'll be confused: it's pretty obvious in
context that this must be for security reasons.

- On the other hand, the current behavior *is* very confusing: mount()
returns EPERM because of rules the caller probably doesn't know
anything about. I've spent a fair amount of time frustrated by this
sort of thing.

-Kenton
