From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [CFT][PATCH 0/10] Making new mounts of proc and sysfs as safe as
 bind mounts
Date: Thu, 14 May 2015 23:26:48 -0700
Message-ID: <CALCETrU1yxcDfv4YV3wVpWMAdiOOsSUFOPUpFAN-mVA4M-OxdQ@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <20150514202951.GA16416@kroah.com>
 <87oalmg90j.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87oalmg90j.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 2:10 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:
>
>> On Thu, May 14, 2015 at 12:30:45PM -0500, Eric W. Biederman wrote:
>>>
>>> The code is currently available at:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
>>>
>>>    HEAD: a524faf520600968e58bbc732063fccf2fdf9199 mnt: Update fs_fully_visible to test for permanently empty directories
>>>
>>> The problem:  Mounting a new instance of proc of sysfs can allow things
>>> that a bind mount of those filesystems would not.
>>>
>>> That is the cases I am dealing with are:
>>>      unshare --user --net --mount ; mount -t sysfs ...
>>>      unshare --user --pid --mount ; mount -t proc ...
>>>
>>> The big change is that this set of changes enforces the preservation of
>>> locked mount flags, from the existing mount to the current mount.  Which
>>> means that if proc was mounted read-only the current current will allow
>>> a new instance of proc to be mounted read-write, and this set of changes
>>> enforces that proc remain read-only.
>>>
>>> The other gotcha is that the current code does not properly detect empty
>>> directories so to prevent things slipping through the cracks this set of
>>> changes annotates all mount points where nothing will be revealed if
>>> the filesystem mounted on top is removed.
>>>
>>> Enforcing the administrators policy can actually matter in the real
>>> world as has been shown by the recent docker issue.
>>>
>>> With this patchset I have two concerns:
>>> - The enforcement of mount flag preservation on proc and sysfs may break
>>>   things.  (I am especially worried about the implicit adding of nodev).
>>
>> What do you mean by this?  What got added?
>
> In a user namespace mounting a filesystem implicitly adds nodev.
>
> When I started enforcing not clearing bits that root had set on a
> filesystem in mount -o remount the implicit nodev wound up being
> an issue that broke userspace for no good reason.  The fix was
> to implicitly add nodev in remount as well.
>
> Taking a second look at this nodev is implicitly added before the
> fs_fully_visible check so even for applications that are know how the
> original proc was mounted (and don't see an implicit nodev) and that
> don't add nodev (because they ''know'' the mount flags) this change
> should not be a problem.  Hooray!  One less scary thing.

Can we please just get rid of this implicit nodev thing once and for all?  If it
breaks some really weird /proc use case, then I think the right fix is to
stop enforcing the nodev lock for the proc fully visible check.  After
all, /proc doesn't contain useful device nodes anyway.

Other than that, the code here looks okay to me on brief inspection.

--Andy
