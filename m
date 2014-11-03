From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Mon, 3 Nov 2014 14:56:47 -0800
Message-ID: <CALCETrXB1CwASpTNSAE5_hOHGdAsJkZ1cmRpB2JTMdJQt+Dj9A@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<87y4rvrakn.fsf@x220.int.ebiederm.org>
	<CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 2:43 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On Fri, Oct 31, 2014 at 6:09 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> wrote:
>>
>> Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>>
>> > This patch enables cgroup mounting inside userns when a process
>> > as appropriate privileges. The cgroup filesystem mounted is
>> > rooted at the cgroupns-root. Thus, in a container-setup, only
>> > the hierarchy under the cgroupns-root is exposed inside the container.
>> > This allows container management tools to run inside the containers
>> > without depending on any global state.
>> > In order to support this, a new kernfs api is added to lookup the
>> > dentry for the cgroupns-root.
>>
>> There is a misdesign in this.  Because files already exist we need the
>> protections that are present in proc and sysfs that only allow you to
>> mount the filesystem if it is already mounted.  Otherwise you can wind
>> up mounting this cgroupfs in a chroot jail when the global root would
>> not like you to see it.  cgroupfs isn't as bad as proc and sys but there
>> is at the very least an information leak in mounting it.
>>
>
> I think simply mounting the cgroupfs doesn't give you any more information
> than what you don't already know about the system ; specially if the
> visibility is restricted within the process's cgroupns-root. The cgroups
> still wont be writable by the user, so I think it should be fine to allow
> mounting?
>

Can we try to figure out a better way to do this than checking at
mount time for a fully-visible procfs/sysfs/cgroupfs?  The current
approach is unpleasant to deal with.

For example, we could check the equivalent conditions when the userns
is created and store then in a per-userns flags field.

>
>>
>> Given that we are effectively performing a bind mount in this patch, and
>> that we need to require cgroupfs be mounted anyway (to be safe).
>>
>> I don't see the point of this change.
>>
>> If we could change the set of cgroups or visible in cgroupfs I could
>> probably see the point.  But as it is this change seems to be pointless.
>>
>
> I agree that this is effectively bind-mounting, but doing this in kernel
> makes it really convenient for the userspace. The process that sets up the
> container doesn't need to care whether it should bind-mount cgroupfs inside
> the container or not. The tasks inside the container can mount cgroupfs on
> as-needed basis. The root container manager can simply unshare cgroupns and
> forget about the internal setup. I think this is useful just for the reason
> that it makes life much simpler for userspace.
>

If we add the fully-visible check at mount time, then I almost agree
with Eric.  I say almost because fs_fully_visible isn't checking
whether the superblock root is the thing that's mounted, and, if we
fix that, then bind-mounting like this becomes impossible and we'd
have to refine the check.

But if we come up with something less gross than checking for fs
visibility at mount time, then I agree with Aditya: let's let mount do
the right thing, since there may be nothing there to bind mount.  If
we go that route, then I think we might want to make it explicit:
require a mount flag like root=. to indicate that we want to be rooted
at our cgroupns's root cgroup.

--Andy
