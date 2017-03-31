From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC 1/4] proc: add proc_fs_info struct to store proc options
Date: Fri, 31 Mar 2017 12:49:35 +0200
Message-ID: <CAEiveUe-_jQFe0c=RuW3g0DB6h0MvZcZr=4iB=Cs+XEQUN-C5g@mail.gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
 <1490887379-25880-2-git-send-email-tixxdz@gmail.com> <CALCETrUG2Smb-+SWKphnB_oMFakZn9AuJDa7WeahnN9hBoENTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUG2Smb-+SWKphnB_oMFakZn9AuJDa7WeahnN9hBoENTQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.ker>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 9:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 30, 2017 at 8:22 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> This is a preparation patch that adds a proc_fs_info to be able to store
>> different procfs options. Right now some mount options are stored inside
>> the pid namespace which make multiple proc share the same mount options.
>> This patch will help also to fix this.
>>
>> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
>
>>  static struct dentry *proc_mount(struct file_system_type *fs_type,
>>         int flags, const char *dev_name, void *data)
>>  {
>> +       int error;
>> +       struct super_block *sb;
>>         struct pid_namespace *ns;
>> +       struct proc_fs_info *fs_info;
>> +
>> +       if (!(flags & MS_KERNMOUNT) && !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
>> +               return ERR_PTR(-EPERM);
>
> Why is this check needed?

This is the same check that we used to have, from mount_ns(). I think
we have to keep the same semantics for now. Later we may adapt it
according to that suggestion of procfs with 'scope=x' mount options
feature where you want a specific feature of procfs that needs X
capability ?

>
>> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
>> index 2d2bf59..e1cb9c3 100644
>> --- a/include/linux/proc_fs.h
>> +++ b/include/linux/proc_fs.h
>> @@ -6,11 +6,27 @@
>>
>>  #include <linux/types.h>
>>  #include <linux/fs.h>
>> +#include <linux/refcount.h>
>> +
>> +enum {
>> +       PROC_FS_V1      = 1,
>> +       PROC_FS_V2      = 2,
>> +};
>> +
>> +struct proc_fs_info {
>> +       refcount_t users;
>> +       struct pid_namespace *pid_ns;
>> +       kgid_t pid_gid;
>> +       int hide_pid;
>> +       int version;
>> +};
>
> What is version?

This is just a name to mirror 'unshare' option, please ignore it, I
will change the var name.

>
> Should this patch have just users and pid_ns and move the other stuff
> to patch 2?

Indeed, will fix it.

Thanks!

-- 
tixxdz
