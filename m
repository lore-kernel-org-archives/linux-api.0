From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Fri, 31 Oct 2014 20:29:15 -0700
Message-ID: <CALCETrWTtGH=q0kD=hFv=LryA+h=K3yCV4_CmgD=TMbuaW3LrA@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
	<87a94blj6m.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87a94blj6m.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 7:59 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>> @@ -1862,6 +1904,7 @@ static struct file_system_type cgroup_fs_type = {
>>>         .name = "cgroup",
>>>         .mount = cgroup_mount,
>>>         .kill_sb = cgroup_kill_sb,
>>> +       .fs_flags = FS_USERNS_MOUNT,
>>
>> Aargh, another one!  Eric, can you either ack or nack my patch?
>> Because if my patch goes in, then this line may need to change.  Or
>> not, but if a stable release with cgroupfs and without my patch
>> happens, then we'll have an ABI break.
>
> cgroupfs has no device nodes.  So as long as we are consistent in any
> given release what happens here is orthogonal.
>
> I don't remember if we have managed to get the original problem fixed
> with the trivial backportable solution.  I think so.

I don't remember.  I think the problem is still there, since I think
my patch still applies, and my patch conflicts with your fix.  It's
been long enough that I'm not sure it's worth applying your patch as
an interim fix.

>
> My apologies for not getting to that I haven't even had time to shepherd
> through the regression associated regression fix.  I probably just lock
> track of them but I haven't found the Tested-By's for it yet.

No worries.  I've tested it, but it's my patch, so there's a big grain
of salt there.  I think Serge tested it, too.

>
> Nor have I had time to dig through and figure out how to safely deal
> with umount -l aka MOUNT_DETACH.

If you're talking about the do_remount_sb thing, that's already in Linus' tree.

>
> Along with the question about what to do with nodev, there is also
> your patch about nosuid.

The nosuid patch has a couple versions, and I'm not sure which version
I prefer.  It's certainly debatable.

>
> Starting in about 5 minutes I am going to be mostly offline until
> sometime in the 3rd week in November as I haul all of my stuff accross
> the country to someplace that actually has winter and my allergies don't
> kill me.

Have fun!

--Andy

>
> I am going to have to review and merge a lot of code as soon as I am
> back to being a programmer full time again.  There is a lot of
> interesting stuff coming in right now.
>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
