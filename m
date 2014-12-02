From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 2/3] userns: Add a knob to disable setgroups on a per
	user namespace basis
Date: Tue, 02 Dec 2014 15:45:36 -0600
Message-ID: <87a935u3nj.fsf@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Tue, 2 Dec 2014 13:05:07 -0800")
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
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Tue, Dec 2, 2014 at 12:28 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> - Expose the knob to user space through a proc file /proc/<pid>/setgroups
>
> Can you rename this to something clearer, e.g. userns_setgroups_mode?

I am not certain that is any clearer.  That just reads as wordier.

The userns bit is definitely confusing and wrong.  Why should we need to
spell out the scope?

>>   A value of 0 means the setgroups system call is disabled in the
>>   current processes user namespace and can not be enabled in the
>>   future in this user namespace.
>>
>>   A value of 1 means the segtoups system call is enabled.
>
> Would it make more sense to put strings like "allow" and "deny" in
> here?  That way, future extensions could add additional values.

If the implementation of the write side isn't too bad.  I would love
to see precedent elsewhere in the kernel.    What I don't expect to do
is have any values except setgroups are enabled and setgroups are
disabled.

I am fine with allowing for the possibility (that is just good
engineering) but I don't intend to seriously considering or
implementing other possibilities.

>> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
>> index 21c91feeca2d..6d0ee1b089fb 100644
>> --- a/arch/s390/kernel/compat_linux.c
>> +++ b/arch/s390/kernel/compat_linux.c
>> @@ -252,6 +252,7 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
>>         int retval;
>>
>>         if (!gid_mapping_possible(user_ns) ||
>> +           !atomic_read(&user_ns->setgroups_allowed) ||
>>             !capable(CAP_SETGID))
>>                 return -EPERM;
>
> This is now incomprehensible because of the gid_mapping_possible
> thing.  If you renamed gid_mapping_possible to
> userns_setgroup_allowed, then this could be added to the
> implementation, and this would all make sense (not to mention avoiding
> duplicating this thing).
>
>> @@ -826,6 +827,11 @@ static bool new_idmap_permitted(const struct file *file,
>>                         kuid_t uid = make_kuid(ns->parent, id);
>>                         if (uid_eq(uid, cred->euid))
>>                                 return true;
>> +               } else if (cap_setid == CAP_SETGID) {
>> +                       kgid_t gid = make_kgid(ns->parent, id);
>> +                       if (!atomic_read(&ns->setgroups_allowed) &&
>> +                           gid_eq(gid, cred->egid))
>> +                               return true;
>
> I still don't see why egid is any better than fsgid here.

Answered in my earlier response fsgid was a goof.
I can set any gid to my egid with my existing permissions.
Show me how I can do that with fsgid or fsuid and I will be happy to use
those.


>>                 }
>>         }
>>
>> @@ -844,6 +850,93 @@ static bool new_idmap_permitted(const struct file *file,
>>         return false;
>>  }
>>
>> +static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
>> +{
>> +       struct user_namespace *ns = seq->private;
>> +
>> +       return (*ppos == 0) ?  ns : NULL;
>> +}
>> +
>> +static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
>> +{
>> +       ++*ppos;
>> +       return NULL;
>> +}
>> +
>> +static void setgroups_m_stop(struct seq_file *seq, void *v)
>> +{
>> +}
>> +
>> +static int setgroups_m_show(struct seq_file *seq, void *v)
>> +{
>> +       struct user_namespace *ns = seq->private;
>> +
>> +       seq_printf(seq, "%u\n", atomic_read(&ns->setgroups_allowed));
>> +       return 0;
>> +}
>> +
>> +const struct seq_operations proc_setgroups_seq_operations = {
>> +       .start  = setgroups_m_start,
>> +       .stop = setgroups_m_stop,
>> +       .next = setgroups_m_next,
>> +       .show = setgroups_m_show,
>> +};
>> +
>> +ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
>> +                            size_t count, loff_t *ppos)
>> +{
>> +       struct seq_file *seq = file->private_data;
>> +       struct user_namespace *ns = seq->private;
>> +       char kbuf[3];
>> +       int setgroups_allowed;
>> +       ssize_t ret;
>> +
>> +       ret = -EPERM;
>> +       if (!file_ns_capable(file, ns, CAP_SETGID))
>> +               goto out;
>
> CAP_SYS_ADMIN?  This isn't setting a gid in the namespace; it's
> reconfiguring the namespace.

Hmm.  Maybe.  It is an activity that is normally controlled by
CAP_SETGID.

Frankly I think the entire split up of the capability model is almost
totally broken.  But I think CAP_SETGID is a close approximation of the
right thing here.

>> +       /* Only allow a very narrow range of strings to be written */
>> +       ret = -EINVAL;
>> +       if ((*ppos != 0) || (count >= sizeof(kbuf)) || (count < 1))
>> +               goto out;
>> +
>> +       /* What was written? */
>> +       ret = -EFAULT;
>> +       if (copy_from_user(kbuf, buf, count))
>> +               goto out;
>> +       kbuf[count] = '\0';
>> +
>> +       /* What is being requested? */
>> +       ret = -EINVAL;
>> +       if (kbuf[0] == '0')
>> +               setgroups_allowed = 0;
>> +       else if (kbuf[0] == '1')
>> +               setgroups_allowed = 1;
>> +       else
>> +               goto out;
>> +
>> +       /* Allow a trailing newline */
>> +       ret = -EINVAL;
>> +       if ((count == 2) && (kbuf[1] != '\n'))
>> +               goto out;
>> +
>> +
>> +       if (setgroups_allowed) {
>> +               ret = -EINVAL;
>> +               if (atomic_read(&ns->setgroups_allowed) == 0)
>> +                       goto out;
>> +       } else {
>
> I would disallow this if gid_map has been written in the interest of
> sanity.

Not a chance.  That is part of making this an independent knob.  If
there is another reason for disabling setgroups you can flip this
knob even after mappings are established.

>> +               atomic_set(&ns->setgroups_allowed, 0);
>> +               /* sigh memory barriers! */
>
> I don't think that any barriers are needed.  If you ever observe
> setgroups_allowed == 0, it will stay that way forever.

Likely.   In practice the code works today.

But I need to review things closely to understand if there are barriers
needed.  But especially since it is a write once knob we can get away
with a lot.

>> +       }
>> +
>> +       /* Report a successful write */
>> +       *ppos = count;
>> +       ret = count;
>> +out:
>> +       return ret;
>> +}
>> +
>>  static void *userns_get(struct task_struct *task)
>>  {
>>         struct user_namespace *user_ns;
>
> --Andy
