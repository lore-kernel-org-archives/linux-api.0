From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v8 1/1] ns: add binfmt_misc to the user namespace
Date: Mon, 16 Dec 2019 21:05:02 +0100
Message-ID: <15d270a6-2264-adc5-3f56-fdb8b67ad267@vivier.eu>
References: <20191216091220.465626-1-laurent@vivier.eu>
 <20191216091220.465626-2-laurent@vivier.eu>
 <CAG48ez2xNCRmuzpNqYW5R+XMKzW8YiemsPUPgk42KSkSZXmvLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2xNCRmuzpNqYW5R+XMKzW8YiemsPUPgk42KSkSZXmvLg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg Kurz <groug@kaod.org>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Dmitry Safonov <dima@arista.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jan Kiszka <jan.kiszka@siemens.com>, Christian Brauner <christian.brauner@ubuntu.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>, Henning Schild <henning.schild@siemens.com>, =?UTF-8?Q?C=c3=a9dric_Le_Goate?= =?UTF-8?Q?r?= <clg@kaod.org>
List-Id: linux-api@vger.kernel.org

Le 16/12/2019 à 20:08, Jann Horn a écrit :
> On Mon, Dec 16, 2019 at 10:12 AM Laurent Vivier <laurent@vivier.eu> wrote:
>> This patch allows to have a different binfmt_misc configuration
>> for each new user namespace. By default, the binfmt_misc configuration
>> is the one of the previous level, but if the binfmt_misc filesystem is
>> mounted in the new namespace a new empty binfmt instance is created and
>> used in this namespace.
>>
>> For instance, using "unshare" we can start a chroot of another
>> architecture and configure the binfmt_misc interpreter without being root
>> to run the binaries in this chroot.
> 
> How do you ensure that when userspace is no longer using the user
> namespace and mount namespace, the entries and the binfmt_misc
> superblock are deleted? As far as I can tell from looking at the code,
> at the moment, if I create a user namespace+mount namespace, mount
> binfmt_misc in there, register a file format and then let all
> processes inside the namespaces exit, the binfmt_misc mount will be
> kept alive by the simple_pin_fs() stuff, and the binfmt_misc entries
> will also stay in memory.
> 
> [...]

Do you have any idea how I can fix this issue?

>> @@ -718,7 +736,9 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>>         if (!inode)
>>                 goto out2;
>>
>> -       err = simple_pin_fs(&bm_fs_type, &bm_mnt, &entry_count);
>> +       ns = binfmt_ns(file_dentry(file)->d_sb->s_user_ns);
>> +       err = simple_pin_fs(&bm_fs_type, &ns->bm_mnt,
>> +                           &ns->entry_count);
> 
> When you call simple_pin_fs() here, the user namespace of `current`
> and the user namespace of the superblock are not necessarily related.
> So simple_pin_fs() may end up taking a reference on the mountpoint for
> a user namespace that has nothing to do with the namespace for which
> an entry is being created.

Do you have any idea how I can fix this issue?

> 
> [...]
>>  static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>>  {
>>         int err;
>> +       struct user_namespace *ns = sb->s_user_ns;
> [...]
>> +       /* create a new binfmt namespace
>> +        * if we are not in the first user namespace
>> +        * but the binfmt namespace is the first one
>> +        */
>> +       if (READ_ONCE(ns->binfmt_ns) == NULL) {
> 
> The READ_ONCE() here is unnecessary, right? AFAIK the VFS layer is
> going to ensure that bm_fill_super() can't run concurrently for the
> same namespace?

So I understand the "READ_ONCE()" is unnecessary and I will remove it.

> 
>> +               struct binfmt_namespace *new_ns;
>> +
>> +               new_ns = kmalloc(sizeof(struct binfmt_namespace),
>> +                                GFP_KERNEL);
>> +               if (new_ns == NULL)
>> +                       return -ENOMEM;
>> +               INIT_LIST_HEAD(&new_ns->entries);
>> +               new_ns->enabled = 1;
>> +               rwlock_init(&new_ns->entries_lock);
>> +               new_ns->bm_mnt = NULL;
>> +               new_ns->entry_count = 0;
>> +               /* ensure new_ns is completely initialized before sharing it */
>> +               smp_wmb();
>> +               WRITE_ONCE(ns->binfmt_ns, new_ns);
> 
> Nit: This would be a little bit semantically clearer if you used
> smp_store_release() instead of smp_wmb()+WRITE_ONCE().

I will.

> 
>> +       }
>> +
>>         err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
> [...]
>> +static void bm_free(struct fs_context *fc)
>> +{
>> +       if (fc->s_fs_info)
>> +               put_user_ns(fc->s_fs_info);
>> +}
> 
> Silly question: Why the "if"? Can you ever reach this with fc->s_fs_info==NULL?

So I understand the if is unnecessary and I will remove it.

> 
>> +
>>  static int bm_get_tree(struct fs_context *fc)
>>  {
>> -       return get_tree_single(fc, bm_fill_super);
>> +       return get_tree_keyed(fc, bm_fill_super, get_user_ns(fc->user_ns));
> 
> get_user_ns() increments the refcount of the namespace, but in the
> case where a binfmt_misc mount already exists, that refcount is never
> dropped, right? That would be a security bug, since an attacker could
> overflow the refcount of the user namespace and then trigger a UAF.
> (And the refcount hardening won't catch it because user namespaces
> still use raw atomics instead of refcount_t.)

Do you have any idea how I can fix this issue?

> [...]
>> +#if IS_ENABLED(CONFIG_BINFMT_MISC)
> 
> Nit: Isn't this kind of check normally written as "#ifdef"?
> 

What is the difference?

Thanks,
Laurent
