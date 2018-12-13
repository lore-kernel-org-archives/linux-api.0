From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [RFC PATCH v1 3/5] Yama: Enforces noexec mounts or file
 executability through O_MAYEXEC
Date: Thu, 13 Dec 2018 15:49:16 +0100
Message-ID: <f13bf750-f418-343c-baa6-9eee6e0f5e19@ssi.gouv.fr>
References: <20181212081712.32347-1-mic@digikod.net>
 <20181212081712.32347-4-mic@digikod.net>
 <CAG48ez3SAW8EyaJ9T1U3qPoRhYwe4CCyL9bAxuc3GxjrXipi-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3SAW8EyaJ9T1U3qPoRhYwe4CCyL9bAxuc3GxjrXipi-A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, zohar@linux.ibm.com, philippe.trebuchet@ssi.gouv.fr, shuah@kernel.org, thibaut.sautereau@ssi.gouv.fr, vincent.strubel@ssi.gouv.fr, yves-alexis.perez@ssi.gouv.fr, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


On 12/12/2018 18:09, Jann Horn wrote:
> On Wed, Dec 12, 2018 at 9:18 AM Mickaël Salaün <mic@digikod.net> wrote:
>> Enable to either propagate the mount options from the underlying VFS
>> mount to prevent execution, or to propagate the file execute permission.
>> This may allow a script interpreter to check execution permissions
>> before reading commands from a file.
>>
>> The main goal is to be able to protect the kernel by restricting
>> arbitrary syscalls that an attacker could perform with a crafted binary
>> or certain script languages.  It also improves multilevel isolation
>> by reducing the ability of an attacker to use side channels with
>> specific code.  These restrictions can natively be enforced for ELF
>> binaries (with the noexec mount option) but require this kernel
>> extension to properly handle scripts (e.g., Python, Perl).
>>
>> Add a new sysctl kernel.yama.open_mayexec_enforce to control this
>> behavior.  A following patch adds documentation.
>>
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
>> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
>> ---
> [...]
>> +/**
>> + * yama_inode_permission - check O_MAYEXEC permission before accessing an inode
>> + * @inode: inode structure to check
>> + * @mask: permission mask
>> + *
>> + * Return 0 if access is permitted, -EACCES otherwise.
>> + */
>> +int yama_inode_permission(struct inode *inode, int mask)
> 
> This should be static, no?

Right, it will be in the next series. The previous function
(yama_ptrace_traceme) is not static though.

> 
>> +{
>> +       if (!(mask & MAY_OPENEXEC))
>> +               return 0;
>> +       /*
>> +        * Match regular files and directories to make it easier to
>> +        * modify script interpreters.
>> +        */
>> +       if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>> +               return 0;
> 
> So files are subject to checks, but loading code from things like
> sockets is always fine?

As I said in a previous email, these checks do not handle fifo either.
This is relevant in a threat model targeting persistent attacks (and
with additional protections/restrictions). We may want to only whitelist
fifo, but I don't get how a socket is relevant here. Can you please clarify?

> 
>> +       if ((open_mayexec_enforce & YAMA_OMAYEXEC_ENFORCE_MOUNT) &&
>> +                       !(mask & MAY_EXECMOUNT))
>> +               return -EACCES;
>> +
>> +       /*
>> +        * May prefer acl_permission_check() instead of generic_permission(),
>> +        * to not be bypassable with CAP_DAC_READ_SEARCH.
>> +        */
>> +       if (open_mayexec_enforce & YAMA_OMAYEXEC_ENFORCE_FILE)
>> +               return generic_permission(inode, MAY_EXEC);
>> +
>> +       return 0;
>> +}
>> +
>>  static struct security_hook_list yama_hooks[] __lsm_ro_after_init = {
>> +       LSM_HOOK_INIT(inode_permission, yama_inode_permission),
>>         LSM_HOOK_INIT(ptrace_access_check, yama_ptrace_access_check),
>>         LSM_HOOK_INIT(ptrace_traceme, yama_ptrace_traceme),
>>         LSM_HOOK_INIT(task_prctl, yama_task_prctl),
>> @@ -447,6 +489,37 @@ static int yama_dointvec_minmax(struct ctl_table *table, int write,
>>         return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
>>  }
>>
>> +static int yama_dointvec_bitmask_macadmin(struct ctl_table *table, int write,
>> +                                         void __user *buffer, size_t *lenp,
>> +                                         loff_t *ppos)
>> +{
>> +       int error;
>> +
>> +       if (write) {
>> +               struct ctl_table table_copy;
>> +               int tmp_mayexec_enforce;
>> +
>> +               if (!capable(CAP_MAC_ADMIN))
>> +                       return -EPERM;
> 
> Don't put capable() checks in sysctls, it doesn't work.
> 

I tested it and the root user can indeed open the file even if the
process doesn't have CAP_MAC_ADMIN, however writing in the sysctl file
is denied. Btw there is a similar check in the previous function
(yama_dointvec_minmax).

Thanks
