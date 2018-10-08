From: Jann Horn <jannh@google.com>
Subject: Re: [RFC v4 1/1] ns: add binfmt_misc to the user namespace
Date: Mon, 8 Oct 2018 13:26:54 +0200
Message-ID: <CAG48ez1S7CVDCCec5F-N32BVEPckLb0Qy+PypThezwKA=8HSSg@mail.gmail.com>
References: <20181006193546.29340-1-laurent@vivier.eu> <20181006193546.29340-2-laurent@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181006193546.29340-2-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>
Cc: kernel list <linux-kernel@vger.kernel.org>, avagin@gmail.com, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, dima@arista.com, containers@lists.linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 6, 2018 at 9:36 PM Laurent Vivier <laurent@vivier.eu> wrote:
> This patch allows to have a different binfmt_misc configuration
> for each new user namespace. By default, the binfmt_misc configuration
> is the one of the previous level, but if the binfmt_misc filesystem is
> mounted in the new namespace a new empty binfmt instance is created and
> used in this namespace.
>
> For instance, using "unshare" we can start a chroot of an another
> architecture and configure the binfmt_misc interpreter without being root
> to run the binaries in this chroot.
>
> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> ---
[...]
> +static struct binfmt_namespace *binfmt_ns(struct user_namespace *ns)
> +{
> +       while (ns) {
> +               if (ns->binfmt_ns)
> +                       return ns->binfmt_ns;
> +               ns = ns->parent;
> +       }
> +       return NULL;
> +}

If the value being read can change under you, please use READ_ONCE().
Also: That "return NULL" can never happen, right? You should probably
at least put a WARN(...) in there.

[...]
> @@ -838,7 +858,29 @@ static int bm_fill_super(struct super_block *sb, void *data, int silent)
>  static struct dentry *bm_mount(struct file_system_type *fs_type,
>         int flags, const char *dev_name, void *data)
>  {
> -       return mount_single(fs_type, flags, data, bm_fill_super);
> +       struct user_namespace *ns = current_user_ns();
> +
> +       /* create a new binfmt namespace
> +        * if we are not in the first user namespace
> +        * but the binfmt namespace is the first one
> +        */
> +       if (ns->binfmt_ns == NULL) {
> +               struct binfmt_namespace *new_ns;
> +
> +               new_ns = kmalloc(sizeof(struct binfmt_namespace),
> +                                GFP_KERNEL);
> +               if (new_ns == NULL)
> +                       return ERR_PTR(-ENOMEM);
> +               INIT_LIST_HEAD(&new_ns->entries);
> +               new_ns->enabled = 1;
> +               rwlock_init(&new_ns->entries_lock);
> +               new_ns->bm_mnt = NULL;
> +               new_ns->entry_count = 0;
> +               ns->binfmt_ns = new_ns;

What happens if someone mounts two instances of the binfmt_misc
filesystem at the same time? Would you end up creating two binfmt
namespaces, one of which would never be freed again?

> +       }
> +
> +       return mount_ns(fs_type, flags, data, ns, ns,
> +                       bm_fill_super);
>  }
[...]
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index e5222b5fb4fe..da4950282ea1 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -140,6 +140,10 @@ int create_user_ns(struct cred *new)
>         if (!setup_userns_sysctls(ns))
>                 goto fail_keyring;
>
> +#if IS_ENABLED(CONFIG_BINFMT_MISC)
> +       ns->binfmt_ns = NULL;
> +#endif

Isn't this unnecessary? The namespace is allocated with all fields zeroed:

ns = kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
