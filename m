From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Wed, 3 May 2017 13:20:58 +0300
Message-ID: <db243b0d-6fca-88d5-4a3f-2ef179fe1291@virtuozzo.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
 <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
 <20170426155352.GA12131@redhat.com>
 <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
 <20170427161255.GA19350@redhat.com>
 <fdd61d9c-6f88-1669-4d12-31748395fe99@virtuozzo.com>
 <20170427162254.GB19579@redhat.com>
 <43249645-f621-511e-dfa8-7bd78c547d2c@virtuozzo.com>
 <20170502163324.GA25036@redhat.com>
 <de392430-18b8-d296-b868-82fdedcd0c0e@virtuozzo.com>
 <8737cngdxi.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8737cngdxi.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03.05.2017 00:13, Eric W. Biederman wrote:
> Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
> 
>> On 02.05.2017 19:33, Oleg Nesterov wrote:
>>> sorry for delay, vacation...
>>>
>>> On 04/28, Kirill Tkhai wrote:
>>>>
>>>> On 27.04.2017 19:22, Oleg Nesterov wrote:
>>>>>
>>>>> Ah, OK, I didn't notice the ns->child_reaper check in pidns_for_children_get().
>>>>>
>>>>> But note that it doesn't need tasklist_lock too.
>>>>
>>>> Hm, are there possible strange situations with memory ordering, when we see
>>>> ns->child_reaper of already died ns, which was placed in the same memory?
>>>> Do we have to use some memory barriers here?
>>>
>>> Could you spell please? I don't understand your concerns...
>>>
>>> I don't see how, say,
>>>
>>> 	static struct ns_common *pidns_for_children_get(struct task_struct *task)
>>> 	{
>>> 		struct ns_common *ns = NULL;
>>> 		struct pid_namespace *pid_ns;
>>>
>>> 		task_lock(task);
>>> 		if (task->nsproxy) {
>>> 			pid_ns = task->nsproxy->pid_ns_for_children;
>>> 			if (pid_ns->child_reaper) {
>                             ^^^^^^^^^^^^^^^^^^^^
>                             Oleg my apologies I missed this line earlier.
>                             This does look like a valid way to skip read_lock(&tasklist_lock);
>>> 				ns = &pid_ns->ns;
>>> 				get_pid_ns(ns);
>                                 ^^^^^^^^^^^^^ This needs to be:
>                                 get_pid_ns(pid_ns);
>                                 
>>> 			}
>>> 		}
>>> 		task_unlock(task);
>>>
>>> 		return ns;
>>> 	}
>>>
>>> can be wrong. It also looks more clean to me.
>>>
>>> ->child_reaper is not stable without tasklist, it can be dead/etc, but
>>> we do not care?
>>
>> I mean the following. We had a pid_ns1 with a child_reaper set. Then
>> it became dead, and a new pid_ns2 were allocated in the same memory.
> 
> task->nsproxy->pid_ns_for_children is always changed with
> task_lock(task) held.  See switch_task_namespaces (used by unshare and
> setns).  This also gives us the guarantee that the pid_ns reference
> won't be freed/reused in any for until task_lock(task) is dropped.

Now I've checked kmem_cache_zalloc() and it looks like it zeroes cache memory
content synchronous on allocation (it seems there is no pre-zeroed memory
for GFP_ZERO cases).

So, the zeroing happens before switch_task_namespaces() (and task_unlock())
and we're really safe after task_lock() in pidns_for_children_get().

Ok, I'll send new version of the patchset.
