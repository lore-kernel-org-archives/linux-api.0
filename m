From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Mon, 20 Oct 2014 22:03:46 -0700
Message-ID: <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-8-git-send-email-adityakali@google.com>
	<20141016211236.GA4308@mail.hallyn.com>
	<CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
	<20141016214710.GA4759@mail.hallyn.com>
	<87iojgmy3o.fsf@x220.int.ebiederm.org>
	<CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
	<44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com>
	<CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
	<87zjcq10ya.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87zjcq10ya.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 9:49 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>> On Sun, Oct 19, 2014 at 9:55 PM, Eric W.Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>
>>> On October 19, 2014 1:26:29 PM CDT, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
>>>> Is the idea
>>>>that you want a privileged user wrt a cgroupns's userns to be able to
>>>>use this?  If so:
>>>>
>>>>Yes, that current_cred() thing is bogus.  (Actually, this is probably
>>>>exploitable right now if any cgroup.procs inode anywhere on the system
>>>>lets non-root write.)  (Can we have some kernel debugging option that
>>>>makes any use of current_cred() in write(2) warn?)
>>>>
>>>>We really need a weaker version of may_ptrace for this kind of stuff.
>>>>Maybe the existing may_ptrace stuff is okay, actually.  But this is
>>>>completely missing group checks, cap checks, capabilities wrt the
>>>>userns, etc.
>>>>
>>>>Also, I think that, if this version of the patchset allows non-init
>>>>userns to unshare cgroupns, then the issue of what permission is
>>>>needed to lock the cgroup hierarchy like that needs to be addressed,
>>>>because unshare(CLONE_NEWUSER|CLONE_NEWCGROUP) will effectively pin
>>>>the calling task with no permission required.  Bolting on a fix later
>>>>will be a mess.
>>>
>>> I imagine the pinning would be like the userns.
>>>
>>> Ah but there is a potentially serious issue with the pinning.
>>> With pinning we can make it impossible for root to move us to a different cgroup.
>>>
>>> I am not certain how serious that is but it bears thinking about.
>>> If we don't implement pinning we should be able to implent everything with just filesystem mount options, and no new namespace required.
>>>
>>> Sigh.
>>>
>>> I am too tired tonight to see the end game in this.
>>
>> Possible solution:
>>
>> Ditch the pinning.  That is, if you're outside a cgroupns (or you have
>> a non-ns-confined cgroupfs mounted), then you can move a task in a
>> cgroupns outside of its root cgroup.  If you do this, then the task
>> thinks its cgroup is something like "../foo" or "../../foo".
>
> Of the possible solutions that seems attractive to me, simply because
> we sometimes want to allow clever things to occur.
>
> Does anyone know of a reason (beyond pretty printing) why we need
> cgroupns to restrict the subset of cgroups processes can be in?
>
> I would expect permissions on the cgroup directories themselves, and
> limited visiblilty would be (in general) to achieve the desired
> visiblity.

This makes the security impact of cgroupns very easy to understand,
right?  Because there really won't be any -- cgroupns only affects
reads from /proc and what cgroupfs shows, but it doesn't change any
actual cgroups, nor does it affect any cgroup *changes*.

>
>> While we're at it, consider making setns for a cgroupns *not* change
>> the caller's cgroup.  Is there any reason it really needs to?
>
> setns doesn't but nsenter is going to need to change the cgroup
> if the pinning requirement is kept.  nsenenter is going to want to
> change the cgroup if the pinning requirement is dropped.
>

It seems easy enough for nsenter to change the cgroup all by itself.

--Andy
