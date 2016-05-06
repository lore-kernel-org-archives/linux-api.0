From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mountinfo: implement show_path for kernfs and cgroup
Date: Fri, 6 May 2016 19:42:48 +0200
Message-ID: <CAKgNAkhCZrZevznOX_PqcckX0oJEMYbOir1tK7J+4qKtzUBwpg@mail.gmail.com>
References: <20160505152058.GC13186@mail.hallyn.com>
	<6db5b7e5-3f15-39bd-cc9e-e3c296378e54@gmail.com>
	<20160506173356.GA1228@mail.hallyn.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160506173356.GA1228-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Serge,

On 6 May 2016 at 19:33, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>> Hi Serge,
>>
>> I'll add my own notes below, as much as anything in order to convince
>> myself that I understand what's going on.
>>
>> On 05/05/2016 05:20 PM, Serge E. Hallyn wrote:
>> > Short explanation:
>> >
>> > When showing a cgroupfs entry in mountinfo, show the path of the mount
>> > root dentry relative to the reader's cgroup namespace root.
>>
>> As part of the commit message, I think it would be useful to add a
>> sentence here explain why this is needed / which applications need it.
>>
>> > Long version:
>> >
>> > When a uid 0 task which is in freezer cgroup /a/b, unshares a new cgroup
>> > namespace, and then mounts a new instance of the freezer cgroup, the new
>> > mount will be rooted at /a/b.  The root dentry field of the mountinfo
>> > entry will show '/a/b'.
>>
>> So, the point is that if we create a new cgroup namespace,
>> then we want both /proc/self/cgroup and /proc/self/mountinfo
>> to show cgroup paths that are correctly virtualized with
>> respect to the cgroup mount point. Previous to this patch,
>> /proc/self/cgroup shows the right info, but
>> /proc/self/mountinfo does not. (Walk through in a moment.)
>>
>> Is the above a correct summary?

Feel free to add that piece to the commit message :-).

[...]

>> So, I applied your patch against a current (i.e., 4.6-rc6) kernel.
>> Same steps as before, and here's what I see:
>>
>> # mkdir -p /sys/fs/cgroup/freezer/a/b
>> # echo $$ > /sys/fs/cgroup/freezer/a/b/cgroup.procs
>> # ./cgroup_info.sh
>>       /proc/self/cgroup:      10:freezer:/a/b
>>       mountinfo:              /       /sys/fs/cgroup/freezer
>> # ~mtk/tlpi/code/ns/unshare -Cm bash
>> # ./cgroup_info.sh
>>       /proc/self/cgroup:      10:freezer:/
>>       mountinfo:              /../..  /sys/fs/cgroup/freezer
>> # mount --make-rslave /
>> # mkdir -p /mnt/freezer
>> # umount /sys/fs/cgroup/freezer
>> # mount -t cgroup -o freezer freezer /mnt/freezer/
>> # ./cgroup_info.sh
>>       /proc/self/cgroup:      10:freezer:/
>>       mountinfo:              /       /mnt/freezer
>>
>> Now the root directory path shown by mountinfo is correct,
>> and when we look inside the mount point, we see that things
>> look "right" (i.e., a cgroup root directory with no
>> subdirectories, and the PID of the shell run by unshare is
>> in the cgroup.procs file of this cgroup):
>>
>> # ls /mnt/freezer/
>> cgroup.clone_children  freezer.parent_freezing  freezer.state      tasks
>> cgroup.procs           freezer.self_freezing    notify_on_release
>> # echo $$
>> 3164
>> # cat /mnt/freezer/cgroup.procs
>> 2653                   # First shell that placed in this cgroup
>> 3164                   # Shell started by 'unshare'
>> 14197                  # cat(1)
>>
>> All makes sense to me.
>
> Right.  So in particular, docker wants to do something like:
>
> bindpath=`grep freezer /proc/self/mountinfo | tail -n 1 | awk '{ print $4 }'`
> mountpoint=`grep freezer /proc/self/mountinfo | tail -n 1 | awk '{ print $5 }'`
> mycg=`awk -F: '/freezer/ { print $3 }' /proc/self/cgroup`
> cat ${mountpoint}/${bindpath}/${mycg}/cgroup.procs
>
> and see its own task.

I think that'd be a great piece to include in the commit message, near
the top, as rationale for the patch

>> Tested-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Acked-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> (I did no review of the patch itself though.)
>
> Thanks, Michael.

You're welcome.

> I'll resend with corrections and a test script of
> some sort.

I think including some version of the two walk thoughs (without + with
patch) would also make for a great commit message :-).

Cheers,

Michael

[...]
