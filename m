From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC v3 3/7] proc: add helpers to set and get proc hidepid
 and gid mount options
Date: Fri, 10 Nov 2017 11:41:12 +0100
Message-ID: <CAEiveUfoU=49Ju8VOhPSYuUjCHHbUbHGn_0nApx+mrfFfCQFzQ@mail.gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
 <1510244046-3256-4-git-send-email-tixxdz@gmail.com> <CACVxJT_cC1BZvfVxhNfa45zwUzO6=b6qef61XbnMaRLQmYtchg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CACVxJT_cC1BZvfVxhNfa45zwUzO6=b6qef61XbnMaRLQmYtchg@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmica>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 11:36 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On 11/9/17, Djalal Harouni <tixxdz@gmail.com> wrote:
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>
>> -static bool has_pid_permissions(struct pid_namespace *pid,
>> +static bool has_pid_permissions(struct proc_fs_info *fs_info,
>
> More "const".
>
>> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
>> index 9abc370..bdd808d 100644
>> --- a/fs/proc/inode.c
>> +++ b/fs/proc/inode.c
>> @@ -476,11 +476,12 @@ struct inode *proc_get_inode(struct super_block *sb,
>> struct proc_dir_entry *de)
>>  int proc_fill_super(struct super_block *s, void *data, int silent)
>>  {
>>       struct proc_fs_info *fs_info = proc_sb(s);
>> -     struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
>>       struct inode *root_inode;
>>       int ret;
>>
>> -     if (!proc_parse_options(data, ns))
>> +     get_pid_ns(fs_info->pid_ns);
>> +
>> +     if (!proc_parse_options(data, fs_info))
>>               return -EINVAL;
>>
>>       /* User space would break if executables or devices appear on proc */
>> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
>> index 4a67188..10bc7be 100644
>> --- a/fs/proc/internal.h
>> +++ b/fs/proc/internal.h
>> @@ -240,7 +240,7 @@ static inline void proc_tty_init(void) {}
>>   * root.c
>>   */
>>  extern struct proc_dir_entry proc_root;
>> -extern int proc_parse_options(char *options, struct pid_namespace *pid);
>> +extern int proc_parse_options(char *options, struct proc_fs_info
>> *fs_info);
>
> "extern" can be dropped if you're touching prototype anyway.
>
>
>
>> +static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
>> +{
>> +     return fs_info->pid_ns->hide_pid;
>> +}
>> +
>> +static inline kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
>> +{
>> +     return fs_info->pid_ns->pid_gid;
>> +}
>
> More "const".
>
>> @@ -59,6 +81,24 @@ static inline void proc_flush_task(struct task_struct
>> *task)
>>  {
>>  }
>>
>> +static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int
>> hide_pid)
>> +{
>> +}
>> +
>> +static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t
>> gid)
>> +{
>> +}
>> +
>> +static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
>> +{
>> +     return 0;
>> +}
>> +
>> +extern kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
>
> ehh?

Ouch copy/past, will compile it without proc support.

Will fix "const" and other comments too, thank you!


-- 
tixxdz
