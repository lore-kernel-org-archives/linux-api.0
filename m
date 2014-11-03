From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
Date: Mon, 3 Nov 2014 15:42:29 -0800
Message-ID: <CAGr1F2EophqP4h=KN1see3m0zG27+ZXqYZOTUO+RX6d2aRzZFA@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-6-git-send-email-adityakali@google.com>
	<CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
	<87y4rvspnd.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87y4rvspnd.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 5:58 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>> On Fri, Oct 31, 2014 at 12:18 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> <snip>
>
>>> +static void *cgroupns_get(struct task_struct *task)
>>> +{
>>> +       struct cgroup_namespace *ns = NULL;
>>> +       struct nsproxy *nsproxy;
>>> +
>>> +       rcu_read_lock();
>>> +       nsproxy = task->nsproxy;
>>> +       if (nsproxy) {
>>> +               ns = nsproxy->cgroup_ns;
>>> +               get_cgroup_ns(ns);
>>> +       }
>>> +       rcu_read_unlock();
>>
>> How is this correct?  Other namespaces do it too, so it Must Be
>> Correct (tm), but I don't understand.  What is RCU protecting?
>
> The code is not correct.  The code needs to use task_lock.
>
> RCU used to protect nsproxy, and now task_lock protects nsproxy.
> For the reasons of of all of this I refer you to the commit
> that changed this, and the comment in nsproxy.h
>

My bad. This should be under task_lock. I will fix it.

> commit 728dba3a39c66b3d8ac889ddbe38b5b1c264aec3
> Author: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Date:   Mon Feb 3 19:13:49 2014 -0800
>
>     namespaces: Use task_lock and not rcu to protect nsproxy
>
>     The synchronous syncrhonize_rcu in switch_task_namespaces makes setns
>     a sufficiently expensive system call that people have complained.
>
>     Upon inspect nsproxy no longer needs rcu protection for remote reads.
>     remote reads are rare.  So optimize for same process reads and write
>     by switching using rask_lock instead.
>
>     This yields a simpler to understand lock, and a faster setns system call.
>
>     In particular this fixes a performance regression observed
>     by Rafael David Tinoco <rafael.tinoco-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>.
>
>     This is effectively a revert of Pavel Emelyanov's commit
>     cf7b708c8d1d7a27736771bcf4c457b332b0f818 Make access to task's nsproxy lighter
>     from 2007.  The race this originialy fixed no longer exists as
>     do_notify_parent uses task_active_pid_ns(parent) instead of
>     parent->nsproxy.
>
>     Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>
> Eric



-- 
Aditya
