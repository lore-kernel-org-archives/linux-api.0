From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC v5 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 9 Oct 2018 15:06:15 +0200
Message-ID: <9059ed5a-6a0d-7f4d-7854-48b3ae4cca76@vivier.eu>
References: <20181009103752.21482-1-laurent@vivier.eu>
 <20181009103752.21482-2-laurent@vivier.eu>
 <CAG48ez1OVKqRZe6AtTwXSc27AjNF596nt-46J9WPffKu7fNb8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1OVKqRZe6AtTwXSc27AjNF596nt-46J9WPffKu7fNb8Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, dima@arista.com, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, avagin@gmail.com, containers@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Le 09/10/2018 à 14:43, Jann Horn a écrit :
> On Tue, Oct 9, 2018 at 12:38 PM Laurent Vivier <laurent@vivier.eu> wrote:
>> This patch allows to have a different binfmt_misc configuration
>> for each new user namespace. By default, the binfmt_misc configuration
>> is the one of the previous level, but if the binfmt_misc filesystem is
>> mounted in the new namespace a new empty binfmt instance is created and
>> used in this namespace.
>>
>> For instance, using "unshare" we can start a chroot of an another
>> architecture and configure the binfmt_misc interpreter without being root
>> to run the binaries in this chroot.
> [...]
>> @@ -823,12 +847,34 @@ static const struct super_operations s_ops = {
>>  static int bm_fill_super(struct super_block *sb, void *data, int silent)
>>  {
>>         int err;
>> +       struct user_namespace *ns = sb->s_user_ns;
>>         static const struct tree_descr bm_files[] = {
>>                 [2] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
>>                 [3] = {"register", &bm_register_operations, S_IWUSR},
>>                 /* last one */ {""}
>>         };
>>
>> +       /* create a new binfmt namespace
>> +        * if we are not in the first user namespace
>> +        * but the binfmt namespace is the first one
>> +        */
>> +       if (READ_ONCE(ns->binfmt_ns) == NULL) {
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
>> +       }
> 
> You're still not preventing a concurrent race of two mount() calls,
> right? What prevents two instances of this code block from running
> concurrently in two different namespaces? I think you want to take
> some sort of global lock around this.
> 

My guess was we have only one binfmt superblock by user namespace, so as
we can't have duplicate superblock, we will not have duplicate binfmt_ns
structure. This function is only called once in the namespace and I
think the superblock creation is already protected by some kind of lock.

But I'm not a VFS expert, if someone wants to clarify the situation,
please go ahead.

Thanks,
Laurent
