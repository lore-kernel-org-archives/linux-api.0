From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Wed, 28 Mar 2018 19:14:09 -0700
Message-ID: <20180329021409.gcjjrmviw2lckbfk@linux-n805>
References: <1520885744-1546-1-git-send-email-longman@redhat.com>
	<1520885744-1546-5-git-send-email-longman@redhat.com>
	<87woyfyh57.fsf@xmission.com>
	<5d4a858a-3136-5ef4-76fe-a61e7f2aed56@redhat.com>
	<87o9jru3bf.fsf@xmission.com>
	<935a7c50-50cc-2dc0-33bb-92c000d039bc@redhat.com>
	<87woyego2u.fsf_-_@xmission.com>
	<047c6ed6-6581-b543-ba3d-cadc543d3d25@redhat.com>
	<87h8ph6u67.fsf@xmission.com>
	<7d3a1f93-f8e5-5325-f9a7-0079f7777b6f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7d3a1f93-f8e5-5325-f9a7-0079f7777b6f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Cc'ing mtk, Manfred and linux-api.

See below.

On Thu, 15 Mar 2018, Waiman Long wrote:

>On 03/15/2018 03:00 PM, Eric W. Biederman wrote:
>> Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>
>>> On 03/14/2018 08:49 PM, Eric W. Biederman wrote:
>>>> The define IPCMNI was originally the size of a statically sized array in
>>>> the kernel and that has long since been removed.  Therefore there is no
>>>> fundamental reason for IPCMNI.
>>>>
>>>> The only remaining use IPCMNI serves is as a convoluted way to format
>>>> the ipc id to userspace.  It does not appear that anything except for
>>>> the CHECKPOINT_RESTORE code even cares about this variety of assignment
>>>> and the CHECKPOINT_RESTORE code only cares about this weirdness because
>>>> it has to restore these peculiar ids.
>>>>
>>>> Therefore make the assignment of ipc ids match the description in
>>>> Advanced Programming in the Unix Environment and assign the next id
>>>> until INT_MAX is hit then loop around to the lower ids.
>>>>
>>>> This can be implemented trivially with the current code using idr_alloc_cyclic.
>>>>
>>>> To make it possible to keep checkpoint/restore working I have renamed
>>>> the sysctls from xxx_next_id to xxx_nextid.  That is enough change that
>>>> a smart CRIU implementation can see that what is exported has changed,
>>>> and act accordingly.  New kernels will be able to restore the old id's.
>>>>
>>>> This code still needs some real world testing to verify my assumptions.
>>>> And some work with the CRIU implementations to actually add the code
>>>> that deals with the new for of id assignment.
>>>>
>>>> Updates: 03f595668017 ("ipc: add sysctl to specify desired next object id")
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>
>>>> Waiman please take a look at this and run it through some tests etc,
>>>> I am pretty certain something like this patch is all you need to do
>>>> to sort out ipc assignment.  Not messing with sysctls needed.
>>>>
>>>>  include/linux/ipc.h           |  2 --
>>>>  include/linux/ipc_namespace.h |  1 -
>>>>  ipc/ipc_sysctl.c              |  6 ++--
>>>>  ipc/namespace.c               | 11 ++----
>>>>  ipc/util.c                    | 80 ++++++++++---------------------------------
>>>>  ipc/util.h                    | 11 +-----
>>>>  6 files changed, 25 insertions(+), 86 deletions(-)
>>>>
>>>> diff --git a/include/linux/ipc.h b/include/linux/ipc.h
>>>> index 821b2f260992..6cc2df7f7ac9 100644
>>>> --- a/include/linux/ipc.h
>>>> +++ b/include/linux/ipc.h
>>>> @@ -8,8 +8,6 @@
>>>>  #include <uapi/linux/ipc.h>
>>>>  #include <linux/refcount.h>
>>>>
>>>> -#define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
>>>> -
>>>>  /* used by in-kernel data structures */
>>>>  struct kern_ipc_perm {
>>>>  	spinlock_t	lock;
>>>> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
>>>> index b5630c8eb2f3..cab33b6a8236 100644
>>>> --- a/include/linux/ipc_namespace.h
>>>> +++ b/include/linux/ipc_namespace.h
>>>> @@ -15,7 +15,6 @@ struct user_namespace;
>>>>
>>>>  struct ipc_ids {
>>>>  	int in_use;
>>>> -	unsigned short seq;
>>>>  	bool tables_initialized;
>>>>  	struct rw_semaphore rwsem;
>>>>  	struct idr ipcs_idr;
>>>> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
>>>> index 8ad93c29f511..a599963d58bf 100644
>>>> --- a/ipc/ipc_sysctl.c
>>>> +++ b/ipc/ipc_sysctl.c
>>>> @@ -176,7 +176,7 @@ static struct ctl_table ipc_kern_table[] = {
>>>>  	},
>>>>  #ifdef CONFIG_CHECKPOINT_RESTORE
>>>>  	{
>>>> -		.procname	= "sem_next_id",
>>>> +		.procname	= "sem_nextid",
>>>>  		.data		= &init_ipc_ns.ids[IPC_SEM_IDS].next_id,
>>>>  		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SEM_IDS].next_id),
>>>>  		.mode		= 0644,
>>>> @@ -185,7 +185,7 @@ static struct ctl_table ipc_kern_table[] = {
>>>>  		.extra2		= &int_max,
>>>>  	},
>>>>  	{
>>>> -		.procname	= "msg_next_id",
>>>> +		.procname	= "msg_nextid",
>>>>  		.data		= &init_ipc_ns.ids[IPC_MSG_IDS].next_id,
>>>>  		.maxlen		= sizeof(init_ipc_ns.ids[IPC_MSG_IDS].next_id),
>>>>  		.mode		= 0644,
>>>> @@ -194,7 +194,7 @@ static struct ctl_table ipc_kern_table[] = {
>>>>  		.extra2		= &int_max,
>>>>  	},
>>>>  	{
>>>> -		.procname	= "shm_next_id",
>>>> +		.procname	= "shm_nextid",
>>>>  		.data		= &init_ipc_ns.ids[IPC_SHM_IDS].next_id,
>>>>  		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SHM_IDS].next_id),
>>>>  		.mode		= 0644,
>>> So you are changing the names of existing sysctl parameters. Will it be
>>> better to add new sysctl to indicate that the rule has changed
>>> instead?
>> In practice I am replacing one set of sysctls with another, that work
>> very similarly but not quite the same.  As we can't keep the existing
>> semantics removing the old sysctl seems correct.  Likewise adding
>> a new sysctl with slightly changed semantics seems correct.
>>
>> This needs an accompanying patch to CRIU to see which sysctls are
>> available and to change it's behavior based upon that.  The practical
>> question is what makes it easiest not to confuse CRIU.
>>
>> Not having the sysctl should be something that CRIU detects today
>> and the old versions should fail gracefully.  But testing is needed.
>> Adding a new sysctl to say the behavior has changed and reusing the
>> old names won't have the same effect of disabling existing versions
>> of CRIU.
>
>That is fine as long as CRIU is the only user.
>
>>
>>> I don't know the history why the id management of SysV IPC was designed
>>> in such a convoluted way, but the patch does make sense to me.
>> I don't have the full history and we might wind up finding more as we
>> run this patch through it's paces.
>>
>> The earliest history I know is what I read in Advanced Programming in
>> the Unix Environment (which predates linux).  It described the ipc ids
>> as assigned from a counter that wraps.  I thought like my patch
>> implements. On closer reading it has a counter that increases each time
>> the slot is used, and then wraps.  Exactly like Linux before my patch.
>> *Grrr*
>>
>> The existing structure of the bifurcated is present in Linux 1.0.  At
>> that time SHMMNI was 256.  SHMMNI was the size of a static array of shm
>> segments.  The high 24 bits held a sequence number that was incremented
>> when a segment was removed at the time.  Presumably the upper bits were
>> incremented to avoid swiftly reusing the same shm ids.
>>
>> Hmm.  I took a quick look at FreeBSD10 and it has the exact same split
>> in the id.  So userspace may actually depend upon that split.
>
>Backward compatibility is the part that I am most worry about this
>patch. That is also the reason I asked why the ID is generated in such a
>way.

I share these fears.

Thanks,
Davidlohr

>
>My original thinking was to have an extended mode where the IPCMNI
>becomes 8M from 32k. That will reduce the sequence number from 16 bits
>to 8 bits. The extended mode is enabled by adding, for example, a boot
>option. So this will be an opt-in feature instead of as a default.
>
>>
>> Which comes down to the fundamental question what depends upon what.
>> How do other operating systems like Solaris handle this?
>
>I don't know how Solaris handle this, but I know they support up to 2^24
>shm segments.
>
>>
>> Does any nix flavor support more that 16bits worth of shm segments?
>>
>> The API has been deprecated for the last 20 years and we are still
>> keeping it alive.  Sigh.
>>
>> Still there is fundamentally only one thing the kernel can do if we wish
>> to increase the number of shm segments.
>>
>> Please take my patch and test it out and see if you can find anything
>> that cares about the change. Except for needing id reuse to be
>> infrequent I can not imagine that there is anything that cares.
>>
>> It could very reasonably be argued that my when shmmni is < INT_MAX
>> my patch implements a version of the existing algorithm.  As we go
>> through all of the possible ids before we reuse any of them.
>>
>> Eric
>>
>Thanks for the patch, I am still thinking about what is the best way to
>handle this.
>
>Cheers,
>Longman
>
>
